function clear_background(element) {
  element.style.backgroundColor = '#FFFFFF';
}
document.observe("dom:loaded", function() {
  var lines = $$('.subcontract_cost');
  var len = lines.length;
  for(var i=0; i<len; i++){
    var line_item_id = lines[i].id.toString().replace('id','');
    var line_item_url = '/line_items/update_field.js';
    new Ajax.InPlaceEditor(lines[i], line_item_url, {
      method: 'post',
      callback: function(form,value) { return '_method=put&line_item[subcontract_cost]='+encodeURIComponent(value)+'&authenticity_token='+encodeURIComponent(authenticity_token)}
    });
  }
  });
