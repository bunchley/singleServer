# singleServer

## Notes General
- deploying to default VPC and default subnets of that VPC which are all public subnets, IP address are accessible from the public internet
- you need a load balancer paired with an auto scaling group, so users have one IP to hit. a Load balancer distributes traffic across the servers and gives users the IP (the DNS name) of the load balancer.


### Security
- servers should be deployed in private subnets, which have IP addresses that can only be accessed from inside VPC
- the only servers you should run in public subnets are a small number of reverse proxies and load balancers


### meta parameter
- `create_before_destroy`: create a new, then destroy old. if set to true, then all resources that depend on x need to be set to true


