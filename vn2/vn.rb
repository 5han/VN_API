# -*- coding: utf-8 -*-

#
# information of vn
#
class VN
  def_delegator :@vn, :each, :each_vn

  def initialize()
    @vn = Hash.new { [].freeze }
    create_vn
  end

  private

  def create_vn
  
  end

  def delete_switch(dpid)
    @ports[dpid].each do | each |
      delete_port dpid, each
    end
    @ports.delete dpid
  end

  def update_port(dpid, port)
    if port.down?
      delete_port dpid, port
    elsif port.up?
      add_port dpid, port
    end
  end

  def add_port(dpid, port)
    @ports[dpid] += [port]
  end

  def delete_port(dpid, port)
    @ports[dpid] -= [port]
    delete_link_by dpid, port
  end

  def add_link_by(dpid, packet_in)
    fail 'Not an LLDP packet!' unless packet_in.lldp?

    link = Link.new(dpid, packet_in)
    unless @links.include?(link)
      @links << link
      @links.sort!
      changed
      notify_observers self
    end
  end

  def add_host_by(dpid, packet_in)
    host = Host.new(dpid, packet_in)
    unless @hosts.include?(host)
      @hosts << host
      @hosts.sort!
      changed
      notify_observers self
    end
  end

  private

  def delete_link_by(dpid, port)
    @links.each do | each |
      if each.has?(dpid, port.number)
        changed
        @links -= [each]
      end
    end
    notify_observers self
  end
end

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
