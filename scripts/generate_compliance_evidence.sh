#!/bin/bash

# generate_compliance_evidence.sh
#
# This script generates a simple compliance evidence report in Markdown format.
# It uses the AWS CLI to check the configuration of key resources against a baseline of security controls.
#
# Usage: ./generate_compliance_evidence.sh <environment> <application_name> <aws_region>
# Example: ./generate_compliance_evidence.sh prod MyWebApp ap-southeast-2

set -euo pipefail

ENVIRONMENT=$1
APP_NAME=$2
AWS_REGION=$3
REPORT_FILE="compliance_evidence_report-${ENVIRONMENT}.md"

# Function to write the report header
write_header() {
    echo "# Compliance Evidence Report for Environment: ${ENVIRONMENT}" > "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "| Control ID | Description | Resource Identifier | Status |" >> "$REPORT_FILE"
    echo "| :--- | :--- | :--- | :--- |" >> "$REPORT_FILE"
}

# Function to check KMS key rotation
check_kms_rotation() {
    local key_id=$(aws kms list-aliases --region "$AWS_REGION" --query "Aliases[?AliasName=='alias/${ENVIRONMENT}/${APP_NAME}'].TargetKeyId" --output text)

    if [[ -z "$key_id" ]]; then
        echo "| CIS 2.8 | KMS Key Rotation Enabled | alias/${ENVIRONMENT}/${APP_NAME} | **FAIL (Key not found)** |" >> "$REPORT_FILE"
        return
    fi

    local rotation_status=$(aws kms get-key-rotation-status --key-id "$key_id" --region "$AWS_REGION" --query 'KeyRotationEnabled' --output text)

    if [[ "$rotation_status" == "true" ]]; then
        echo "| CIS 2.8 | KMS Key Rotation Enabled | ${key_id} | **PASS** |" >> "$REPORT_FILE"
    else
        echo "| CIS 2.8 | KMS Key Rotation Enabled | ${key_id} | **FAIL** |" >> "$REPORT_FILE"
    fi
}

# Function to check RDS instance encryption
check_rds_encryption() {
    local db_identifier=$(aws rds describe-db-instances --region "$AWS_REGION" --filters "Name=tag:Environment,Values=${ENVIRONMENT}" "Name=tag:Application,Values=${APP_NAME}" --query 'DBInstances[0].DBInstanceIdentifier' --output text 2>/dev/null)

    if [[ -z "$db_identifier" || "$db_identifier" == "None" ]]; then
        echo "| SOC 2 C1.1 | RDS Encryption Enabled | Tags: ${ENVIRONMENT},${APP_NAME} | **FAIL (Instance not found)** |" >> "$REPORT_FILE"
        return
    fi

    local encryption_status=$(aws rds describe-db-instances --db-instance-identifier "$db_identifier" --region "$AWS_REGION" --query 'DBInstances[0].StorageEncrypted' --output text)

    if [[ "$encryption_status" == "true" ]]; then
        echo "| SOC 2 C1.1 | RDS Encryption Enabled | ${db_identifier} | **PASS** |" >> "$REPORT_FILE"
    else
        echo "| SOC 2 C1.1 | RDS Encryption Enabled | ${db_identifier} | **FAIL** |" >> "$REPORT_FILE"
    fi
}

# Function to check S3 bucket encryption
check_s3_encryption() {
    local bucket_name=$(aws s3api list-buckets --region "$AWS_REGION" --query "Buckets[?starts_with(Name, '${ENVIRONMENT}-${APP_NAME}-alb-access-logs')].Name" --output text)

    if [[ -z "$bucket_name" ]]; then
        echo "| ISO A.10.1.1 | S3 Bucket Encryption Enabled | Prefix: ${ENVIRONMENT}-${APP_NAME}-alb-access-logs | **FAIL (Bucket not found)** |" >> "$REPORT_FILE"
        return
    fi

    local encryption_config=$(aws s3api get-bucket-encryption --bucket "$bucket_name" --region "$AWS_REGION" --query 'ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm' --output text 2>/dev/null)

    if [[ "$encryption_config" == "aws:kms" ]]; then
        echo "| ISO A.10.1.1 | S3 Bucket Encryption Enabled | ${bucket_name} | **PASS** |" >> "$REPORT_FILE"
    else
        echo "| ISO A.10.1.1 | S3 Bucket Encryption Enabled | ${bucket_name} | **FAIL** |" >> "$REPORT_FILE"
    fi
}

# --- Main Script ---
echo "Generating compliance evidence report for environment: ${ENVIRONMENT}..."
write_header
check_kms_rotation
check_rds_encryption
check_s3_encryption
echo "Report generated: ${REPORT_FILE}"
