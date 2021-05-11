# Yard-classmethods

[![Build Status](https://img.shields.io/travis/coderanger/yard-classmethods.svg)](https://travis-ci.org/coderanger/yard-classmethods)
[![Gem Version](https://img.shields.io/gem/v/yard-classmethods.svg)](https://rubygems.org/gems/yard-classmethods)
[![Code Climate](https://img.shields.io/codeclimate/github/coderanger/yard-classmethods.svg)](https://codeclimate.com/github/coderanger/yard-classmethods)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

Yard-classmethods is a [YARD](http://yardoc.org/) plugin to help with embedding
class methods defined in a `module ClassMethods` style.

## Installation

Install the gem:

```bash
$ gem install yard-classmethods
```

You can either enable the plugin on the command line:

```bash
$ yard doc --plugin classmethods
```

or add it your `.yardopts` file to enable it permanently:

```bash
$ echo '--plugin classmethods' >> .yardopts
```

## Usage

The plugin exposes a `@!classmethods` directive:

```ruby
module FixtureModule
  # A normal method
  def my_normal_method
  end

  # @!classmethods
  module ClassMethods
    # A class method via a shim module
    def my_class_method
    end

    def included(klass)
      super
      klass.extend ClassMethods
    end
  end

  extend ClassMethods
end
```

## License

Copyright 2015, Noah Kantrowitz

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
