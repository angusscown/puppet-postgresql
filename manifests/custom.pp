class postgresql::custom{

 file {"pg_hba.conf":
    path    => "/etc/postgresql/9.1/main/pg_hba.conf",
    content => template("postgresql/9.1/pg_hba.conf.erb"),
    owner   => 'postgres',
    group   => 'postgres',
    replace => true,
    mode    => 640,
    require => [User['postgres'],Exec['init-postgres']]    ,
    notify  => Service['postgresql'],
  }

  file {"postgresql.conf":
    path    => "/etc/postgresql/9.1/main/postgresql.conf",
    content => template("postgresql/9.1/postgresql.conf.erb"),
    owner   => 'postgres',
    group   => 'postgres',
    require => [User['postgres'],Exec['init-postgres']]  ,
    notify  => Service['postgresql'],
  }

  file {"/data/postgresql":
     ensure => directory,
     group => "postgres",
     owner => "postgres",
     mode => 0700,
     require => [File["/data"],Package["postgresql-9.1"]]

    }

   exec {'init-postgres' :
      command => "pg_dropcluster --stop 9.1 main && pg_createcluster -e UTF-8 -d /data/postgresql/ 9.1 main ",
      provider => shell,
      logoutput => true,
      creates => "/data/postgresql/base",
      require => [Package["postgresql-9.1"],File["/data/postgresql"],Package["repmgr"]],
    }

    }
