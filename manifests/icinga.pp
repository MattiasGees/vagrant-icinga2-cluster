node 'master.vagrant.local' {
  class { '::mysql::server':
    root_password           => 'testicinga',
    remove_default_accounts => true,
  }
  mysql::db { 'icinga2':
    user     => 'icinga2',
    password => 'icinga2',
    host     => 'localhost',
  }
  mysql::db { 'icingaweb2':
    user     => 'icingaweb2',
    password => 'icingaweb2',
    host     => 'localhost',
  }

  apt::source { 'icinga2':
    location    => 'http://packages.icinga.org/ubuntu',
    release     => 'icinga-trusty',
    repos       => 'main',
    key         => '13F2C675',
    key_source  => 'http://packages.icinga.org/icinga.key',
    include_src => false,
  }

  class { 'icinga2::server':
    purge_unmanaged_object_files  => true,
    server_db_type                => 'mysql',
    db_host                       => 'localhost',
    db_port                       => '3306',
    db_name                       => 'icinga2',
    db_user                       => 'icinga2',
    db_password                   => 'icinga2',
    server_enabled_features       => [
      'checker',
      'notification',
      'command',
      'api',
      'compatlog',
      'icingastatus',
      'livestatus',
      'mainlog',
      'mysql_connection',
      'perfdata',
      'statusdata'
    ],
    server_install_nagios_plugins => false, #NRPE installs this
    install_mail_utils_package    => false, #Postfix installs this
  }

  icinga2::object::idomysqlconnection { 'mysql_connection':
    target_dir    => '/etc/icinga2/features-enabled',
    user          => 'icinga2',
    database      => 'icinga2',
    host          => 'localhost',
    password      => 'icinga2',
    instance_name => $fqdn,
    categories    => [
      'DbCatCheck',
      'DbCatState',
      'DbCatConfig',
      'DbCatAcknowledgement',
      'DbCatComment',
      'DbCatDowntime',
      'DbCatEventHandler',
      'DbCatExternalCommand',
      'DbCatFlapping',
      'DbCatLog',
      'DbCatNotification',
      'DbCatProgramStatus',
      'DbCatRetention',
      'DbCatStateHistory',
    ],
  }

  Apt::Source['icinga2'] ->
  Mysql::Db['icinga2'] ->
  Class['Icinga2::Server'] ->
  Icinga2::Object::Idomysqlconnection['mysql_connection']
}
