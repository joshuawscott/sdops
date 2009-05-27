function toggleContracts(){
  //alert("Contracts Toggled");
  var account = $('contract[account_id]').value;
  var a = $('contract[account_id]').options;
  if (account == ""){
    hideAllContracts();
  }
  else {
    for (i=0; i < a.length; i++){
      var name = 'tr[id="'+a[i].value+'"]';
      if (a[i].value != account && a[i].value !=""){
        $$(name).invoke('hide');
      }
      else {
        $$(name).invoke('show');
      }
    }
  }
}

function hideAllContracts(){
  var a = $('contract[account_id]').options;
  for (i=0; i < a.length; i++){
    var name = 'tr[id="'+a[i].value+'"]';
    $$(name).invoke('hide');
  }
  //alert("Contracts Hidden");
}
window.onload = function() {hideAllContracts();}
