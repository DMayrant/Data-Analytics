📊 Data-Analytics Pipeline — NYC Air Quality Monitoring

☁️ You are a Cloud Engineer working for an industrial company that specializes in monitoring air pollution levels and air quality in New York City. The company is having issues with data processing and developing analytics for their sensor data to determine pollution levels and overall air quality trends.

Your task is to design and deploy a secure, scalable, multi-AZ data analytics platform on AWS that supports:

⚡️ Real-time sensor data ingestion

🗄️ Storage in a highly available Aurora database

🧪 Batch ETL processing with AWS Glue

🔎 Interactive analytics using Amazon Athena over S3

This project simulates the work of a Cloud / DevSecOps Engineer responsible for building production-ready data platforms for IoT-style sensor workloads.

# 🌆 What NYC Air Quality Sensors (and Their System) Struggled With

1️⃣ High-Volume Data Ingestion Problems

NYC has thousands of sensors generating continuous readings:

Measurements every few seconds or minutes

Multiple pollutant types: PM2.5, PM10, O₃ (ozone), CO₂, NO₂, CO

Sensors deployed across all five boroughs

The legacy system struggled with:

⚠️ Traffic spikes during weather changes, rush hours, or pollution events

❌ Overloaded ingestion endpoints, causing HTTP timeouts and retries

🕒 Ingest delays and dropped data points, resulting in incomplete data

# The old system struggled with:

Data spikes during temperature changes or pollution events

Overloading ingestion endpoints

Late data or dropped samples

![image alt](https://github.com/DMayrant/Data-Analytics/blob/main/BatchAnalyticsPipeline.jpeg?raw=true)


