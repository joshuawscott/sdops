# Fields:
# id
# name
# contact_name
# contact_email
# contact_phone_work
# contact_phone_mobile
# phone
# address1
# address2
# city
# state
# postalcode
# country
# note

class Subcontractor < ActiveRecord::Base
  has_many :subcontracts

  # converts the subcontractor to a vcard
  def to_vcf
    @subcontractor = "BEGIN:VCARD\r\n"
    @subcontractor += "VERSION:2.1\r\n"
    @subcontractor += "N:#{contact_name}\r\n"
    @subcontractor += "FN:#{contact_name}\r\n"
    @subcontractor += "ORG:#{name}\r\n"
    @subcontractor += "NOTE;ENCODING=QUOTED-PRINTABLE::#{note_to_vcf}\r\n"
    @subcontractor += "TEL;WORK;VOICE:#{contact_phone_work}\r\n"
    @subcontractor += "TEL;WORK;VOICE:#{phone}\r\n"
    @subcontractor += "TEL;CELL;VOICE:#{contact_phone_mobile}\r\n"
    @subcontractor += "ADR;WORK:#{address1};#{address2};#{city};#{state};#{postalcode};#{country}\r\n"
    @subcontractor += "EMAIL;PREF;INTERNET:#{contact_email}\r\n"
    @subcontractor += "URL:https://sdops/subcontractors/#{id}.vcf\r\n"
    @subcontractor += "END:VCARD"
  end

  # Properly escapes the note field for the vcard format
  def note_to_vcf
    note = @note.gsub("\r\n", "=0D=0A") unless note.nil?
  end
end
