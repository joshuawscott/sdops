class FishbowlInventoryItemsController < ApplicationController
  def index
    begin
      Rails.cache.clear
      flash[:notice] = ''
      @line_items_limit ||= 1000
      # avoid returning everything on a blank search
      if !params[:search].blank? && !(params[:search][:serialnum].blank? && params[:search][:part_num].blank? && params[:search][:locationgroupid].blank? && params[:search][:partdescription].blank?)
        params[:search][:line_items_limit].to_i < 1 ? @line_items_limit = 1000 : @line_items_limit = params[:search][:line_items_limit].to_i
        search_hash = params[:search]
        search_hash.delete_if { |k, v| v.blank? }
        @part_num = search_hash[:part_num] if !search_hash[:part_num].blank?
        @partdescription = search_hash[:partdescription] if !search_hash[:partdescription].blank?
        @serialnum = search_hash[:serialnum] if !search_hash[:serialnum].blank?
        @locationgroup = search_hash[:locationgroup] if !search_hash[:locationgroup].blank?
        @locationgroupid = search_hash[:locationgroupid].to_i if !search_hash[:locationgroupid].blank?
        params_hash = {}
        params_hash[:use_like] = 1
        params_hash[:partnum] = @part_num unless @part_num.blank?
        params_hash[:partdescription] = @partdescription unless @partdescription.blank?
        params_hash[:serialnum] = @serialnum unless @serialnum.blank?
        params_hash[:locationgroup] = @locationgroup unless @locationgroup.blank?
        params_hash[:locationgroupid] = @locationgroupid unless @locationgroupid.blank?
        params_hash[:qty] = 1.0
        params_hash[:use_limit] = @line_items_limit

        @inventory_items = FishbowlQoh.find(:all, :params => params_hash)
        flash[:notice] = "Search limited to #{@line_items_limit} items" if @inventory_items.size == @line_items_limit
      else
        @inventory_items = []
        @locations = []
      end
      #Takes too long
      #@locations = Fishbowl.find(:all, :from => :location)
      @locationgroups = Fishbowl.find(:all, :from => :locationgroup).map { |lg| [lg.name, lg.id] }
    rescue ActiveResource::ResourceNotFound => err
      @inventory_items = []
      @locationgroups = []
      flash[:notice] = "No items found - " + err.to_s
    rescue ActiveResource::ServerError => err
      @inventory_items = []
      @locationgroups = []
      flash[:notice] = "Fishbowl Server Error - Click 'Clear Search' to start over. - " + err.to_s
    end
  end
end