structure template features/rabbitmq/client/openstack;

'rabbit_hosts' = if (OPENSTACK_HA) {
    openstack_dict_to_hostport_string(OPENSTACK_RABBITMQ_HOSTS);
} else {
    null;
};
'rabbit_userid' = OPENSTACK_RABBITMQ_USERNAME;
'rabbit_password' = OPENSTACK_RABBITMQ_PASSWORD;
