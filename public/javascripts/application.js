// ************************************************
// Functions for Renewals report
// ************************************************
function toggleOffices(sum_col){
  var office = $('filter_offices').value;
  var a = $('filter_offices').options;
  if (office == ""){
    showAll();
  }
  else {
    for (i=0; i < a.length; i++){
      var name = 'tr[name="'+a[i].value+'"]';
      if (a[i].value != office && a[i].value !=""){
        $$(name).invoke('addClassName', 'hidden');
      }
      else {
        $$(name).invoke('removeClassName', 'hidden');
      }
    }
  }
  $('sum_total').innerHTML = sumVisibleRows(sum_col);
}

function showAll(){
  var a = $('filter_offices').options;
  for (i=0; i < a.length; i++){
    var name = 'tr[name="'+a[i].value+'"]';
    $$(name).invoke('removeClassName', 'hidden');
  }
}

function sumVisibleRows(sum_col){
	var rows = $$('#sum_table tbody tr');
	var sum_area = $('expired_total');
	var sum = 0.0;
	rows.each(function(r) {
			if (r.hasClassName('hidden') == false) {
				var price = r.cells[sum_col].innerHTML.replace(/[\$\,]/g, '');
				sum += (price * 1.0); // * 1.0 converts string to a float
			}
	});
	return number_to_currency(sum);
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
// To use this, you will need to put an element with class <css_class>,
// and the id of that element should be db_field_name_<id>
// css_class -> the selector string to iterate through and create click-to-edit fields.  e.g.: '.click_to_edit_class'
// url_prefix -> the beginning part of the post url (everything before the id)
// rails_class -> the underscore formatted name of the rails model to update
// db_field_name -> the name of the database field
function editFieldInPlaceInTable(css_class, url_prefix, rails_class, db_field_name) {
  var items = $$(css_class);
  var len = items.length;
  for(var i=0; i<len; i++){
    var item_id = items[i].id.toString().replace(db_field_name+'_','');
    var post_url = '/'+url_prefix+'/update_field.js';
    new Ajax.InPlaceEditor(items[i], post_url, {
      method: 'post',
      callback: function(form, value) { return '_method=put&id='+encodeURIComponent(item_id)+'&'+rails_class+'['+db_field_name+']='+encodeURIComponent(value)+'&authenticity_token='+encodeURIComponent(authenticity_token)}
    });
  }
}