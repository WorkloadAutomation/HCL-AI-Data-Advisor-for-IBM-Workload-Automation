#!/bin/bash

# *******************************************************************************
# Licensed Materials - Property of HCL
# (c) Copyright HCL Technologies Ltd. 2021. All Rights Reserved.
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
    echo "  set-shards            Sets the number of shards for Elasticsearch (default is 1)"
    echo "  build-start           Builds, creates and starts AIDA's containers (reccommended for the first start)"
    echo "  build                 Builds and creates AIDA's containers (without starting them)"
    echo "  start                 Starts AIDA's containers (without building and creating them, before the first start run build or directly use build-start)"
    echo "  stop                  Stops AIDA's containers"
    echo "  restart               Restarts AIDA's containers"
    echo "  down                  Removes AIDA's containers (but not volumes)"
    echo "  down-volumes          Removes AIDA's containers and volumes"
    echo "  first-start           Helps setting up AIDA configuration for the first start"
    echo "  add-credentials       Lets you add credentials to connect to an OpenMetrics server"
    echo "  update-credentials    Lets you update previously added credentials"
    echo "  delete-credentials    Lets you delete previously added credentials"
    echo ""
    echo "Options:"
    echo "  --noexporter          Excludes the exporter service when executing the command"
}

# Use "docker compose" if "docker-compose" doesn't exist.
if ! type docker-compose >& /dev/null; then 
    docker-compose() {
        docker compose "$@"
    }
fi

load() {
    docker load -i ../aida-images.tgz
}

start() {
    docker-compose -f $1 start
}

stop() {
    docker-compose -f $1 stop
}

restart() {
    docker-compose -f $1 restart
}

down() {
    docker-compose -f $1 down
}

down_volumes() {
    docker-compose -f $1 down --volumes $2
}

build() {
	docker-compose -f $1 build --build-arg REGISTRY="cp.icr.io/cp" --build-arg VERSION=10.2.6
    docker-compose -f $1 up --no-start
}

build_start() {
	docker-compose -f $1 build --build-arg REGISTRY="cp.icr.io/cp" --build-arg VERSION=10.2.6 $2
    docker-compose -f $1 up -d $2
}

first_start() {
    read -p "Do you want to add the credentials to connect to an OpenMetrics server? [Y/n]: " -n 1 -r
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

    read -p "Do you want to change the default number of shards (1) of Elasticsearch? [Y/n]: " -n 1 -r
    echo ""

    case "$REPLY" in
        y|Y|"")
        set_shards $common
        ;;

        *)
        echo "Leaving the default shard count (1) unchanged."
        echo ""
        ;;
    esac
}

start_config() {
    if ! docker image inspect "cp.icr.io/cp/ibm-workload-automation-aida-config:10.2.6" >&/dev/null; then
        echo "Loading configuration container image..."
        docker load -i ../aida-images.tgz
    fi

    echo "Starting configuration container..."

    docker-compose --profile config -f $yml up -d config

    if [ $? -ne 0 ]; then
        echo ""
        echo "ERROR: Failed to start the configuration container"
        exit
    fi

    echo ""
}

start_elasticsearch() {
    echo "Starting Elasticsearch to store credentials..."

    build_start $yml "es"

    if [ $? -ne 0 ]; then
        echo ""
        echo "ERROR: Failed to start Elasticsearch"
        exit
    fi

    echo ""
}

add_credentials() {
    start_elasticsearch
    
    docker-compose --profile config exec config /config.sh add_credentials
}

update_credentials() {
    start_elasticsearch

    docker-compose --profile config exec config /config.sh update_credentials
}

delete_credentials() {
    start_elasticsearch

    docker-compose --profile config exec config /config.sh delete_credentials    
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
    if sed -Ezi "s/ports:(\s+)- \"[0-9]+:([0-9]+)\"/ports:\1- \"$port:\2\"/" $1; then
        echo "Port successfully changed!"
    else
        echo "ERROR: Could not change the port"
    fi

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

cleanup() {
    echo "Removing configuration container..."

    docker-compose -f $yml rm -svf "config"

    if [ $? -ne 0 ]; then
        echo ""
        echo "ERROR: Failed to remove the configuration container"
        exit
    fi

    echo ""
}

# Parse options
if ! options=$(getopt -n "$0" --options "h" --long "help,noexporter" -- "$@"); then
    usage
    exit
fi

eval set -- "$options"

# Use options
noexporter=false
yml="docker-compose.yml"
common="common.env"
while true; do
    case "$1" in
    --noexporter)
        noexporter=true
        yml="docker-compose-noexporter.yml"
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

    set-shards)
        set_shards $common
        ;;

    start)
        start $yml
        ;;

    stop)
        stop $yml
        ;;

    restart)
        restart $yml
        ;;

    down)
        down $yml
        ;;

    down-volumes)
        down_volumes $yml
        ;;

    build)
        build $yml
        ;;

    build-start)
        build_start $yml
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

    -h|--help|*)
        usage
        exit
        ;;
esac