# Abstract class for Fishbowl models, storing common connection information.
class Fishbowl < ActiveResource::Base
  #self.site = "http://fbxml.corp.ad/"
  Rails.env == "production" ? self.site = "http://fbxml.corp.ad/" : self.site = "http://192.168.254.129:3000/"
  self.element_name = ""
  self.format = :json
end