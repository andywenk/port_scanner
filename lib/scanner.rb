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

require 'socket'
require_relative 'exceptions'

class Scanner
  attr_reader :timeout, :port_list, :domain

  def initialize(params)
    raise InvalidConfigurationFileSyntax unless params.is_a?(Object)
    @timeout = 2
    @port_list = [21,22,23,25,53,80,443,3306,5601,8080]
    @domain = params.domain_name
  end

  def execute
    port_list.each do |port|
      scan_port(port)
    end
  end

  private def scan_port(port)

    socket = Socket.new(:AF_INET, :SOCK_STREAM, 0)
    remote_addr = Socket.sockaddr_in(port, domain)

    begin
      socket.connect_nonblock(remote_addr)
    rescue Errno::EINPROGRESS
    rescue Errno::EAFNOSUPPORT
      puts 'not supported'
    end

    _, sockets, _ = IO.select(nil, [socket], nil, timeout)

    if sockets 
      p "Port #{port} is open."
    else
      p "Port #{port} is closed."
    end
  end
end