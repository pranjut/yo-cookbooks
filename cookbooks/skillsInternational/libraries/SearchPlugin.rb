module MyKnifePlugins

  require 'chef/search/query'
  require 'chef/knife'


   def self.discoverIp(role)
      members=search(:node, role)
      node = members.first
      return node.has_key?("ec2") ? node["ec2"]["hostname"] : node["ipaddress"]

    end
end