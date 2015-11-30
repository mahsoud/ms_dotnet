#
# Cookbook Name:: ms_dotnet
# Library:: windows_version_helper
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
#
# Copyright (C) 2015 Criteo
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
# This module should be part of the windows cookbook.
# see: https://github.com/chef-cookbooks/windows/pull/312
module Windows
  # Module based on windows ohai kernel.cs_info providing version helpers
  module VersionHelper
    # Module referencing CORE SKU contants from product type
    # see. https://msdn.microsoft.com/windows/desktop/ms724358#PRODUCT_DATACENTER_SERVER_CORE
    # n.b. Prefix - PRODUCT_ - and suffix - _CORE- have been removed
    module CoreSKU
      # Server Datacenter Core
      DATACENTER_SERVER   = 0x0C unless defined?(DATACENTER_SERVER)
      # Server Datacenter without Hyper-V Core
      DATACENTER_SERVER_V = 0x27 unless defined?(DATACENTER_SERVER_V)
      # Server Enterprise Core
      ENTERPRISE_SERVER   = 0x0E unless defined?(ENTERPRISE_SERVER)
      # Server Enterprise without Hyper-V Core
      ENTERPRISE_SERVER_V = 0x29 unless defined?(ENTERPRISE_SERVER_V)
      # Server Standard Core
      STANDARD_SERVER     = 0x0D unless defined?(STANDARD_SERVER)
      # Server Standard without Hyper-V Core
      STANDARD_SERVER_V   = 0x28 unless defined?(STANDARD_SERVER_V)
    end

    # Determines whether current node is running a windows Core version
    def self.core_version?(node)
      validate_platform node

      CoreSKU.constants.any? { |c| CoreSKU.const_get(c) == node['kernel']['os_info']['operating_system_sku'] }
    end

    # Determine whether current node is a workstation version
    def self.workstation_version?(node)
      validate_platform node
      # see https://msdn.microsoft.com/library/windows/desktop/ms724833#VER_NT_SERVER for product types
      node['kernel']['os_info']['product_type'] == 0x1
    end

    # Determine whether current node is a server version
    def self.server_version?(node)
      !workstation_version?(node)
    end

    # Determine NT version of the current node
    def self.nt_version(node)
      validate_platform node

      node['platform_version'].to_f
    end

    private

    def self.validate_platform(node)
      fail 'Windows helper are only supported on windows platform!' if node['platform'] != 'windows'
    end
  end
end
