# Two Tier Application Deployment

## Description
This is a type of software architecture pattern where the application is divided into two layers(tiers):
1. __The Presentation Tier (Client Layer)__: this is the front end interface of the application where users interact with the system 
2. __Data Tier (Database Layer)__: The layer stores and manages the application's data. This layer is responsible for processing queries, transactions and providing data to the client's layer.

## Table of Content
1. [Infrastructure Provisioning](#infrastructure-Provisioning)
2. [S3 Buckets](#S3-buckets)
3. [Relational Database](#Relational-database)
4. [Cloudfront Distribution](#cloudfront-distribution)
5. [IAM Role](#IAM-Role)
6. [Webserver](#webserver)
7. [Route 53](#Route-53)
8. [Wordpress Setup](#wordpress-setup)
9. [Crontab Setup](#crontab-setup)
10. [Application Loadbalancer](#application-loadbalancer)
11. [Auto-scaling Group](#auto-scaling-group)
12. [Testing](#testing)


## Infrastructure Provisioning
### Lists of resources created in this stage: 
1. VPC
2. Subnets (2 public and private in 2 availability zones)
3. Internet Gateways
4. NAT gateway
5. Route tables
6. Security Groups

#### Steps
1. On the AWS services, search and click VPC
![](/img/0001.search-vpc.png)
2. Create a vpc, select vpc only and choose your CIDR 
![](/img/001.create-vpc.png)
3. On the side menu, choose subnet 
![](/img/01.subnet.png)
4. Create a subnet- this will be our public subnet, choose a name for the subnet, select an availability zone(AZ) and choose a CIDR block that is within the VPC CIDR
![](/img/02.pubsub1.png)
5. Repeat the process but for another AZ
![](/img/03.pubsub2.png)
6. Create a third subnet, this will be our private subnet but remember to choose the same AZ as the first public subnet created.
![](/img/04.prisub1.png)
7. Create a forth subnet, this will be our second private subnet but in the same availability zone as the second public subnet.<br>
__NB__ the CIDR blocks must not overlap but fall within the same block of the VPC
![](/img/05.prisub2.png)
8. Next is to create the Internet Gateway (IGW), from the side menu, select Internet Gateway
![](/img/06.createIG.png)
9. Give the internet gateway a name and click create
![](/img/07.nameigw.png)
10. After creating, attach the IGW to your VPC by clicking the "Attach to a VPC"
![](/img/08.attachigw.png)
11. Then select your VPC from the dropdown and click attach
![](/img/09.selectvpc.png)
12. Select NAT gateways from the side menu and click create NAT Gateway
![](/img/10.createnatgw.png)
13. Choose a name for your NAT gateway, choose the public subnet in the first AZ and allocate an Elastic IP
![](/img/11.filldetails.png) 
14. Select route table from the side menu and click create a route table, this will be our public route table
![](/img/12.create-pub-rt.png)
15. Select your VPC where the route table will be routing traffic through
![](/img/13.filldetails.png)
16. Create another route table, this will be our private route table
![](/img/14.create-pri-rt.png)
17. On the public route table, select routes, then edit routes
![](/img/15.edit-pub-rt.png)
18. Add route, then select target to be the internet gateway
![](/img/16.add-route.png)
![](/img/17.choose-igw.png)
19. Under the internet gateway, choose the gateway that was created in step 9 and click save
![](/img/18.select-ur-igw7.png)  
20. Click the subnet association, and edit subnet association 
![](/img/19.edit-pub-sub-ass.png)
21. Choose the two public subnets and save the association. This step ensures that the public subnets are associated with the required route table.
![](/img/20choose-subs.png)
22. Edit the private route tables, click on route and edit routes
![](/img/21.edit-pri-rt.png)
23. Add routes as shown and select NAT gateway
![](/img/22.add-route.png)
![](/img/23.choose-nat.png)
24. Choose the NAT gateway created in step 13 and click save
![](/img/24.select-ur-nat.png)
25. Edit private subnet association 
![](/img/25.edit-pri-ass.png)
26. Select the two private subnets, and click save.
![](/img/26.choose-subs.png)
27. From the side menu, choose security group then click create security group
![](/img/27.create-sg.png)
28. Give your security group a name this will be our front end security group, a description and choose your VPC
![](/img/28name-des.png)
29. Add new rule to the inbounds rule
![](/img/29.add-rule.png)
30. Select SSH and HTTP from the dropdown under type, choose source as anywhere and put the description
![](/img/30.edit-rule.png)
31. Create the security group
![](/img/31.create.png)
32. Create another security group (this will be our backend security group), choose the required VPC
![](/img/32.backend-sg.png)
33. Under type, choose SSh and MYSQL and allow both source from front end security group, then click create
![](/img/33.edit-rule-be.png)