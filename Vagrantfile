# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'fileutils'

MYSQL_ROOT_PASSWORD="healthit"
MYSQL_DATABASE="hitd8"

unless File.exists?("keys")
  Dir.mkdir("keys")
  ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
  File.open("keys/id_rsa.pub", 'w') { |file| file.write(ssh_pub_key) }
end

Vagrant.configure(2) do |config|
	config.vm.define "hitdb" do |sql|
		sql.vm.provider "docker" do |d|
			d.vagrant_machine = "healthithost"
			d.vagrant_vagrantfile = "host/Vagrantfile"
			d.image = "mysql:5.7.16"
			d.env = { :MYSQL_ROOT_PASSWORD => MYSQL_ROOT_PASSWORD, :MYSQL_DATABASE => MYSQL_DATABASE }
			d.name = "hitdb"
			d.remains_running = true
			d.ports = ["3306:3306"]
		end
	end
	config.vm.define "hitd8" do |hit|
		hit.vm.synced_folder ".", "/srv/app", type: "rsync",
			rsync__exclude: get_ignored_files(),
			rsync__args: ["--verbose", "--archive", "--delete", "--copy-links"],
			rsync__chown: false

		hit.vm.provider "docker" do |d|
			d.vagrant_machine = "healthithost"
			d.vagrant_vagrantfile = "host/Vagrantfile"
			#d.image = "hit:latest"
			#d.name = "drupal-container"
			d.build_dir = "."
			d.name = "hitd8"
			d.remains_running = true
			#d.volumes = ["/home/rancher/.composer:/root/.composer","/home/ashishpagar/.drush:/root/.drush"]
			d.ports = ["80:80","2222:2222"]
			d.link("hitdb:hitdb")
		end
	end
end
def get_ignored_files()
	ignore_file = ".rsyncignore"
	ignore_array = []

	if File.exists? ignore_file and File.readable? ignore_file
		File.read(ignore_file).each_line do |line|
			ignore_array << line.chomp
		end
	end

	ignore_array
end