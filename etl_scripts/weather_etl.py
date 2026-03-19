import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

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
RAW_PREFIX     = args["RAW_PREFIX"]
CURATED_BUCKET = args["CURATED_BUCKET"]
CURATED_PREFIX = args["CURATED_PREFIX"]
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
raw_path = f"s3://{RAW_BUCKET}/{RAW_PREFIX}"

raw_df = (
    spark.read
    .option("multiline", "true")
    .json(raw_path)
)

# -------------------------------------------------------------------
# 2. Flatten / select relevant fields to match the JSON structure
# -------------------------------------------------------------------
from pyspark.sql.functions import col, to_timestamp

flattened_df = (
    raw_df
    .select(
        col("location.name").alias("city"),
        col("location.region").alias("region"),
        col("location.country").alias("country"),
        col("location.lat").alias("latitude"),
        col("location.lon").alias("longitude"),
        to_timestamp(col("location.localtime")).alias("localtime"),

        col("current.temp_c").alias("temp_c"),
        col("current.temp_f").alias("temp_f"),
        col("current.is_day").alias("is_day"),
        col("current.wind_kph").alias("wind_kph"),
        col("current.wind_dir").alias("wind_dir"),
        col("current.pressure_mb").alias("pressure_mb"),
        col("current.humidity").alias("humidity"),
        col("current.cloud").alias("cloud"),
        col("current.feelslike_c").alias("feelslike_c"),
        col("current.vis_km").alias("vis_km"),
        col("current.uv").alias("uv"),
        col("current.gust_kph").alias("gust_kph"),
    )
)

# -------------------------------------------------------------------
# 3. Write curated data to S3 as Parquet (partitioned by date)
# -------------------------------------------------------------------
from pyspark.sql.functions import to_date

curated_df = flattened_df.withColumn("date", to_date(col("localtime")))

curated_path = f"s3://{CURATED_BUCKET}/{CURATED_PREFIX}"

(
    curated_df
    .repartition("date")
    .write
    .mode("overwrite")
    .partitionBy("date")
    .parquet(curated_path)
)

# -------------------------------------------------------------------
# 4. Create / update Glue table via GlueContext
# -------------------------------------------------------------------
glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={"paths": [curated_path]},
    format="parquet"
)

glueContext.catalog_client.create_table(
    database=DATABASE_NAME,
    table_input={
        "Name": TABLE_NAME,
        "StorageDescriptor": {
            "Columns": [
                {"Name": "city", "Type": "string"},
                {"Name": "region", "Type": "string"},
                {"Name": "country", "Type": "string"},
                {"Name": "latitude", "Type": "double"},
                {"Name": "longitude", "Type": "double"},
                {"Name": "localtime", "Type": "timestamp"},
                {"Name": "temp_c", "Type": "double"},
                {"Name": "temp_f", "Type": "double"},
                {"Name": "is_day", "Type": "int"},
                {"Name": "wind_kph", "Type": "double"},
                {"Name": "wind_dir", "Type": "string"},
                {"Name": "pressure_mb", "Type": "double"},
                {"Name": "humidity", "Type": "int"},
                {"Name": "cloud", "Type": "int"},
                {"Name": "feelslike_c", "Type": "double"},
                {"Name": "vis_km", "Type": "double"},
                {"Name": "uv", "Type": "double"},
                {"Name": "gust_kph", "Type": "double"},
            ],
            "Location": curated_path,
            "InputFormat": "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
            "OutputFormat": "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat",
            "SerdeInfo": {
                "SerializationLibrary": "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
                "Parameters": {"serialization.format": "1"},
            },
        },
        "PartitionKeys": [
            {"Name": "date", "Type": "date"}
        ],
        "TableType": "EXTERNAL_TABLE",
        "Parameters": {"classification": "parquet"},
    },
)

job.commit()
