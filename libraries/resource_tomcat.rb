#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Cookbook Name:: tomcat
# Resource:: default
#
# Copyright 2012, Bryan w. Berry
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

require File.expand_path('mixin.rb', File.dirname(__FILE__))
require 'chef/resource'
require 'set'

class Chef
  class Resource
    class Tomcat < Chef::Resource

      include Chef::Resource::Tomcat::Utils
      
      attribute :path, :required => true
      attribute :unpack_wars, :equal_to => [true, false], :default => true
      attribute :auto_deploy, :equal_to => [true, false], :default => true
      attribute :environment, :kind_of => Hash, :default => {}
      attribute :user, :kind_of => String, :required => true
      
      def initialize(name, run_context=nil)
        super
        @resource_name = :tomcat
        @user = 'tomcat'
        @path = nil
        @version = "6"
        @environment = {}
        @allowed_actions.push(:install, :restart, :start)
        @action = :install
        @unpack_wars = true
        @auto_deploy = true
        @provider = Chef::Provider::Tomcat
      end

      def jvm(*args, &block)
        @jvm ||= Mash.new
        @jvm.update(jvm_options_block(*args, &block)) if @jvm.empty?
        @jvm
      end

      def ports(*args, &block)
        @ports ||= Mash.new
        @ports.http = '8080'
        @ports.https = '8443'
        @ports.ajp = '8009'
        @ports.shutdown = '8005'
        @ports.update(ports_options_block(*args, &block))
      end

      def datasource(*args, &block)
        @datasource ||= Mash.new
        @datasource.update(options_block(*args, &block))
      end
      
    end
  end
end

