module ReportsHelper
  def comment_link_if_present(contract)
    comment = contract.last_comment
    if comment.nil?
      haml_concat "<span>NO</span>"
    else
      haml_concat "<div class='tooltip_target' id='contract_comment_" + contract.id.to_s + "' style='cursor:pointer;text-decoration: underline'>YES</div>"
      haml_concat "<div class='tooltip_content' id='contract_comment_tooltip_" + contract.id.to_s + "'><p><b>Contract " + contract.id.to_s + "</b><br/><b>User:</b> " + comment.user+ "<br/><b>Date:</b>" + comment.updated_at.to_s + "</p><p>" + comment.body + "</p></div>"
    end
  end
end
