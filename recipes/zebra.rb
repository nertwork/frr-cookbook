#
# Cookbook Name:: frr
# Recipe:: zebra
#

include_recipe 'frr'

frr_zebra 'zebra' do
  not_if { node['quagga']['prefix_lists'].empty? &&
         node['quagga']['interfaces'].empty? &&
         node['quagga']['static_routes'].empty? }
end
