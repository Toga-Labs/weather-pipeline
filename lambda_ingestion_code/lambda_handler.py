import os
import json
import boto3
import urllib.request
from datetime import datetime

s3 = boto3.client("s3")
ssm = boto3.client("ssm")

def lambda_handler(event, context):
    # Environment variables
    bucket = os.environ["RAW_BUCKET"]
    city = os.environ["CITY"]
    param_name = os.environ["API_KEY_SSM_PARAM"]

    # Retrieve API key securely from SSM Parameter Store
    response = ssm.get_parameter(
        Name=param_name,
        WithDecryption=True
    )
    api_key = response["Parameter"]["Value"]

    # Build OpenWeather API URL
    url = (
        f"https://api.openweathermap.org/data/2.5/weather"
        f"?q={city}&appid={api_key}&units=metric"
    )

    # Fetch weather data
    with urllib.request.urlopen(url) as response:
        data = json.loads(response.read().decode("utf-8"))

    # Generate timestamped S3 key
    timestamp = datetime.utcnow().strftime("%Y-%m-%dT%H-%M-%SZ")
    key = f"weather_raw/{city.replace(',', '_')}/{timestamp}.json"

    # Store JSON in RAW bucket
    s3.put_object(
        Bucket=bucket,
        Key=key,
        Body=json.dumps(data),
        ContentType="application/json"
    )

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Weather data stored successfully",
            "s3_key": key
        })
    }
