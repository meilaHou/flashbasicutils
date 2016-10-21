﻿package com.ql.gameKit.utils.mouseWheelFixer
{
    import flash.display.*;
    import flash.external.*;
    import flash.geom.*;

    public class MouseWheelFixer extends Object
    {
        public static const VERSION:String = "1.5";
        public static const STATE_NATIVE:int = 0;
        public static const STATE_IF_NEEDED:int = 1;
        public static const STATE_HACKED:int = 2;
        public static const EXECUTE_LIBRARY_FUNCTION:String = "SWFWheel.join";
        public static const GET_STATE_FUNCTION:String = "SWFWheel.getState";
        public static const DEFINE_LIBRARY_FUNCTION:String = <![CDATA[
nfunction() {
n	tif (window.SWFWheel) return;
n	tvar win = window,
n	t	tdoc = document,
n	t	tnav = navigator;
n	tvar SWFWheel = window.SWFWheel = function(id) {
n	t	t	tthis.setUp(id);
n	t	t	tif (SWFWheel.browser.msie) this.bind4msie();
n	t	t	telse this.bind()
n	t	t};
n	tSWFWheel.prototype = {
n	t	tsetUp: function(id) {
n	t	t	tvar el = SWFWheel.retrieveObject(id);
n	t	t	tif (el.nodeName.toLowerCase() == ''embed'' || SWFWheel.browser.safari) el = el.parentNode;
n	t	t	tthis.target = el;
n	t	t	tthis.eventType = SWFWheel.browser.mozilla ? ''DOMMouseScroll'' : ''mousewheel''
n	t	t},
n	t	tbind: function() {
n	t	t	tthis.target.addEventListener(this.eventType, function(evt) {
n	t	t	t	tvar target, name, xDelta, yDelta = 0;
n	t	t	t	tif (/XPCNativeWrapper/.test(evt.toString())) {
n	t	t	t	t	tvar k = evt.target.getAttribute(''id'') || evt.target.getAttribute(''name'');
n	t	t	t	t	tif (!k) return;
n	t	t	t	t	ttarget = SWFWheel.retrieveObject(k)
n	t	t	t	t} else {
n	t	t	t	t	ttarget = evt.target
n	t	t	t	t}
n	t	t	t	tname = target.nodeName.toLowerCase();
n	t	t	t	tif (name != ''object'' && name != ''embed'') return;
n	t	t	t	tif (!target.checkBrowserScroll()) {
n	t	t	t	t	tevt.preventDefault();
n	t	t	t	t	tevt.returnValue = false
n	t	t	t	t}
n	t	t	t	tif (!target.triggerMouseEvent) return;
n	t	t	t	tswitch (true) {
n	t	t	t	tcase SWFWheel.browser.mozilla:
n	t	t	t	t	tyDelta = -evt.detail/1.5;
n	t	t	t	t	t // hscroll supported in FF3.1+
n	t	t	t	t	tif (evt.axis){
n	t	t	t	t	t	tif (evt.axis == evt.HORIZONTAL_AXIS){
n	t	t	t	t	t	t	t// FF can only scroll one dirction at a time
n	t	t	t	t	t	t	txDelta = yDelta;
n	t	t	t	t	t	t	tyDelta = 0;
n	t	t	t	t	t	t}
n	t	t	t	t	t}
n	t	t	t	t	tbreak;
n	t	t	t	tcase SWFWheel.browser.opera:
n	t	t	t	t	t// Opera doesn''t support hscroll; vscroll is also buggy
n	t	t	t	t	tyDelta = -yDelta / 40;
n	t	t	t	t	tbreak;
n	t	t	t	tdefault:
n	t	t	t	t	tif (evt.wheelDeltaX){
n	t	t	t	t	t	t// Webkit can scroll two directions simultaneously
n	t	t	t	t	t	txDelta = evt.wheelDeltaX;
n	t	t	t	t	t	tyDelta = evt.wheelDeltaY;
n	t	t	t	t	t}else{
n	t	t	t	t	t	t// fallback to standard scrolling interface
n	t	t	t	t	t	tyDelta = evt.wheelDelta;
n	t	t	t	t	t}
n	t	t	t	t	t// you''ll have to play with these,
n	t	t	t	t	t// browsers on Windows and OS X handle them differently
n	t	t	t	t	txDelta /= 120;
n	t	t	t	t	tyDelta /= 120;
n	t	t	t	t	tbreak
n	t	t	t	t}
n	t	t	t	tif(SWFWheel.browser.mac){
n	t	t	t	t	txDelta*=9;
n	t	t	t	t	tyDelta*=9;
n	t	t	t	t}
n	t	t	t	ttarget.triggerMouseEvent(xDelta, yDelta, evt.ctrlKey, evt.altKey, evt.shiftKey)
n	t	t	t}, false)
n	t	t},
n	t	tbind4msie: function() {
n	t	t	tvar _wheel, _unload, target = this.target;
n	t	t	t_wheel = function() {
n	t	t	t	tvar evt = win.event,
n	t	t	t	t	tdelta = 0,
n	t	t	t	t	tname = evt.srcElement.nodeName.toLowerCase();
n	t	t	t	tif (name != ''object'' && name != ''embed'') return;
n	t	t	t	tif (!target.checkBrowserScroll()) evt.returnValue = false;
n	t	t	t	tif (!target.triggerMouseEvent) return;
n	t	t	t	tdelta = evt.wheelDelta / 40;
n	t	t	t	ttarget.triggerMouseEvent(delta,delta, evt.ctrlKey, evt.altKey, evt.shiftKey)
n	t	t	t};
n	t	t	t_unload = function() {
n	t	t	t	ttarget.detachEvent(''onmousewheel'', _wheel);
n	t	t	t	twin.detachEvent(''onunload'', _unload)
n	t	t	t};
n	t	t	ttarget.attachEvent(''onmousewheel'', _wheel);
n	t	t	twin.attachEvent(''onunload'', _unload)
n	t	t}
n	t};
n	tSWFWheel.browser = (function() {
n	t	tvar ua = nav.userAgent.toLowerCase(),
n	t	t	tpl = nav.platform.toLowerCase(),
n	t	t	tversion, pv = [0, 0, 0];
n	t	tif (nav.plugins && nav.plugins[''Shockwave Flash'']) {
n	t	t	tversion = nav.plugins[''Shockwave Flash''].description.replace(/^.*\\\s+(\\\S+\\\s+\\\S+$)/, ''$1'');
n	t	t	tpv[0] = parseInt(version.replace(/^(.*)\\\..*$/, ''$1''), 10);
n	t	t	tpv[1] = parseInt(version.replace(/^.*\\\.(.*)\\\s.*$/, ''$1''), 10);
n	t	t	tpv[2] = /[a-z-A-Z]/.test(version) ? parseInt(version.replace(/^.*[a-zA-Z]+(.*)$/, ''$1''), 10) : 0
n	t	t} else if (win.ActiveXObject) {
n	t	t	ttry {
n	t	t	t	tvar axo = new ActiveXObject(''ShockwaveFlash.ShockwaveFlash'');
n	t	t	t	tif (axo) {
n	t	t	t	t	tversion = axo.GetVariable(''$version'');
n	t	t	t	t	tif (version) {
n	t	t	t	t	t	tversion = version.split('' '')[1].split('','');
n	t	t	t	t	t	tpv[0] = parseInt(version[0], 10);
n	t	t	t	t	t	tpv[1] = parseInt(version[1], 10);
n	t	t	t	t	t	tpv[2] = parseInt(version[2], 10)
n	t	t	t	t	t}
n	t	t	t	t}
n	t	t	t} catch (e) {}
n	t	t}
n	t	treturn {
n	t	t	twin: pl ? /win/.test(pl) : /win/.test(ua),
n	t	t	tmac: pl ? /mac/.test(pl) : /mac/.test(ua),
n	t	t	tplayerVersion: pv,
n	t	t	tversion: (ua.match(/.+(?:rv|it|ra|ie)[\/:\\\s]([\\\d.]+)/) || [0, ''0''])[1],
n	t	t	tchrome: /chrome/.test(ua),
n	t	t	tstainless: /stainless/.test(ua),
n	t	t	tsafari: /webkit/.test(ua) && !/(chrome|stainless)/.test(ua),
n	t	t	topera: /opera/.test(ua),
n	t	t	tmsie: /msie/.test(ua) && !/opera/.test(ua),
n	t	t	tmozilla: /mozilla/.test(ua) && !/(compatible|webkit)/.test(ua)
n	t	t}
n	t})();
n	tSWFWheel.join = function(id) {
n	t	tvar t = setInterval(function() {
n	t	t	tif (SWFWheel.retrieveObject(id)) {
n	t	t	t	tclearInterval(t);
n	t	t	t	tnew SWFWheel(id)
n	t	t	t}
n	t	t}, 0)
n	t};
n	tSWFWheel.getState = function(id) {
n	t	tvar STATE_HACKED = 2,
n	t	t	tSTATE_IF_NEEDED = 1,
n	t	t	tSTATE_NATIVE = 0,
n	t	t	tbr = SWFWheel.browser,
n	t	t	tfp = br.playerVersion;
n	t	tif (br.mac) {
n	t	t	tif (fp[0] >= 10 && fp[1] >= 1) {
n	t	t	t	tif (br.safari || br.stainless) return STATE_NATIVE;
n	t	t	t	telse if (br.chrome) return STATE_IF_NEEDED;
n	t	t	t	telse return STATE_HACKED
n	t	t	t} else {
n	t	t	t	treturn STATE_HACKED
n	t	t	t}
n	t	t}
n	t	tif (!(fp[0] >= 10 && fp[1] >= 1) && SWFWheel.browser.safari) return STATE_HACKED;
n	t	tvar el = SWFWheel.retrieveObject(id),
n	t	t	tname = el.nodeName.toLowerCase(),
n	t	t	twmode = '''';
n	t	tif (name == ''object'') {
n	t	t	tvar k, param, params = el.getElementsByTagName(''param''),
n	t	t	t	tlen = params.length;
n	t	t	tfor (var i = 0; i < len; i++) {
n	t	t	t	tparam = params[i];
n	t	t	t	tif (param.parentNode != el) continue;
n	t	t	t	tk = param.getAttribute(''name'');
n	t	t	t	twmode = param.getAttribute(''value'') || '''';
n	t	t	t	tif (/wmode/i.test(k)) break
n	t	t	t}
n	t	t} else if (name == ''embed'') {
n	t	t	tvar wmode = el.getAttribute(''wmode'') || ''''
n	t	t}
n	t	tif (br.msie) {
n	t	t	tif (/transparent/i.test(wmode)) return STATE_HACKED;
n	t	t	telse if (/opaque/i.test(wmode)) return STATE_IF_NEEDED;
n	t	t	telse return STATE_NATIVE
n	t	t} else {
n	t	t	tif (/opaque|transparent/i.test(wmode)) return STATE_HACKED;
n	t	t	telse return STATE_NATIVE
n	t	t}
n	t};
n	tSWFWheel.retrieveObject = function(id) {
n	t	tvar el = doc.getElementById(id);
n	t	tif (!el) {
n	t	t	tvar nodes = doc.getElementsByTagName(''embed''),
n	t	t	t	tlen = nodes.length;
n	t	t	tfor (var i = 0; i < len; i++) {
n	t	t	t	tif (nodes[i].getAttribute(''name'') == id) {
n	t	t	t	t	tel = nodes[i];
n	t	t	t	t	tbreak
n	t	t	t	t}
n	t	t	t}
n	t	t}
n	t	treturn el
n	t}
n}]]>")("<![CDATA[
function() {
	if (window.SWFWheel) return;
	var win = window,
		doc = document,
		nav = navigator;
	var SWFWheel = window.SWFWheel = function(id) {
			this.setUp(id);
			if (SWFWheel.browser.msie) this.bind4msie();
			else this.bind()
		};
	SWFWheel.prototype = {
		setUp: function(id) {
			var el = SWFWheel.retrieveObject(id);
			if (el.nodeName.toLowerCase() == 'embed' || SWFWheel.browser.safari) el = el.parentNode;
			this.target = el;
			this.eventType = SWFWheel.browser.mozilla ? 'DOMMouseScroll' : 'mousewheel'
		},
		bind: function() {
			this.target.addEventListener(this.eventType, function(evt) {
				var target, name, xDelta, yDelta = 0;
				if (/XPCNativeWrapper/.test(evt.toString())) {
					var k = evt.target.getAttribute('id') || evt.target.getAttribute('name');
					if (!k) return;
					target = SWFWheel.retrieveObject(k)
				} else {
					target = evt.target
				}
				name = target.nodeName.toLowerCase();
				if (name != 'object' && name != 'embed') return;
				if (!target.checkBrowserScroll()) {
					evt.preventDefault();
					evt.returnValue = false
				}
				if (!target.triggerMouseEvent) return;
				switch (true) {
				case SWFWheel.browser.mozilla:
					yDelta = -evt.detail/1.5;
					 // hscroll supported in FF3.1+
					if (evt.axis){
						if (evt.axis == evt.HORIZONTAL_AXIS){
							// FF can only scroll one dirction at a time
							xDelta = yDelta;
							yDelta = 0;
						}
					}
					break;
				case SWFWheel.browser.opera:
					// Opera doesn't support hscroll; vscroll is also buggy
					yDelta = -yDelta / 40;
					break;
				default:
					if (evt.wheelDeltaX){
						// Webkit can scroll two directions simultaneously
						xDelta = evt.wheelDeltaX;
						yDelta = evt.wheelDeltaY;
					}else{
						// fallback to standard scrolling interface
						yDelta = evt.wheelDelta;
					}
					// you'll have to play with these,
					// browsers on Windows and OS X handle them differently
					xDelta /= 120;
					yDelta /= 120;
					break
				}
				if(SWFWheel.browser.mac){
					xDelta*=9;
					yDelta*=9;
				}
				target.triggerMouseEvent(xDelta, yDelta, evt.ctrlKey, evt.altKey, evt.shiftKey)
			}, false)
		},
		bind4msie: function() {
			var _wheel, _unload, target = this.target;
			_wheel = function() {
				var evt = win.event,
					delta = 0,
					name = evt.srcElement.nodeName.toLowerCase();
				if (name != 'object' && name != 'embed') return;
				if (!target.checkBrowserScroll()) evt.returnValue = false;
				if (!target.triggerMouseEvent) return;
				delta = evt.wheelDelta / 40;
				target.triggerMouseEvent(delta,delta, evt.ctrlKey, evt.altKey, evt.shiftKey)
			};
			_unload = function() {
				target.detachEvent('onmousewheel', _wheel);
				win.detachEvent('onunload', _unload)
			};
			target.attachEvent('onmousewheel', _wheel);
			win.attachEvent('onunload', _unload)
		}
	};
	SWFWheel.browser = (function() {
		var ua = nav.userAgent.toLowerCase(),
			pl = nav.platform.toLowerCase(),
			version, pv = [0, 0, 0];
		if (nav.plugins && nav.plugins['Shockwave Flash']) {
			version = nav.plugins['Shockwave Flash'].description.replace(/^.*\\s+(\\S+\\s+\\S+$)/, '$1');
			pv[0] = parseInt(version.replace(/^(.*)\\..*$/, '$1'), 10);
			pv[1] = parseInt(version.replace(/^.*\\.(.*)\\s.*$/, '$1'), 10);
			pv[2] = /[a-z-A-Z]/.test(version) ? parseInt(version.replace(/^.*[a-zA-Z]+(.*)$/, '$1'), 10) : 0
		} else if (win.ActiveXObject) {
			try {
				var axo = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
				if (axo) {
					version = axo.GetVariable('$version');
					if (version) {
						version = version.split(' ')[1].split(',');
						pv[0] = parseInt(version[0], 10);
						pv[1] = parseInt(version[1], 10);
						pv[2] = parseInt(version[2], 10)
					}
				}
			} catch (e) {}
		}
		return {
			win: pl ? /win/.test(pl) : /win/.test(ua),
			mac: pl ? /mac/.test(pl) : /mac/.test(ua),
			playerVersion: pv,
			version: (ua.match(/.+(?:rv|it|ra|ie)[\/:\\s]([\\d.]+)/) || [0, '0'])[1],
			chrome: /chrome/.test(ua),
			stainless: /stainless/.test(ua),
			safari: /webkit/.test(ua) && !/(chrome|stainless)/.test(ua),
			opera: /opera/.test(ua),
			msie: /msie/.test(ua) && !/opera/.test(ua),
			mozilla: /mozilla/.test(ua) && !/(compatible|webkit)/.test(ua)
		}
	})();
	SWFWheel.join = function(id) {
		var t = setInterval(function() {
			if (SWFWheel.retrieveObject(id)) {
				clearInterval(t);
				new SWFWheel(id)
			}
		}, 0)
	};
	SWFWheel.getState = function(id) {
		var STATE_HACKED = 2,
			STATE_IF_NEEDED = 1,
			STATE_NATIVE = 0,
			br = SWFWheel.browser,
			fp = br.playerVersion;
		if (br.mac) {
			if (fp[0] >= 10 && fp[1] >= 1) {
				if (br.safari || br.stainless) return STATE_NATIVE;
				else if (br.chrome) return STATE_IF_NEEDED;
				else return STATE_HACKED
			} else {
				return STATE_HACKED
			}
		}
		if (!(fp[0] >= 10 && fp[1] >= 1) && SWFWheel.browser.safari) return STATE_HACKED;
		var el = SWFWheel.retrieveObject(id),
			name = el.nodeName.toLowerCase(),
			wmode = '';
		if (name == 'object') {
			var k, param, params = el.getElementsByTagName('param'),
				len = params.length;
			for (var i = 0; i < len; i++) {
				param = params[i];
				if (param.parentNode != el) continue;
				k = param.getAttribute('name');
				wmode = param.getAttribute('value') || '';
				if (/wmode/i.test(k)) break
			}
		} else if (name == 'embed') {
			var wmode = el.getAttribute('wmode') || ''
		}
		if (br.msie) {
			if (/transparent/i.test(wmode)) return STATE_HACKED;
			else if (/opaque/i.test(wmode)) return STATE_IF_NEEDED;
			else return STATE_NATIVE
		} else {
			if (/opaque|transparent/i.test(wmode)) return STATE_HACKED;
			else return STATE_NATIVE
		}
	};
	SWFWheel.retrieveObject = function(id) {
		var el = doc.getElementById(id);
		if (!el) {
			var nodes = doc.getElementsByTagName('embed'),
				len = nodes.length;
			for (var i = 0; i < len; i++) {
				if (nodes[i].getAttribute('name') == id) {
					el = nodes[i];
					break
				}
			}
		}
		return el
	}
}]]>.toString();
        private static var _stage:Stage;
        private static var _state:int = 0;
        private static var _browserScroll:Boolean = true;

        public function MouseWheelFixer()
        {
            return;
        }// end function

        public static function get use_native() : Boolean
        {
            if (_state == 0)
            {
                return true;
            }
            return false;
        }// end function

        public static function initialize(stage:Stage) : void
        {
            if (!available || isReady)
            {
                MouseWheelFixer.trace("ERROR: external interface not ready");
                return;
            }
            _stage = stage;
            ExternalInterface.call(DEFINE_LIBRARY_FUNCTION);
            if (!ExternalInterface.objectID)
            {
                MouseWheelFixer.trace("ERROR: no object id found. be sure swf object has id AND name attribute");
            }
            ExternalInterface.call("SWFWheel.join", ExternalInterface.objectID);
            ExternalInterface.addCallback("checkBrowserScroll", checkBrowserScroll);
            if (stage.loaderInfo.loaderURL.substr(0, 5) == "file:")
            {
                _state = 0;
            }
            else
            {
                _state = ExternalInterface.call("SWFWheel.getState", ExternalInterface.objectID);
            }
            if (_state == 0)
            {
                return;
            }
            ExternalInterface.addCallback("triggerMouseEvent", triggerMouseEvent);
            return;
        }// end function

        public static function get isReady() : Boolean
        {
            return _stage != null;
        }// end function

        public static function get available() : Boolean
        {
            var _loc_1:Boolean = false;
            if (!ExternalInterface.available)
            {
                return _loc_1;
            }
            try
            {
                _loc_1 = ExternalInterface.call("function(){return true;}");
            }
            catch (e:Error)
            {
                MouseWheelFixer.trace(e.getStackTrace());
                MouseWheelFixer.trace("Warning: turn off SWFWheel because can\'t access external interface.");
            }
            return _loc_1;
        }// end function

        public static function get state() : int
        {
            return _state;
        }// end function

        public static function get browserScroll() : Boolean
        {
            return _browserScroll;
        }// end function

        public static function set browserScroll(value:Boolean) : void
        {
            _browserScroll = value;
            return;
        }// end function

        private static function triggerMouseEvent(deltaX:Number, deltaY:Number, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false) : void
        {
            var _loc_7:String = null;
            if (_state == 0)
            {
                return;
            }
            if (_state == 1 && _browserScroll)
            {
                return;
            }
            var _loc_9:* = _stage.getObjectsUnderPoint(new Point(_stage.mouseX, _stage.mouseY));
            var _loc_8:* = _stage.getObjectsUnderPoint(new Point(_stage.mouseX, _stage.mouseY)).pop() as DisplayObject;
            while (_loc_8 != null)
            {
                
                _loc_7 = _loc_8 as InteractiveObject;
                if (!_loc_7)
                {
                    _loc_8 = _loc_8.parent;
                }
            }
            if (!_loc_7)
            {
                return;
            }
            var _loc_6:* = new MouseWheelEvent("mouseWheel2", true, false, _loc_7.mouseX, _loc_7.mouseY, null, ctrlKey, altKey, shiftKey, false, deltaX, deltaY);
            _loc_7.dispatchEvent(_loc_6);
            return;
        }// end function

        private static function checkBrowserScroll() : Boolean
        {
            return _browserScroll;
        }// end function

    }
}