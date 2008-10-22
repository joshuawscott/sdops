class GraphsController < ApplicationController
  before_filter :login_required
  
  def sales_by_office_mini_bar
    # Prepare data and labels for the graph
    total_hw_rev = Contract.sum(:annual_hw_rev, :group => :sales_office_name)
    total_sw_rev = Contract.sum(:annual_sw_rev, :group => :sales_office_name)
    
    hw_temp = total_hw_rev.map {|x| max = x[1] }
    sw_temp = total_sw_rev.map {|x| max = x[1] }
    temp = hw_temp + sw_temp
    temp.compact!
    max = temp.max * 1.1

    n = 0
    labels = {}
    hw_data = []
    total_hw_rev.map do |x|
      labels[n] = x[0].to_s.slice(0,3)
      n += 1
      if x[1].nil?
        hw_data << 0
      else
        hw_data << x[1]
      end
    end
    
    sw_data = []
    total_sw_rev.map do |x|
      if x[1].nil?
        sw_data << 0
      else
        sw_data << x[1]
      end
    end

    #Initialize new graph and set general properties
    g = Gruff::Bar.new("270x90")
    theme_sdc(g)
    g.hide_title = true
    #g.title = "Yearly Support Rev By Office"
    g.top_margin= 8
    g.marker_font_size = 23
    g.hide_line_numbers=true
    #g.hide_legend = true
    #g.legend_font_size = 10
    g.title_font_size = 27
    g.labels = labels
    g.minimum_value = 0
    g.maximum_value = max
    
    g.data("HW", hw_data)
    g.data("SW", sw_data)

    #Convert to blob object and send to browser
    send_data(g.to_blob, 
              :disposition => 'inline', 
              :type => 'image/png', 
              :filename => "test.png")
  end

  def sales_by_office
    # Prepare data and labels for the graph
    total_hw_rev = Contract.sum(:annual_hw_rev, :conditions => 'expired <> 1', :group => 'sales_office_name')
    total_sw_rev = Contract.sum(:annual_sw_rev, :conditions => 'expired <> 1', :group => 'sales_office_name')
    
    hw_temp = total_hw_rev.map {|x| max = x[1] }
    sw_temp = total_sw_rev.map {|x| max = x[1] }
    temp = hw_temp + sw_temp
    temp.compact!
    max = temp.max * 1.1

    n = 0
    labels = {}
    hw_data = []
    total_hw_rev.map do |x|
      labels[n] = x[0].to_s
      n += 1
      if x[1].nil?
        hw_data << 0
      else
        hw_data << x[1]
      end
    end
    
    sw_data = []
    total_sw_rev.map do |x|
      if x[1].nil?
        sw_data << 0
      else
        sw_data << x[1]
      end
    end

    #Initialize new graph and set general properties
    g = Gruff::SideBar.new("670x400")
    theme_sdc(g)
    g.title = "Total Yearly Support $ Rev By Office"
    g.hide_legend = false
    g.labels = labels
    g.minimum_value = 0
    g.maximum_value = max
    
    g.data("HW", hw_data)
    g.data("SW", sw_data)

    #Convert to blob object and send to browser
    send_data(g.to_blob, 
              :disposition => 'inline', 
              :type => 'image/png', 
              :filename => "test.png")
  end

  def contract_counts_by_office
    # Prepare data and labels for the graph
    total_hw_rev = Contract.count :annual_hw_rev, {:conditions => 'expired <> 1', :group => :sales_office_name}
    total_sw_rev = Contract.count :annual_sw_rev, {:conditions => 'expired <> 1', :group => :sales_office_name}
    
    hw_temp = total_hw_rev.map {|x| max = x[1] }
    sw_temp = total_sw_rev.map {|x| max = x[1] }
    temp = hw_temp + sw_temp
    temp.compact!
    max = temp.max

    n = 0
    labels = {}
    hw_data = []
    total_hw_rev.map do |x|
      labels[n] = x[0][0,4].to_s
      n += 1
      if x[1].nil?
        hw_data << 0
      else
        hw_data << x[1]
      end
    end
    
    sw_data = []
    total_sw_rev.map do |x|
      if x[1].nil?
        sw_data << 0
      else
        sw_data << x[1]
      end
    end

    #Initialize new graph and set general properties
    g = Gruff::Bar.new("680x400")
    theme_sdc(g)
    g.title = "Contract Counts By Office"
    g.hide_legend = false
    g.labels = labels
    g.y_axis_increment = 20
    g.marker_font_size=15.0
    g.minimum_value = 0
    g.maximum_value = max
    
    g.data("HW", hw_data)
    g.data("SW", sw_data)

    #Convert to blob object and send to browser
    send_data(g.to_blob, 
              :disposition => 'inline', 
              :type => 'image/png', 
              :filename => "test.png")
  end

  def sales_by_type_pie
    #Initialize new graph and set general properties
    g = Gruff::Pie.new("670x400")
    theme_sdc(g)
    g.title = "Support Rev By Type"
    
    # Generate data for the graph
    g.data("Hardware", Contract.sum(:annual_hw_rev, :conditions => 'expired <> 1'))
    g.data("Software", Contract.sum(:annual_sw_rev, :conditions => 'expired <> 1'))
    g.data("CE Days", Contract.sum(:annual_ce_rev, :conditions => 'expired <> 1'))
    g.data("SA Days", Contract.sum(:annual_sa_rev, :conditions => 'expired <> 1'))
    g.data("DR", Contract.sum(:annual_dr_rev, :conditions => 'expired <> 1'))
    
    #Convert to blob object and send to browser
    send_data(g.to_blob, 
              :disposition => 'inline', 
              :type => 'image/png', 
              :filename => "test.png")
  end

  protected
  
  def theme_sdc(graph)
    # Colors
    @black = 'black'
    @blue = '#000099'
    @green = '#009900'
    @orange = '#cf5910'
    @purple = '#cc99cc'
    @red = '#990000'
    @yellow = '#FFF804'
    @colors = [@green, @blue, @red, @yellow, @purple, @orange, @black]
  
    graph.theme = {
      :colors => @colors,
      :marker_color => 'black',
      :font_color => 'black',
      :background_colors => ['white', 'white']
    }
  end
  
  def theme_transparent(graph)
    # Colors
    @black = 'black'
    @blue = '#3d2be0'
    @green = '#339933'
    @orange = '#cf5910'
    @purple = '#cc99cc'
    @red = '#c12b44'
    @yellow = '#FFF804'
    @colors = [@red, @blue, @green, @yellow, @purple, @orange, @black]
  
    graph.theme = {
      :colors => @colors,
      :marker_color => 'black',
      :font_color => 'black',
      :background_colors => ['white', 'white']
    }
  end  
end
