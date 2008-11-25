
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

