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
      var name = 'tr[name="'+a[i].value+'"]';
      if (a[i].value != office && a[i].value !=""){
        $$(name).invoke('hide');
      }
      else {
        $$(name).invoke('show');
      }
    }
  }
  sumVisibleRows();
}

function showAll(){
  var a = $('filter_offices').options;
  for (i=0; i < a.length; i++){
    var name = 'tr[name="'+a[i].value+'"]';
    $$(name).invoke('show');
  }
  sumVisibleRows();
}

function sumVisibleRows(){
	var rows = $$('#expired_table tbody tr');
	var sum = 0.0;
	rows.each(function(r) {
			if (r.getAttribute("style") != 'display: none;') {
				var price = r.cells[7].innerHTML.replace(/[\$\,]/g, '');
				sum += (price * 1.0);
				//console.log(r.getAttribute("name"));
			}
	});
	console.log(sum);
	$('expired_total').innerHTML = number_to_currency(sum);
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

// Basic functions

function number_to_currency(Amount) {
	var AmountWithCommas = Amount.toLocaleString();
	var arParts = String(AmountWithCommas).split('.');
	var intPart = arParts[0];
	var decPart = (arParts.length > 1 ? arParts[1] : '');
	decPart = (decPart + '00').substr(0,2);

	return '$' + intPart + '.' + decPart;

}