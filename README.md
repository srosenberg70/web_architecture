# Take home evaluation

Configuration in this directory creates two ALB's, two Auto-Scaling Groups, an Internet Gateway, Route table for IG, an RDS instance (Primary/read replica), VPC, subnets, Availability Zones, Security Groups and associated configs.

Used existing or create new VPC with dedicated CIDR block.   Create the subnets (CIDR's) for the web and db instances.  Configure each subnet with the associated Availability Zone (AZ) - subnets 1,3,5 to AZa, and subnet 2,4,6 to AZb.

Security Groups between web and application servers in subnets 1-4.
Security groups between application EC2 instances and RDS in subnets 3-6

Create the Launch template and include the AMI's for the web application server, along with InstanceType, min-size 1, max-size 2 and deesired-capacity of 2 EC2 instances.  Specify the Amazon Machine Image (AMI), instance type, key pair, security groups to allow access to RDS in both AZ's, add custom tags.    

Create the Auto Scaling Group (ASG), referencing the launch template created in step 3, the VPC and appropriate subnets from Step 1.   Attach ASG with the ELB created in step2. Registering the Amazon EC2 instances with a load balancer can be configured here, so I chose the ALB that will be created in Step 6.  Turn on Elastic Load Balancing health checks.  Under Additional settings, Monitoring, choose whether to enable CloudWatch group metrics collection.  For Enable default instance warmup, select this option and choose the warm-up time for your application. If you are creating an Auto Scaling group that has a scaling policy, the default instance warmup feature improves the Amazon CloudWatch metrics used for dynamic scaling
 
Amazon RDS:  all logs, backups, and snapshots are encrypted using AWS KMS key to encrypt these resources.  A read replica is created in both AZ's A read replica and encrypted using the same KMS key. 
A standby of the replica in another Availability Zone is also created for failover support for the replica.

Create an internet-facing Application Load Balancer (ALB). With Application Load Balancers, cross-zone load balancing is always enabled at the load balancer level. When cross-zone load balancing is enabled, each load balancer node distributes traffic across the registered targets in all enabled Availability Zones.  Default routing is done via round robin.
 
On the Application Load Balancer, create a target group, which is used to route requests to one or more registered targets (i.e. EC2 instances). When the listener rule is created on the ALB, a target group and conditions are specified. When a rule condition is met, traffic is forwarded to the relevant target group. Again, default routing is done via round robin.

I chose an Application Load Balancer over a Network Load Balancer because the ALB examines the application layer protocol data from the request header. Though this takes more time than network load balancing, it allows the balancer to make a more informed decision of where to direct the request.   Other advantages:  ALB's can listen in on HTTP and HTTPS requests, target groups can used by the ALB to route traffic to different urls (if needed), integration with AWS Certificate Manager to run TLS (HTTPS) connections, make routing decisions based on HTTPS headers, and HTTP routing rules can be based on host header value or URL path pattern. 
 
I created two separate Application load balancers - internet-facing and internal.  The web servers/EC2 instances attached to the internet-facing application load balancer have public IP addresses, and therefore reside in a public subnet.
The application servers/EC2 intances of the internal application load balancer have only private IP addresses, and therefore reside in private subnets.

Cloudwatch
EC2:  By default, Amazon EC2 sends metric data to CloudWatch in 5-minute periods
RDS:  By default, Amazon RDS automatically sends metric data to CloudWatch in 1-minute periods. 
ALB:  Elastic Load Balancing publishes data points to Amazon CloudWatch for the application load balancers(internet and internal) and associated targets.

Flow logs
VPC:  I'll create a flow log for a VPC, a subnet, or a network interface. For theflow log for a subnet or VPC, each network interface in that subnet or VPC will be monitored.

To run the Terraform against dev/stage/prod environments, use the following commands:

terraform apply -var-file="terraform-dev.tfvars"
terraform apply -var-file="terraform-stage.tfvars"
terraform apply -var-file="terraform-prod.tfvars"



<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 3.0 |
| <a name="module_ec2_instances"></a> [ec2\_instances](#module\_ec2\_instances) | terraform-aws-modules/ec2-instance/aws | ~> 2.0 |
| <a name="module_elb"></a> [elb](#module\_elb) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_s3_bucket.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_elb_service_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet_ids.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_number_of_instances"></a> [number\_of\_instances](#input\_number\_of\_instances) | Number of instances to create and attach to ELB | `string` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elb_dns_name"></a> [elb\_dns\_name](#output\_elb\_dns\_name) | The DNS name of the ELB |
| <a name="output_elb_id"></a> [elb\_id](#output\_elb\_id) | The name of the ELB |
| <a name="output_elb_instances"></a> [elb\_instances](#output\_elb\_instances) | The list of instances in the ELB (if may be outdated, because instances are attached using elb\_attachment resource) |
| <a name="output_elb_name"></a> [elb\_name](#output\_elb\_name) | The name of the ELB |
| <a name="output_elb_source_security_group_id"></a> [elb\_source\_security\_group\_id](#output\_elb\_source\_security\_group\_id) | The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances |
| <a name="output_elb_zone_id"></a> [elb\_zone\_id](#output\_elb\_zone\_id) | The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
