# Connects to the Fishbowl "QOHVIEW" view
# ===Schema (read-only)
#   locationgroupid integer
#   locationid      integer
#   partid          integer
#   tagnum          string
#   serialnum       string
#   qty             integer
class FishbowlQoh < Fishbowl
  self.element_name = 'custom_inventory'
  self.collection_name = 'custom_inventory'
  # Caches locationgroupid to avoid repeated XML requests.
  def fb_locationgroup
    @fb_locationgroup ||= Rails.cache.fetch("fishbowl_locationgroup_#{locationgroupid}") { Fishbowl.find(:first, :from => :locationgroup, :params => {:id => locationgroupid}) }
  end
  #def location
  #  @location ||= Rails.cache.fetch("fishbowl_location_#{locationid}") { Fishbowl.find(:first, :from => :location, :params => {:id => locationid} ) }
  #end
  #def part
  #  @part ||= Rails.cache.fetch("fishbowl_location_#{partid}") { Fishbowl.find(:first, :from => :part, :params => {:id => partid} ) }
  #end
  #def tag
  #  @tag ||= Tag.find(:first, :from => :tag, :params => {:num => tagnum} )
  #end
end