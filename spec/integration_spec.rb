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

require 'fileutils'

require 'spec_helper'

describe 'Integration' do
  command 'yard doc --plugin classmethods fixture.rb'
  after do
    FileUtils.rm_r(File.expand_path('../.yardoc', __FILE__), secure: true)
    FileUtils.rm_r(File.expand_path('../doc', __FILE__), secure: true)
  end

  its(:stdout) { is_expected.to_not include('[error]') }
  its(:stdout) { is_expected.to_not include('[warn]') }
  its(:stdout) { is_expected.to match(/^Files:\s+1$/) }
  doc_file('method_list.html') { is_expected.to match_html(<<-EOH) }
<ul id="full_list" class="method">
  <li class="r1 ">
    <span class='object_link'><a href="FixtureModule.html#my_class_method-class_method" title="FixtureModule.my_class_method (method)">my_class_method</a></span>
    <small>FixtureModule</small>
  </li>
  <li class="r2 ">
    <span class='object_link'><a href="FixtureModule.html#my_normal_method-instance_method" title="FixtureModule#my_normal_method (method)">#my_normal_method</a></span>
    <small>FixtureModule</small>
  </li>
</ul>
EOH

end
