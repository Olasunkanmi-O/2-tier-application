# Two Tier Application Deployment

## Description
This is a type of softtware architecture pattern where the application is divided into two layers(tiers):
1. __The Presentation Tier (Client Layer)__: this is the front end interface of the application where users interract with the system 
2. __Data Tier (Database Layer)__: The layer stores and manages the application's data. This layer is responsible for processing queries, transactions and providing data to the client's layer.

## Table of Content
1. [Infrastructure Provisioning](#infrastructure-Provisioning)
2. [S3 Buckets](#S3-buckets)
3. [Relational Database](#Relational-database)
4. [Cloudfront Distribution](#cloudfront-distribution)
5. [IAM Role](#IAM-Role)
6. [Webservers](#webservers)
7. [Route 53](#Route-53)
8. [Wordpress Setup](#wordpress-setup)
9. [Crontab Setup](#crontab-setup)
10. [Application Loadbalancer](#application-loadbalancer)
11. [Auto-scaling Group](#auto-scaling-group)
12. [Testing](#testing)

