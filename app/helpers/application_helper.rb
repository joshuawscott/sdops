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

  #Requires the activecalendar plugin & javascript declarations.
  #Creates a date selector for use inside a form_tag created form.
  #You can change the defaults by passing standard html tag options to the field_options
  #or img_options hashes, for example, you can change the clickable image to sdc.jpg like this:
  #date_select("date", nil, img_options ={:src => '/images/sdc.jpg'}
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
