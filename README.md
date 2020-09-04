# aws-terraform-boilerplate
Capture boilerplate terraform code and templates for AWS

# About
This project is simply a dump of some terraform code which defined a system which is no longer in
in use.  This is an attempt to not loose the learnings for how to use terraform to define
and build multiple environments, along with some good examples of how to define AWS 
components in terraform.

# Notes
Dont try and run this project, its completely broken due to the refactoring and obfuscation.

# How It All Works

## texec

The 'texec' shell script is a wrapper around the terraform commands.  Typically, your aws accounts 
map to a number of environments.  For instance dev and uat might be in a notprod account, and prod and preprod 
might be in a prod account.  The initial part of the script looks at the environment you are processing and 
sets up the correct configuration for the account, via the AWS_PROFILE env var.

The second thing that texec does is load any secrets based on the environment you specified.
To start it loads your secret from aws using the asw secretmanager (see get-secret script) based on the environment.  

Next the resulting json string is processed using jq to create a 'locals.tf' file which contains 
your secrets defined in a terraform format.

Finally texec simply executes the terraform command you have specified as your final argument
such as plan, delete etc.

## How Terraform Works

Now that we have our environment set and our secrets created locally in a file we run the actual terraform
command.  This reads the 'modules.json' file and loads those modules for processing.
For now there are 2 modules, once small module is environment dependent and lives in the 
current directory (all modules are called terraform.tf) the other main module where all the
real work goes on is in the common directory.

## Shared State

Because we want to be able to run our commands from any machine we need to share the terraform state centrally.  
This is done through a definition in the 'terraform.tf' file by specifying a backend, in our case an S3 
bucket.

## Whats in Common

Mostly common contains the AWS components you want to deploy.  However, there are a few other files
as well as some intricacies around data.

Variables for the module are declared in the 'variables.tf' file.  Variables are local to a module so 
you need to bridge definitions made outside the module using this file.

'profile.tf' defines how terraform works with AWS.  In general terraform uses a provider
architecture and this file contains this definition.

Some component definitions are really configured via json files and not by tf definitions.
For example dashboard, api gateway etc.  These components reference a data file which is 
also stored in the common area (see template files in terraform).

Some components (such as sqs and sns definitions) have several resources associated with them.
For these I decided to put them in separate file definitions.  Otherwise, components are broken 
up by type such as 'lambdas/tf'

## Empty Zip

A quick note that when creating a lambda you MUST give it a code base. 
To this end an empty zip file is provided.

## Account Level Components

Some components may belong at the account level rather that the environment level.  For example
cost and budget alarms.  These are also accommodated though the relevant directories.