# labos-devops-task

# # Requirements
- Terraform CLI installed
- AWS profile (User must have enough privileges according to ```main.tf``` resources)

# # Run
- ```terraform init```
- ```terraform apply```

If you're choosing a different AWS profile, use the command below:
```terraform apply -var='aws_profile={YOUR AWS PROFILE}'```

For automatically provisiong please add ```-auto-approve``` flag