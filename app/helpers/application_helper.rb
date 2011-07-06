# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
   # put this in the body after a form to set the input focus to a specific control id
  def set_focus_to_id(id)
    <<-END
    <script language="javascript">
        <!--
                document.getElementById("#{id}").focus()
        //-->
    </script>
    END
  end
  
  def commenter_url
    commenter = controller.controller_name.singularize
    comments_path(:commentable_type => commenter, :commentable_id => controller.instance_variable_get("@#{commenter}").id)
  end

  def include_calendar
    content_for(:stylesheets) { stylesheet_link_tag("/javascripts/jscalendar-1.0/calendar-blue.css") }
    content_for(:top_js) { javascript_include_tag("jscalendar-1.0/calendar.js", "jscalendar-1.0/lang/calendar-en.js", "jscalendar-1.0/calendar-setup.js", :cache => "calendar_all") }
  end
  # Requires the activecalendar plugin.
  # Creates a javascript assisted date selector for use inside a form_tag created form.
  # This is done with a text field, and an image trigger.
  # field_options - html options for the text field.
  # img_options - html options for the img tag.
  #
  # Examples:
  #   <%= date_select :date_created %>
  # Becomes
  #   <input type="text" id="date_created", name="date_created", value=""/>
  #   <img src="/images/calendar.png", id="trigger" style="cursor: pointer", title="Date Selector"/>
  #   <script type='text/javascript'>
  #   ... [javascript for popup calendar]
  #   </script>
  # Set a default value:
  #   <%= date_select :date_created, @date_created %>
  # Change the image:
  #   date_select("date", nil, {}, {:src => '/images/sdc.jpg'})
  # You must include the following javascript files to utilize this helper:
  #   <%= stylesheet_link_tag "/javascripts/jscalendar-1.0/calendar-blue.css" %>
  #   <%= javascript_include_tag "jscalendar-1.0/calendar.js" %>
  #   <%= javascript_include_tag "jscalendar-1.0/lang/calendar-en.js" %>
  #   <%= javascript_include_tag "jscalendar-1.0/calendar-setup.js" %>
  def date_select_tag(name, value = Date.today.to_s(:local), field_options = {}, img_options = {})
    trigger = name.to_s + "_trigger"
    value ||= Date.today.to_s(:local)
    html = ""
    html += tag :input, {"type" => "text", "id" => name, "name" => name, "value" => value}.update(field_options.stringify_keys)
    html += "\n"
    html += tag("img", {"src" => "/images/calendar.png", "id" => trigger, "style" => "cursor: pointer", "title" => "Date selector"}.update(img_options.stringify_keys))
    html += "\n"
    html += "<script type='text/javascript'>\n"
    html += "  Calendar.setup({\n"
    html += "    button : '#{trigger}',\n"
    html += "    inputField : '#{name}',\n"
    html += "    ifFormat : '%m/%d/%Y',\n"
    html += "    singleClick : true\n"
    html += "  });\n"
    html += "</script>"
    html
  end

  # Returns a url containing parameters for executing a search on the contracts/index action.
  def contract_search_url(search_hash = {})
    Contract.columns.each do |c|
      search_hash[c.name.to_sym] ||= ""
    end
    url_for  :controller => "contracts", :action => "index", :commit => "Search", :params => { :search => search_hash }
  end

  # Renders a simple show view using haml.  Attempts to translate column names ending in '_id' into a
  # foreign table name, where the value of the remote table's 'name' and 'description' fields are 
  # substituted for the id value in the table:
  #   @line_item.support_deal_id => @line_item.contract.[name|description]
  # If name or description fields are not available, then the id value prints.
  # instance should be a single ActiveRecord object
  # 
  # options hash:
  # - exclude => array of column name excluded from the
  # - ignored_foreign_keys => array of column names that are excluded from the automatic foreign key translation
  # - prefix => this string will be prepended to the table names when doing a foreign key lookup
  # 
  # example:
  #   - render_simple_show @user, :exclude => [:id, :created_at], :ignored_foreign_keys => [:passport_id], :prefix => ["users"]
  def render_simple_show(instance, options = {})
    options.symbolize_keys!
    options[:exclude] ||= []
    options[:ignored_foreign_keys] ||= []
    if options[:prefix]
      options[:prefix] += '_'
    else
      options[:prefix] = ''
    end
    instance.class.columns.each do |c|
      next if options[:exclude].include? c.name.to_sym
      haml_tag :p do
        haml_tag :label, {:for => c.name} do
          haml_concat h(c.name.humanize)
        end
        if((c.name.split('_')[-1] == 'id' && c.name != 'id') && (!options[:ignored_foreign_keys].include?(c.name.to_sym)))
          # handle foreign key fields
          foreign_model = (options[:prefix].to_s + c.name.gsub(/_id$/, '')).camelize.constantize
          if foreign_model.columns.include?('name')
            haml_concat h(instance.__send__(foreign_model.to_s.underscore).name)
          elsif foreign_model.columns.include?('description')
            haml_concat h(instance.__send__(foreign_model.to_s.underscore).description)
          else
            haml_concat h(instance.__send__(c.name))
          end
        else
          haml_concat h(instance.__send__(c.name))
        end
        haml_tag :br
      end
    end
    haml_tag :span
  end

  # Creates a table with the supplied aggregation.  Same options as render_simple_show
  # The table includes show, edit, and destroy links for each line.
  # additional options, these hide or display the show/edit/destroy links all rows. default is true
  # - :display_show => true|false
  # - :display_edit => true|false
  # - :display_destroy => true|false
  def render_simple_index(aggregation, options = {})
    return "<p>No Records Found.</p>" if aggregation[0].class.name == 'NilClass'
    options.symbolize_keys!
    options[:exclude] ||= []
    options[:ignored_foreign_keys] ||= []
    if options[:prefix]
      options[:prefix] += '_'
    else
      options[:prefix] = ''
    end
    linkcols = 0
    [options[:display_show], options[:display_edit], options[:display_destroy]].each do |opt|
      opt = true if opt.nil?
      linkcols += 1 if opt == true
    end
    options[:display_show] = true if options[:display_show].nil?
    options[:display_edit] = true if options[:display_edit].nil?
    options[:display_destroy] = true if options[:display_destroy].nil?
    haml_tag :table do
      haml_tag :thead do
        aggregation[0].class.columns.each do |c|
          next if options[:exclude].include? c.name.to_sym
          haml_tag :th do
            haml_concat h(c.name.humanize)
          end
        end
        linkcols > 0 ? haml_tag(:th, "Options", {:colspan => linkcols}) : nil
      end
      
      haml_tag :tbody do
        aggregation.each do |instance|
          haml_tag :tr do
            instance.class.columns.each do |c|
              haml_tag :td do
                if((c.name.split('_')[-1] == 'id' && c.name != 'id') && (!options[:ignored_foreign_keys].include?(c.name.to_sym)))
                  # handle foreign key fields
                  foreign_model = (options[:prefix].to_s + c.name.gsub(/_id$/, '')).camelize.constantize
                  if foreign_model.column_names.include?('name')
                    haml_concat h(instance.__send__(foreign_model.to_s.underscore).name)
                  elsif foreign_model.column_names.include?('description')
                    haml_concat h(instance.__send__(foreign_model.to_s.underscore).description)
                  else
                    haml_concat h(instance.__send__(c.name))
                  end
                else
                  haml_concat h(instance.__send__(c.name))
                end # big if
              end #td
            end #columns.each
            if options[:display_show]
              haml_tag :td do
                haml_concat link_to('Show', url_for(instance))
              end
            end
            if options[:display_edit]
              haml_tag :td do
                haml_concat link_to('Edit', url_for(instance) + "/edit")
              end
            end
            if options[:display_destroy]
              haml_tag :td do
                haml_concat link_to('Destroy', url_for(instance), :confirm => "Are You Sure?", :method => :delete)
              end
            end
          end #tr
        end #aggregation
      end #tbody
    end #table
  end #render_simple_index

  #returns an html options hash for the main submenu
  def submenuhash(id,description)
    {:class => 'submenu', :onmouseover => "commandDescOn('#{id}','#{description}');", :onmouseout => "commandDescOff('#{id}');"}
  end

  #returns the correct css class for the tab by checking the current controller
  def tabclass(cname)
    #change cname to the correct selected tab name in exceptional cases:
    case controller.controller_name
      when  'inventory_items'
        rcname = 'reports'
      when  'comments',
            'line_items',
            'subcontractors',
            'subcontracts'
        rcname = 'contracts'
      when  'audits',
            'dropdowns',
            'import',
            'roles',
            'users'
        rcname = 'admin'
      when  'appgen_orders',
            'io_slots',
            'ioscans',
            'servers',
            'swlist_blacklists',
            'swlist_whitelists',
            'swlists',
            'swproducts',
            'upfront_orders'
        rcname = 'tools'
      when  'hw_support_prices',
            'manufacturers',
            'manufacturer_lines',
            'sw_support_prices'
        rcname = 'prices'
      else
        rcname = controller.controller_name
    end
    #general case
    if cname == rcname 
      return("menuSelected")
    else
      return("menuUnselected")
    end
    
  end

  # Similar to link_to_if, but returns "" rather than name when condition is false.
  def link_if(condition, name, options = {}, html_options ={}, &block)
    if !condition
      if block_given?
        block.arity <= 1 ? yield(name) : yield(name, options, html_options)
      else
        ""
      end
    else
      link_to(name, options, html_options)
    end
  end

end

def tooltip_if_truncated(string, length)
  string.length > 30 ? string : ""
end