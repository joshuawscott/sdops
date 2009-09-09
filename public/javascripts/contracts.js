function getContractFormData(){
  $('export_sales_office').value = $('search_sales_office').value;
  $('export_support_office').value = $('search_support_office').value;
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
  }
}

