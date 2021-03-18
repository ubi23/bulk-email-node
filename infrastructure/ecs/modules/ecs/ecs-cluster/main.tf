# Enable long resource ids for ECS
resource "null_resource" "enable_long_ecs_resource_ids" {
  provisioner "local-exec" {
    command = <<EOF
      export AWS_TEMP_CREDS=`aws sts assume-role --role-arn "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${split("/", data.aws_caller_identity.current.arn)[1]}" --role-session-name ${split("/", data.aws_caller_identity.current.arn)[2]} --duration-seconds 900 --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text`
		  export AWS_ACCESS_KEY_ID=`echo $AWS_TEMP_CREDS | awk '{ print $1 }'`
		  export AWS_SECRET_ACCESS_KEY=`echo $AWS_TEMP_CREDS | awk '{ print $2 }'`
		  export AWS_SESSION_TOKEN=`echo $AWS_TEMP_CREDS | awk '{ print $3 }'`
      aws ecs put-account-setting --name serviceLongArnFormat --value enabled
      aws ecs put-account-setting --name taskLongArnFormat --value enabled
      aws ecs put-account-setting --name containerInstanceLongArnFormat --value enabled
EOF
  }
}

# Create the ECS cluster
resource "aws_ecs_cluster" "main" {
  name = replace(substr(join("-", [var.tags.Service, "cluster"]), 0, 255), "/-$/", "")

  setting {
    name  = "containerInsights"
    value = var.containerInsights
  }

  tags = var.tags
  depends_on = [
    null_resource.enable_long_ecs_resource_ids
  ]
}
