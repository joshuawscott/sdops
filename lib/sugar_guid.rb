module SugarGuid
  #######################################################
  # This will create a GUID in a form compatible
  # with SugarCRM.
  #      aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
  #######################################################
  
  def create_guid()
     t = Time.now
     a_dec = t.usec.to_s
     a_sec = t.to_i.to_s
     
     dec_hex = sprintf("%x", a_dec)
     sec_hex = sprintf("%x", a_sec)
     
     dec_hex = ensure_length(dec_hex,5)
     sec_hex = ensure_length(sec_hex,6)
     
     @guid = ""
     @guid << dec_hex
     @guid << create_guid_section(3)
     @guid << "-"
     @guid << create_guid_section(4)
     @guid << "-"
     @guid << create_guid_section(4)
     @guid << "-"
     @guid << create_guid_section(4)
     @guid << "-"
     @guid << sec_hex
     @guid << create_guid_section(6)
  
     return @guid
  end
  
  protected
    def ensure_length(str, len) #:nodoc:
       strlen = str.length
       
       if strlen < len
          str = str + "000000"
          str = str[0,len]
       elsif strlen > len
          str = str[0,len]
       end
       
       return str
    end
    
    def create_guid_section(chars) #:nodoc:
       @retval = ""
       
       chars.times do |i|
         @retval << sprintf("%x", rand(15))
       end
       return @retval
    end
   
end
