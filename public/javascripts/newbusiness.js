// ************************************************
// Functions for newbusiness report
// ************************************************

function togglePeriods(){
  var period = $('filter_period').value;
  var a = $('filter_period').options;
  if (period == ""){
    showAllPeriods();
  }
  else {
    for (i=0; i < a.length; i++){
      var name = 'tr[id="'+a[i].value+'"]';
      if (a[i].value != period && a[i].value !=""){
        $$(name).invoke('hide');
      }
      else {
        $$(name).invoke('show');
      }
    }
  }
}

function showAllPeriods(){
  var a = $('filter_period').options
  for (i=0; i < a.length; i++){
    var name = 'tr[id"'+a[i].value+'"]';
    $$(name).invoke('show');
  }
}

window.onload = function() {
togglePeriods();
}
