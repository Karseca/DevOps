# DevOps
Automation scripts / Puppet Resources/Classes/Manifests / Chef configs / Security scripts / Monitoring scripts

The scripts in this repository are intended to help you with some of your daily work, automating tasks that we do repetidely.

We provide an install script so the repository scripts and configuration files would be placed in the correct directories sourced in the configuration files, but feel free to change what you think it suites you better.

The scripts are organized in folders:

- ./devoops/ --> main scripts that work with configuration files;
- ./devoops/default/ --> global configuration files with global functions;
- ./devoops/default/include/ --> script specific configuration files;

- ./secoops/ --> main scripts that work with configuration files;
- ./secoops/include/ --> configuration files with script specific functions;


The scripts in the devoops directory are intended to work with OMD (Open Monitoring Distribution) monitoring framework, and others that would be there to interact with some applications on operating systems, and the ones in secoops are intended to work for security automation and implementation purposes.

Thanks.


