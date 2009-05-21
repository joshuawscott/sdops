require 'active_record/validations'
require 'faster_csv'
require 'csv'

class Appgen
  attr_reader :appgen_dir
  attr_accessor :dir
  attr_accessor :table
  attr_accessor :field_count
  attr_accessor :mv_field_count
  attr_accessor :out_file
  attr_accessor :fields
  attr_accessor :errors

  #appgen_dir = '/usr/appgen', dir = '', table = '', field_count = 0, mv_field_count = 0, out_file = '', fields = ''
  def initialize(opts={})
    # Create an Errors object, which is required by validations and to use some view methods.
    @appgen_dir = '/usr/appgen'
    @dir = opts[:dir]
    @table = opts[:table]
    @field_count = opts[:field_count].to_i
    @mv_field_count = opts[:mv_field_count].to_i
    @out_file = opts[:out_file]
    @fields = opts[:fields]
    @errors = ActiveRecord::Errors.new(self)
  end

  def reg_field_count
    field_count - mv_field_count
  end
  
  def query
    appgen_dir + '/bin/show -c1 ' + appgen_dir + '/' + dir + '/' + table + ' ' + fields
  end
  

  def get_data
    temp = `#{query}`
    #remove commas and double quotes:
    temp.gsub!(/[,"]/,"")
    
    #change dates to mysql format
    temp.gsub!(/([01][0-9])\/([0-3][0-9])\/([0-9][0-9])/) {"20" + $3 + "-" + $1 + "-" + $2}
    
    #MUST use regular slow CSV, since it allows splitting on "\n\n"
    #This stores an array of strings, each string containing the metarecord
    metarecord = CSV.parse(temp, nil, "\n\n").to_a
    
    #free memory
    temp = nil
    
    #ary will become the array that we process into CSV.
    ary = []
    i=0
    metarecord.each_with_index do |metarec,row|
      record = metarec[0].split("\n")
      record.each_with_index {|r,idx| record[idx] = r.split(":")[1].to_s.strip}
      recs_to_create = mv_field_count > 0 ? (record.size - reg_field_count) / mv_field_count : 1
      recs_to_create.times {ary << []}
      recs_to_create.times do |z|
        ary[i][0..reg_field_count - 1] = record[0..reg_field_count - 1]
        mv_field_count.times {|nf| ary[i][reg_field_count + nf] = record[(reg_field_count + recs_to_create*nf) + z] == "" ? nil : record[(reg_field_count + recs_to_create*nf) + z]}
        i = i.succ
      end
    end
    output = fields.gsub!(/\s/,"|")+"\n"
    ##Open file to write output to
    #debugger
    #FasterCSV.open(out_file, "w", {:col_sep => "|", :row_sep => "\n"}) do |csv|
    out_csv = FasterCSV.generate({:col_sep => "|", :row_sep => "\n"}) do |csv|
      ary.map do |row|
        #row = ["\\N"].concat(row) # Add id field
        csv << row
      end
    end
    output << out_csv
    #return true
  end
end
