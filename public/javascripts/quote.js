document.observe("dom:loaded", function() {
  editFieldInPlaceInTable( '.location_click_to_edit', 'line_items', 'line_item', 'location');
  //editFieldInPlaceInTable( '.product_num_click_to_edit', 'line_items', 'line_item', 'product_num');
  editFieldInPlaceProductNum(); // Because I want it to update description/list price.
  editFieldInPlaceInTable( '.note_click_to_edit', 'line_items', 'line_item', 'note');
  editFieldInPlaceInTable( '.description_click_to_edit', 'line_items', 'line_item', 'description');
  editFieldInPlaceInTable( '.serial_num_click_to_edit', 'line_items', 'line_item', 'serial_num');
  editFieldInPlaceInTable( '.qty_click_to_edit', 'line_items', 'line_item', 'qty');
  editFieldInPlaceInTable( '.list_price_click_to_edit', 'line_items', 'line_item', 'list_price');
});

function editFieldInPlaceProductNum() {
  var items = $$('.product_num_click_to_edit');
  var len = items.length;
  var post_url = '/line_items/update_field.js';
  for(var i=0; i<len; i++){
    new Ajax.InPlaceEditor(items[i], post_url, {
      method: 'post',
      callback: function(form, value) {
        var valuePost = value;
        return '_method=put&line_item[product_num]='+encodeURIComponent(value)+'&authenticity_token='+encodeURIComponent(authenticity_token);
      },
      onComplete: function(transport,element) {
        var value = element.innerHTML;
        var item_id = element.id.toString().replace('product_num_', '');
        $('description_'+item_id).addClassName('inplaceeditor-saving');
        $('list_price_'+item_id).addClassName('inplaceeditor-saving');
        var pricing_info = '';
        var support_type = '';
        new Ajax.Request('/line_items/form_pull_pn_data.json?authenticity_token='+encodeURIComponent(authenticity_token)+'&product_num='+encodeURIComponent(value)+'&support_deal_id='+encodeURIComponent($('support_deal_id').innerHTML)+'&support_type='+encodeURIComponent($('support_type_'+item_id).innerHTML), {
          method: 'post',
          onSuccess: function(transport) { },
          onFailure: function(transport) {
            updateDescriptionAndPrice(item_id, {description: '', list_price: 0.0}); },
          onComplete: function(transport) {
            pricing_info = transport.responseText.evalJSON(true);
            if(pricing_info.hw_support_price) {
              pricing_info = pricing_info.hw_support_price;
            } else {
              pricing_info = pricing_info.sw_support_price;
            }
            updateDescriptionAndPrice(item_id, pricing_info);
          }
        });
      }
    });
  }
}

function updateDescriptionAndPrice(item_id, pricing_info) {
  // Do the description:
  var description = pricing_info.description;
  var price = pricing_info.list_price;
  var requestURL = '/line_items/update_field.js';
  new Ajax.Request(requestURL, {
    method: 'post',
    parameters: '_method=put&line_item[description]='+encodeURIComponent(description)+'&authenticity_token='+encodeURIComponent(authenticity_token)+'&editorId='+encodeURIComponent(item_id),
    onFailure: function(transport) {
      alert('FAILURE saving description');
      $('description_'+item_id).removeClassName('inplaceeditor-saving');
    },
    onSuccess: function(transport){
      $('description_'+item_id).innerHTML = description;
      $('description_'+item_id).removeClassName('inplaceeditor-saving');
    }
  });
  new Ajax.Request('/line_items/update_field.js', {
    method: 'post',
    parameters: '_method=put&line_item[list_price]='+encodeURIComponent(price)+'&authenticity_token='+encodeURIComponent(authenticity_token)+'&editorId='+encodeURIComponent(item_id),
    onFailure: function(transport) {
      alert('FAILURE saving price');
      $('list_price_'+item_id).removeClassName('inplaceeditor-saving');
    },
    onSuccess: function(transport){
      $('list_price_'+item_id).innerHTML = number_to_currency(price);
      $('list_price_'+item_id).removeClassName('inplaceeditor-saving');
    }
  });
}

function addRow(row_id) {
	//
}

function deleteRow(row_id) {
	var row = $(row_id);
        row.remove();
}

function accountChanged() {
  var result = $('spinner_account').show();
  //alert(result);
  $('quote_account_name').value = $('quote_account_id').options[$('quote_account_id').selectedIndex].text;
  var account_id = $('quote_account_id').value;
  new Ajax.Request('/sugar_accts/' + account_id + '.json', {
    method: 'get',
    onSuccess: function(transport) {
      var account_info = transport.responseText.evalJSON(true)["sugar_acct"];
      //alert(account_info["id"]);
      $('quote_support_office').value = account_info.team_id;
      $('quote_sales_office').value = account_info.team_id;
      var index = $('quote_sales_office').selectedIndex;
      var value = $('quote_sales_office').options[index].text;
      //alert(value);
      $('quote_sales_office_name').value = value;
      $('quote_support_office_name').value = value;
      $('quote_address1').value = account_info.billing_address_street;
      $('quote_address2').value = account_info.billing_address_city + ", " + account_info.billing_address_state + " " + account_info.billing_address_postalcode;
      new Ajax.Request('/sugar_contacts.json?account_id=' + account_info.id, {
        method: 'get',
        onSuccess: function(transport) {
          var contacts = transport.responseText.evalJSON(true);
          //alert(contacts[0]["sugar_contact"]["first_name"]);
          var contact_selector = $('quote_contact_id');
          contact_selector.options.length = 0;
          contact_selector.options[0] = new Option("","||");
          for(var i=0;i<=contacts.length;i++) {
            var contact = contacts[i]["sugar_contact"];
            //alert(contact["id"]);
            contact_selector.options[i+1] = new Option(contact["first_name"]+" "+contact["last_name"],contact["first_name"]+" "+contact["last_name"]+"|"+contact["phone_work"]+"|"+contact["email_address"]);
            $('spinner_account').hide();
          }
        }
      });
    }
  });
}

function contactChanged() {
  $('spinner_contact').show();
  var contact = $('quote_contact_id').value.split("|");
  $('quote_contact_name').value = contact[0];
  $('quote_contact_phone').value = contact[1];
  $('quote_contact_email').value = contact[2];
  $('spinner_contact').hide();
}

