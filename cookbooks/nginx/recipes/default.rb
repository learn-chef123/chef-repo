#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'yum'

package 'nss' do
  action :upgrade
end

include_recipe 'yum-epel'

package 'nginx' do
  version "#{node[:nginx][:version]}"
  not_if "rpm -qa | grep -i nginx-#{node[:nginx][:version]}"
end


template "/etc/nginx/conf.d/default.conf" do
  source "nginx_default.conf.erb"
  mode 00644
  variables(
      :listen_port => node[:nginx][:port],
      :server_name => node[:nginx][:name],
      :basic_auth_enabled => node[:nginx][:basic_auth],
      )
  notifies :restart, "service[nginx]", :delayed
end

service "nginx" do
  action [:enable, :start]
end
