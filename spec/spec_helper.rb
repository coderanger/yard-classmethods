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

require 'rspec'
require 'rspec/its'
require 'mixlib/shellout'

module YardClassmethodsHelper
  def command(cmd=nil, options={}, &block)
    subject do
      cmd = block.call if block
      Mixlib::ShellOut.new(
        "bundle exec #{cmd}",
        {
          cwd: File.expand_path('..', __FILE__),
          environment: {
            'BUNDLE_GEMFILE' => File.expand_path('../../Gemfile', __FILE__),
          },
        }.merge(options),
      ).tap do |cmd|
        cmd.run_command
        cmd.error!
      end
    end
  end

  def doc_file(path, *options, &block)
    describe(path) do
      let(:file_subject) do
        subject # Force it to run
        IO.read(File.join(File.expand_path('../doc', __FILE__), path))
      end

      def is_expected
        expect(file_subject)
      end

      example(nil, *options, &block)
    end
  end
end

RSpec.configure do |config|
  # Basic configuraiton
  config.run_all_when_everything_filtered = true
  config.filter_run(:focus)

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.extend YardClassmethodsHelper
end

RSpec::Matchers.define :match_html do |expected|
  diffable
  expected_regexp = Regexp.new(Regexp.escape(expected).gsub(/(\\[ nt])+/, '\s*'))
  match do |actual|
    expected_regexp.match(actual)
  end
end
