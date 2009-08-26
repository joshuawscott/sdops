require 'active_record/validations'
require 'faster_csv'
require 'csv'

class Appgen
  attr_reader :appgen_dir
  attr_accessor :delimited
  attr_accessor :dir
  attr_accessor :table
  attr_accessor :reg_field_count
  attr_accessor :mv_field_count
  attr_accessor :out_file
  attr_accessor :sort_str
  attr_accessor :filters
  attr_accessor :fields
  attr_accessor :errors

  def initialize(opts={})
    # Create an Errors object, which is required by validations and to use some view methods.
    @appgen_dir = '/usr/appgen'
    @delimited = opts[:delimited]
    @dir = opts[:dir]
    @table = opts[:table]
    @mv_field_count = opts[:mv_field_count].to_i
    @out_file = opts[:out_file]
    @sort_str = opts[:sort_str]
    @filters = opts[:filters]
    @fields = opts[:fields]
    @errors = ActiveRecord::Errors.new(self)
  end

  def field_count
    fields.split(" ").size
  end 
  
  def reg_field_count
    field_count - mv_field_count
  end

  def query

    cols = delimited == "false" ? '10000 ' : '1 '
    
    #Explicitly use the instance variable name or else
    #it is treated as local variable
    if !@sort_str.blank?    
      @sort_str = ' ' + @sort_str.to_s
    end
    
    if !@filters.blank?
      @filters = ' ' + @filters.to_s
    end

    appgen_dir + '/bin/show -c' + cols + appgen_dir + '/' + dir + '/' + table + @filters.to_s + @sort_str.to_s + ' ' + fields
  end
  

  def get_data
    temp = `#{query}`
    #remove commas and double quotes:
    temp.gsub!(/[,"]/,"")
    
    #change dates to mysql format
    temp.gsub!(/([01][0-9])\/([0-3][0-9])\/([0-9][0-9])/) {"20" + $3 + "-" + $1 + "-" + $2}

    if delimited == "true"
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
        #Ensure there is allways 1 for the field counts
        if mv_field_count > 0
          field_count = (record.size - reg_field_count) / mv_field_count <= 0 ? 1 : (record.size - reg_field_count) / mv_field_count
          recs_to_create = mv_field_count > 0 ? field_count : 1
        else
          recs_to_create = 1
        end
        recs_to_create.times {ary << []}
        recs_to_create.times do |z|
          ary[i][0..reg_field_count - 1] = record[0..reg_field_count - 1]
          mv_field_count.times {|nf| ary[i][reg_field_count + nf] = record[(reg_field_count + recs_to_create*nf) + z] == "" ? nil : record[(reg_field_count + recs_to_create*nf) + z]}
          i = i.succ
        end
      end
      ##Open file to write output to
      if out_file.blank?
        output = fields.gsub!(/\s/,"|")+"\n"
        out_csv = FasterCSV.generate({:col_sep => "|", :row_sep => "\n"}) do |csv|
          ary.map do |row|
            #row = ["\\N"].concat(row) # Add id field
            csv << row
          end
        end
        output << out_csv
      else
        output = fields.gsub!(/\s/,"|")
        `echo '#{output}' > #{out_file}`
        FasterCSV.open(out_file, "a", {:col_sep => "|", :row_sep => "\n"}) do |csv|
          ary.map do |row|
            #row = ["\\N"].concat(row) # Add id field
            csv << row
          end
        end
        return "#{out_file} has been saved."
      end
    else
      return temp
    end
  end
end
