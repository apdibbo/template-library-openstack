#!/bin/bash

%s

export AODH_URL="http://%s:8042"

export AODH_DB_HOST=%s
export AODH_DB_USER=%s
export AODH_DB_PASSWORD=%s
export AODH_USER=%s
export AODH_PASSWORD=%s

echo "[START] Databases configuration"
echo "  Telemetry Service"

echo "[DONE] Database configuration"


echo "[START] service configuration"
echo "  aodh"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'alarming' "Telemetry" 'aodh'
echo "[END] service configuration"

echo "[START] endpoints configuration"
echo "  Aodh endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'alarming' $endpoint_type $REGION $AODH_URL
done
echo "[END] endpoints configuration"

echo "[START] User configuration"
echo "  aodh user [$AODH_USER]"
$DEBUG_USERS quattor_openstack_add_user.sh $AODH_USER $AODH_PASSWORD $OS_PROJECT_DOMAIN_ID
echo "[END] User configuration"

echo "[START] Role configuration"
echo "  Role for aodh"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $AODH_USER 'admin' 'service'
echo "[END] Role configuration"
