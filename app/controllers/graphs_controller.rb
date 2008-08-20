class GraphsController < ApplicationController
  before_filter :login_required
  
  def sales_by_office
    # Prepare data and labels for the graph
    total_rev = Contract.sum(:revenue, :group => :sales_office_name)

    temp = total_rev.map {|x| max = x[1] }
    max = temp.max * 1.1
    
    n = 0
    labels = {}
    data = []
    total_rev.map do |x|
      labels[n] = x[0].to_s
      n += 1
      data << x[1]
    end

    #Initialize new graph and set general properties
    g = Gruff::SideBar.new("400x325")
    theme_sdc(g)
    g.title = "Total Yearly Support Rev By Office"
    g.hide_legend = true
    g.labels = labels
    g.minimum_value = 0
    g.maximum_value = max
    
    g.data("Support", data)

    #Convert to blob object and send to browser
    send_data(g.to_blob, 
              :disposition => 'inline', 
              :type => 'image/png', 
              :filename => "test.png")
  end

  def sales_by_office_mini_bar
    # Prepare data and labels for the graph
    total_rev = Contract.sum(:revenue, :group => :sales_office_name)

    temp = total_rev.map {|x| max = x[1] }
    max = temp.max * 1.1
    
    n = 0
    labels = {}
    data = []
    total_rev.map do |x|
      labels[n] = x[0].to_s.slice(0,3)
      n += 1
      data << x[1]
    end
    
    #Initialize new graph and set general properties
    g = Gruff::Bar.new("300x90")
    theme_sdc(g)
    #g.render_transparent_background
    #g.hide_title = true
    g.title = "Yearly Support Rev By Office"
    g.top_margin=10
    g.marker_font_size = 23
    g.hide_legend = true
    #g.legend_font_size = 10
    g.title_font_size = 27
    g.labels = labels
    g.minimum_value = 0
    g.maximum_value = max
    
   
    g.data("Support", data)
    #g.data("Product", data)

    #Convert to blob object and send to browser
    send_data(g.to_blob, 
              :disposition => 'inline', 
              :type => 'image/png', 
              :filename => "test.png")
  end

  def sales_by_type_pie
    #Initialize new graph and set general properties
    g = Gruff::Pie.new("400x325")
    theme_sdc(g)
    g.title = "Support Rev By Type"
    
    # Generate data for the graph
    g.data("Hardware", Contract.sum(:annual_hw_rev))
    g.data("Software", Contract.sum(:annual_sw_rev))
    g.data("CE Days", Contract.sum(:annual_ce_rev))
    g.data("SA Days", Contract.sum(:annual_sa_rev))
    g.data("DR", Contract.sum(:annual_dr_rev))
    
    #Convert to blob object and send to browser
    send_data(g.to_blob, 
              :disposition => 'inline', 
              :type => 'image/png', 
              :filename => "test.png")
  end

  protected
  
  def get_offices
    #debugger
    #Dropdown.find(:all, :select => "id", :conditions => "dd_name = 'office'", :order => "sort_order").map do |x|
    #  x.id
    #end
    Dropdown.find(:all, :select => "label", :conditions => "dd_name = 'office'", :order => "sort_order").map do |x|
      x.label
    end
  end

  def theme_sdc(graph)
    # Colors
    @black = 'black'
    @blue = '#0000cc'
    @green = '#00cc00'
    @orange = '#cf5910'
    @purple = '#cc99cc'
    @red = '#cc0000'
    @yellow = '#FFF804'
    @colors = [@green, @red, @blue, @yellow, @purple, @orange, @black]
  
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
