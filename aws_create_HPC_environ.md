
These instructions would let one build a parallel cluster using AWS services. It will be equivalent to doing the job of an administrator for installing and maintaing a HPC facility for scientific computing applications. The instructions are heavily borrowed from the work of Jiawei Zhang from Harvard University. His two papers provide all the details related for advancing scientific computing applications on a cloud environment  

A HPC type AWS cloud environment contains two resources that users would use and they include:
* EC2 -> Elastic Compute Cloud that is equivalent of having a machine to run the jobs.
* S3  -> Simple Storage Service that is where one can store (It is much cheaper to store here than EC2). 

#### 1. Obtaining a AWS account 
The AWS account for users is usually created by the overarching agency that is paying for those resources. 
It contains two pieces of information 
* 1.1 Username and password that can be used to login directly to the AWS website (aws.amazon.com) in this case. The user can use the web console to login check the status of resources under Services tab. One example of this could be checking the status of EC2 whether it is running, what amount of resources are being utilized etc., several other options for users to setup their cloud environment. 

* 1.2 AWS Identity and Access Management (IAM) information that contains an access key and secret access key. It is equivalent to having a secret key to use AWS commands from our local machine. The next step shows us how it is exactly utilized. 

#### 2. Setting up our local machine to use AWS commands
There are many ways to install software that can lead to using AWS commands from our local machine. One good idea is to use the anaconda tool that is widely used and is free to use. It can be downloaded in all platforms (Windows, MAC, Linux). The main idea behind using anaconda is to have a command type terminal on our local machine. Legacy users can think of this as CYGWIN. 
Download link: https://www.anaconda.com/distribution/#download-section

Once anaconda is installed it provides a command line environment to install AWSCLI (i.e. AWS Command Line Interface). AWSCLI software would let the users to use AWS commands from their local machine. To install AWSCLI open the anaconda terminal and type the following command to get the AWSCLI:
```
conda install -c conda-forge awscli
```
```
conda install -c conda-forge aws-parallelcluster
```

Now we have the software installed to use AWS commands and need to configure them with the secret access key. 
This is done by the command:
```
aws configure 
```
It asks for the following questions that contain the IAM information for each user (Section 1.2). An example is shown here:
```
AWS Access Key ID [None]: ARANTLRADSGH 
AWS Secret Access Key [None]: wxxxxxxxxxxxxxxxxEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json
```
Now we are all set to use the AWS commandsfrom local machine and can check that this works by logging into AWS console (Section 1.1). We can try to send a simple textfile from local machine to AWS S3 storage.
```
aws s3 textfile_check.txt cp s3://coawst/textfile_check.txt  
```
Transfers a sample textfile_check.txt to S3/coawst directory. One can check that it is copied by accessing the S3 services in AWS console and navigating to the coawst folder.

#### 3. Configuring parallel cluster options 
Login to AWS console, search for EC2 service, then select keypair and create a new keypair (we called our "reaper"), selecting ".pem" for openssh. Download the .pem file and move to the ~/.ssh folder on your local machine.

Run 
```
pcluster configure ghost_config
```
where ghost_config is the configuration file name and use "reaper" for the keypair name (We created that keypair above). (Should already be in the selection menu)

It would ask for several options to setup the configuration file and ours are listed below. 
Notes:
* base_os = We chose the Centos operating system (Linux OS)
* compute_instance_type= defines the computing power and is associated with our account. We can use a different compute cluster
that has a higher memory and higher number of virtual cores. Because our account had set a maximum default of 16 virtual CPU's, we ended up using c5n.4xlarge. For more on computing instance types, check https://aws.amazon.com/ec2/instance-types/
* VPC instructions for AWS parallelcluster
Automate VPC creation? (y/n) [n]: y
Allowed values for Network Configuration:
a) Master in a public subnet and compute fleet in a private subnet
b) Master and compute fleet in the same public subnet
Network Configuration [Master in a public subnet and compute fleet in a private subnet]: 1
Beginning VPC creation. Please do not leave the terminal until the creation is finalized

* disable_hyperthreading = true (Models like COAWST benefit from disabling hyperthreading because .............communication slowdown..
  Taran check)
* enable_efa = (Not done yet and plan to do that)

##### Configuration file options
```
[aws]
aws_region_name = us-west-2

[global]
cluster_template = default
update_check = true
sanity_check = true

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}

[cluster default]
key_name = reaper
base_os = centos7
scheduler = slurm
master_instance_type = c5n.large
compute_instance_type = c5n.4xlarge
initial_queue_size = 1
max_queue_size = 8
maintain_initial_size = true
vpc_settings = default

[vpc default]
vpc_id = vpc-0402215e278931469
master_subnet_id = subnet-0d6031a19add9b228
compute_subnet_id = subnet-0b84ee057b64da006
use_public_ips = false
```
We have the same configuration file located at this link: https://github.com/rsignell-usgs/coawst-aws/blob/master/ghost_working_config

The we created the cluster with the name "ghost":
```
pcluster create -c ghost_config ghost
```
Note: 11 mins took to do this step  

