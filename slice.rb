# -*- coding: utf-8 -*-
require 'rubygems'

#
# information of vertual slice
#
class SliceInfo
  attr_reader :vn
  def initialize
    @vn = Hash.new { [].freeze }
    @input_file = "slice.conf"
    create_vn_from_file
  end

  def create_vn_from_file
    f = File::open(@input_file)
    while line = f.gets
      # line = slice*{*,*,...,*}
      line[0..4] = ""
      # line = *{*,...,*}
      dev = line.split("{") 
      slice_num = dev[0]
      # print "slice_num: " + slice_num + "\n"
      line2 = dev[1].split("}")[0] 
      # line2 = *,...,*
      host = line2.split(",") 
      for var in host do
        @vn[var] = slice_num
      end 
    end
    f.close
    @vn.each{|key, value|
      print "(" + key + ", " + value + ")\n"
    }
  end

end

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
