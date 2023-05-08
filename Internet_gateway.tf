resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "IGW"-"${var.environment}"
 }
}

resource "aws_route_table" "table" {
  vpc_id = "${aws_vpc.main.id}"
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name = "RT"-"${var.environment}"
  }
}