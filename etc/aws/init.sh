#!/bin/bash
awslocal s3 mb s3://product-image
awslocal s3api put-bucket-cors --bucket product-image --cors-configuration file:///etc/aws/cors.json