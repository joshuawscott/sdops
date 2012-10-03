// ************************************************
// Functions for Renewals report
// ************************************************
function toggleOfficesRenewal(sum_col, expected_col) {
  toggleOffices(sum_col);
  // insert sums for each section
  sumVisibleRows('sum_expired', 'renewals_expired', sum_col, 1);
  sumVisibleRows('sum_0_30', 'renewals_0_30', sum_col, 1);
  sumVisibleRows('sum_31_60', 'renewals_31_60', sum_col, 1);
  sumVisibleRows('sum_61_90', 'renewals_61_90', sum_col, 1);
  sumVisibleRows('sum_91_120', 'renewals_91_120', sum_col, 1);
  sumVisibleRows('expected_expired', 'renewals_expired', expected_col, 1);
  sumVisibleRows('expected_0_30', 'renewals_0_30', expected_col, 1);
  sumVisibleRows('expected_31_60', 'renewals_31_60', expected_col, 1);
  sumVisibleRows('expected_61_90', 'renewals_61_90', expected_col, 1);
  sumVisibleRows('expected_91_120', 'renewals_91_120', expected_col);

  // insert counts for each section
  countVisibleRows('count_expired', 'renewals_expired');
  countVisibleRows('count_0_30', 'renewals_0_30');
  countVisibleRows('count_31_60', 'renewals_31_60');
  countVisibleRows('count_61_90', 'renewals_61_90');
  countVisibleRows('count_91_120', 'renewals_91_120');
  //Total the sum column
  var sum_all = $('sum_all');
  var expected_all = $('expected_all');
  var total = 0.0;
  var expected_total = 0.0;
  //ugh... floats.
  total += ($('sum_expired').innerHTML.replace(/[^0-9\.]+/g, "") * 100).round();
  total += ($('sum_0_30').innerHTML.replace(/[^0-9\.]+/g, "") * 100).round();
  total += ($('sum_31_60').innerHTML.replace(/[^0-9\.]+/g, "") * 100).round();
  total += ($('sum_61_90').innerHTML.replace(/[^0-9\.]+/g, "") * 100).round();
  total += ($('sum_91_120').innerHTML.replace(/[^0-9\.]+/g, "") * 100).round();
  sum_all.innerHTML = number_to_currency(total/100);
  expected_total += ($('expected_expired').innerHTML.replace(/[^0-9\.]+/g, "") * 100).round();
  expected_total += ($('expected_0_30').innerHTML.replace(/[^0-9\.]+/g, "") * 100).round();
  expected_total += ($('expected_31_60').innerHTML.replace(/[^0-9\.]+/g, "") * 100).round();
  expected_total += ($('expected_61_90').innerHTML.replace(/[^0-9\.]+/g, "") * 100).round();
  expected_total += ($('expected_91_120').innerHTML.replace(/[^0-9\.]+/g, "") * 100).round();
  expected_all.innerHTML = number_to_currency(expected_total/100);
  // Total the count column
  var count_all = $('count_all');
  count_all.innerHTML = $('count_expired').innerHTML*1 + $('count_0_30').innerHTML*1 + $('count_31_60').innerHTML*1 + $('count_61_90').innerHTML*1 + $('count_91_120').innerHTML*1;
  //expected_all.innerHTML = $('expected_expired').innerHTML*1 + $('expected_0_30').innerHTML*1 + $('expected_31_60').innerHTML*1 + $('expected_61_90').innerHTML*1 + $('expected_91_120').innerHTML*1;
}

function toggleOfficesGeneric(sum_col, options) {
  toggleOffices(sum_col);
  var display_as_currency = 0
  if(options == undefined || options['display_as_currency'] == undefined) {
    display_as_currency = 1;
  }
  sumVisibleRows('sum_total', 'sum_table', sum_col, display_as_currency);
}

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
}

function showAll(){
  var a = $('filter_offices').options;
  for (i=0; i < a.length; i++){
    var name = 'tr[name="'+a[i].value+'"]';
    $$(name).invoke('removeClassName', 'hidden');
  }
}

function countVisibleRows(total_container_id, count_table_id) {
  var rows = $$('#'+count_table_id+' tbody tr');
  var count = 0;
    rows.each(function(r) {
      if(r.hasClassName('hidden') == false) {
        count += 1;
      }
    })
  $(total_container_id).innerHTML = count;
}

function sumVisibleRows(total_container_id, sum_table_id, sum_col, display_as_currency){
	var rows = $$('#'+sum_table_id+' tbody tr');
	var sum_area = $('expired_total');
	var sum = 0.0;
	rows.each(function(r) {
			if (r.hasClassName('hidden') == false) {
				var price = r.cells[sum_col].innerHTML.replace(/[\$\,]/g, '');
				sum += (price * 1.0); // * 1.0 converts string to a float
			}
	});
        if(display_as_currency == 0) {
          $(total_container_id).innerHTML = sum;
        } else {
          $(total_container_id).innerHTML = number_to_currency(sum);
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

// Basic functions

function number_to_currency(Amount) {
	return '$' + Amount.formatMoney(2,".",",");
}

// Number.formatMoney([floatPoint: Integer = 2], [decimalSep: String = ","], [thousandsSep: String = "."]): String
//    Returns the number into the monetary format.
//    floatPoint amount of decimal places
//    decimalSep string that will be used as decimal separator
//    thousandsSep string that will be used as thousands separator
Number.prototype.formatMoney = function(c, d, t){
    var n = this, c = isNaN(c = Math.abs(c)) ? 2 : c, d = d == undefined ? "," : d, t = t == undefined ? "." : t, s = n < 0 ? "-" : "",
    i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};

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

document.observe("dom:loaded", function() {
  var tooltip_elements = $$('.tooltip_target');
  var tooltips = $$('.tooltip_content');
  var len = tooltip_elements.length;
  //var len = tooltip_elements.length;
    for(var i=0; i<len; i++){
      //alert(tooltip_elements[i].id);
      new Tooltip(tooltip_elements[i], tooltips[i], {hook: {target:'rightMid', tip:'leftMid'} } );
    }


})