# A Server is a definition of a server that contains information on I/O slots,
# number of CPU sockets, model name, etc. for the ioscan and swlist tools.
# Schema
#   id            integer
#   model_name    string
#   server_line   string
#   tier          integer
#   sockets       integer
#   created_at    datetime
#   updated_at    datetime
#--
# TODO: override tier setter and getter methods to provide automatic translation between integrity and pa_risc tiers.
class Server < ActiveRecord::Base
  has_many :io_slots, :order => 'io_slots.slot_number ASC, io_slots.path ASC'
  validates_uniqueness_of :model_name
  validates_presence_of :server_line, :tier, :sockets
  # Returns a collection useful for dropdowns.
  def self.by_name
    self.find(:all, :select => "id, model_name", :order => "model_name")
  end
  
  # Returns the tier of the server for integrity
  def integrity_socket_tier
    if self.sockets <= 2
      1
    elsif self.sockets <= 4
      2
    elsif self.sockets <= 8
      3
    else
      4
    end
  end
  
end
