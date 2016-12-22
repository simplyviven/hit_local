Instructions
=============

0. Run 'git clone https://ashish_pagar@bitbucket.org/ahrq/hitgov_drupal8.git'
0. Download database, unzip it, and rename it to hitd8.sql
0. Make sure public key is generated and available at ~/.ssh/id_rsa.pub, if not follow ssh instructions at the end
0. Run 'vagrant up --no-parallel' (run again if it fails)
0. ssh -p 2222 root@192.168.1.70 "mysql -h 192.168.1.70 -u root -phealthit hitd8 < /srv/app/hitd8.sql"
