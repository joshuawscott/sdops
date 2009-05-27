function toggleCompleted() {
  var completed = $('upfront_order_completed');
  var checkbox = $('upfront_order_has_upfront_support');
  var contractid = $('contractid');
  if ( checkbox.checked == true ){
    if(contractid.innerHTML == "")
      completed.value = 0;
  } else {
    completed.value = 1;
  }
}
