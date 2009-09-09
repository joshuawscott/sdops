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
    for (i=0; i < a.length; i++){
      var name = 'tr[id="'+a[i].value+'"]';
      if (a[i].value != office && a[i].value !=""){
        $$(name).invoke('hide');
      }
      else {
        $$(name).invoke('show');
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

// Print view
function toggleHeaderStuff(){
  $('header').toggle();
  $('section1').toggle();
}

// Menu functions
function commandDescOn(id, strText){
  $(id).innerHTML = strText;
}

function commandDescOff(id){
  $(id).innerHTML = '&nbsp;';
}

