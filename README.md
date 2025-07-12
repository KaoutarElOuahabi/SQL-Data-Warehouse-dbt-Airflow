# Enterprise Data Platform: SQL Data Warehouse with dbt & Airflow

## Overview

This project serves as a comprehensive blueprint for building a **modern, enterprise-grade data platform**. It demonstrates the implementation of a **Medallion Architecture** (Bronze, Silver, Gold layers) within a **SQL Server Data Warehouse**, orchestrated by **Apache Airflow**, and leveraging **dbt (data build tool)** for robust data transformations and quality assurance.

The goal is to provide a practical, production-ready example of an ETL/ELT pipeline that prioritizes:
* **Modularity & Maintainability**: Clean separation of concerns with structured code.
* **Data Quality**: Automated testing at critical stages.
* **Reproducibility**: Consistent environments via Docker.
* **Scalability**: Designed for growth and future integration with CI/CD practices.
* **Collaboration**: Structured for multiple team members.

This repository reflects best practices encountered in large IT enterprises, making it an ideal learning resource or a foundation for real-world data engineering projects.

## Technologies Used

* **Data Warehouse**: SQL Server (containerized for local development, scalable for cloud production like Azure SQL/Synapse)
* **Data Transformation**: [dbt (data build tool)](https://www.getdbt.com/)
* **Workflow Orchestration**: [Apache Airflow](https://airflow.apache.org/)
* **Containerization**: [Docker & Docker Compose](https://www.docker.com/)
* **Version Control**: Git / GitHub

## Project Structure

The project follows a well-defined directory structure designed for clarity and maintainability:
