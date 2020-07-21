# Alavida Technical Test
This repository represents the Alavida Technical Test metadata as a  Salesforce DX project. For more information on Salesforce DX:

[Salesforce Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)

# Project Setup

### Install Salesforce CLI

You can install Salesforce CLI via NPM. Once you have NPM installed, simply run:

    npm install sfdx-cli --global

### Clone the Repository

    git clone git@github.com:evdubu/alavida-task.git

### Initialise DevHub

Navigate to your project directory and execute:

    sfdx force:auth:web:login -a DevHub -d

Login with Salesforce credentials (Developer Edition or Production Org) [DevHub](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_enable_devhub.htm).

# Deploy to a Scratch Org

### 1. Create a Scratch Org

    sfdx force:org:create -f config/project-scratch-def.json -d 30 -a <orgname>

### 2. Push the project source to your Scratch Org

    sfdx force:source:push -f -u <orgname>

### 3. Publish the Community

    sfdx force:community:publish -n "Patients" -u <orgname>

# Notes
-  I've setup a community in the org and as a result, a lot of required Salesforce metadata is included in the project to enable deployment to a Scratch Org (I've put these into subdirectories named 'scaffolding')
- Custom Apex classes incldued are: DailyModuleScheduled, DailyModuleScheduledTest & TestDataFactory