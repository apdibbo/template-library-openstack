unique template features/mariadb/aodh;

include 'components/mysql/config';
variable usersdict = if (OS_HA) {
    users = dict();
    foreach(k;v;OS_AODH_SERVERS) {
        users[escape(OS_AODH_DB_USERNAME+"@"+k)]= dict(
            'password',OS_AODH_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES'),
        )
    };
    users;
} else {
    dict(
        OS_AODH_DB_USERNAME, dict(
            'password',OS_AODH_DB_PASSWORD,
            'rights',list('ALL PRIVILEGES')
        )
    );
};
prefix '/software/components/mysql/databases';
'aodh' = {
  SELF['createDb'] = true;
  SELF['server'] = OS_AODH_DB_HOST;
  SELF['users'] = usersdict;
  SELF;
};
