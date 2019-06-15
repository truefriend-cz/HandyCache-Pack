var objCurrent=null, objClone=null, objToDrop=null,
	removed=[];
var cmInteractiveMode = document.getElementById('cm_only').getAttribute('cm_interactive_mode');
var cmBackgroundColor = cmInteractiveMode=='hide' ? '#b7b7ff' : '#ffb7b7';
var cmOutlineColor = cmInteractiveMode=='hide' ? '#0000ff' : '#ff0000';

function BreakEvent(ev) {
	if (ev.stopPropagation) ev.stopPropagation();
	ev.cancelBubble = true;
	// подавить текст строки статуса в браузере и не переходить по ссылкам
	if (ev.preventDefault) ev.preventDefault();
	ev.returnValue = false;
};

function getDOMPath(elem) {
	var obj=elem, selector='';
	if (cmInteractiveMode == 'remove') {
		var i;
		while (obj) {
			if (obj===document.body) {
				selector = '##' + selector;
				break;
			}
			if (obj.id) {
				selector = '#' + obj.id + '#' + selector;
				break;
			}
			i = 1;
			while (obj.previousSibling) {
				obj = obj.previousSibling;
				if (obj.nodeType==1 && obj.nodeName!='STYLE' && obj.nodeName!='SCRIPT') i = i + 1;
			}
			selector = '-' + i + selector;
			obj = obj.parentNode;
		}
	}
	else {
		var delimiter='', old_obj;
		do {
			old_obj = obj;
			if (obj.id) {
				selector = obj.tagName.replace(/:/, '\\:') + '#' + obj.id + delimiter + selector;
				break;
			}
			else selector = obj.tagName.replace(/:/, '\\:') + delimiter + selector;
			while (obj.previousSibling && obj.previousSibling.nodeType!=1)
				obj = obj.previousSibling;
			if (obj.previousSibling) {
				obj = obj.previousSibling;
				delimiter = '+';
			}
			else {
				obj = obj.parentNode;
				delimiter = '>';
				if (obj && obj.nodeType==1)
					selector = selector.replace(/^([^+>]+)/, '$1:first-of-type');
			};
		} while (old_obj!==document.body);
	};
	return selector;
};

function loadXMLDoc(url, info) {
	var req = null;
	if (window.XMLHttpRequest) {
		try { req = new XMLHttpRequest(); }
		catch(e) {};
	}
	else if (window.ActiveXObject) {
		var activeXObjects = ['Msxml2.XMLHTTP.6.0', 'Msxml2.XMLHTTP.5.0', 'Msxml2.XMLHTTP.4.0', 'Msxml2.XMLHTTP.3.0', 'Msxml2.XMLHTTP', 'Microsoft.XMLHTTP']; 
		for(var i=0; i<activeXObjects.length; i++){ 
			try{ 
				req = new ActiveXObject(activeXObjects[i]); 
			} catch(e) { continue; };
			break;
		}
	};
	if (req) {
		req.open('GET', url, true);
		req.setRequestHeader('cm-info', info);
		req.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT");
		req.send(null);
	}
	else alert('Impossible to accept changes');
};

function cm_checkChanges() {
	if (removed.length>0) {
		document.getElementById('CM_undo_button').style.color = 'inherit';
		document.getElementById('CM_save_button').style.color = 'inherit';
	} else {
		document.getElementById('CM_undo_button').style.color = cmInteractiveMode=='hide' ? '#939393' : '#939393';
		document.getElementById('CM_save_button').style.color = cmInteractiveMode=='hide' ? '#939393' : '#939393';
	}
}

var CM_Undo = function() {
	if (removed.length>0) {
		var obj = removed[removed.length-1];
		obj.style.display = obj.CM_oldDisplay;
		obj.CM_oldDisplay = undefined;
		removed.splice(removed.length-1, 1);
	};
	cm_checkChanges();
};


var cm_ondblclick = function (ev) {
	BreakEvent(ev || window.event);
};

