

# AI Data Advisor (AIDA) 


## Content
  -  [Introduction](#introduction)  
  -  [Prerequisites](#prerequisites)
  -  [Resources required](#resources-required)  
  -  [Supported platforms](#supported-platforms)
  -  [Accessing the container images](#accessing-the-container-images)
  -  [AIDA structure](#aida-structure)
  -  [AIDA Installation](#aida-installation) 
  -  [Managing Workload Automation server credentials](#managing-workload-automation-server-credentials)
  -  [Updating AIDA installation](#updating-aida-installation)
  -  [Uninstalling AIDA](#uninstalling-aida)
  -  [AIDA.sh script](#aida.sh-script)
  -  [Configuration variables](#configuration-variables)
  -  [Troubleshooting](#troubleshooting)

## Introduction
**AI Data Advisor (AIDA)** is a new component of IBM Workload Automation V10.1, based on Artificial Intelligence and Machine Learning techniques. It enables fast and simplified data-driven decision making for an intelligent workload management. By analyzing workload historical data and metrics gathered by IBM Workload Automation and predicting their future patterns, AIDA identifies anomalies in KPIs trend (such as the jobs in plan by status and the jobs in plan by workstation) and sends immediate alerts to prevent problems and delays. Alerts show up on the Workload Dashboard and can be notified via email.

For more information about AIDA, see AIDA User's Guide in the [IBM Workload Automation documentation](https://www.ibm.com/docs/en/workload-automation/10.1.0).


## Prerequisites

 -  IBM Workload Automation V10.1 exposed metrics.
    - For information about IBM Workload Automation exposed metrics, see "Exposing metrics to monitor your workload" in the [IBM Workload Automation documentation](https://www.ibm.com/docs/en/workload-automation/10.1.0) User's Guide.  
    - For information about IBM Workload Automation for Z exposed metrics, see "Exposing metrics to monitor your workload" in the [IBM Z Workload Scheduler documentation](https://www.ibm.com/docs/en/workload-automation/10.1.0) Managing the Workload manual.    

 -  Docker Compose 1.28 or later.

    Docker 19.x or later.

    Verify that Docker and Docker Compose are installed, configured, and ready to use.
	
 -  Supported browsers are: 
	- Google Chrome 67.0.3396.99 or higher
    - Mozilla Firefox 61.0.1 or higher 
    - Microsoft Edge 79 or higher

 -  External container image for OpenSearch 2.3.0 (an Elasticsearch based technology).

 -  External container image for Keycloak (JBoss Keycloak V17.0.0). Optional, if you want to access AIDA UI from outside the Dynamic Workload Console.
 
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
 You can access AIDA docker file and container images from the Entitled Registry:

 -  Contact your IBM sales representative for the login details required to access the Entitled Registry.
    
 -  Execute the following command to log in into the Entitled Registry:
    
    ```
     docker login -u <your_username> -p <your_entitled_key> : cp.icr.io
    
    ```
The images are as follows:
 
 - ``cp.icr.io/cp/aida-ad:10.1.0.00`` 
 - ``cp.icr.io/cp/aida-exporter:10.1.0.00``
 - ``cp.icr.io/cp/aida-email:10.1.0.00``
 - ``cp.icr.io/cp/aida-nginx:10.1.0.00``
 - ``cp.icr.io/cp/aida-orchestrator:10.1.0.00``
 - ``cp.icr.io/cp/aida-predictor:10.1.0.00``
 - ``cp.icr.io/cp/aida-redis:10.1.0.00``
 - ``cp.icr.io/cp/aida-ui:10.1.0.00``
 

 
  
### From IBM Fix Central

If you are accessing the images from IBM Fix Central source repository, run the following steps:
1. Untar the package locally.
2. From the [docker_deployment_dir] load all the docker images into your environment by running the following commands:
 
	For linux:
 
	 ``./AIDA.sh load``
	 
	 where AIDA.sh is the AIDA installation script: it provides options to run Docker Compose operations and AIDA configuration steps.
	 You can find the script in the installation package.
	 
	 
	For zlinux:
	
	``tar -xvzf aida-images.tgz``
	``for f in ./aida-images/aida-*.tar*; do cat $f | docker load; done``

## AIDA structure
AIDA package includes the following containers: 

- **aida-ad** - Anomaly detection and alert generation service
- **aida-exporter** - Exporter service
- **aida-mail** - Email notification service 
- **aida-nginx** - As a reverse proxy for AIDA components
- **aida-orchestrator** - Orchestrator service
- **aida-predictor** - Predictor service
- **aida-redis** - Internal event manager
- **aida-ui** - AIDA UI
  

Also, AIDA uses:

 - **Keycloak** - To manage security and user access. Keycloak is optional: if used, it enables the creation of AIDA administrators who can access AIDA UI from outside the Dynamic Workload Console. Otherwise,  AIDA can only be accessed from the alert widget in the Workload Dashboard of the Dynamic Workload Console. 

 - **OpenSearch (an Elasticsearch based technology)** - To store and analyze data.

 
## AIDA installation 
To install AIDA, run the following procedure: 

 1. Accept the product license by setting the LICENSE parameter to **accept** in the common.env file located in the [docker_deployment_dir] directory.
 2. To use custom SSL certificates for AIDA, in the <install_path>/nginx/cert folder replace aida.crt e aida.key with your own files (do not change the default names).
 3. Verify that the `DWC_PUBLIC_KEY` parameter in the common.env file is set to the DWC public key of the Liberty SSL certificates.

	If you are using custom certificates for the DWC, replace the `DWC_PUBLIC_KEY` value accordingly.
 4. In the common.env file, set the ``OPENSSL_PASSWORD``  parameter. This parameter will be used to generate an encryption key to hide the IBM Workload Automation engine credentials. (According to ISO, passwords must be encrypted inside the database).
 5. If you want to customize the installation parameters, edit the common.env file. For details, see  [Configuration variables](#configuration-variables).
 6. Optionally, from [docker_deployment_dir], run the command
 
	 ``./AIDA.sh first-start``

     This command starts a guided configuration procedure. Follow the guided procedure and answer the prompts to configure AIDA with your settings.
   
 7.  Build, create, and start AIDA containers by running the command   
 
     ``./AIDA.sh build-start``

	 AIDA is now up and running.    
 8.  Configure the first server to be monitored by running the command 
 
     ``./AIDA.sh add-credentials``    
	
     This command starts a guided configuration of the server. 
	 For details, see [Managing Workload Automation server credentials](#managing-workload-automation-server-credentials).
    
9. If Keycloak is included in your AIDA deployment, you can connect AIDA user interface at the following link
 
	 ``https://aida-ip:aida-port/``
	
	 Specify ``aida-port`` only if it is different from the default value (9432). 
     Otherwise, AIDA can only be accessed from the alert widget in the Workload Dashboard of the Dynamic Workload Console. 

   **Note**: The **common.env** environment file contains all the environment variables. For details, see  [Configuration variables](#configuration-variables).   

## Managing Workload Automation server credentials
You can manage the credentials needed to connect to a Workload Automation server using  AIDA.sh script. 
With a single AIDA instance you can monitor hybrid environments with a mix of IBM Workload Automation for distributed and z/OS systems.

**Limitations:**
With AIDA.sh script you can add, update, and delete credentials. You cannot list credentials since this function is not currently available.

To **add new credentials**, run the following steps:
 1. From [docker_deployment_dir], run the following command  
 
	 ``./AIDA.sh add-credentials``. 
	
	 A guided configuration procedure will start. 
 2. Follow the guided procedure and answer the prompts to add your credentials, specify the engine type (if IBM Workload Automation for distributed systems or IBM Z Workload Scheduler) and, for IBM Z Workload Scheduler only, also the engine name.

**Note:** If you are connecting IBM Workload Automation for distributed systems, you must use the Engine credentials.
If you are connecting IBM Z Workload Scheduler, you must use the Dynamic Workload Console credentials instead.

To **update existing credentials**, run the following steps:
 1. From [docker_deployment_dir], run the following command   
 
	 ``./AIDA.sh update-credentials``. 
	
	 A guided configuration procedure will start.
 2. Follow the guided procedure and answer the prompts to add your credentials, specify the engine type (if IBM Workload Automation for distributed systems or IBM Z Workload Scheduler) and, for IBM Z Workload Scheduler only, also the engine name.


To **delete existing credentials**, run the following steps:
1.	From [docker_deployment_dir], run the following command

	 ``./AIDA.sh delete-credentials``. 
	
	 A guided configuration procedure will start.
2.	 Follow the guided procedure and answer the prompts to delete your credentials.


## Updating AIDA installation

To update an existing AIDA installation, you just need to refresh AIDA images in the installation folder and rerun the installation steps:
1. ``./AIDA.sh down``
2. For linux:
 
	 ``./AIDA.sh load``
	 
	  
	 
	For zlinux:
	
	``tar -xvzf aida-images.tgz``
	``for f in ./aida-images/aida-*.tar*; do cat $f | docker load; done``
3. ``./AIDA.sh build-start``

 Existing configuration parameters are used.
 
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

``add-credentials`` Lets  you  add  credentials to connect to a Workload Automation engine

``update-credentials`` Lets  you update previously  added  credentials

``delete-credentials`` Lets  you  delete previously added credentials 

``set-custom-port`` Sets a custom port to access AIDA (default value is 9432)


 
## Configuration variables
This section lists the configuration variables in the common.env file.

### Common
``LICENSE=notaccepted`` - before starting AIDA deployment, change into **accept** to accept the product license

``LOG_LEVEL=INFO`` - logging level. Possible values are: DEBUG, INFO, ERROR, WARNING, CRITICAL

``ESCONFIG=["https://admin:admin@aida-es:9200"]`` - comma separated list of elasticsearch hosts

``REDIS_HOST=aida-redis`` - aida-redis hostname

``REDIS_PORT=6379`` - aida-redis port

``REDIS_PSWD=foobared`` - aida-redis password

``DEFAULT_SHARD_COUNT=1`` - Number of opensearch shards  

``DEFAULT_REPLICA_COUNT=0`` - Number of opensearch replicas

``WEB_CONCURRENCY=6`` - Number of workers of the web server. The more they are, the more there is parallelism (and the more RAM is consumed). Suggested value: 2 x <number_of_cores> + 1

``OPENSSL_PASSWORD=`` - mandatory - this password will be used to generate an encryption key to hide the Workload Automation server credentials. (According to ISO, passwords must be encrypted inside the database).
 
### aida-ad
``AIDA_UI_URL: "https://aida-ip:9432/"`` - aida UI url 

``PAST_MILLIS=86400000`` - the number of milliseconds that AIDA waits before analyzing predictions to detect alerts

``TOLERANCE_MILLIS=240000`` - the maximum number of milliseconds between a real data point and a predicted data point in oder to consider them close and, therefore, usable by the alert detection algorithm

``MINIMUM_SEVERITY_FOR_MAIL=high`` - minimum level of severity above which an alert will be sent by email. Can be high, medium or low


### aida-mail
``SMTP_SERVER="smtp.mail.com"`` - smtp server

``SMTP_PORT=587`` - smtp port

``SENDER_MAILID="sender@mail.com"`` - alert sender email account

``SENDER_MAILPWD=pwd`` - alert sender email password

``RECIPIENT_MAILIDS=test1@mail.com,test2@mail.com`` - list of recipient emails


### aida-redis

Optionally, before AIDA installation, you can replace the following default certificates for redis connection with custom certificates (file names must be the same): 

``[docker_deployment_dir]/aida-redis/redis.key`` - certificate key

``[docker_deployment_dir]/aida-redis/redis.crt`` - certificate 

``[docker_deployment_dir]/aida-redis/ca.pem`` - certificate authority

The above certificates will only be used for AIDA's containers internal communication.

### aida-orchestrator
``PROPHET_URL=http://aida-predictor:5000`` -  aida-predictor connection url

``ALERT_URL=http://aida-ad:5000`` - aida-ad connection url

``PROPHET_ORCHESTRATOR={"schedule":1440"}`` - interval in minutes between two subsequent training(s). Default value is 1440.

``DAYS_OF_PREDICTION=1`` - How many days to predict in the future


### aida-nginx
``CLIENT_SECRET=CLIENT_SECRET_CONFIG``

``KEYCLOAK_URL=https://keycloak_URL/keycloak`` - aida-keycloak connection url

``DWC_PUBLIC_KEY= "certificate"`` - by default this variable is set to the DWC public key of the Liberty SSL certificates. If you are using custom certificates for the DWC, replace the default value accordingly.

### aida-exporter
``WA_OMETRICS=https://WA_URL/metrics`` - connection url to WA exposed metrics

``WA_METADATA=http://WA_URL/metadata`` - connection url to WA metadata

``WA_RECORDS=http://WA_URL/records`` - connection url to WA records

``ALERT_CONFIG_URL=http://WA_URL/metric_retriever`` - connection url to alert configuration file

``KPI_CONFIG_URL=http://WA_URL/kpi_retriever`` - connection url to kpi configuration file

``MAXIMUM_DAYS_OF_OLDER_PREDICTIONS=14`` - number of days of predictions to keep in the past

``MAXIMUM_DAYS_OF_OLDER_DATA=400`` - the number of days of metrics data to keep in the past

``RESOLVE_ALERTS_AFTER_DAYS=1`` - number of days after which alerts will automatically go in "resolved" status

### aida-ui
``DEBUG=ERROR:*,INFO:*,-TRACE:*`` - logging level

  

## Troubleshooting

 1. If the Elasticsearch container fails to get up, verify the ``vm.max_map_count`` parameter is at minimum 262144 on the host machine (not inside the container). 
 
	To get the current value, run the command: ``sysctl  vm.max_map_count``.

	To set the new value, run the command: ``sudo  sysctl  vm.max_map_count=262144``.
