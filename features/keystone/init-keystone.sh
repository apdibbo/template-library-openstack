#!/bin/bash
echo "load variable"

# Keystone URL
export KEYSTONE_URI="http://%s:5000"
export KEYSTONE_URL="http://%s:35357"

export ADMIN_USERNAME=%s
export ADMIN_PASSWORD=%s


echo "[START] Databases configuration"
echo "  Identity service"
$DEBUG_DATABASES su -s /bin/sh -c "keystone-manage db_sync" keystone
echo "[DONE] Database configuration"

echo "[START] service configuration"
systemctl start openstack-keystone
echo "  keystone"
$DEBUG_SERVICES quattor_openstack_add_service.sh 'identity' "Openstack Identity" 'keystone'
echo "[END] service configuration"

echo "[START] endpoints configuration"
echo "  Identity endpoint"
for endpoint_type in $ENDPOINT_TYPES
do
  $DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'identity' $endpoint_type $REGION "$KEYSTONE_URI/v2.0"
done
$DEBUG_ENDPOINTS quattor_openstack_add_endpoint.sh 'identity' $ADMIN_ENDPOINT_TYPE $REGION "$KEYSTONE_URI/v2.0"
echo "[END] endpoints configuration"

echo "[START] Project configuration"
echo "  service project"
$DEBUG_PROJECTS quattor_openstack_add_project.sh 'service' "Service Project" $OS_PROJECT_DOMAIN_ID
echo "  admin project"
$DEBUG_PROJECTS quattor_openstack_add_project.sh 'admin' "Admin Project" $OS_PROJECT_DOMAIN_ID
echo "[END] Project configuration"

echo "[START] Role configuration"
echo "  admin role"
$DEBUG_ROLES quattor_openstack_add_role.sh 'admin'
echo "  role user"
$DEBUG_ROLES quattor_openstack_add_role.sh 'user'
echo "[END] Role configuration"

echo "[START] User configuration"
echo "  admin user [$ADMIN_USERNAME]"
$DEBUG_USERS quattor_openstack_add_user.sh $ADMIN_USERNAME $ADMIN_PASSWORD $OS_PROJECT_DOMAIN_ID
echo "[END] User configuration"

echo "[START] Role configuration"
echo "  Role for admin"
$DEBUG_USERS_TO_ROLES quattor_openstack_add_user_role.sh $ADMIN_USERNAME 'admin' 'admin'
echo "[END] Role configuration"
