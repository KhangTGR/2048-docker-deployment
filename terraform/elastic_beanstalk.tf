resource "aws_elastic_beanstalk_application" "application" {
  name        = "${var.prefix}-${var.elastic_beanstalk_application.name}"
  description = var.elastic_beanstalk_application.description
}

resource "aws_elastic_beanstalk_application_version" "version" {
  bucket      = aws_s3_bucket.application.id
  key         = var.elastic_beanstalk_application.key
  application = aws_elastic_beanstalk_application.application.name
  name        = "${var.prefix}-${var.elastic_beanstalk_application.version}"

  depends_on = [
    aws_s3_object.application_source
  ]
}

resource "aws_elastic_beanstalk_environment" "environment" {
  name                = "${var.prefix}-${var.elastic_beanstalk_environment.name}"
  application         = aws_elastic_beanstalk_application.application.name
  solution_stack_name = var.elastic_beanstalk_environment.solution_stack_name
  tier                = var.elastic_beanstalk_environment.tier
  description         = var.elastic_beanstalk_environment.description
  version_label       = aws_elastic_beanstalk_application_version.version.name

  depends_on = [
    aws_vpc.vpc,
    aws_iam_instance_profile.beanstalk_iam_instance_profile,
  ]

  count = length(var.network.public_subnets_cidr_block)

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_iam_instance_profile.arn
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.vpc.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "True"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = element(aws_subnet.public_subnet.*.id, count.index)
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }
}
