#!/bin/bash

target=public.ecr.aws/t6y8f1l2
containers="nirmata/kubectl nirmata/nirmata-cni-installer nirmata/nirmata-kube-installer nirmata/nirmata-host-agent nirmata/hostpath-provisioner"

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

for container in $containers ; do
    aws ecr-public create-repository --repository-name $container --region us-east-1
    docker pull -a $container
    docker images $container  --format "docker tag {{.Repository}}:{{.Tag}} $target/{{.Repository}}:{{.Tag}} | docker push $target/{{.Repository}}:{{.Tag}}" |bash
done
