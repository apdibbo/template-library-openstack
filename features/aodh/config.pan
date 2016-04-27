unique template features/aodh/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Include utils
include 'defaults/openstack/utils';

include 'features/aodh/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-aodh-api/on' = '';
'openstack-aodh-api/startstop' = true;
'openstack-aodh-evaluator/on' = '';
'openstack-aodh-evaluator/startstop' = true;
'openstack-aodh-notifier/on' = '';
'openstack-aodh-notifier/startstop' = true;
'openstack-aodh-listener/on' = '';
'openstack-aodh-listener/startstop' = true;

# Configuration file for aodh
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/aodh/aodh.conf}';
'module' = 'tiny';
'daemons/openstack-aodh-api'='restart';
'daemons/openstack-aodh-evaluator'='restart';
'daemons/openstack-aodh-notifier'='restart';
'daemons/openstack-aodh-listener'='restart';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/cert_file' = if (OS_SSL) {
  OS_SSL_CERT;
} else {
  null;
};
'contents/DEFAULT/key_file' = if (OS_SSL) {
  OS_SSL_KEY;
} else {
  null;
};
# [oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# [database] section
'contents/database/connection' = 'mysql+pymysql://' +
  OS_AODH_DB_USERNAME + ':' +
  OS_AODH_DB_PASSWORD + '@' +
  OS_AODH_DB_HOST + '/aodh';

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_AODH_USERNAME;
'contents/keystone_authtoken/password' = OS_AODH_PASSWORD;

'contents/service_credentials/os_auth_url' = OS_KEYSTONE_CONTROLLER_PROTOCOL + '://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000/v2.0';
'contents/service_credentials/username' = OS_AODH_USERNAME;
'contents/service_credentials/os_tenant_name' = 'service';
'contents/service_credentials/os_password' = OS_AODH_PASSWORD;
'contents/service_credentials/os_endpoint_type' = 'internalURL';
'contents/service_credentials/os_region_name' = OS_REGION_NAME;

include if (OS_HA) {
    'features/glance/ha';
} else {
    null;
};
