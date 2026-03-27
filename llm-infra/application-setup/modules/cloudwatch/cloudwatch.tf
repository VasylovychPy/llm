resource "aws_sns_topic" "cloudwatch_alerts" {
  name = "llm-${var.env}-cloudwatch-alerts"

  tags = merge(var.common_tags, {
    Name = "llm-${var.env}-cloudwatch-alerts"
  })
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.cloudwatch_alerts.arn
  protocol  = "email"
  endpoint  = var.sns_email
}

resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  alarm_name          = "[llm]-[${var.env}]-[db]-[high]-[storage]"
  alarm_description   = "RDS free storage space is low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 5
  datapoints_to_alarm = 3
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 21474836480
  treat_missing_data  = "breaching"

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  alarm_actions = [aws_sns_topic.cloudwatch_alerts.arn]
  ok_actions    = [aws_sns_topic.cloudwatch_alerts.arn]

  tags = merge(var.common_tags, {
    Name = "llm-${var.env}-db-high-storage"
  })
}

resource "aws_cloudwatch_metric_alarm" "rds_high_cpu" {
  alarm_name          = "[llm]-[${var.env}]-[db]-[high]-[cpu]"
  alarm_description   = "RDS CPU utilization is high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  datapoints_to_alarm = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "breaching"

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  alarm_actions = [aws_sns_topic.cloudwatch_alerts.arn]
  ok_actions    = [aws_sns_topic.cloudwatch_alerts.arn]

  tags = merge(var.common_tags, {
    Name = "llm-${var.env}-db-high-cpu"
  })
}

resource "aws_cloudwatch_metric_alarm" "rds_low_memory" {
  alarm_name          = "[llm]-[${var.env}]-[db]-[high]-[memory]"
  alarm_description   = "RDS freeable memory is low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 5
  datapoints_to_alarm = 3
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 536870912
  treat_missing_data  = "breaching"

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  alarm_actions = [aws_sns_topic.cloudwatch_alerts.arn]
  ok_actions    = [aws_sns_topic.cloudwatch_alerts.arn]

  tags = merge(var.common_tags, {
    Name = "llm-${var.env}-db-high-memory"
  })
}

resource "aws_cloudwatch_metric_alarm" "alb_4xx" {
  alarm_name          = "[llm]-[${var.env}]-[elb]-[medium]-[4XX-errors]"
  alarm_description   = "ALB generated too many 4XX responses"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  datapoints_to_alarm = 3
  metric_name         = "HTTPCode_ELB_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 20
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = [aws_sns_topic.cloudwatch_alerts.arn]
  ok_actions    = [aws_sns_topic.cloudwatch_alerts.arn]

  tags = merge(var.common_tags, {
    Name = "llm-${var.env}-elb-medium-4XX-errors"
  })
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "[llm]-[${var.env}]-[elb]-[medium]-[5XX-errors]"
  alarm_description   = "ALB generated too many 5XX responses"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  datapoints_to_alarm = 2
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = [aws_sns_topic.cloudwatch_alerts.arn]
  ok_actions    = [aws_sns_topic.cloudwatch_alerts.arn]

  tags = merge(var.common_tags, {
    Name = "llm-${var.env}-elb-medium-5XX-errors"
  })
}