
// ************************************************
// Functions for Renewals report
// ************************************************
function toggleOffices(){
  var office = $('filter_offices').value;
  var a = $('filter_offices').options;
  if (office == ""){
    showAll();
  }
  else {
    showAll();
    for (i=0; i < a.length; i++){
      if (a[i].value != office && a[i].value !=""){
        var name = 'tr[id="'+a[i].value+'"]';
        $$(name).invoke('hide');
      }
    }
  }
}

function showAll(){
  var a = $('filter_offices').options;
  for (i=0; i < a.length; i++){
    var name = 'tr[id="'+a[i].value+'"]';
    $$(name).invoke('show');
  }
}


// ************************************************
// Functions for Dashboard report
// ************************************************
function toggleHeaderStuff(){
  $('header').toggle();
  $('submenu').toggle();
}

// ************************************************
// Functions for Contract Edit
// ************************************************
function setReplacedBy(box){
  var chBox = $('contract[successor_ids][' + box + ']');
  if (chBox.checked == true)
  {
    var set_expired = confirm('This contract will be set to "Expired", are you sure you want to continue?\nBe sure to you are selecting the right replacement contract.\n\nHit "Update" to accept changes.');
    if (set_expired == true)
      { 
      setExpiredTrue();
      }
    else
      {
      chBox.checked = false;
      return false;
      }
  }
  else
  {
    setExpiredFalse();
    chBox.checked = false;
  }
}

function setExpiredTrue(){
  $('contract_expired').checked = true;
}

function setExpiredFalse(){
  $('contract_expired').checked = false;
}