When configuration was complete setting up it showed no errors in the config file and said that the stack was completed

Note: The configuration file is created on the path ~/.parallelcluster/config in our local machine

#### 4.  

 4. pcluster configure

INFO: Configuration file /home/taran/.parallelcluster/config will be written.

==================================

VPC instructions for AWS parallelcluster Automate VPC creation? (y/n) [n]: y Allowed values for Network Configuration:

Master in a public subnet and compute fleet in a private subnet
Master and compute fleet in the same public subnet Network Configuration [Master in a public subnet and compute fleet in a private subnet]: 1 Beginning VPC creation. Please do not leave the terminal until the creation is finalized =
When AWS was complete it showed no errors in the config file and said that the stack was completed

```
pcluster create -c ghost_config ghost
```

11 mins took to do this step .

========================================= https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-master-core-task-nodes.html

The master node manages the cluster and typically runs master components of distributed applications. For example, the master node runs the YARN ResourceManager service to manage resources for applications, as well as the HDFS NameNode service. It also tracks the status of jobs submitted to the cluster and monitors the health of the instance groups.

Install Intel Compiler with Spack
Install Spack on a fresh AWS HPC cluster
```
cd $HOME
git clone https://github.com/spack/spack.git
cd spack
git checkout 3f1c78128ed8ae96d2b76d0e144c38cbc1c625df  # Spack v0.13.0 release in Oct 26 2019 broke some previous commands. Freeze it to ~Sep 2019.
```

echo 'source $HOME/spack/share/spack/setup-env.sh' >> $HOME/.bashrc
source $HOME/.bashrc
spack compilers  # check whether Spack can find system compilers
Put the Intel license file (*.lic) under the directory /opt/intel/licenses/ on the AWS cluster. This step is extremely important, otherwise the installation later will fail.

Follow the steps for Installing Intel tools within Spack. Basically, run spack config --scope=user/linux edit compilers to edit the file ~/.spack/linux/compilers.yaml. Copy and paste the following block into the file, in addition to the original gcc section:

- compiler:
    target:     x86_64
    operating_system:   centos7
    modules:    []
    spec:       intel@19.0.4
    paths:
        cc:       stub
        cxx:      stub
        f77:      stub
        fc:       stub
Run spack install intel@19.0.4 %intel@19.0.4 to install the compiler. Spack will spend a long time downloading the installer http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15537/parallel_studio_xe_2019_update4_composer_edition.tgz. When the download finishes, need to confirm the license term, by simply exiting the prompted text editor (:wq in vim).
Tip: If the installation needs to be done frequently, better save the .tgz file to S3 and follow Integration of Intel tools installed external to Spack instead.

Run find $(spack location -i intel) -name icc -type f -ls to get the compiler executable path like /home/centos/spack/opt/spack/.../icc. Run spack config --scope=user/linux edit compilers again and fill in the previous stub entries with the actual paths: .../icc, .../icpc, .../ifort. (Without this step, will get configure: error: C compiler cannot create executables when later building NetCDF with Spack).

Discover the compiler executable:

source $(spack location -i intel)/bin/compilervars.sh -arch intel64
which icc icpc ifort
icc --version  # will fail if license is not available
Recommend adding the source line to ~/.bashrc to avoid setting it every time.

Build libraries using Spack and Intel compiler
Configure Intel-MPI

AWS ParallelCluster comes with an Intel MPI installation, which can be found by module show intelmpi and module load intelmpi.

Switching between internal compilers is done by setting Compilation Environment Variables. To wrap Intel compilers instead of GNU compilers:

export I_MPI_CC=icc
export I_MPI_CXX=icpc
export I_MPI_FC=ifort
export I_MPI_F77=ifort
export I_MPI_F90=ifort
Verify that mpicc actually wraps icc:

module load intelmpi
mpicc --version  # should be icc instead of gcc


spack compiler add

spack -v install netcdf-fortran %intel ^netcdfmpi ^hdf5mpi+fortran+hl

find the multiple packages echo $(spack lopcation -i hd5)/lib

In general when we build netcdf on local machines, we create a folder where all the libraries for netcdf and netcdf fortran exists beceause we use spacke here we have to softlink the netcdf-frotran to netcdf folder so everything exists in one place..

and echo $(spack location -i intel@19.0.4.243/liva ln -s hd5%1.10.5%intel@19.0.4.243/lib netcdf@4.7.0%intel@19.0.4.243

ADd things in bashrc for the netcdf export NETCDF_HOME=$(spack location -i netcdf)/

plcuster start ghost This is reuqired to start the compute nodes.

======================================= SSH TO GHOST ssh -i "xxxx.pem" centos@ec2-cccxxxxxcc.us-xxxxx.compute.amazonaws.com

Some links:

https://github.com/JiaweiZhuang/cloud-gchp-paper/issues/6
Instructions that we used 2. https://github.com/JiaweiZhuang/cloud-gchp-paper

3.https://github.com/JiaweiZhuang/cloud-gchp-paper/issues/4

https://github.com/JiaweiZhuang/cloud-gchp-paper/blob/master/README.md
