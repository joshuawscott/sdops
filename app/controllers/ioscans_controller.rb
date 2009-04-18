class IoscansController < ApplicationController
  def index
    @server_names = Server.by_name
  end

  def show
    ioscan_file = params[:ioscan_file]
    @server = Server.find(params[:server_id])
    
    io_slots_by_path = IoSlot.find(:all, :conditions => ["server_id = ?", @server.id], :order => 'path ASC')
    @io_slots_in_server = IoSlot.find(:all, :conditions => ["server_id = ?", @server.id], :order => 'slot_number ASC')

    # Store the lines in the uploaded file into an array of hashes "@ioscan_array"
    @ioscan_array = Array.new
    x = io_slots_by_path.each do |io_slot|
      #logger.debug "Trying I/O Slot " + io_slot.path
      line_num = 0
      ioscan_file.each_line do |line|
        fields = line.split(':')
        hwpath = fields[10].strip
        if hwpath.slice(0, io_slot.path.length) == io_slot.path
          @ioscan_array[line_num] = {
            :classname => fields[8],
            :drivername => fields[9],
            :description => fields[17],
            :slot_id => io_slot.id,
            :path => hwpath,
            :hw_type => fields[16]
          }
          #logger.debug @ioscan_array[line_num]
          #classname = fields[8]
          #drivername = fields[9]
          #description = fields[17]
          #io_slot_number = io_slot.id
        end #if
        line_num = line_num.succ
      end #@ioscan_file.each_line
      ioscan_file.pos = 0
    end #@io_slots_in_server.each
  
  end #def show

  def new_show
    ioscan_file = params[:ioscan_file]
    @server = Server.find(params[:server_id])
    
    io_slots_by_path = IoSlot.find(:all, :conditions => ["server_id = ?", @server.id], :order => 'path ASC')
    @io_slots_in_server = IoSlot.find(:all, :conditions => ["server_id = ?", @server.id], :order => 'slot_number ASC')

    # Store the lines in the uploaded file into an array of hashes "@ioscan_array"
    @ioscan_array = Array.new
    
  end
end
