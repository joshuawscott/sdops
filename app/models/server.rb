class Server < ActiveRecord::Base
  has_many :io_slots, :order => 'io_slots.slot_number ASC, io_slots.path ASC'
  validates_uniqueness_of :model_name
  validates_presence_of :server_line, :tier, :sockets
  def self.by_name
    self.find(:all, :select => "id, model_name", :order => "model_name")
  end

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
