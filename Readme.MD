# Initial Setup

To configure your AWS infrastructure using Terraform, you need to set the following environment variables:

  

-  `AWS_ACCESS_KEY_ID`: The access key ID of your AWS account.

-  `AWS_SECRET_ACCESS_KEY`: The secret access key corresponding to the access key ID.

-  `AWS_REGION`: The AWS region where you want to create your resources.

  
  

### Option 1: Set Environment Variables in the Terminal

  

Open your terminal and run the following commands to set the environment variables:

  

```bash

export AWS_ACCESS_KEY_ID=your_access_key_id

export AWS_SECRET_ACCESS_KEY=your_secret_access_key

```

  
  

### Option 2: Use a `.env` File

  

Alternatively, you can create a .env file in the root directory of your project and populate it with the following content:

  

Please make sure to add `.env` to .gitignore`

  

```

AWS_ACCESS_KEY_ID=your_access_key_id

AWS_SECRET_ACCESS_KEY=your_secret_access_key

```

  

# Terraform

  

### Create ```terraform.tfvars``` file

 

  

**terraform.tfvars**
```
sftp_user_name=""
sftp_password=""
key_location=""
vpc_cidr=""
private_subnet_cidr=""
public_subnet_cidr=""
bucket_unique_name=""
defaultregion=""
instancetype=""
keypairname=""

```

###  Terraform Commands   

Initialize terraform :

     terraform init

 Execute Script
 

    terraform apply

