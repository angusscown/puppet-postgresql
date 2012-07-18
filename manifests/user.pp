# This can only create a user on the PostgreSLQ server, and can not create users remotely
#
# Using checks from https://github.com/uggedal/puppet-module-postgresql/blob/master/manifests/user.pp
#
# DOES NOT MAKE SUPERUSERS. This is intentional.

define postgresql::user(
	$ensure 				= present,
	$password,
	$logoutput			= false
){
	if $ensure == 'present' {		
	  postgresql::psql{"createuser-${name}":
	    database 	=> "postgres",
	    sql      	=> "CREATE ROLE ${name} WITH LOGIN PASSWORD '${password}';",
	    sqlcheck 	=> "\"SELECT usename FROM pg_user WHERE usename = '${name}'\" | grep ${name}",
	    logoutput	=> $logoutput,
	    require  	=>  [Package['postgresql_client'],Service['postgresql']],
	  }
	} elsif $ensure == 'absent' {
		postgresql::psql{"destroyuser-${name}":
	    database 	=> "postgres",
	    sql      	=> "DROP ROLE ${name};",
	    sqlcheck 	=> "'SELECT rolname FROM pg_catalog.pg_roles;' | grep '^ ${name}$'",
	    logoutput	=> $logoutput,
	    require  	=>  [Package['postgresql_client'],Service['postgresql']],
	  }
	}
}