class IoscansController < ApplicationController
  # GET /ioscans
  def index
    @server_names = Server.by_name
  end

  def new_index
    @server_names = Server.by_name
  end

  # POST /ioscans/show
  #
  # This is where the ioscan is processed into an Array of Hashes
  # for the view.
  # --
  # TODO: move work to an Ioscan model
  def show
    unless request.post?
      redirect_to :action => :index and return
    end
    ioscan_file = params[:ioscan_file]
    @server = Server.find(params[:server_id])

    io_slots_by_path = IoSlot.find(:all, :conditions => ["server_id = ?", @server.id], :order => 'path ASC')
    @io_slots_in_server = IoSlot.find(:all, :conditions => ["server_id = ?", @server.id], :order => 'chassis_number ASC, slot_number ASC')
    # Store the lines in the uploaded file into an array of hashes "@ioscan_array"
    @ioscan_array = Array.new
    x = io_slots_by_path.each do |io_slot|
      #logger.debug "Trying I/O Slot " + io_slot.path
      line_num = 0
      # \n argument is needed to handle dos and unix files
      ioscan_file.each_line("\n") do |line|
        if line.match(/Class\s*I\s*H\/W Path\s*Driver/)
          #short-circuit processing of ioscan -f output
          flash[:notice] = 'You attempted to upload an ioscan -f, rather than an ioscan -F'
          redirect_to :action => :index and return
        end
        next unless line.match(/(:.*?){17}/) # Filter out any invalid rows
        fields = line.split(':')
        hwpath = fields[10].strip
        if hwpath.slice(0, io_slot.path.length) == io_slot.path
          @ioscan_array[line_num] = {
              :classname => fields[8],
              :drivername => fields[9],
              :description => fields[17].strip,
              :slot_id => io_slot.id,
              :path => hwpath,
              :hw_type => fields[16]
          }
        end #if
        line_num = line_num.succ
      end #ioscan_file.each_line
      ioscan_file.pos = 0 #reset to the beginning of the file.
    end #@io_slots_in_server.each
  end

  #def show

  def new_show #:nodoc:
    # OPTIMIZE: Re-write ioscan/show.
    ioscan_file = params[:ioscan_file]
    @server = Server.find(params[:server_id])

    io_slots_by_path = IoSlot.find(:all, :conditions => ["server_id = ?", @server.id], :order => 'path ASC')
    @io_slots_in_server = IoSlot.find(:all, :conditions => ["server_id = ?", @server.id], :order => 'slot_number ASC')

    # Store the lines in the uploaded file into an array of hashes "@ioscan_array"
    @ioscan_array = Array.new

  end
end
