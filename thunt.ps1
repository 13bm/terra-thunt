Function Clean-up {
    $old_ErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    Remove-Item Env:TF_VAR_SSH_KEY
    Set-Variable -Name 'DIO' -Value (0) -Scope Global
    rm id_ssh
    rm id_ssh.pub
}
Function Terraform-installed{
    $old_ErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
            if (terraform){
                Write-Host "Terraform already installed, nice"
            }
            $tf = '.\terraform.exe'
            if (-not(Test-Path -Path $tf -PathType Leaf)) {
                try {
                    Write-Host "Downloading Terraform"
                    $null = Invoke-WebRequest -Uri https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_windows_amd64.zip -OutFile .\terraform.zip
                    Write-Host "Terraform Downloaded!"
                    Write-Host "Now extracting"
                    $null = Expand-Archive .\terraform.zip -DestinationPath .\terraform
                    $null = Move-Item -Path .\terraform\terraform.exe -Destination terraform.exe
                    rm .\terraform
                    rm terraform.zip
                    Write-Host "Terraform ready!!"
                }
                catch {
                    throw $_.Exception.Message
                }
            }
            # If the file already exists, show the message and do nothing.
            else {
                Write-Host "Local Terraform install"
            }
        }

Terraform-installed
function Get-Provider {
    $pinput = read-host "Please pick Cloud Provider, [A] AWS or [D] DigitalOcean"

    switch ($pinput) `
    {
        'A' {
            Set-Variable -Name 'DIO' -Value (0) -Scope Global
            aws-choice
        }
    
        'D' {
            DIOcreds
        }

        default {
            write-host 'You may only answer [A] AWS or [D] DigitalOcean, please try again.'
            Get-Provider
        }
    }
}
function aws-choice {
    $pinput = read-host "Please pick which aws creds to use, [A] /.aws/ or [E] Environment variables"

    switch ($pinput) `
    {
        'A' {
        }
    
        'E' {
            awscreds
        }

        default {
            write-host 'You may only answer [A] /.aws/ or [E] Environment variables, please try again.'
            Get-Provider
        }
    }
}
function awscreds {
    if ($null -eq $env:AWS_ACCESS_KEY_ID) {
        $aws_access_key_id = read-host -Prompt "Please Provide AWS Access Key id" -AsSecureString
        $aws_access_key_id = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($aws_access_key_id))
        $env:AWS_ACCESS_KEY_ID = $aws_access_key_id
    }
    if ($null -eq $env:AWS_SECRET_ACCESS_KEY) {
        $aws_secret_access_key = read-host -Prompt "Please Provide Aws Secret Access Key" -AsSecureString
        $aws_secret_access_key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($aws_secret_access_key))
        $env:AWS_SECRET_ACCESS_KEY = $aws_secret_access_key
    }
}
function DIOcreds {
    Set-Variable -Name 'DIO' -Value (1) -Scope Global
    if ($null -eq $env:DIGITALOCEAN_TOKEN) {
        $dioinput = read-host -Prompt "Please Provide DigitalOcean Token" -AsSecureString
        $dioinput = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($dioinput))
        $env:DIGITALOCEAN_TOKEN = $dioinput
    }
}
Function Login {
    if($DIO -eq $true){
        Start-Process powershell -ArgumentList "ssh root@$(terraform '-chdir=.\DIO' output -raw public_ip) -i id_ssh"
    }
    else {Start-Process powershell -ArgumentList "ssh ubuntu@$(terraform '-chdir=.\AWS' output -raw public_ip) -i id_ssh"
    }
}
Get-Provider
#Start-Sleep -Seconds 30
ssh-keygen -t rsa -C "Thunt" -f .\id_ssh -q -N """"
$env:TF_VAR_SSH_KEY = cat id_ssh.pub
if($DIO -eq $true){
    terraform '-chdir=.\DIO' init
    terraform '-chdir=.\DIO' apply -auto-approve
}
else {
    terraform '-chdir=.\AWS' init
    terraform '-chdir=.\AWS' apply -auto-approve
}
Write-Host "Waiting 30s for host to come online"
Start-Sleep -Seconds 30
Login
function Get-Answer {
    $input = read-host "Please confirm, enter [R] Ready to teardown infrastructure or [C] to connect again"

    switch ($input) `
    {
        'r' {
            if($DIO -eq $true){
                terraform '-chdir=.\DIO' init
                terraform '-chdir=.\DIO' destroy -auto-approve
                Clean-up
            }
            else {
                terraform '-chdir=.\AWS' init
                terraform '-chdir=.\AWS' destroy -auto-approve
                Clean-up
            }
        }
    
        'ready' {
            if($DIO -eq $true){
                terraform '-chdir=.\DIO' init
                terraform '-chdir=.\DIO' destroy -auto-approve
                Clean-up
            }
            else {
                terraform '-chdir=.\AWS' init
                terraform '-chdir=.\AWS' destroy -auto-approve
                Clean-up
            }
        }

        'c' {
            Login
            Get-Answer
        }

        'connect' {
            Login
            Get-Answer
        }

        default {
            write-host 'You may only answer [R] Ready to teardown infrastructure or [C] to connect again, please try again.'
            Get-Answer
        }
    }
}

Get-Answer