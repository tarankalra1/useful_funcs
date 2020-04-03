1. install awscli so you can use aws commands 

sudo apt install awscli

''

DECIDED TO DO everything via CONDA 

On ubutnu 18.04 

1. conda install -c conda-forge awscli
2. conda install -c conda-forge aws-parallelcluster


Start the configurattion 
At this point need the IAM configuration secret key settings. 


3. aws configure
-------
Got this from Rich

---------------

4. pcluster configure

INFO: Configuration file /home/taran/.parallelcluster/config will be written.

==================================

VPC instructions for AWS parallelcluster
Automate VPC creation? (y/n) [n]: y
Allowed values for Network Configuration:
1. Master in a public subnet and compute fleet in a private subnet
2. Master and compute fleet in the same public subnet
Network Configuration [Master in a public subnet and compute fleet in a private subnet]: 1
Beginning VPC creation. Please do not leave the terminal until the creation is finalized
=

When AWS was complete it showed no errors in the config file and 
said that the stack was completed
==============================================================================

5. pcluster create -c ghost_config ghost

11 mins took to do this step . 

=========================================
https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-master-core-task-nodes.html

The master node manages the cluster and typically runs master components of distributed applications. For example, the master node runs the YARN ResourceManager service to manage resources for applications, as well as the HDFS NameNode service. It also tracks the status of jobs submitted to the cluster and monitors the health of the instance groups.

## Install Intel Compiler with Spack

1. Install Spack on a fresh AWS HPC cluster

```bash
cd $HOME
git clone https://github.com/spack/spack.git
cd spack
git checkout 3f1c78128ed8ae96d2b76d0e144c38cbc1c625df  # Spack v0.13.0 release in Oct 26 2019 broke some previous commands. Freeze it to ~Sep 2019.
echo 'source $HOME/spack/share/spack/setup-env.sh' >> $HOME/.bashrc
source $HOME/.bashrc
spack compilers  # check whether Spack can find system compilers
```

2. Put the Intel license file (`*.lic`) under the directory `/opt/intel/licenses/` on the AWS cluster. **This step is extremely important, otherwise the installation later will fail.**

3. Follow the steps for [Installing Intel tools within Spack](https://spack.readthedocs.io/en/latest/build_systems/intelpackage.html#installing-intel-tools-within-spack). Basically, run `spack config --scope=user/linux edit compilers` to edit the file `~/.spack/linux/compilers.yaml`. Copy and paste the following block into the file, in addition to the original `gcc` section:

```
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
```

3. Run `spack install intel@19.0.4 %intel@19.0.4` to install the compiler. Spack will spend a long time downloading the installer `http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15537/parallel_studio_xe_2019_update4_composer_edition.tgz`. When the download finishes, need to confirm the license term, by simply exiting the prompted text editor (`:wq` in `vim`).

Tip: If the installation needs to be done frequently, better save the `.tgz` file to S3 and follow [Integration of Intel tools installed external to Spack](https://spack.readthedocs.io/en/latest/build_systems/intelpackage.html#integration-of-intel-tools-installed-external-to-spack) instead.

4. Run `find $(spack location -i intel) -name icc -type f -ls` to get the compiler executable path like `/home/centos/spack/opt/spack/.../icc`. Run `spack config --scope=user/linux edit compilers` again and fill in the previous `stub` entries with the actual paths: `.../icc`, `.../icpc`, `.../ifort`. (Without this step, will get `configure: error: C compiler cannot create executables` when later building NetCDF with Spack).

5. Discover the compiler executable:

```bash
source $(spack location -i intel)/bin/compilervars.sh -arch intel64
which icc icpc ifort
icc --version  # will fail if license is not available
```

**Recommend adding the `source` line to `~/.bashrc`** to avoid setting it every time.

### Build libraries using Spack and Intel compiler

1. Configure Intel-MPI

   AWS ParallelCluster comes with an Intel MPI installation, which can be found by `module show intelmpi` and `module load intelmpi`.

   Switching between internal compilers is done by setting [Compilation Environment Variables](https://software.intel.com/en-us/mpi-developer-reference-windows-compilation-environment-variables). To wrap Intel compilers instead of GNU compilers:

	```bash
	export I_MPI_CC=icc
	export I_MPI_CXX=icpc
	export I_MPI_FC=ifort
	export I_MPI_F77=ifort
	export I_MPI_F90=ifort
	```

	Verify that `mpicc` actually wraps `icc`:
	```
	module load intelmpi
	mpicc --version  # should be icc instead of gcc


 spack compiler add
 

spack -v install netcdf-fortran %intel ^netcdf~mpi ^hdf5~mpi+fortran+hl


find the multiple packages 
echo $(spack lopcation -i hd5)/lib 


In general when we build netcdf on local machines, we create a folder where all the libraries
for netcdf and netcdf fortran exists
beceause we use spacke here we have to softlink the netcdf-frotran to netcdf folder so everything exists in one place..



and echo $(spack location -i intel@19.0.4.243/liva
ln -s hd5%1.10.5%intel@19.0.4.243/lib netcdf@4.7.0%intel@19.0.4.243


ADd things in bashrc for the netcdf
export NETCDF_HOME=$(spack location -i netcdf)/


6. 
plcuster start ghost 
This is reuqired to start the compute nodes. 





=======================================
Some links: 
1. https://github.com/JiaweiZhuang/cloud-gchp-paper/issues/6

Instructions that we used 
2. https://github.com/JiaweiZhuang/cloud-gchp-paper

3.https://github.com/JiaweiZhuang/cloud-gchp-paper/issues/4

https://github.com/JiaweiZhuang/cloud-gchp-paper/blob/master/README.md
