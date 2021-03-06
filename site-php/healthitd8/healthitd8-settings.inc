<?php

/* Boost memory limit */

ini_set('memory_limit', '128M');

/* Trusted host pattern */

$settings['trusted_host_patterns'] = array(
  '^hitd8\.local',
  '^healthithost',
  '^192\.168\.1\.70' // your local domain name goes here
);

/* Set database configuration */

$databases['default']['default'] = array (
  'database' => 'hitd8',  // database name
  'username' => 'root',  // database username
  'password' => 'healthit',  // database password
  'prefix' => '',
  'host' => '192.168.1.70',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);

$config['system.performance']['css']['preprocess'] = FALSE;
$config['system.performance']['js']['preprocess'] = FALSE;
