
## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Make filebucket 'main' the default backup location for all File resources:
File { backup => 'main' }

# Kill deprecation warnings in PE 3.3:
#Package { allow_virtual => false }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
  #include profiles::jenkins
  #include profiles::puppet_four_changes
}

node oron-puppet-client-1 {
  class { 'ansible':
  ensure => node,
  master => 'oron-puppet-master'
  }
}

node oron-puppet-master {
  class { 'ansible':
  ensure => master
  }
}
node oron-puppet-client-2 {
  artifactory::artifact {'download-artifact':
      user          => 'admin',
      password      => 'password',
      url           => 'http://oron-puppet-client-1:8081/artifactory',
      jenkins_build => 'oron',
      repository    => 'ext-release-local', 
      output        => "/tmp",  
      path          => '/var/www/html',  
      type          => 'zip',
       }
}

