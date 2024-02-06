resource "aws_subnet" "subnet" {
  count                   = var.Subnet_Count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr[count.index]
  availability_zone       = var.availability_Zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Igor-EKS-subnet"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"  
  }

  tags = {
    Name = "igor-EKS-rt"
  }
}

resource "aws_route_table_association" "subnet_1" {
  count = var.Subnet_Count
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.rt.id
}