# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'fileutils'

MYSQL_ROOT_PASSWORD="healthit"

Vagrant.configure(2) do |config|
	config.vm.define "mysql" do |sql|
		sql.vm.provider "docker" do |d|
			d.vagrant_machine = "healthithost"
			d.vagrant_vagrantfile = "./host/Vagrantfile"
			d.image = "mysql:5.7.16"
			d.env = { :MYSQL_ROOT_PASSWORD => MYSQL_ROOT_PASSWORD }
			d.name = "mysql-container"
			d.remains_running = true
			d.ports = ["3306:3306"]
		end
	end
	config.vm.define "healthit" do |hit|
		hit.vm.provider "docker" do |d|
			d.vagrant_machine = "healthithost"
			d.vagrant_vagrantfile = "./host/Vagrantfile"
			d.image = "drupal"
			d.name = "drupal-container"
			d.remains_running = true
			d.ports = ["80:80","2222:22"]
			# d.link("mysql-container:mysql")
		end
	end
end