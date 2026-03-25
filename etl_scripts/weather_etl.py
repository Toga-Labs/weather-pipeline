import sys
import boto3
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import (
    col,
    from_unixtime,
    to_date
)

# -------------------------------------------------------------------
# Glue job arguments
# -------------------------------------------------------------------
args = getResolvedOptions(
    sys.argv,
    [
        "JOB_NAME",
        "RAW_BUCKET",
        "RAW_PREFIX",
        "CURATED_BUCKET",
        "CURATED_PREFIX",
        "DATABASE_NAME",
        "TABLE_NAME",
    ],
)

JOB_NAME       = args["JOB_NAME"]
RAW_BUCKET     = args["RAW_BUCKET"]
RAW_PREFIX     = args["RAW_PREFIX"].rstrip("/")
CURATED_BUCKET = args["CURATED_BUCKET"]
CURATED_PREFIX = args["CURATED_PREFIX"].rstrip("/")
DATABASE_NAME  = args["DATABASE_NAME"]
TABLE_NAME     = args["TABLE_NAME"]

# -------------------------------------------------------------------
# Glue / Spark setup
# -------------------------------------------------------------------
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(JOB_NAME, args)

# -------------------------------------------------------------------
# 1. Read raw JSON from S3
# -------------------------------------------------------------------
raw_path = f"s3://{RAW_BUCKET}/{RAW_PREFIX}/*"
print("DEBUG RAW PATH:", raw_path)

raw_df = (
    spark.read
    .option("multiline", "true")
    .json(raw_path)
)

# -------------------------------------------------------------------
# 2. Flatten OpenWeatherMap JSON
# -------------------------------------------------------------------
flattened_df = (
    raw_df.select(
        col("name").alias("city"),
        col("sys.country").alias("country"),
        col("coord.lat").alias("latitude"),
        col("coord.lon").alias("longitude"),
        from_unixtime(col("dt")).alias("localtime"),
        col("main.temp").alias("temp_c"),
        col("main.feels_like").alias("feelslike_c"),
        col("main.pressure").alias("pressure_mb"),
        col("main.humidity").alias("humidity"),
        col("wind.speed").alias("wind_kph"),
        col("wind.deg").alias("wind_dir"),
        col("clouds.all").alias("cloud"),
        col("visibility").alias("vis_km"),
        col("weather")[0]["main"].alias("weather_main"),
        col("weather")[0]["description"].alias("weather_description")
    )
)

# -------------------------------------------------------------------
# 3. Write curated data to S3 as Parquet (partitioned by date)
# -------------------------------------------------------------------
curated_df = flattened_df.withColumn("date", to_date(col("localtime")))

curated_path = f"s3://{CURATED_BUCKET}/{CURATED_PREFIX}/"
print("DEBUG CURATED PATH:", curated_path)

(
    curated_df
    .repartition("date")
    .write
    .mode("overwrite")
    .partitionBy("date")
    .parquet(curated_path)
)

# -------------------------------------------------------------------
# 4. Create / update Glue table using boto3
# -------------------------------------------------------------------
glue_client = boto3.client("glue")

table_input = {
    "Name": TABLE_NAME,
    "StorageDescriptor": {
        "Columns": [
            {"Name": "city", "Type": "string"},
            {"Name": "country", "Type": "string"},
            {"Name": "latitude", "Type": "double"},
            {"Name": "longitude", "Type": "double"},
            {"Name": "localtime", "Type": "timestamp"},
            {"Name": "temp_c", "Type": "double"},
            {"Name": "feelslike_c", "Type": "double"},
            {"Name": "pressure_mb", "Type": "double"},
            {"Name": "humidity", "Type": "int"},
            {"Name": "wind_kph", "Type": "double"},
            {"Name": "wind_dir", "Type": "int"},
            {"Name": "cloud", "Type": "int"},
            {"Name": "vis_km", "Type": "double"},
            {"Name": "weather_main", "Type": "string"},
            {"Name": "weather_description", "Type": "string"}
        ],
        "Location": curated_path,
        "InputFormat": "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
        "OutputFormat": "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat",
        "SerdeInfo": {
            "SerializationLibrary": "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
            "Parameters": {"serialization.format": "1"}
        }
    },
    "PartitionKeys": [
        {"Name": "date", "Type": "date"}
    ],
    "TableType": "EXTERNAL_TABLE",
    "Parameters": {"classification": "parquet"}
}

try:
    glue_client.create_table(
        DatabaseName=DATABASE_NAME,
        TableInput=table_input
    )
    print("Table created.")
except glue_client.exceptions.AlreadyExistsException:
    glue_client.update_table(
        DatabaseName=DATABASE_NAME,
        TableInput=table_input
    )
    print("Table updated.")

job.commit()

