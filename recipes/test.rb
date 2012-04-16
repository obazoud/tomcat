user 'foobarbaz'


tomcat 'geo1' do
  path '/opt/geo1'
  user 'foobarbaz'
end

tomcat 'geo' do
  path '/opt/geo'
  user 'foobarbaz'
  jvm do
    xms '277m'
    xmx '1111m'
    max_perm_size '159m'
  end
end



# # most basic example
# tomcat "geo" do
#   path     "/opt/geo"
#   version         "7"
#   user            "geo"
#   unpack_wars     true
#   auto_deploy     true
#   environment     'GEO_HOME' => '/home/geo' 
# end


# # the works!
# tomcat "pentaho" do
#   path     "/opt/pentaho"
#   version         "7"
#   user            "pentaho"
#   unpack_wars     true
#   auto_deploy     true
#   environment     'PENTAHO_HOME' => '/home/pentaho' 
#   jvm do
#     xms           "256m"    
#     xmx           "512m"
#     max_perm_size "256m"  
#     xx_opts       'CompileThreshold' => '10000', 'ParallelGCThreads' => '',
#     '+UseConcMarkSweepGC' => '',      # -XX:  options
#     d_opts             # -D options
#     additional_opts [    ] # anything that doesn't fit in previous _opts
#   end
#   datasource do
#     driver 'org.gjt.mm.mysql.Driver'
#     database 'name'
#     port 5678
#     username 'user'
#     password 'password'
#     max_active 1
#     max_idle 2
#     max_wait 3  
#   end      
#   ports do
#     http      8080
#     https     8443  # defaults to nil and not used
#     ajp       8009
#     shutdown  8005
#   end
# end

# # Example using custom templates for server.xml and context.xml
# # and non-default ports
# tomcat "pentaho" do
#   version "6"
#   user "pentaho"
#   context_template "pentaho_context.xml.erb"
#   server_template  "server.xml.erb"
#   logging_template "logging.properties.erb"
#   ports do
#     http      8081
#     https     8444  # defaults to nil and not used
#     ajp       8010
#     shutdown  8006
#   end
# end
