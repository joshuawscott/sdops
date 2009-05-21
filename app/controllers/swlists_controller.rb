class SwlistsController < ApplicationController
  before_filter :login_required
  before_filter :set_curr_tab
  def index
    @server_names = Server.by_name
  end
  
  def show
    @license_types = Swproduct.license_types
    swlist_file = params[:swlist_file]
    server_cores = params[:server_cores]
    if server_cores == nil || server_cores.to_i < 1
      flash[:notice] = "Invalid number of Active Cores"
      redirect_to :action => :index and return
    end
    @server = Server.find(params[:server_id])
    whitelist = SwlistWhitelist.find(:all)
    blacklist = SwlistBlacklist.find(:all)
    license_basis = params[:hpux_version].match(/10\.\d\d/) || params[:hpux_version].match(/11\.00/) ? 'per_tier' : 'per_core'
    @productslist_array = []
    @whitelist_array = []
    @unmatched_array = []
    @blacklist_array = []
    
    swlist_file.each_line do |line|
      wlmatch = false
      blmatch = false
      logger.debug "current line: " + line
      whitelist.each do |wpattern|
        m = line.match(/#{wpattern.pattern}/)
        if m
          logger.debug "whitelist pattern '" + wpattern.pattern + "' matches"
          #@whitelist_array << ['original line', line]
          x = Swproduct.find_quotable(wpattern.pattern, license_basis, server_cores, @server)
          if x
            @productslist_array << [x.product_number, 1]
            @productslist_array << [x.license_product, x.qty]
          else
            @whitelist_array << ['original line', line]
          end
          
          wlmatch = true
        end #if
        break if wlmatch
      end #whitelist.each
      blacklist.each do |bpattern|
        m = line.match(/#{bpattern.pattern}/)
        if m
          @blacklist_array << line
          logger.debug "blacklist pattern '" + bpattern.pattern + "' matches"
          blmatch = true
        end #if
        break if blmatch
      end #blacklist.each
      logger.debug "wlmatch: " + wlmatch.to_s + "; blmatch: " + blmatch.to_s
      @unmatched_array << line unless wlmatch || blmatch
      logger.debug "no pattern matched" unless wlmatch || blmatch
      
    end #swlist_file.each
    @productslist_array ||= ['no products found', '']
    @whitelist_array ||= ['no products found']
    @unmatched_array ||= ['no products found']
    @blacklist_array ||= ['no products found']
  end #show
  protected
  def set_curr_tab
    @current_tab = 'swlists'
  end
end #class
