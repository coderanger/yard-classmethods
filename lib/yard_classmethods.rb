#
# Copyright 2015, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'yard/code_objects/method_object'
require 'yard/handlers/ruby/module_handler'
require 'yard/tags/directives'
require 'yard/tags/library'
require 'yard/tags/tag'


module YardClassmethods
  class Directive < YARD::Tags::Directive
    def call
      # Mark the module as private so we don't see the methods twice.
      object.visibility = :private
      # Set this instance variable as a marker to be checked down below.
      handler.yard_classmethods_module = object if handler
    end
  end

  module Handler
    attr_accessor :yard_classmethods_module

    def process
      super
      # Are we looking at a ClassMethods-style module.
      if yard_classmethods_module
        # Start object tree surgery.
        yard_classmethods_module.meths.each do |meth|
          if meth.name != :included
          # Build a new method object under the parent namespace and copy all data over.
            new_meth = register meth.class.new(namespace, meth.name, :module)
            meth.copy_to(new_meth)
          end
          meth.visibility = :private
        end
      end
    end
  end

end

YARD::Tags::Library.define_directive(:classmethods, YardClassmethods::Directive)
# Module#prepend only became public in Ruby 2.1.
YARD::Handlers::Ruby::ModuleHandler.send(:prepend, YardClassmethods::Handler)
