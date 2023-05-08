module "alb_wafv2" {
  source  = "trussworks/wafv2/aws"
  version = "0.0.1"

  name  = "alb-web-acl"
  scope = "REGIONAL"

  alb_arn       = aws_lb.alb.arn
  associate_alb = true

}

# SizeRestrictions_QUERYSTRING rule:  Inspects for URI query strings that are over 2,048 bytes.
# NoUserAgent_HEADER rule:  Inspects for requests that are missing the HTTP User-Agent header.

# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html

resource "aws_wafv2_web_acl" "example" {
  name        = "managed-rule-example"
  description = "Example of a managed rule."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "SizeRestrictions_QUERYSTRING"
        }

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "NoUserAgent_HEADER"
        }

        scope_down_statement {
          geo_match_statement {
            country_codes = ["US"]
          }
        }
      }
    }

    token_domains = ["mywebsite.com", "myotherwebsite.com"]

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = true
  }
}