#
# Cookbook Name:: mytomcat
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'my_java::default'

user node['tomcat']['user']

# put chefed in the group so we can make sure we don't remove it by managing cool_group
group node['tomcat']['group'] do
  members node['tomcat']['user']
  action :create
end

# Install Tomcat 8.0.36 to the default location
tomcat_install node['tomcat']['appName'] do
  version node['tomcat']['version']
  #install_path node['tomcat']['install_path']
  #tarball_uri 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz'
  tomcat_user node['tomcat']['user']
  tomcat_group node['tomcat']['group']
end

# Drop off our own server.xml that uses a non-default port setup
cookbook_file "/opt/tomcat_#{node['tomcat']['appName']}/conf/server.xml" do
  source 'mytomcat_server.xml'
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode '0644'
  notifies :restart, "tomcat_service[#{node['tomcat']['appName']}]"
end

remote_file "/opt/tomcat_#{node['tomcat']['appName']}/webapps/sample.war" do
  owner node['tomcat']['user']
  mode '0644'
  source 'https://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war'
  checksum '89b33caa5bf4cfd235f060c396cb1a5acb2734a1366db325676f48c5f5ed92e5'
end

# start the helloworld tomcat service using a non-standard pic location
tomcat_service node['tomcat']['appName'] do
  action [:start, :enable]
  env_vars [{ 'CATALINA_PID' => "/opt/tomcat_#{node['tomcat']['appName']}/bin/#{node['tomcat']['appName']}.pid" }]
  sensitive true
  tomcat_user node['tomcat']['user']
  tomcat_group node['tomcat']['group']
end
