#!/bin/bash

USER=$1
ROLE=$2
PROJECT=$3

openstack role add --project $PROJECT --user $USERNAME $ROLE
