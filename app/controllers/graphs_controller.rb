class GraphsController < ApplicationController
  before_filter :login_required
  
  def sales_by_office
    #Initialize new graph and set general properties
    g = Gruff::SideBar.new("400x325")
    theme_sdc(g)
    g.title = "Total Yearly Support Rev By Office"
    g.hide_legend = true
    g.labels = create_lables
    g.minimum_value = 0
    g.maximum_value = 160000
    
    # Generate data for the graph
    @offices = get_offices
    @total_rev =  Contract.sum(:revenue, :group => :sales_office)
    @data = @offices.map do |d|
      if @total_rev[d] == nil
         @total_rev[d] = 0
      end
      @total_rev[d]
    end
    g.data("Support", @data)

    #Convert to blob object and send to browser
    send_data(g.to_blob, 
              :disposition => 'inline', 
              :type => 'image/png', 
              :filename => "test.png")
  end

  def sales_by_office_mini_bar
    # Prepare data and labels for the graph
    total_rev = Contract.sum(:revenue, :group => :sales_office)
    
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
    g.theme_troy
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
  
  def create_lables
    @data = Dropdown.find(:all, :select => "sort_order, label", :conditions => "dd_name = 'office'")
    a = @data.map {|x| x.sort_order-1}
    b = @data.map {|x| x.label}
    c = a.zip(b)
    c.flatten!
    Hash[*c]
  end
  
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
