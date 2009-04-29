# Schema:
#   id              integer
#   product_number  string
#   license_type    string
#   tier            integer
#   license_product       string
#   swlist_whitelist_id   integer
#   created_at      datetime
#   updated_at      datetime
#   explanation     text
#   server_line     string
class Swproduct < ActiveRecord::Base
  belongs_to :swlist_whitelists
  validates_uniqueness_of :tier, :scope => [:product_number, :server_line, :swlist_whitelist_id]
  
  def self.find_quotable(pattern, license_type, server_cores, server)
    socket_tier = ""
    socket_tier = server.integrity_socket_tier if server.server_line == 'Integrity'
    if license_type == 'per_core'
      x = self.find(:first,
        :select => ["product_number, license_product, #{server_cores} as qty"], 
        :joins => 'LEFT JOIN swlist_whitelists on swproducts.swlist_whitelist_id = swlist_whitelists.id',
        :conditions => ['swlist_whitelists.pattern = ? AND license_type = "per_core" AND (server_line IS NULL OR server_line IN ("", ?)) AND (tier IS NULL OR tier = ? )',pattern, server.server_line, socket_tier ],
        :order => 'field(license_type, "per_core", "per_tier", "exception")')
    end
    logger.debug "x = " + x.to_s
    if x.nil?
      logger.debug "resorting to per-tier products"
      x = self.find(:first,
        :select => "product_number, license_product, 1 as qty", 
        :joins => 'LEFT JOIN swlist_whitelists on swproducts.swlist_whitelist_id = swlist_whitelists.id',
        :conditions => ['swlist_whitelists.pattern = ? AND license_type = "per_tier" AND (tier IS NULL OR tier IN("", ?))',pattern, server.tier ],
        :order => 'field(license_type, "per_core", "per_tier", "exception")')
    end
    if x == []
      nil
    else
      x
    end
  end
  def self.license_types
    # db_name => "Human Readable Name"
    { 'per_core' => 'Per Core',
      'per_tier' => 'Server/Tier Based',
      'exception' => 'Other' }
  end
  def self.tier_choices
    [['N/A',nil],[0,0],[1,1],[2,2],[3,3],[4,4]]
  end
end
