# Copyright [2021] [sum.cumo Sapiens GmbH]

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# frozen_string_literal: true

require 'optparse'
require 'ostruct'
require 'pp'

Params = Struct.new(:domain_name, :configuration_file)

class Parser
  def self.execute    
    begin
      params = Params.new

      OptionParser.new do |opts|
        opts.on('-d STRING', String, 'Define the domain URI and run with default values') do |d|
          params.domain_name = d
        end
        opts.on('-c STRING', String, "Path to JSON configuration file: \n#{@config}") do |c|
          params.configuration_file = c
        end
        opts.on('-h', '--help', 'Print this help') do |h|
          puts opts
          exit(0)
        end
      end.parse!
    rescue OptionParser::MissingArgument
      puts 'There is a missing argument for this option'
      exit(0)
    end
    params
  end

  def self.config 
<<-CONF
                                     {
                                        "domain_name": "www.example.com",
                                        "ports": [21,22,23,25,53,80,443,3306,5601,8080]
                                        "timeout": 2
                                     }
CONF
  end
end