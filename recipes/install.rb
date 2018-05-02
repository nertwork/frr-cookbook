#
# Author:: James Gomez <james@nertwork.com>
# Cookbook Name:: frr
# Recipe:: install
#
# Copyright 2018, James Gomez
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package 'frr' do
  action :install
end

directory node['frr']['dir'] do
  owner node['frr']['user']
  group node['frr']['group']
  mode '0755'
  action :create
end

service 'frr' do
  action :enable
end

if %w( debian ubuntu cumulus ).include? node['platform']
  template "#{node['frr']['dir']}/daemons" do
    source 'daemons.erb'
    owner node['frr']['user']
    group node['frr']['group']
    mode '0644'
    notifies :restart, 'service[frr]', :delayed
  end

  template "#{node['frr']['dir']}/debian.conf" do
    source 'debian.conf.erb'
    owner node['frr']['user']
    group node['frr']['group']
    mode '0644'
  end

  %w( zebra.conf ospfd.conf ospf6d.conf bgpd.conf ).each do |file|
    file "#{node['frr']['dir']}/#{file}" do
      owner node['frr']['user']
      group node['frr']['group']
      mode '0644'
      action :touch
    end
  end

  template '/etc/default/frr' do
    source 'frr.erb'
    owner 'root'
    group 'root'
    mode '0644'
  end
end

integrated_config = node['quagga']['integrated_vtysh_config']

# Combine the templates into a master file to be reloaded
template 'integrated_config' do
  path "#{node['frr']['dir']}/frr.conf"
  source 'frr.conf.erb'
  owner node['frr']['user']
  group node['frr']['group']
  mode '0644'
  if node['quagga']['enable_reload']
    notifies :reload, 'service[frr]', :delayed
  else
    notifies :restart, 'service[frr]', :delayed
  end
  action :nothing
end

# vtysh configuration
template "#{node['frr']['dir']}/vtysh.conf" do
  source 'vtysh.conf.erb'
  owner node['frr']['user']
  group node['frr']['group']
  mode '0644'
  if integrated_config
    notifies :create, 'template[integrated_config]', :delayed
  else
    notifies :restart, 'service[frr]', :delayed
  end
end
