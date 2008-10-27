
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

