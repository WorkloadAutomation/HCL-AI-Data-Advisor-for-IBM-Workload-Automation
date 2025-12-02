#!/bin/bash

# *******************************************************************************
# Licensed Materials - Property of HCL
# (c) Copyright HCL Technologies Ltd. 2023. All Rights Reserved.
# 
# Note to U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# *******************************************************************************


usage() {
    echo ""
    echo "Usage:    $0 COMMAND [OPTIONS]"
    echo ""
    echo "This script manages the AIDA deployment."
    echo ""
    echo "Commands:"
    echo "  load                  Loads AIDA's container images"
    echo "  set-custom-port       Sets a custom port to access AIDA (default is 9432)"
    echo "  build-start           Builds, creates and starts AIDA's containers (reccommended for the first start)"
    echo "  build                 Builds and creates AIDA's containers (without starting them)"
    echo "  start                 Starts AIDA's containers (without building and creating them, before the first start run build or directly use build-start)"
    echo "  up                    Recreates only containers if the configuration changed after last start (reccommended for debug)"
    echo "  stop                  Stops AIDA's containers"
    echo "  restart               Restarts AIDA's containers"
    echo "  down                  Removes AIDA's containers (but not volumes)"
    echo "  down-volumes          Removes AIDA's containers and volumes"
    echo "  first-start           Helps setting up AIDA configuration for the first start"
    echo "  add-credentials       Lets you add credentials to connect to a Workload Automation server"
    echo "  update-credentials    Lets you update previously added credentials"
    echo "  delete-credentials    Lets you delete previously added credentials"
    echo ""
    echo "Options:"
    echo "  --noexporter          Excludes the exporter service when executing the command"
    echo "  --debug               Enables debug mode"
}

# Use "docker compose" if "docker-compose" doesn't exist.
if ! type docker-compose >& /dev/null; then 
    docker-compose() {
        docker compose "$@"
    }
fi

load() {
    for f in ../aida-*.t*; do cat $f | docker load; done
}

start() {
    docker compose -f $yml start
}

stop() {
    docker compose -f $yml stop
}

restart() {
    docker compose -f $yml restart
}

down() {
    docker compose -f $yml down
}

down_volumes() {
    docker compose -f $yml down --volumes
}

build() {
	docker compose -f $yml build --build-arg REGISTRY='hclcr.io/wa/workload-automation/hcl-' --build-arg VERSION=10.2.3
    docker compose -f $yml up --no-start
}

build_start() {
	docker compose -f $yml build --build-arg REGISTRY='hclcr.io/wa/workload-automation/hcl-' --build-arg VERSION=10.2.3 $1
    docker compose -f $yml up -d $1
}

up() {
    docker compose -f $yml up -d
}

first_start() {
    read -p "Do you want to add the credentials to connect to an Workload Automation server? [Y/n]: " -n 1 -r
    echo ""

    case "$REPLY" in
        y|Y|"")
        add_credentials
        ;;

        *)
        echo "Credentials not configured."
        echo ""
        ;;
    esac

    read -p "Do you want to change the default port (9432) to access AIDA? [Y/n]: " -n 1 -r
    echo ""

    case "$REPLY" in
        y|Y|"")
        set_custom_port $yml
        ;;

        *)
        echo "Leaving the default port (9432) unchanged."
        echo ""
        ;;
    esac
}

start_config() {
    if ! docker image inspect "hclcr.io/wa/workload-automation/hcl-aida-config:10.2.3" >&/dev/null; then
        echo "Loading configuration container image..."
        for f in ../aida-*.t*; do cat $f | docker load; done
    fi

    echo "Starting configuration container..."

    docker compose --profile config -f $yml up -d config

    if [ $? -ne 0 ]; then
        echo ""
        echo "ERROR: Failed to start the configuration container"
        exit
    fi

    echo ""
}

start_opensearch() {
    echo "Starting database to store credentials..."

    build_start "es"

    if [ $? -ne 0 ]; then
        echo ""
        echo "ERROR: Failed to start Opensearch"
        exit
    fi

    echo ""
}

add_credentials() {
    start_opensearch
    
    docker compose --profile config exec config /config.sh add_credentials
}

update_credentials() {
    start_opensearch

    docker compose --profile config exec config /config.sh update_credentials
}

delete_credentials() {
    start_opensearch

    docker compose --profile config exec config /config.sh delete_credentials    
}

set_custom_port() {
    read -p "Enter the new port you want to use: " port

    OK=1
    while [ "$OK" -ne 0 ]; do
        # Check if the input is an integer.
        if [[ ! "$port" =~ ^[0-9]+$ ]]; then
            read -p "Please enter an integer number: " port
            OK=1
            continue
        fi

        # Check if the port is already used.
        if timeout 1 bash -c "</dev/tcp/host.docker.internal/${port}" &> /dev/null; then
            read -p "Port is used by another process, please choose another one: " port
            OK=1
            continue
        fi

        OK=0
    done

      # Changes the port in the docker-compose yaml file.
    if sed -Ezi "s/ports:(\s+)- \"[0-9]+:[0-9]+\"/ports:\1- \"$port:$port\"/" $1 &&
       sed -Ezi "s/listen(\s+)[0-9]+/listen\1$port/" "./nginx/default.conf" &&
       sed -Ezi "s,HOST_PORT=[0-9]+,HOST_PORT=$port,g" "common.env"; then
        echo "Port successfully changed!"
    else
        echo "ERROR: Could not change the port"
    fi
    sed -Ezi "s,hostname-port=[0-9]+,hostname-port=${port},g" ./keycloak/keycloak.conf

    docker cp ./keycloak/keycloak.conf aida-keycloak:/opt/keycloak/conf/keycloak.conf
    up

    docker cp ./nginx/default.conf aida-nginx:/etc/nginx/conf.d/default.conf.template
    docker restart aida-nginx
    echo ""
}

