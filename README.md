

# AI Data Advisor (AIDA) 

## Content
  -  [Introduction](#introduction)  
  -  [Prerequisites](#prerequisites)
  -  [Resources required](#resources-required)  
  -  [Supported platforms](#supported-platforms)
  -  [Accessing the container images](#accessing-the-container-images)
  -  [AIDA structure](#aida-structure)
  -  [AIDA Installation](#aida-installation) 
  -  [Updating AIDA installation](#updating-aida-installation)
  -  [Uninstalling AIDA](#uninstalling-aida)
  -  [AIDA.sh script](#aida.sh-script)
  -  [Configuration parameters](#configuration-parameters)
  -  [Troubleshooting](#troubleshooting)

## Introduction
**AI Data Advisor (AIDA)** is a component of HCL Workload Automation since V10.1, based on Artificial Intelligence and Machine Learning techniques. It enables fast and simplified data-driven decision making for an intelligent workload management. By analyzing workload historical data and metrics gathered by HCL Workload Automation and predicting their future patterns, AIDA identifies anomalies in KPIs trend (such as the jobs in plan by status and the jobs in plan by workstation) and sends immediate alerts to prevent problems and delays. Alerts show up on the Workload Dashboard and can be notified via email.

For more information about AIDA, see [AIDA User's Guide](https://help.hcltechsw.com/workloadautomation/v1023/common/src_ai/awsaimst_welcome.html).

   

## Prerequisites

 -  HCL Workload Automation V10.1 or higher exposed metrics.
     - For information about HCL Workload Automation exposed metrics, see [Exposing metrics to monitor your workload](https://help.hcltechsw.com/workloadautomation/v1023/distr/src_ref/awsrgmonprom.html).  

     - For information about HCL Workload Automation for Z exposed metrics, see [Exposing metrics to monitor your workload](https://help.hcltechsw.com/workloadautomation/v1023/zos/src_man/eqqr1metricsmonitoring.html). 

 -  Docker Compose 1.28 or higher.

 -  Docker from version 20.10+ to version 24.0+.

    Verify that Docker and Docker Compose are installed, configured, and ready to use.
	
 -  Supported browsers are: 
    - Google Chrome 67.0.3396.99 or higher
    - Mozilla Firefox 61.0.1 or higher 
    - Microsoft Edge 79 or higher

 -  External container image for OpenSearch 2.3.0 (an Elasticsearch based technology).

 -  External container image for Keycloak V24.0.0. (only for HCL Workload Automation users). Optional, if you want to access AIDA UI from outside the Dynamic Workload Console. 
    Note: HCL Workload Automation for Z users can only access AIDA UI from the alert widget in the Workload Dashboard of the Dynamic Workload Console.
 
 -  Before starting AIDA installation, verify that `vm.max_map_count` parameter for Elasticsearch is at minimum 262144 on the host machine (not inside the container). 
 
    -  To get the current value, run the command: `sysctl vm.max_map_count`  
	
    -  To set the new value, run the command: `sudo sysctl vm.max_map_count=262144`


##  Resources Required

 The following resources correspond to the default values required to manage a production environment. These numbers might vary depending on the environment.
 
| Component | Container resource limit | Container memory request |
|--|--|--|
|**AIDA**  | CPU: 6, Memory: 32Gi, Storage: 50Gi |CPU: 2, Memory: 8Gi, Storage: 20Gi  |


## Supported platforms
Linux intel based 64-bit, and Linux on Z.


## Accessing the container images
 You can access AIDA docker file and container images from the Entitled Registry (online installation):

 -  Contact your HCL sales representative for the login details required to access the Entitled Registry.
    
 -  Execute the following command to log into the Entitled Registry:
    
    ```
     docker login -u <your_username> -p <your_entitled_key> hclcr.io
    
    ```
The images are as follows:
 
 - ``hclcr.io/wa/workload-automation/hcl-aida-ad:10.2.3`` 
 - ``hclcr.io/wa/workload-automation/hcl-aida-exporter:10.2.3``
 - ``hclcr.io/wa/workload-automation/hcl-aida-email:10.2.3``
 - ``hclcr.io/wa/workload-automation/hcl-aida-nginx:10.2.3``
 - ``hclcr.io/wa/workload-automation/hcl-aida-orchestrator:10.2.3``
 - ``hclcr.io/wa/workload-automation/hcl-aida-predictor:10.2.3``
 - ``hclcr.io/wa/workload-automation/hcl-aida-redis:10.2.3``
 - ``hclcr.io/wa/workload-automation/hcl-aida-config:10.2.3``
 - ``hclcr.io/wa/workload-automation/hcl-aida-ui:10.2.3``
 

 
  
#### From HCL Flexera (offline installation)

Only if you are accessing the images from HCL Flexera source repository (offline installation), run the following steps:
1. Untar the package locally.
2. From the [docker_deployment_dir] load all the docker images into your environment by running the following commands:

	For linux:
 
	 ``./AIDA.sh load``
	 
	 where AIDA.sh is the AIDA installation script: it provides options to run Docker Compose operations and AIDA configuration steps.
	 You can find the script in the installation package or on the [HCL TECH SOFTWARE public github repository]( https://github.com/HCL-TECH-SOFTWARE/HCL-AI-Data-Advisor-For-HCL-Workload-Automation/blob/main/AIDA.sh).
	 
	 
	For zlinux:
	
	``tar -xvzf aida-images.tgz``
	``for f in ./aida-images/aida-*.tar*; do cat $f | docker load; done``
	

	 

## AIDA structure
AIDA package includes the following containers: 

- **aida-ad** - Anomaly detection and alert generation service
- **aida-exporter** - Exporter service
- **aida-email** - Email notification service 
- **aida-nginx** - As a reverse proxy for AIDA components
- **aida-orchestrator** - Orchestrator service
- **aida-predictor** - Predictor service
- **aida-redis** - Internal event manager
- **aida-config** - AIDA configuration
- **aida-ui** - AIDA UI
  

Also, AIDA uses:

 - **Keycloak** - To manage security and user access, for HCL Workload Automation only (not for HCL Workload Automation for Z). Keycloak is optional: if used, it enables the creation of AIDA administrators who can access AIDA UI from outside the Dynamic Workload Console. Otherwise,  AIDA can only be accessed from the alert widget in the Workload Dashboard of the Dynamic Workload Console. 
    Note: For HCL Workload Automation for Z, AIDA can only be accessed from the alert widget.

 - **OpenSearch (an Elasticsearch based technology)** - To store and analyze data.

 
## AIDA installation 
To install AIDA, run the following procedure: 

 1. To use custom SSL certificates for AIDA, in the <install_path>/nginx/cert folder replace aida.crt e aida.key with your own files (do not change the default names).
 2. Verify that the `DWC_PUBLIC_KEY` parameter in the common.env file is set to the DWC public key of the Liberty SSL certificates.

    If you are using custom certificates for the DWC, replace the `DWC_PUBLIC_KEY` value accordingly.
 3. In the common.env file, set the ``OPENSSL_PASSWORD``  parameter. This parameter will be used to generate an encryption key to hide the HCL Workload Automation engine credentials.
 4. Edit the common.env file to set mandatory parameters (parameters whose value you must provide). For example, if you want to receive alert notification via email, properly set the configuration parameters in the aida-email section in the common.env file. For the non-mandatory parameters of the common.env file, you can use the default values. For details, see  [Configuration parameters](#configuration-parameters).
 5. To prevent HTTP Host Header attacks, in the common.env file add the string ``EXTERNAL_HOSTNAME=IP where IP`` is the IP address of the machine where AIDA is being installed.
 6. Optionally, from [docker_deployment_dir], run the command
 
	 ``./AIDA.sh first-start``

         This command starts a guided configuration procedure. Follow the guided procedure and answer the prompts to configure AIDA with your settings.
         Accept the product license when prompted.
   
 7.  Build, create, and start AIDA containers by running the following command
 
         ``./AIDA.sh build-start``

	 Accept the product license when prompted.
    
8. If Keycloak is included in your AIDA deployment, you can connect AIDA user interface at the following link
 
	 ``https://aida-ip:aida-port/``
	
	 Specify ``aida-port`` only if it is different from the default value (9432). 
     Otherwise, AIDA can only be accessed from the alert widget in the Workload Dashboard of the Dynamic Workload Console. 

   **Note**: The **common.env** environment file contains all the environment variables. For details, see  [Configuration parameters](#configuration-parameters). 
    After AIDA installation, if you want to modify the configuration parameters, edit the common.env file and then run the command: ./AIDA.sh restart.     



## Updating AIDA installation


If you are using AIDA V10.1 or V10.2.0.0 with Keycloak V17.0.0 and want to update your AIDA installation to V10.2.3,  you must first migrate your previous Keycloak V17.0.0 data to Keycloak V24.0.0.

Run the following procedure.  

 1. Download data from Keycloak V17.0.0 to a file named `aida-realm.json` by running the following commands: 

    ``timeout --preserve-status -s SIGINT 60 docker exec -it aida-keycloak /opt/jboss/keycloak/bin/standalone.sh -Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.realmName=aida -Dkeycloak.migration.usersExportStrategy=REALM_FILE -Dkeycloak.migration.file=/opt/jboss/aida-realm.json; docker cp aida-keycloak:opt/jboss/aida-realm.json aida-realm.json``

 2. Save the file ``aida-realm.json`` to a disk drive.
 3. Remove the data volume from Keycloak V17.0.0 by running the following commands:
    ``./AIDA.sh down; docker run --rm -it --entrypoint /bin/sh -v docker-deployment_aida-keycloak-data:/keycloak docker-deployment_keycloak -c 'mkdir keycloak/old_backup_data; mv keycloak/* keycloak/old_backup_data'``
 4. Download AIDA V10.2.3 images from the source repository.
 5. Copy the file ``aida-realm.json`` to the ``keycloak/`` folder in the [docker_deployment_dir]. 
 6. From [docker_deployment_dir],run the following command:
    ``sed -i 's+"loginTheme" : "custom"+"loginTheme" : "keycloakTemplate_HCL"+g' ./keycloak/aida-realm.json``
 7. Complete AIDA V10.2.3 installation by running the following commands: 
    ``./AIDA.sh load``
    ``./AIDA.sh build-start``
    
 
## Uninstalling AIDA 

To uninstall AIDA, run the command 

``./AIDA.sh down``
	
This command will remove AIDA's container, saving data and configuration. 
To remove AIDA's containers and volumes, run the command
 
``./AIDA.sh down-volumes``


## AIDA.sh script 

``AIDA.sh`` script is available to manage AIDA deployment. It provides options to run Docker Compose operations and AIDA configuration steps. 
For the command usage, run  

``./AIDA.sh --help``

``Usage: ./AIDA.sh COMMAND [OPTIONS]``

``Commands:``

``load`` Loads AIDA's container images (required before the first start)

``first-start`` Helps setting up AIDA configuration for the first start

``build-start`` Builds, creates, and starts AIDA's containers (recommended for the first start)

``build`` Builds and creates AIDA's containers (without  starting  them)

``start`` Starts AIDA's containers (without building and creating them. Before the first start, run build or directly use build-start)

``stop`` Stops  AIDA's containers 

``restart``  Restarts  AIDA's containers

``down`` Removes  AIDA's containers (but  not  volumes)

``down-volumes``  Removes  AIDA's containers and volumes

``set-custom-port`` Sets a custom port to access AIDA (default value is 9432)


 
## Configuration parameters

AIDA configuration parameters in the common.env file are divided in three categories:

 1. Parameters whose value users must provide (Mandatory=Y)
 2. Parameters with a default value that users can optionally customize ( Customizable =Y)
 3. Parameters with a default value that users should not change ( Customizable =N)

 - ### Common parameters
 The following table lists the common configurable parameters in the common.env file and their default values:

| **Parameter** | **Description** | **Mandatory** | **Customizable** | **Default value** |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | -------------------------------- | -------------------------------- |
|LOG_LEVEL_INFO |Log level in AIDA. It can be DEBUG, INFO, ERROR, WARNING, CRITICAL | N | Y |"INFO"  |
|ESCONFIG|The Elasticsearch host| N | N | ["https://admin:admin@aida-es:9200"]
|REDIS_HOST|aida-redis host name |N  |N |"aida-redis" |
|REDIS_PSWD|aida-redis password  |N  |N  |"foobared" |
|REDIS_PORT|aida-redis port |N  |N |6379 |
|DEFAULT_SHARD_COUNT | The default number of OpenSearch shards |N |N |1  |	
|DEFAULT_REPLICA_COUNT | The default number of OpenSearch replicas |N | N |0  |
|OPENSSL_PASSWORD | This password will be used to generate an encryption key to hide the Workload Automation server credentials. (According to ISO, passwords must be encrypted inside the database) | Y |  | |
|WEB_CONCURRENCY | Number of workers of the web server (trading). The more they are, the more there is parallelism (and the more RAM is consumed). Suggested value: [(2 x <number_of_cores>) + 1] | N | Y| 2  |


- ### AIDA parameters
The following tables list the configurable parameters of each service in the common.env file and their default values:
 
 ### [aida-predictor parameters](#aida-predictor-parameters)
 	
| **Parameter** | **Description** | **Mandatory** | **Customizable** | **Default** |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | -------------------------------- | -------------------------------- |
|Model|The Machine Learning model used for predictions  |N  | N |  neural (for AIDA on Z Linux, only Prophet ML model is supported) |
 
 ### [aida-ad parameters](#aida-ad-parameters)
 	
| **Parameter** | **Description** | **Mandatory** | **Customizable** | **Default** |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | -------------------------------- | -------------------------------- |
|AIDA_UI_URL|AIDA UI url  |N  | N |  "https://aida-ui:9432/" |
|TOLERANCE_MILLIS |The maximum number of milliseconds between a real data point and a predicted data point in order to consider them close and, therefore, usable by the alert detection algorithm   | N  | Y |240000 |
|MINIMUM_SEVERITY_FOR_MAIL |The minimum level of severity above which an alert will be sent by email. Can be high, medium or low|N   | Y |high |
	
 ### [aida-email parameters](#aida-email-parameters)
 	
| **Parameter** | **Description** | **Mandatory** | **Customizable** | **Default** |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | -------------------------------- | -------------------------------- |
|SMTP_SERVER|The smtp server. Example:  smtp-mail.outlook.com    | Y (if you want to receive anomaly notification by email) | | smtp.server.com  |
|SMTP_PORT|The port of the smtp server  | Y (if you want to receive anomaly notification by email)|  |  587  |
|SENDER_MAILID| The email account of the alert sender   | Y (if you want to receive anomaly notification by email) |  | smtp@server.com  |
|SENDER_MAILPWD|The email password of the alert sender   | Y (if you want to receive anomaly notification by email)|  | smtpPassword  |
|RECIPIENT_MAILIDS|The list of recipient emails. Example: `jack@gmail.com,jessie@live.com`   | Y (if you want to receive anomaly notification by email) | | test1@email.com,test2@email.com  |
|HOST_IP|AIDA Host IP address and Port. Example: 10.14.32.141:9432| Y (if you want to receive anomaly notification by email) | |  |
|EXTERNAL_HOSTNAME=|AIDA Hostname to resolve vulnerabilities|  | |  |



### [aida-orchestrator parameters](#aida-orchestrator-parameters)
 	
| **Parameter** | **Description** | **Mandatory** | **Customizable** | **Default** |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | -------------------------------- | -------------------------------- |
|PROPHET_URL|aida-predictor connection url |N  |N |  "http://aida-predictor:5000"|
|ALERT_URL | aida-ad connection url |N |N | "http://aida-ad:5000" |
|PROPHET_ORCHESTRATOR | interval in minutes between two subsequent predictions, and between two subsequent alert detections  |N  |Y | {"schedule":1440},{"schedule_alert":15} |
|DAYS_OF_PREDICTION |How many days to predict in the future|N   |Y  |1 |


### [aida-ui parameters](#aida-ui-parameters)
 	
| **Parameter** | **Description** | **Mandatory** | **Customizable** | **Default** |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | -------------------------------- | -------------------------------- |
|DEBUG|Log level in AIDA UI  |N  | N |"ERROR:*,INFO:*,-TRACE:*"  |


### [aida-nginx parameters](#aida-nginx-parameters)
 	
| **Parameter** | **Description** | **Mandatory** | **Customizable** | **Default** |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | -------------------------------- | -------------------------------- |
|LICENSE |Before starting AIDA deployment, change into **accept** to accept the product license. | Y | Y | notaccepted |
|CLIENT_SECRET|AIDA secret  |N |N  |AIDA-SECRET |
|KEYCLOAK_URL  |aida-keycloak connection url  | N | N|"http://aida-keycloak:8080"|
|UI_URL  |aida-UI connection url  |N  | N|"http://aida-ui:9000"|
|DWC_PUBLIC_KEY  |By default this variable is set to the DWC public key of the Liberty SSL certificates. If you are using custom certificates for the DWC, replace the default value accordingly.  |N| Y   |(DWC Public Key)|

 ### [aida-exporter parameters](#aida-exporter-parameters)
 	
| **Parameter** | **Description** | **Mandatory** | **Customizable** | **Default** |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | -------------------------------- | -------------------------------- |
|WA_OMETRICS|Connection url to WA exposed metrics  |N  |N|https://WA_URL/metrics  |
|WA_METADATA|Connection url to WA metadata  |N |N |https://WA_URL/twsd/engine/historical_metric/metadata  |
|WA_RECORDS|Connection url to WA records  |N  |N |https://WA_URL/twsd/engine/historical_metric/record  |
|ALERT_CONFIG_URL|Connection url to alert configuration file  |N  |N |https://WA_URL/twsd/engine/definition/alert |
|KPI_CONFIG_URL|Connection url to kpi configuration file  |N  |N |https://WA_URL/twsd/engine/definition/kpi |
|WA_CATALOGS|WA Catalogs  |N  |N |https://WA_URL/twsd/engine/definition/aida_catalog |
|ENDPOINTS_CONF|For KPIs configuration  |N  |N |{"KPI_CONFIG": "twsd/engine/definition/kpi", "ALERT_CONFIG": "twsd/engine/definition/alert", "WA_OMETRICS": "metrics", "WA_METADATA": "twsd/engine/historical_metric/metadata", "WA_RECORDS": "twsd/engine/historical_metric/record", "WA_CATALOGS": "twsd/engine/definition/aida_catalog"} |
|ENDPOINTS_Z_CONF|For KPIs configuration  |N  |N |{"KPI_CONFIG": "twsz/v1/aida/definition/kpi", "ALERT_CONFIG": "twsz/v1/aida/definition/alert", "WA_OMETRICS": "metrics", "WA_METADATA": "twsz/v1/aida/historical_metric/metadata", "WA_RECORDS": "twsz/v1/aida/historical_metric/record", "WA_CATALOGS": "twsz/v1/aida/definition/aida_catalog"} |
|MAXIMUM_DAYS_OF_OLDER_PREDICTIONS_AND_ALERTS |How many days of prediction and alert data to keep in the past | N  |Y |14 |
|MAXIMUM_DAYS_OF_OLDER_DATA|How many days of metrics data to keep in the past |N  |Y|180|
|RESOLVE_ALERTS_AFTER_DAYS|Number of days after which alerts will automatically go in "resolved" status | N  |Y |1|

### [Debugging parameters](#debugging-parameters)

| **Parameter** | **Description** | **Mandatory** | **Customizable** | **Default** |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | -------------------------------- | -------------------------------- |
|PREDICT_EVERYTHING|For debugging purposes| N | N |false|
|TOGGLE_HISTORICAL_DATA|For debugging purposes| N | N |true|



## Troubleshooting

 1. If the Elasticsearch container fails to get up, verify the ``vm.max_map_count`` parameter is at minimum 262144 on the host machine (not inside the container). 
 
	To get the current value, run the command: ``sysctl  vm.max_map_count``.

	To set the new value, run the command: ``sudo  sysctl  vm.max_map_count=262144``.
