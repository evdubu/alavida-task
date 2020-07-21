# Alavida Technical Test
This repository represents the Alavida Technical Test metadata as a Salesforce DX project.

# Project Setup

### Install the Salesforce CLI

You can install Salesforce CLI via NPM. Once you have NPM installed, simply run:

    npm install sfdx-cli --global

### Clone the Repository

    git clone git@github.com:evdubu/alavida-task.git

### Initialise DevHub

Navigate to your project directory and execute:

    sfdx force:auth:web:login -a DevHub -d

Login with Salesforce credentials (Developer Edition or Production Org) - [DevHub](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_enable_devhub.htm).

# Deploy to a Scratch Org

### 1. Create a Scratch Org

    sfdx force:org:create -f config/project-scratch-def.json -d 30 -a <orgname>

### 2. Push the project source to your Scratch Org

    sfdx force:source:push -f -u <orgname>

### 3. Publish the Community

    sfdx force:community:publish -n "Patients" -u <orgname>

### 4. Generate some Module sample data
This will create some Module records in the Scratch Org

    sfdx force:data:tree:import -p config/sample-data-plan.json -u <orgname>

# Notes & Assumptions
-  I've setup a Community in the org and as a result, a lot of required Salesforce metadata is included in the project, to enable deployment to a Scratch Org (I've put most of these into subdirectories named 'scaffolding')
- Custom Apex classes incldued for the purpose of assigning Daily Modules to Accounts are: **DailyModuleScheduled**, **DailyModuleScheduledTest** & **TestDataFactory**
- The **DailyModuleScheduled** class can be scheduled to run daily from the UI - [Schedule Apex](https://help.salesforce.com/articleView?id=code_schedule_batch_apex.htm&type=5)
- Custom object definitions, fields & layouts are also included - **DailyModule__c** and **Module__c**
- Assumption that all Person Accounts in the system are patients, and should be assigned a Daily Module
- Assumption that there are enough modules in the system so that each patient can be assigned a fresh module each day
- I've created the job as a scheduled Apex class, but this could also easily be converted to a batch scheduled class to cater for a large number of Account records
- I've included a 'Patient Community User' profile that can be asssigned when enabling a Customer User from an Account for the Community