set_shards() {
    read -p "Enter the number of shards you want to use: " shards

    # Check if the input is an integer.
    while [[ ! "$shards" =~ ^[0-9]+$ ]]; do
        read -p "Please enter an integer number: " shards
    done

    # Changes the shards in the common.env file.
    if sed -Ezi "s/DEFAULT_SHARD_COUNT=[0-9]+/DEFAULT_SHARD_COUNT=$shards/" $1; then
        echo "Shards successfully changed!"
    else
        echo "ERROR: Could not change the shards"
    fi

    echo ""
}



get_machine_address(){
    ip_already_setted=$(cat common.env | grep -E "HOST_IP=[0-9.]+")
    
    if [ -n "$ip_already_setted" ];then
        return 0
    fi
    machine_address=$(ip -4 -o -br address show | head -2 | tail -1 | tr -s ' ' | cut -d ' ' -f 3 | cut -d '/' -f 1)
    if [ $? -ne 0 ] || [ -z "$machine_address" ]; then
        echo ""
        echo "Ip address of the machine not found,the IP of the machine will not be setted automatically"
        return 0
    fi

    if ping -q -c 1 -w 2 $machine_address 2>&1 > /dev/null;then
        echo "Found IP Address $machine_address, it will be setted automatically"
        sed  -i "s,EXTERNAL_HOSTNAME=,EXTERNAL_HOSTNAME=$machine_address,g" common.env
    else
        echo "Found IP Address $machine_address,but can't reach it"
        echo "IP Address $machine_address. Will not be setted automatically"
    fi

}   

cleanup() {
    echo "Removing configuration container..."

    docker compose -f $yml rm -svf "config"

    if [ $? -ne 0 ]; then
        echo ""
        echo "ERROR: Failed to remove the configuration container"
        exit
    fi

    echo ""
}

check_license(){
    if [ $(grep -Fx "LICENSE=accept" common.env) ]; then
        return
    fi

    less Licenses/license

    LICENSE_CONFIRMATION="Y"
    read -p "Confirm License [Y/n] " LICENSE_CONFIRMATION
    if [[ $LICENSE_CONFIRMATION == "Y"  ||  $LICENSE_CONFIRMATION == "y" ]]; then
        sed -i "s,LICENSE=notaccepted,LICENSE=accept,g" common.env
    else
        echo You need to accept the license before using AIDA
        exit 1
    fi
}

dump_log(){
    LOG_DIR="docker_logs"
    mkdir -p $LOG_DIR

    echo "Searching for Aida Docker Containers"
    set -f
    IFS=" "
    CONTAINERS=$(docker ps -a | grep -oh "aida-\w*" | tr '\n' ' ')
    CONTAINERS_CLEAN=()

    for container in $CONTAINERS;do
        if [[ "$container" != *"nginx"* ]] && [[ "$container" != *"hcl"* ]] && [[ "$container" != *"config"* ]] 
        then
            CONTAINERS_CLEAN+=("$container")
        fi
    done

    if [ ${#CONTAINERS_CLEAN[@]} -eq 0 ];then
        echo "There are no containers builded"
        echo "Please before calling dump build the containters with AIDA.sh build-start"
        exit 2
    fi

    for container in $CONTAINERS_CLEAN;do
        if [[ "$container" != *"nginx"* ]] && [[ "$container" != *"hcl"* ]]
        then
            docker logs $container >> "$LOG_DIR/$container.log" 2>&1
        fi
    done

    docker cp aida-nginx:/var/log/nginx $LOG_DIR/
}

# Parse options
if ! options=$(getopt -n "$0" --options "h" --long "help,noexporter,debug,dev" -- "$@"); then
    usage
    exit
fi

eval set -- "$options"

# Use options
noexporter=false
yml="docker-compose.yml"
debug_yml="docker-compose.debug.yml"
dev_yml="docker-compose.dev.yml"
common="common.env"
while true; do
    case "$1" in
    --noexporter)
        noexporter=true
        yml="docker-compose-noexporter.yml"
        shift
        ;;
    --debug)
        yml="$yml -f $debug_yml"
        shift
        ;;
    --dev)
        yml="$yml -f $dev_yml"
        shift
        ;;
    -h|--help)
        usage
        exit
        ;;
    --)
        shift
        break
        ;;
    *)
        usage
        exit
        ;;
    esac
done

# Check number of commands
if [ "$#" -ne 1 ]; then
    usage
    exit
fi

# Start config container
check_license
#get_machine_address
start_config

# Clean up containers if the script exits
trap cleanup EXIT

# Execute command
case "$1" in
    load)
        load $noexporter
        ;;

    set-custom-port)
        set_custom_port $yml
        ;;

    start)
        start
        ;;

    stop)
        stop
        ;;

    restart)
        restart
        ;;

    down)
        down
        ;;

    down-volumes)
        down_volumes
        ;;

    build)
        build
        ;;

    build-start)
        build_start
        ;;

    up)
        up
        ;;

    first-start)
        first_start
        ;;

    add-credentials)
        add_credentials
        ;;

    update-credentials)
        update_credentials
        ;;

    delete-credentials)
        delete_credentials
        ;;
    dump)
        dump_log
        ;;
    -h|--help|*)
        usage
        exit
        ;;
esac