function fixNodes(curNode) {
	curNode.removeable = true;
	curNode.onmouseover = function (ev) {
		if (!this.removeable) return;
		objCurrent = this;
		window.status = this.outerHTML ? this.outerHTML.match(/^<[^>]+>/) : this.tagName;
		this.oldBg = this.style.backgroundColor; this.style.backgroundColor = cmBackgroundColor;
		this.oldOl = this.style.outline; this.style.outline='2px solid ' + cmOutlineColor;
		if (this.style.setProperty) {
			this.oldOpacity = this.style.opacity; this.style.opacity=0.55;
			this.oldBoxShadow = this.style.getPropertyValue('box-shadow') || this.style.getPropertyValue('-moz-box-shadow') || this.style.getPropertyValue('-webkit-box-shadow');
			this.style.setProperty('box-shadow', 'inset 0 0 15px 2px ' + cmOutlineColor, null);
			this.style.setProperty('-moz-box-shadow', 'inset 0 0 15px 2px ' + cmOutlineColor, null);
			this.style.setProperty('-webkit-box-shadow', 'inset 0 0 15px 2px ' + cmOutlineColor, null);
		}
		else if (this.style.getAttribute) {
			this.oldFilter = this.style.filter;
			this.style.filter = "progid:DXImageTransform.Microsoft.BasicImage(opacity=0.3)";
		};
	/*		if (this.className) {
			var elist = document.getElementsByClassName(this.className);
			for (var i=0; i<elist.length; i++) {
				if (elist[i]===this) continue;
				elist[i].oldBg = elist[i].style.backgroundColor; elist[i].style.backgroundColor='#ffb7b7';
				elist[i].oldOl = elist[i].style.outline; elist[i].style.outline='1px dashed #0000FF';
			};
		};
	*/		ev = ev || window.event;
		BreakEvent(ev);
	};
	curNode.onmouseout = function (ev) {
		if (!this.removeable) return;
		objCurrent = null;
		window.status = window.defaultStatus;
		this.style.backgroundColor = this.oldBg;
		try { this.style.outline = this.oldOl; } catch(e) {};
		if (this.style.setProperty) {
			this.style.opacity = this.oldOpacity;
			if (this.oldBoxShadow) {
				this.style.setProperty('box-shadow', this.oldBoxShadow);
				this.style.setProperty('-moz-box-shadow', this.oldBoxShadow);
				this.style.setProperty('-webkit-box-shadow', this.oldBoxShadow);
			}
			else {
				this.style.removeProperty('box-shadow', this.oldBoxShadow);
				this.style.removeProperty('-moz-box-shadow', this.oldBoxShadow);
				this.style.removeProperty('-webkit-box-shadow', this.oldBoxShadow);
			};
		}
		else if (this.style.setAttribute) {
			this.style.filter = this.oldFilter;
		};
	/*		if (this.className) {
			var elist = document.getElementsByClassName(this.className);
			for (var i=0; i<elist.length; i++) {
				if (elist[i]===this) continue;
				elist[i].style.backgroundColor=elist[i].oldBg;
				elist[i].style.outline=elist[i].oldOl;
			};
		};
	*/		ev = ev || window.event;
		BreakEvent(ev);
	};

	curNode.onclick = function(ev) {
		ev = ev || window.event;
		if (ev.ctrlKey) CM_Undo();
		else if (ev.shiftKey) CM_AcceptChanges();	// если нажат SHIFT, то фиксируем изменения
	// else if (ev.altKey)
		// if (this.className) {
			// var elist = document.getElementsByClassName(this.className);
			// for (var i=0; i<elist.length; i++) {
				// if (!elist[i].removeable) continue;
				// elist[i].CM_oldDisplay = elist[i].style.display;
				// elist[i].style.display = 'none';
				// removed.push(elist[i]);
				// elist[i].style.backgroundColor = elist[i].oldBg;
				// elist[i].style.outline = elist[i].oldOl;
			// }
			// objCurrent = objCurrent.parentNode;
		// }
		else {
			if (!this.removeable) return;
			objCurrent.CM_oldDisplay = objCurrent.style.display;
			objCurrent.style.display = 'none';
			removed.push(objCurrent);
			objCurrent = objCurrent.parentNode;
			objCurrent.style.backgroundColor = objCurrent.oldBg;
			try { objCurrent.style.outline = objCurrent.oldOl; } catch(e) {};
			cm_checkChanges();
		};
		BreakEvent(ev);
	};

	curNode.ondblclick = cm_ondblclick;
};

