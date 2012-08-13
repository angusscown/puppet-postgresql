class postgresql::server::install(
  $version,
  $listen_addresses,
  $max_connections,
  $shared_buffers,
  $psql_port
  ) {

  package {"postgresql":
    ensure  => present,
    name    => $operatingsystem ? {
      Ubuntu  => "postgresql-${version}",
      default => "postgresql",
    },
  }

  package {'postgresql-plperl':
    ensure  => installed,
    require => Package['postgresql'],
    name    => $operatingsystem ? {
      Ubuntu  => "postgresql-plperl-${version}",
      default => "postgresql-plperl",
    },
  }

  package {'postgresql-contrib':
    ensure  => installed,
    require => Package['postgresql'],
    name    => $operatingsystem ?{
      Ubuntu  => "postgresql-contrib-${version}",
      default => 'postgresql-contrib',
    }
  }

  service {'postgresql':
    enable      => true,
    name        => 'postgresql',
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    require     => Package['postgresql'],
  }

  user { 'postgres':
    ensure  => present,
    require => Package['postgresql'],
  }



}  

