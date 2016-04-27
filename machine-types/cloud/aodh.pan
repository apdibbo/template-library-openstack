unique template machine-types/cloud/aodh;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'personality/aodh/config';
