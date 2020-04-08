
These are the basic instructions for using AWS services that are equivalent to using a HPC system for scientific computing applications. They require no prior knowledge other than some basic familiarity with command line environments. A HPC type AWS cloud environment contains two resources that users would use and they include:
* EC2 -> Elastic Compute Cloud that is equivalent of having a machine to run the jobs.
* S3  -> Simple Storage Service that is where one can store (It is much cheaper to store here than EC2). 

#### 1. Obtaining a AWS account 
The AWS account for users is usually created by the overarching agency that is paying for those resources. 
It contains two pieces of information 
* Username and password that can be used to login directly to the AWS website (aws.amazon.com) in this case. The user can use the web console to login check the status of resources under Services tab. One example of this could be checking the status of EC2 whether it is running, what amount of resources are being utilized etc., several other options for users to setup their cloud environment. 

* AWS Identity and Access Management (IAM) information that contains an access key and secret access key. It is equivalent to having a secret key to use AWS commands from your local machine. The next step shows us how it is exactly utilized. 

#### 2. Setting up your local machine to use AWS commands
There are many ways to install software that can lead to using AWS commands from our local machine. One good idea is to use the anaconda tool that is widely used and is free to use. It can be downloaded in all platforms (Windows, MAC, Linux). The main idea behind using anaconda is to have a command type terminal on your local machine. Legacy users can think of this as CYGWIN. 
Download link: https://www.anaconda.com/distribution/#download-section

Once anaconda is installed it provides a command line environment to install AWSCLI (i.e. AWS Command Line Interface). AWSCLI software would let the users to use AWS commands from their local machine. To install AWSCLI open the anaconda terminal and type the following command to get the AWSCLI:
```
conda forge
```
Now we have the software installed to use AWS commands and need to configure them with the secret access key. 
This is done by the command:
```
aws configure 
```
It asks for the following questions that contain the IAM information for each user. An example is shown here:
```
AWS Access Key ID [None]: ARANTLRADSGH 
AWS Secret Access Key [None]: wxxxxxxxxxxxxxxxxEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json
```
Now we are all set to use the AWS commands 
