function clear_background(element) {
  element.style.backgroundColor = '#FFFFFF';
}
document.observe("dom:loaded", function() {
  var lines = $$('.subcontract_cost');
  var len = lines.length;
  for(i=0; i<len; i=i+1){
    var line_item_id = lines[i].id.toString().replace('id','');
    var line_item_url = '/line_items/' + line_item_id + '.js';
    new Ajax.InPlaceEditor(lines[i], line_item_url, {
      method: 'post',
      callback: function(form,value) { return '_method=put&line_item[id]='+encodeURIComponent(line_item_id)+'&line_item[subcontract_cost]='+encodeURIComponent(value)+'&authenticity_token='+encodeURIComponent(authenticity_token)}
    });
  }
  });
