function toggleContracts(){
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
  var rows = $$('tbody#contracts tr');
  rows.invoke('hide');
}
/*
window.onload = function() {hideAllContracts();}
*/
document.observe("dom:loaded", function() {
  hideAllContracts();
  toggleContracts();
});
