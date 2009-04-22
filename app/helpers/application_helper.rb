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

end
