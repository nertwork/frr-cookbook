default['quagga']['dir'] = '/etc/quagga'

default['quagga']['user'] = 'quagga'
default['quagga']['group'] = 'quagga'

default['quagga']['daemons']['zebra'] = true
default['quagga']['daemons']['ospfd'] = false
default['quagga']['daemons']['bgpd'] = false
default['quagga']['daemons']['ospf6d'] = false
default['quagga']['daemons']['ripd'] = false
default['quagga']['daemons']['ripngd'] = false
default['quagga']['daemons']['isisd'] = false
default['quagga']['daemons']['babeld'] = false

# insecured default username and password. overwrite when deploy
default['quagga']['password'] = 'quagga'
default['quagga']['enabled_password'] = 'quagga'

default['quagga']['integrated_vtysh_config'] = false
default['quagga']['enable_reload'] = true
default['quagga']['max_instances'] = 5
