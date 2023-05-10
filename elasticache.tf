# this vpc is redundant but included as an example
resource "aws_subnet" "foo" {
  vpc_id            = aws_vpc.foo.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "tf-test"
  }
}

resource "aws_elasticache_subnet_group" "bar" {
  name       = "tf-test-cache-subnet"
  subnet_ids = [aws_subnet.foo.id]
}


resource "aws_elasticache_replication_group" "elasticache_repl_group" {
  replication_group_id          = "foo"
  replication_group_description = "test description"
  node_type                     = "cache.m4.large"
  automatic_failover_enabled = true
  subnet_group_name = [aws_elasticache_subnet_group.bar.name]
  port                 = 6379
  number_cache_clusters         = 1
  transit_encryption_enabled    = true
      cluster_mode {
        replicas_per_node_group = 2
        num_node_groups         = "${var.node_groups}"
        }
}