## `terraform-nsx-manager`
Terraform module for NSX manager appliance on vSphere  
Clone repository and adjust parameters as required  

#### `clone`
```
git clone https://github.com/apnex/terraform-nsx-manager
cd terraform-nsx-manager
```

#### `parameters`
Verify and adjust parameters of `main.tf` to suit deployment target

#### `init`
Initialise terraform provider
```
terraform init
```

#### `plan`
Run plan and review changes
```
terraform plan
```

#### `apply`
Apply the plan
```
terraform apply
```

#### `destroy` [optional]
Destroy deployed appliance
```
terraform destroy
```
