//v.1.6 build 80603

/*
Copyright DHTMLX LTD. http://www.dhtmlx.com
You allowed to use this component or parts of it under GPL terms
To use it on other terms or get Professional edition of the component please contact us at sales@dhtmlx.com
*/

dhtmlXGridObject.prototype.enableSmartRendering=function(mode,buffer,reserved){if (arguments.length>2){if (buffer && !this.rowsBuffer[buffer-1])this.rowsBuffer[buffer-1]=0;buffer=reserved};this._srnd=convertStringToBoolean(mode);this._srdh=this._srdh||20;this._dpref=buffer||0};dhtmlXGridObject.prototype.setAwaitedRowHeight = function(height) {this._srdh=parseInt(height)};dhtmlXGridObject.prototype._get_view_size=function(){return Math.floor(parseInt(this.entBox.offsetHeight)/this._srdh)+2};dhtmlXGridObject.prototype._add_filler=function(pos,len,fil){if (!len)return null;var id="__filler__";var row=this._prepareRow(id);row.firstChild.style.height=len*this._srdh+"px";fil=fil||this.rowsCol[pos];if (fil && fil.nextSibling)fil.parentNode.insertBefore(row,fil.nextSibling);else
 if (_isKHTML)this.obj.appendChild(row);else
 this.obj.rows[0].parentNode.appendChild(row);return [pos,len,row]};dhtmlXGridObject.prototype._update_srnd_view=function(){var min=Math.floor(this.objBox.scrollTop/this._srdh);var max=min+this._get_view_size();if (max>this.rowsBuffer.length)max=this.rowsBuffer.length;for (var j=min;j<max;j++){if (!this.rowsCol[j]){var res=this._add_from_buffer(j);if (res==-1){this._current_load=[j,(this._dpref?this._dpref:(max-j))];this.load(this.xmlFileUrl+getUrlSymbol(this.xmlFileUrl)+"posStart="+j+"&count="+this._current_load[1], this._data_type);return}}}};dhtmlXGridObject.prototype._add_from_buffer=function(ind){var row=this.render_row(ind);if (row==-1)return -1;if (row._attrs["selected"]){this.selectRow(row,false,true);delete row._attrs["selected"]};if (!this._cssSP){if (this._cssEven && ind%2 == 0 )row.className+=" "+this._cssEven;else if (this._cssUnEven && ind%2 == 1 )row.className+=" "+this._cssUnEven}else if (this._h2){var x=this._h2.get[row.idd];row.className+=" "+((x.level%2)?(this._cssUnEven+" "+this._cssUnEven):(this._cssEven+" "+this._cssEven))+"_"+x.level+(this.rowsAr[x.id]._css||"")};for (var i=0;i<this._fillers.length;i++){var f=this._fillers[i];if (f && f[0]<=ind && (f[0]+f[1])>ind ){var pos=ind-f[0];if (pos==0){this._insert_before(ind,row,f[2]);this._update_fillers(i,-1,1)}else if (pos == f[1]-1){this._insert_after(ind,row,f[2]);this._update_fillers(i,-1,0)}else {this._fillers.push(this._add_filler(ind+1,f[1]-pos-1,f[2]));this._insert_after(ind,row,f[2]);this._update_fillers(i,-f[1]+pos,0)};return}}};dhtmlXGridObject.prototype._update_fillers=function(ind,right,left){var f=this._fillers[ind];f[1]=f[1]+right;f[0]=f[0]+left;if (!f[1]){f[2].parentNode.removeChild(f[2]);this._fillers.splice(ind,1)}else 
 f[2].firstChild.style.height=parseFloat(f[2].firstChild.style.height)+right*this._srdh+"px"};dhtmlXGridObject.prototype._insert_before=function(ind,row,fil){fil.parentNode.insertBefore(row,fil);this.rowsCol[ind]=row};dhtmlXGridObject.prototype._insert_after=function(ind,row,fil){if (fil.nextSibling)fil.parentNode.insertBefore(row,fil.nextSibling);else
 fil.parentNode.appendChild(row);this.rowsCol[ind]=row};
//v.1.6 build 80603

/*
Copyright DHTMLX LTD. http://www.dhtmlx.com
You allowed to use this component or parts of it under GPL terms
To use it on other terms or get Professional edition of the component please contact us at sales@dhtmlx.com
*/