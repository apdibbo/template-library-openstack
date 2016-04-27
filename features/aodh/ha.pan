template features/aodh/ha;


# Configuration file for aodh
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/aodh/aodh.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/memcached_servers' = { hosts = '';
foreach(k;v;OS_MEMCACHE_HOSTS) {
        if ( hosts != '') {
            hosts = hosts + ',' + v + ':11211';
        } else {
            hosts = v + ':11211';
        };

        hosts;
    };
};
