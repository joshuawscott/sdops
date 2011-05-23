class Fishbowl < ActiveResource::Base
  Rails.env == "production" ? self.site = "http://fbxml.corp.ad/" : self.site = "http://192.168.254.129:3000/"
  self.element_name = ""
  self.format = :json
end