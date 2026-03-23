#!/bin/bash
set -e

rm -rf package
mkdir package

pip install -r requirements.txt -t package
cp lambda_handler.py package/

cd package
zip -r ../lambda.zip .
cd ..
