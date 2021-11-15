# Terra-Thunt

A simple scirpt that uses terraform to spin up a machine for Active Counter Measure's Threat Hunting class with the cloud provider of your choice (AWS or Digital Oceans). Along with setting up it up with the scirpt that was provided.

### Opening notes from Active CounterMeasures

```md
You're welcome to continue using this machine after the class is done:
we hope you'll take some more time to try out the tools and do the labs!
```

### Helpful stuff for this lab
If you are new to the Linux operating system please visit to page on navigating the Linux Filesystem
-	https://www.redhat.com/sysadmin/navigating-linux-filesystem
	
## Getting Started
Download Terra-Thunt
```md
curl https://raw.githubusercontent.com/13bm/terra-thunt/main/thunt.ps1 -o thunt.ps1
```

Set Powershell Execution Policy
```md
Set-ExecutionPolicy Unrestricted
```

After you are done you can Set Powershell Execution Policy back to the default
```md
Set-ExecutionPolicy Restricted
```

More about Powershell Excution Policy can be found  [here](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.2)
## 1.0 Creating Cloud Account
In order to use this scirpt you will need a cloud provider account and token/keys for said account to authenticate.

Digital Oceans is the **_recommended_** choice for beginners
 - ##### 1.1 Signing up for Digital Oceans free trial
	 - https://try.digitalocean.com/freetrialoffer/
 - ##### 1.2 Signing up for AWS free trial
	 - https://aws.amazon.com/free/

## 2.0 Creating Login Tokens
- ##### 2.1 Set up personal access tokens for Digital Oceans
	- https://docs.digitalocean.com/reference/api/create-personal-access-token/
- ##### 2.2 Set up access tokens for AWS
	- https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html
## 3.0 Running Terra-Thunt
Open powershell and run Terra-Thunt
```md
PS > .\thunt.ps1
```
Terra-Thunt will be downloaded/updated
```md
PS > .\thunt.ps1
Downloading\Updating Terra-Thunt
```
Pick your Cloud provider
```md
Please pick Cloud Provider, [A] AWS or [D] DigitalOcean:
```
- **AWS** option will give you the choice of using preconfigured aws keys located in the **`~/.aws/`** folder ( more on this  [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)) or enviorment variables which you will be ask for. Please save AWS keys securely 

  ```md
  Please pick which aws creds to use, [A] /.aws/ or [E] Environment variables:
  ```
 - **Digital Ocean** option will ask for the access token, please save this token securely

	```md
	Please Provide DigitalOcean Token:
	```

## 4.0 Final Touchs
Terra-Thunt will automagically deploy a machine in the cloud and connect to it for you over ssh in a new powershell window **it is important you do not close the orignal windows, that will be needed for later**

When connected a scirpt will be run to finish the install on the machine. This script will pull down needed utilities, install rita and supporting tools, and pull down the sample data needed for the labs. It'll take a few minutes. 

In this script you'll be asked if users other than root should be allowed to run wireshark to capture packets. Unless you know you'll be using this long term, will be creating non-root user accounts, and want them to sniff packets, leave the answer at the default of "No". 

You'll also be asked to configure Zeek, Answer ```y```
```md
"Would you like to continue running the zeek configuration script and generate a new node.cfg file? (y/n) ?:
``` 

For eth0 you'll be asked, Answer ```y```
```md
"Would you like to include it as a sniff interface (y/n)?"
```  

For eth1, Answer ```n```. 

Would you like to replace the existing node.cfg, Answer ```y```
 ```md
 "Would you like to replace the existing node.cfg with the above file?"
 ```

Once Zeek is done setting up, you can see the 3 lab directories by running the command:
```bash
ls -Al ~/lab*
```

If you get back a listing that includes "lab1", "lab2", and "lab3" similar to the below, you have everything installed and are ready to start the labs. 

```md
/root/lab1:
total 88512
-rw-rw-r-- 1 1000 1000 1769129 Feb 17 17:25 conn.log
-rw-rw-r-- 1 1000 1000 48722 Feb 17 17:25 dhcp.log
-rw-rw-r-- 1 1000 1000 1529159 Feb 17 17:25 dns.log
-rw-rw-r-- 1 1000 1000 169343 Feb 17 17:25 files.log
-rw-rw-r-- 1 1000 1000 1444115 Feb 17 17:25 http.log
-rw-rw-r-- 1 1000 1000 819 Feb 17 17:25 ntp.log
-rw-rw-r-- 1 1000 1000 254 Feb 17 17:25 packet_filter.log
-rw-rw-r-- 1 1000 1000 109204 Feb 17 17:25 ssl.log
-rwxrwxr-x 1 1000 1000 85294077 Jun 10 2020 trace1.pcap
-rw-rw-r-- 1 1000 1000 15630 Feb 17 17:25 weird.log
-rw-rw-r-- 1 1000 1000 235138 Feb 17 17:25 x509.log

/root/lab2:
total 456
-rw-rw-r-- 1 1000 1000 1281 Jan 22 16:01 conn.log
-rw-rw-r-- 1 1000 1000 453834 Jan 22 16:01 dns.log
-rw-rw-r-- 1 1000 1000 253 Jan 22 16:01 packet_filter.log
-rw-rw-r-- 1 1000 1000 470 Jan 22 16:01 weird.log

/root/lab3:
total 319724
-rw-rw-r-- 1 1000 1000 1294975 Feb 18 09:09 conn.log
-rw-rw-r-- 1 1000 1000 48738 Feb 18 09:09 dhcp.log
-rw-rw-r-- 1 1000 1000 1463736 Feb 18 09:09 dns.log
-rw-rw-r-- 1 1000 1000 176430 Feb 18 09:09 files.log
-rw-rw-r-- 1 1000 1000 26802 Feb 18 09:09 http.log
-rw-rw-r-- 1 1000 1000 254 Feb 18 09:09 packet_filter.log
-rw-rw-r-- 1 1000 1000 125354 Feb 18 09:09 ssl.log
-rw-r--r-- 1 1000 1000 323949399 Feb 17 17:17 trace3.pcap
-rw-rw-r-- 1 1000 1000 15621 Feb 18 09:09 weird.log
-rw-rw-r-- 1 1000 1000 266437 Feb 18 09:09 x509.log
```


## 5.0 Tearing Down

### Very Important Infomation
Cloud providers continues to bill you for the machine until you delete it! Logging out of it, halting it, or closing the powershell windows _**will not**_ stop the billing. The only way to stop paying for the instance is to tear it down / destroy it


Terra-Thunt can tear down and destroy all resources it used to make the machine. 
Answer ```r``` to do so.
```md
Please confirm, enter [R] Ready to teardown infrastructure or [C] to connect again:
```

In the event that you closed the powershell window before tearing down the infrastructure
you can simply run Terra-Thunt again. 

```md
PS > .\thunt.ps1
```

You will be asked again for your provider choice and depending on your selection you will be asked again for you AWS keys or Digital Ocean token, if you did not save this you will need to make new ones again.