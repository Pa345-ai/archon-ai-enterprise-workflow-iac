output "waf_acl_arn" {
  description = "The ARN of the WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.main.arn
}
