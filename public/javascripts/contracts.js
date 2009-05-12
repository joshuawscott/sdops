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
