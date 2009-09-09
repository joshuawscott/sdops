function toggleRows(cellNr, _id){
  var table = $('orders_table');
  var ele;
  var cb = $(_id)
  if (cb.checked == true) {
    for (var r = 1; r < table.rows.length; r++){
      ele = table.rows[r].cells[cellNr].innerHTML.replace(/<[^>]+>/g,"");
        if (ele == 'true')
          table.rows[r].style.display = '';
    }
  } else {
    suche = 'false';
    for (var r = 1; r < table.rows.length; r++){
      ele = table.rows[r].cells[cellNr].innerHTML.replace(/<[^>]+>/g,"");
      if (ele == 'false')
        table.rows[r].style.display = '';
      else table.rows[r].style.display = 'none';
    }
  }
}

function unhideAllRows(){
  var table = $('orders_table');
  for (var r = 1; r < table.rows.length; r++){
    table.rows[r].style.display = '';
  }
}

window.onload = function() {
  $('completed_ckbox').removeAttribute('disabled');
  toggleRows(5, 'completed_ckbox');
}
