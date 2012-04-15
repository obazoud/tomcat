Description
===========

Installs and configures the Tomcat, Java servlet engine and webserver.



Requirements
============

Platform: 

* CentOS, Red Hat, Fedora, Debian, Ubuntu

The following Opscode cookbooks are dependencies:

* java
* ark


Attributes
==========

* prefix_root - /usr/local/, /var/lib/, etc.

Recipes
=======

* default.rb -- installs a vanilla tomcat from binary package provided
  by tomcat.apache.org and creates a service
* base.rb  installs the tomcat from the binary provided by
tomcat.apache.org, will use version 7 unless node['tomcat']['version'] set
to 6. No tomcat service is installed.

All of the default webapps such as "ROOT" and "manager" are removed

default
-------

This recipe creates a vanilla tomcat installation based on the tarball
of bytecode available from http://tomcat.apache.org and places it in 
${prefix_root}. Additionally, it configures a system v
init script and creates the symlink

    ${prefix_root}/tomcat/default -> ${prefix_root}/tomcat/tomcat{6,7}


base
----

It creates an installation of tomcat to prefix_root. It does very
little besides that.

By default it uses the tomcat 7 by including tomcat7 recipe

This recipe is intended to be used together with the CATALINA_BASE method to install
multiple tomcat instances that use the same set of tomcat installation
files. This recipe does not add any services. It is intended to be used together with the tomcat lwrp.

    ${prefix_root}/tomcat/tomcat{6,7}  # CATALINA_HOME

and creates a symlink to that directory

    ${prefix_root}/tomcat/default -> ${prefix_root}/tomcat/tomcat{6,7}



Resources/Providers
===================

tomcat

# Actions

- :install: install
- :remove: remove the instance

# Attribute Parameters


# Example using ports, jvm, jmx database helpers

    tomcat "pentaho" do
      prefix_root     "/opt/pentaho"
      version         "7"
      user            "pentaho"
      unpack_wars     true
      auto_deploy     true
      environment     { }
      jvm do
        xms           "256m"
        xmx           "512m"
        max_perm_size "256m"
        x_opts        { }
        xx_opts       { }
        d_opts        { }
        additional_opts [    ]
      end
      datasource do
        driver 'org.gjt.mm.mysql.Driver'
        database 'name'
        port 5678
        username 'user'
        password 'password'
        max_active 1
        max_idle 2
        max_wait 3  
      end      
      ports do
        http      8080
        https     8443  # defaults to nil and not used
        ajp       8009
        shutdown  8005
      end
    end

# Example using custom templates for server.xml and context.xml

    tomcat "pentaho" do
      version "6"
      user "pentaho"
      context_template "pentaho_context.xml.erb"
      server_template  "server.xml.erb"
      logging_template "logging.properties.erb"
    end



# An exception will be thrown if one of the values specified by *_port
# is already in use by another tomcat lwrp

# All *_OPTS attributes are combined into the environment variable JAVA_OPTS.
# Duplicate options are removed.

# # Example

#     tomcat "pentaho" do
#       http_port  false
#       https_port "8443"
#       version    "7"
#     end

# To deploy a webapp to the new tomcat, you use a deploy resource or a
# maven resource (coming soon).

# # Example

#    deploy "pentaho" do  
#      deploy_root tomcat['pentaho']['webapps']
#      repository "github.com/bryanwb/pentaho.git"
#      revision   "1.0.2"
#      restart_command tomcat['pentaho'] :restart
#    end


TODO
====


License and Author
==================

Author:: Bryan W. Berry (<bryan.berry@gmail.com>)

Copyright:: 2012, Bryan W. Berry

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
