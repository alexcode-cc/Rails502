require 'json'
require 'socket'
class PagesController < ApplicationController
  def about
    @app = Rails.application.class.name.split(/::/)[0]
    @version = JSON.parse(File.read(Rails.root.join('package.json')))['version']
    @rails = Rails.version
    @ruby = RUBY_VERSION
    @env = Rails.env
    @adapter = ActiveRecord::Base.connection.adapter_name
    @host = Socket.gethostname
    @ip = Socket.ip_address_list.find { |ip| ip.ipv4? && !ip.ipv4_loopback? }.ip_address
    @remote_ip = request.remote_ip
    @time = Time.current.to_s(:long)
  end
end
