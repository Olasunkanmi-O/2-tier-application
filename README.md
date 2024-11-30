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
8. [Wordpress Setup](#wordpress-Setup)
9. [Crontab Setup](#crontab-setup)
10. [Application Load-balancer](#application-load-balancer)
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

## S3 Buckets
### Two buckets will be created in this stage.
1. One to hold the application's media which will be publicly accessible
2. The other for the application's code, this bucket will not be publicly accessible.

#### steps
1. In the search bar, type S3 and click on the S3 bar
![](/img/34.select-s3.png)
2. Create bucket, this will be our media bucket
![](/img/35.create-bucket.png)
3. Give a unique name to the bucket 
![](/img/35name-bucket.png)
4. Uncheck "Block all public access" and check the acknowledgement
![](/img/36.pub-access.png)
5. Click the newly created bucket and choose permissions
![](/img/37.permissions.png)
6. Under bucket policy, click edit
![](/img/38.edit-policy.png)
7. Click on policy generator
![](/img/39.gen-policy.png)
8. Choose the required criteria for the policy
![](/img/40.gen-policy2.png)
![](/img/40.gen-policy2b.png)
9. Click generate policy
![](/img/40.gen-policy2c.png)
10. copy the generated policy and paste on the page of the bucket policy
![](/img/41.paste-policy.png)
11. Create a second bucket, this will be the code bucket
![](/img/101.create-another-bucket.png)
12. Also give it a unique name 
![](/img/102.name-bucket.png)
13. ensure that "Block all public access" is checked
![](/img/103.block-pub-access.png)
14. Click create
![](/img/104.create.png)



## Relational Database
We will use MYSQL engine for our RDS for this project.

#### steps
1. Search for RDS in the search bar
![](/img/42.search-rds.png)
2. Click on subnet groups and create a DataBase subnet group
![](/img/43.create-subnetgrp.png)
3. Give it a name, a description and choose your VPC
![](/img/44.fill-details.png)
4. Select your availability zones and the required subnets, then click create
![](/img/45.az-subnets.png)
5. After, click on create database
![](/img/46create-databse.png)
6. Choose a database creation method and your desired engine
![](/img/47.choose-engine.png)
7. Select your availability zone type
![](/img/48.multi-az.png)
8. Create a master username and password
![](/img/49.credentials.png)
9. Fill in the other details and choose VPC and subnet group
![](/img/50.details.png)
10. Choose your security group (this will be the Backend SG)
![](/img/51.be-sg.png)
11. Under additional configuration, give an initial name to your database 
![](/img/52.choose-db-name.png), this will be the name of your db
12. click create database ![](/img/53.create.png)

## Cloudfront Distribution

#### steps
1. Search for cloudfront in the search bar
![](/img/54search-cloudfront.png)
2. Click on create cloudfront distribution
![](/img/55.create-distr.png)
3. Under the origin, choose the media storage bucket 
![](/img/56.choose-media-bucket.png)
4. Enable Security protections
![](/img/57.enable-security.png)
5. Click create distribution
![](/img/58.create.png)
6. Note the distribution domain name
![](/img/107.cloudfront-domainname.png)

## IAM Role
Here, we will create an IAM role with S3 full permission to allow our servers(EC2) access the bucket on our behalf

#### steps
1. Under services, search for IAM 
![](/img/59.serach-iam.png)
2. Click on roles on the side menu then click on create role 
![](/img/60.sarch-roles.png)
3. Select your trusted entity
![](/img/61.choose-service.png)
4. Choose a use case, click next
![](/img/62.choose-usecase.png)
5. Select permission type, then click next
![](/img/63.choose-s3.png)
6. Create role
![](/img/64.create-role.png)


## Webserver
1. Search for EC2 in the search bar
![](/img/65.search-ec2.png)
2. On the side menu, click instances then launch instances
![](/img/66.launch-instance.png)
3. Give the instance a name and choose required AMI (OS)
![](/img/67.choose-img.png)
4. Select your instance type and a key pair 
![](/img/68.instance-kp.png)
5. Choose your VPC, enable public IP and choose SG (front end SG)
![](/img/69.fill-details.png)
6. Under advanced details, select the IAM role created in the last stage
![](/img/70.IAM-role.png)
7. scroll down to userdata and paste this [userdata](/userdata.sh) this userdata allows us to install a specific version of wordpress v 6.1.1. which is required for this project
![](/img/71.input-userdata.png) 
8. Click on launch instance
![](/img/72.launch-inst.png)

## Route 53
Requirement for this stage 
- A registered domain name
- propagated Domain name 

#### steps
1. In the search bar, type Route 53
![](/img/73.route-53.png)
2. On the side bar, click hosted zone
![](/img/74.hosted-zone.png)
3. Create hosted zone
![](/img/75.create-hz.png)
4. Enter your domain name 
![](/img/76.domain-name.png)
5. Click create hosted zone
![](/img/77.create.png)

## Wordpress Setup

1. Copy the EC2 public IP into your browser
![](/img/78.copy-ip.png)
![](/img/79.test-ip.png)
2. Create the application credentials and install wordpress
![](/img/80.install-wp.png)
3. Click on login 
![](/img/81.success-page.png)
4. Enter the credentials created in step 2 and click login
![](/img/82.log-in.png)
5. You will see the application dashboard
![](/img/83.homepage.png)
6. In the left panel, click on media
![](/img/84.select-media.png)
7. Click on add new
![](/img/85.add-new.png)
8. Click on select files 
![](/img/86.select-files.png)
9. Upload a media of your choice 
10. In the left panel, select posts, and add new
![](/img/87.new-post.png) 
11. Add a title and click on the plus button to add more segments (we used image and paragraph for this project)
![](/img/88.choose-title.png)
12. Click on image
![](/img/89.select-image.png)
13. Click on media library 
![](/img/90.select-media-lib.png)
14. Select the image to be uploaded
![](/img/91.choose-img.png)
15. Click on publish 
![](/img/92.publish.png)
16. Click on view post, you will be able to view your post
![](/img/93.view-post.png)
![](/img/success-application.png)

## Crontab Setup

#### steps
1. SSH into the instance to install AWS CLI 
![](/img/94ssh-webserver.png)
2. Install AWS CLI using below command 
``` bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo yum install unzip -y
unzip awscliv2.zip
sudo ./aws/install
```
![](/img/95install.png)
![](/img/96.ongoing1.png)
![](/img/98.successful.png)
3. Using AWS CLI, copy all media from upload directory on the EC2 instance to the S3 media bucket
```bash
aws s3 cp --recursive /var/www/html/wp-content/uploads/ s3://your-media-bucket-name
```
![](/img/99.copy-to-s3.png)
4. Copy the wordpress application code to S3 code bucket 
![](/img/105.cp-all-to-s3.png)
5. Synchronize /var/www/html directory with the code bucket
```bash
aws s3 sync /var/www/html/ s3://your-code-bucket-name
```
![](/img/106.sync-with-s3.png)
6. On the terminal, cd into the html dir and create a file called .htaccess
![](/img/108.create-htaccess.png) 
7. Paste below code inside but modify the domain name to your cloudfront domain name
    ```bash
    Options +FollowSymlinks
    RewriteEngine on
    rewriterule ^wp-content/uploads/(.*)$ https://your-cloudfront-endpoint/$1 [r=301,nc]
    ```
![](/img/ran2.png)
8. Update the Apache config file to allow redirection of all content in the upload directory to be served through cloudfront endpoint. This is done by changing the `AllowOverride None` to `AllowOverride All`
```bash
sudo vi /etc/httpd/conf/httpd.conf
```
![](/img/109.modify-conf.png)
![](/img/110.change.png)
9. Create a crontab that will synchronize the code bucket with /var/www/html by executing below commands 
```bash
cd /etc
sudo vi crontab
```
![](/img/111.create-crontab.png)
10. Paste the code below in the crontab file and save
```bash
* * * * * ec2-user /usr/local/bin/aws s3 sync --delete s3://your-code-bucket-name /var/www/html/
```
![](/img/112.modify-crontab.png)


## Application Load-Balancer
#### steps
1. Back into our console, on the left hand panel, scroll to Load Balancers<br>
![](/img/113.create-loadbalancer.png)
2. click on create
![](/img/114.create-loadbalancer.png)
3. Select the Application Load-Balancer and click create
![](/img/115.create-alb.png)
4. Give it a name and choose internet facing
![](/img/116.state-name.png)
5. Under mapping, choose your VPC and your availability zones and subnets
![](/img/117.choose-subnets.png)
6. Select your security group
![](/img/118.choose-sg.png)
7. click on create target group
![](/img/119.create-tg.png)
8. Choose instances as your target type
![](/img/120.choose-instances.png)
9. click on next
![](/img/121.create.png)
10. After creating your target group, choose the same target group here
![](/img/122.choose-tg.png)
11. create load balancer
![](/img/123.create.png)
12. Make sure your load balancer is Active then copy the DNS name and paste on your browser
![](/img/124.cp-dns-name.png)
![](/img/124b.confirm-ALB.png)
13. Go to route 53 on the search menu and create a record for the load-balancer in your hosted zone
![](/img/125.create-record.png)
14. Enable alias, select from the dropdown __Alias to Application and Classic Load Balancer__ 
![](/img/126.choose-ALB.png)
15. Select your region and in the search bar, choose your load balancer DNS, click on create records
![](/img/127.fill-details.png)
16. Test the configuration by typing your domain name in the browser.
![](/img/128.confirm-domainname.png)

## Auto-scaling Group

#### steps
1. Create an AMI from the instance, on the EC2 dashboard, select your instance and click on __Action__, select __Images and Templates__ and then __create image__
![](/img/129.create-image.png)
2. Give your image a name 
![](/img/130.name-image.png)
3. Click on create 
![](/img/131.create.png)
4. From the left panel, select auto scaling group
and  create auto scaling group
![](/img/132.create-asg.png)
5. Give your auto scaling group a name and create a launch template 
![](/img/133.create-launch-template.png)
6. Give your launch template a name
![](/img/134.choose-name.png)
7. Under AMI, select __My AMIs__ and choose the image earlier created 
![](/img/135.choose-template.png)
8. Select your instance type and the key pair
![](/img/136.instance-type-key.png)
9. Under Network Settings, select the front end security group
![](/img/137.select-sg.png)
10. Scroll to advanced details and choose your IAM role under IAM instance profile then click create launch template
![](/img/138.choose-IAM.png)
![](/img/139.create.png)
11. Back to the auto scaling group, under the launch template, choose the newly created launch template, then click next
![](/img/140.select-LT.png)
12. Under network, select your VPC, availability zones and the subnets(public subnets)
![](/img/141.choose-vpc.png)
13. Select attach an existing load balancer and choose your target group
![](/img/142.choose-loadbalancer.png)
14. Define your scaling group size
![](/img/143.configure-capacity.png)
15. click next
![](/img/144.click-next.png)
16. Give it a tag(optional)
![](/img/145.add-tags.png)
17. Review your choices and create
![](/img/146.review-create.png)


## Testing

### Stress test

1. Copy one of the ASG instance IP address and SSH into it via the terminal
![](/img/148.choose-instance.png)
![](/img/149.ssh-into.png)
2. Execute  ```top``` command in the terminal to access the CPU processes and usage
```bash
top
```
![](/img/150.initial-cpu-usage.png)
3. Now run the sha1sum command to spike up the CPU 
```bash
sha1sum /dev/zero &
```
![](/img/150.stress-cmd.png)
![](/img/151.cpu-usage-2.png)
4. After a few minutes, ASG spins up a new instance
![](/img/152.new-instance.png)
5. From the activity tab under history, you will see a new instance been created based off of the stress induced
![](/img/153.activity-history.png)
6. Go into the spiked up instance and kill the sha1sum process(stress-inducer), then run the top command again
![](/img/154.kill-stress.png)
7. ASG scales back in by terminating some instances not needed
![](/img/155.terminating.png).