function CM_AcceptChanges () {
	if (removed.length>0) {
		var s = '';
		for (var i=0; i<removed.length; i++) {
			var breakFlag=false, deleteFlag=false, t=getDOMPath(removed[i]);
			for (var j=0; j<removed.length; j++) {
				var u = getDOMPath(removed[j]);
				if (j!=i && t.indexOf(u)==0) {
					if (t==u) {
						if (j<i) breakFlag = true;
						else continue;
					}
					else if ((cmInteractiveMode == 'hide' && t[u.length]=='>') || (cmInteractiveMode == 'remove' && t[u.length]=='-')) {
						deleteFlag=true;
						break;
					};
				};
			};
			if (breakFlag) break;
			if (!deleteFlag) s = t + '#~#' + s;
		};
		s = document.getElementById('cm_only').getAttribute('cm_mindex') + '###' + cmInteractiveMode + '###' + s
		loadXMLDoc(location.protocol+'//'+location.host+'/for_CM', 'AcceptChanges###' + s);
		removed = [];
		cm_checkChanges();
	};
};

function CM_Reload() {
	if (location.href.search(/\?cm_interactive/)!=-1) location.replace(location.href.replace(/\?cm_interactive.*/, ''))
	else location.reload(true);
};

function CM_Toggle() {
	cmInteractiveMode = (cmInteractiveMode=='hide') ? 'remove' : 'hide';
	location.replace(location.href.replace(/^(.*?(?=\?cm_interactive|#|$)).*/, '$1?cm_interactive_' + cmInteractiveMode));
};

function CM_Inject() {
	if (typeof _interfaces !== 'undefined') {
		for (var i = 0; i < _interfaces.length; i++) {
			for (var j=0; j<_methods.length; j++) { 
				if (_interfaces[i].prototype[_methods[j]]) { _interfaces[i].prototype[_methods[j]] = _old_prototypes[i][j]; };
			};
		};
		document.documentElement.insertBefore = old_insertBefore;
	};
	var objList = document.body.getElementsByTagName('*');
	for (var i=0; i<objList.length; i++) {
		var el = objList[i];
			fixNodes(el);
	};

	// document.body.style.marginTop = '58px';	// не удалять, т.к. с одним только CSS не работает на nhl.com (вроде, перекрыли все-таки с помощью !important)
	var elem = document.createElement('div');
	elem.id = "CM_menu_holder";
	elem.setAttribute('unselectable', 'on');
	elem.setAttribute('onselectstart', 'return false;');
	elem.style.backgroundColor = cmBackgroundColor;
	elem.innerHTML =
		'<table id="CM_nav"> \
			<tr> \
				<td class="CM_nav_item">Remove element<br><span>( Click )</span></td> \
				<td class="CM_nav_item CM_nav_button" id="CM_undo_button" onclick="CM_Undo();" onmouseover="this.style.backgroundColor=cmInteractiveMode==\'hide\' ? \'#e7e7ff\' : \'#ffe7e7\';" onmouseout="this.style.backgroundColor=\'inherit\';">Undo<br><span>( Ctrl + Click )</span></td> \
				<td class="CM_nav_item CM_nav_button" id="CM_save_button" onclick="CM_AcceptChanges();" onmouseover="this.style.backgroundColor=cmInteractiveMode==\'hide\' ? \'#e7e7ff\' : \'#ffe7e7\';" onmouseout="this.style.backgroundColor=\'inherit\';">Save<br><span>( Shift + Click )</span></td> \
				<td class="CM_nav_item CM_nav_button" onclick="CM_Reload();" onmouseover="this.style.backgroundColor=cmInteractiveMode==\'hide\' ? \'#e7e7ff\' : \'#ffe7e7\';" onmouseout="this.style.backgroundColor=\'inherit\';">Reload</td> \
				<td class="CM_nav_item CM_nav_button" onclick="CM_Toggle()" onmouseover="this.style.backgroundColor=cmInteractiveMode==\'hide\' ? \'#e7e7ff\' : \'#ffe7e7\';" onmouseout="this.style.backgroundColor=\'inherit\';">Toggle</td> \
				<td class="CM_nav_item" id="CM_mode_text" style="color:' + (cmInteractiveMode=='hide' ? '#4040df' : '#df4040') + ';">Current mode: ' + cmInteractiveMode + '</td> \
			</tr> \
		</table>';
	document.documentElement.insertBefore(elem, document.documentElement.firstChild);
	document.getElementById('CM_nav').style.backgroundColor = cmBackgroundColor;
	cm_checkChanges();
};

var DecemberInjected;
document.addEventListener("DOMContentLoaded", function(event) {
	DecemberInjected = true;
	CM_Inject();
});
window.onload = function() {
	if (!DecemberInjected) {
		CM_Inject();
	}
}