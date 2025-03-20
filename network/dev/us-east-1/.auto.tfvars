number_of_az = 2
vpc = {
   name = "vpc"
   cidr = "10.0.0.0/16"
   enable_nat_gateway     = true
   single_nat_gateway     = true
   one_nat_gateway_per_az = false 
   map_public_ip_on_launch = true
}