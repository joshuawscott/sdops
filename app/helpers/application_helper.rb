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
      search_hash[c.name] ||= ""
    end
    url_for  :controller => "contracts", :action => "index", :commit => "Search", :params => { :search => search_hash }
  end

  # Renders a simple show view using haml.  Attempts to translate column names ending in '_id' into a
  # foreign table name, where the value of the remote table's 'name' and 'description' fields are 
  # substituted for the id value in the table:
  #   @line_item.contract_id => @line_item.contract.[name|description]
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
      #debugger
      next if options[:exclude].include? c.name.to_sym
      haml_tag :p do
        haml_tag :label, {:for => c.name} do
          haml_concat h(c.name.humanize)
        end
        if((c.name.split('_')[-1] == 'id' && c.name != 'id') && (!options[:ignored_foreign_keys].include?(c.name.to_sym)))
          # handle foreign key fields
          foreign_model = (options[:prefix].to_s + c.name.gsub(/_id$/, '')).camelize.constantize
          if foreign_model.methods.include?('name')
            haml_concat h(instance.__send__(foreign_model.to_s.underscore).name)
          elsif foreign_model.methods.include?('description')
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
  end

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
            'line_items'
        rcname = 'contracts'
      when  'dropdowns', 
            'import',
            'io_slots',
            'servers',
            'swlist_blacklists',
            'swlists_whitelists',
            'swproducts'
        rcname = 'admin'
      when  'ioscans',
            'swlists'
        rcname = 'tools'
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
end
