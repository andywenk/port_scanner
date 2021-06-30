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

TIMEOUT = 2
PORT_LIST = [21,22,23,25,53,80,443,3306,5601,5984,8080,27017,27018,27019]

class Scanner
  attr_reader :timeout, :port_list, :domain_name

  def initialize(params)
    @timeout = get_timeout(params)
    @port_list = get_port_list(params)
    @domain_name =  get_domain_name(params)
  end

  def execute
    port_list.each do |port|
      scan_port(port)
    end
  end

  private def scan_port(port)
    begin
      socket = Socket.new(:AF_INET, :SOCK_STREAM, 0)
      remote_addr = Socket.sockaddr_in(port, domain_name)    
      socket.connect_nonblock(remote_addr)
    rescue Errno::EINPROGRESS
    rescue Errno::EAFNOSUPPORT => e
      puts 'not supported'
      puts e.message
    rescue SocketError => e
      puts "SOCKET ERROR:\n"
      puts e.message
      exit(0)
    end

    _, sockets, _ = IO.select(nil, [socket], nil, timeout)

    if sockets 
      p "Port #{port} is open."
    else
      p "Port #{port} is closed."
    end
  end

  private def get_timeout(params)
    params.json_from_file.nil? ? TIMEOUT : params.json_from_file["timeout"]
  end

  private def get_domain_name(params)
    params.json_from_file.nil? ? params.domain_name : params.json_from_file["domain_name"]
  end

  private def get_port_list(params)
    params.json_from_file.nil? ? PORT_LIST : params.json_from_file["ports"]
  end
end