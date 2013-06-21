function getContractFormData(){
  $('export_sales_office').value = $('search_sales_office').value;
  $('export_support_office').value = $('search_support_office').value;
  $('export_sales_rep').value = $('search_sales_rep').value;
  $('export_account_name').value = $('search_account_name').value;
  $('export_said').value = $('search_said').value;
  $('export_description').value = $('search_description').value;
  $('export_start_date').value = $('search_start_date').value;
  $('export_end_date').value = $('search_end_date').value;
  $('export_payment_terms').value = $('search_payment_terms').value;
  $('export_revenue').value = $('search_revenue').value;
  if($('search_expired').checked == true) {
    $('export_expired').checked = true;
  } else {
    $('export_expired').checked = false;
  }
}

function checkAllBoxes(section){
  var checkboxclass = '.' + section + '_line_item_class';
  var mainboxid = section + 'checkbox';
  var cboxes = $$(checkboxclass);
  var mainbox = $(mainboxid);
  cboxes.each(function(c){c.checked = mainbox.checked;});
}

function setReplacedBy(box){
  if (box.checked == true)
  {
    var set_expired = confirm('This contract will be set to "Expired", are you sure you want to continue?\nBe sure to you are selecting the right replacement contract.\n\nHit "Update" to accept changes.');
    if (set_expired == true)
      {
      $('contract_expired').checked = true;
      return true;
      }
    else
      {
      box.checked = false;
      return false;
      }
  }
  else
  {
    $('contract_expired').checked = false;
    box.checked = false;
    return false;
  }
}

function setExpiredHiddenField() {
  var search_expired = $('search_expired');
  var hidden_field = $('hidden_search_expired');
  if(search_expired.checked == 1) {
    hidden_field.value = 1;
  } else {
    hidden_field.value = 0;
  }
}

function disableDragOnSort(e) {
  //alert(Event.element(event).innerHTML);
  if(e.ctrlKey == true && e.altKey == true) {
    $$('.drag_handle').each(function(s){ s.hide(); });
    $('sort_warning').innerHTML = 'Drag & Drop disabled due to table sorting.  Refresh page to enable.';
  }
}

function changeAccount() {
  var account_id_dropdown = $('contract_account_id');
  var account_id = account_id_dropdown.options[account_id_dropdown.options.selectedIndex].value;
  //Update account name:
  $('contract_account_name').value = account_id_dropdown.options[account_id_dropdown.selectedIndex].text;
  //Find partners, if needed
  var requestURL = '/sugar_accts/end_users_for_partner/'+account_id+'.json';
  new Ajax.Request(requestURL, {
    method: 'get',
    //parameters: 'id='+encodeURIComponent(account_id)+'&authenticity_token='+encodeURIComponent(authenticity_token),
    onFailure: function(transport) {
      alert('Error retrieving end-users');
      $('contract_end_user_id').innerHTML = '';
    },
    onSuccess: function(transport){
      var end_users = transport.responseText.evalJSON(true);
      var end_user_dropdown = $('contract_end_user_id');
      end_user_dropdown.options.length = 0;
      end_user_dropdown.options[end_user_dropdown.options.length] = new Option('','');
      end_users.each(function(end_user) {
        end_user_dropdown.options[end_user_dropdown.options.length] = new Option(end_user['sugar_acct']['name'], end_user['sugar_acct']['id']);
      })
      new Effect.Highlight(end_user_dropdown, {startcolor: '#ffff80'});
    }
  });

}
document.observe("dom:loaded", function() {
  editFieldInPlaceInTable( '.note_click_to_edit', 'line_items', 'line_item', 'note');
  editFieldInPlaceInTable( '.serial_num_click_to_edit', 'line_items', 'line_item', 'serial_num');
  //Watch for ctrl-alt-click (sort override) and disable drag/drop.
  $('hw_line_items_table').observe('click', disableDragOnSort);
  $('sw_line_items_table').observe('click', disableDragOnSort);
  $('srv_line_items_table').observe('click', disableDragOnSort);
});