from datetime import datetime as python_lib_datetime_Datetime
import math as python_lib_Math
import math as Math
import os as python_lib_Os
import re as python_lib_Re
from threading import Thread as duell_helpers_Thread
import threading as duell_helpers_Threading
import importlib as python_ImportLib
import builtins as python_lib_Builtins
import functools as python_lib_Functools
import inspect as python_lib_Inspect
import json as python_lib_Json
import random as python_lib_Random
import shutil as python_lib_Shutil
import subprocess as python_lib_Subprocess
import sys as python_lib_Sys
import time as python_lib_Time
import traceback as python_lib_Traceback
from io import BufferedReader as python_lib_io_BufferedReader
from io import BufferedWriter as python_lib_io_BufferedWriter
from io import StringIO as python_lib_io_StringIO
from io import TextIOWrapper as python_lib_io_TextIOWrapper
from socket import socket as python_lib_net_Socket
from os import path as python_lib_os_Path
from subprocess import Popen as python_lib_subprocess_Popen
import urllib.parse as python_lib_urllib_Parse
from sys import path as python_sys_Path
from urllib import request as python_urllib_Request


def _hx_resources__():
	import inspect
	import sys
	if not hasattr(sys.modules[__name__], '__file__'):
		_file = 'duell.py'
	else:
		_file = __file__
	return {"generalArguments": open('%s.%s'%(_file,'generalArguments'),'rb').read()}


class _hx_AnonObject:
	def __init__(self, fields):
		self.__dict__ = fields


_hx_classes = {}


class Enum:
	_hx_class_name = "Enum"
	_hx_fields = ["tag", "index", "params"]
	_hx_methods = ["__str__"]

	def __init__(self,tag,index,params):
		self.tag = None
		self.index = None
		self.params = None
		self.tag = tag
		self.index = index
		self.params = params

	def __str__(self):
		if (self.params is None):
			return self.tag
		else:
			return (((HxOverrides.stringOrNull(self.tag) + "(") + HxOverrides.stringOrNull(",".join([python_Boot.toString1(x1,'') for x1 in self.params]))) + ")")

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.tag = None
		_hx_o.index = None
		_hx_o.params = None
Enum._hx_class = Enum
_hx_classes["Enum"] = Enum


class Class:
	_hx_class_name = "Class"
Class._hx_class = Class
_hx_classes["Class"] = Class


class Date:
	_hx_class_name = "Date"
	_hx_fields = ["date"]
	_hx_methods = ["toString"]
	_hx_statics = ["EPOCH_LOCAL", "now", "fromTime", "datetimeTimestamp", "fromString"]

	def __init__(self,year,month,day,hour,_hx_min,sec):
		self.date = None
		if (year < python_lib_datetime_Datetime.min.year):
			year = python_lib_datetime_Datetime.min.year
		if (day == 0):
			day = 1
		self.date = python_lib_datetime_Datetime(year, (month + 1), day, hour, _hx_min, sec, 0)

	def toString(self):
		m = ((self.date.month - 1) + 1)
		d = self.date.day
		h = self.date.hour
		mi = self.date.minute
		s = self.date.second
		return ((((((((((Std.string(self.date.year) + "-") + HxOverrides.stringOrNull(((("0" + Std.string(m)) if ((m < 10)) else ("" + Std.string(m)))))) + "-") + HxOverrides.stringOrNull(((("0" + Std.string(d)) if ((d < 10)) else ("" + Std.string(d)))))) + " ") + HxOverrides.stringOrNull(((("0" + Std.string(h)) if ((h < 10)) else ("" + Std.string(h)))))) + ":") + HxOverrides.stringOrNull(((("0" + Std.string(mi)) if ((mi < 10)) else ("" + Std.string(mi)))))) + ":") + HxOverrides.stringOrNull(((("0" + Std.string(s)) if ((s < 10)) else ("" + Std.string(s))))))

	@staticmethod
	def now():
		d = Date(1970, 0, 1, 0, 0, 0)
		d.date = python_lib_datetime_Datetime.now()
		return d

	@staticmethod
	def fromTime(t):
		d = Date(1970, 0, 1, 0, 0, 0)
		d.date = python_lib_datetime_Datetime.fromtimestamp((t / 1000.0))
		return d

	@staticmethod
	def datetimeTimestamp(dt,epoch):
		return ((dt - epoch).total_seconds() * 1000)

	@staticmethod
	def fromString(s):
		_g = len(s)
		if (_g == 8):
			k = s.split(":")
			d = Date(0, 0, 0, Std.parseInt((k[0] if 0 < len(k) else None)), Std.parseInt((k[1] if 1 < len(k) else None)), Std.parseInt((k[2] if 2 < len(k) else None)))
			return d
		elif (_g == 10):
			k1 = s.split("-")
			return Date(Std.parseInt((k1[0] if 0 < len(k1) else None)), (Std.parseInt((k1[1] if 1 < len(k1) else None)) - 1), Std.parseInt((k1[2] if 2 < len(k1) else None)), 0, 0, 0)
		elif (_g == 19):
			k2 = s.split(" ")
			y = None
			_this = (k2[0] if 0 < len(k2) else None)
			y = _this.split("-")
			t = None
			_this1 = (k2[1] if 1 < len(k2) else None)
			t = _this1.split(":")
			return Date(Std.parseInt((y[0] if 0 < len(y) else None)), (Std.parseInt((y[1] if 1 < len(y) else None)) - 1), Std.parseInt((y[2] if 2 < len(y) else None)), Std.parseInt((t[0] if 0 < len(t) else None)), Std.parseInt((t[1] if 1 < len(t) else None)), Std.parseInt((t[2] if 2 < len(t) else None)))
		else:
			raise _HxException(("Invalid date format : " + ("null" if s is None else s)))

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.date = None
Date._hx_class = Date
_hx_classes["Date"] = Date


class EReg:
	_hx_class_name = "EReg"
	_hx_fields = ["pattern", "matchObj", "global"]
	_hx_methods = ["replace"]

	def __init__(self,r,opt):
		self.pattern = None
		self.matchObj = None
		self._hx_global = None
		self._hx_global = False
		options = 0
		_g1 = 0
		_g = len(opt)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			c = None
			if (i >= len(opt)):
				c = -1
			else:
				c = ord(opt[i])
			if (c == 109):
				options = (options | python_lib_Re.M)
			if (c == 105):
				options = (options | python_lib_Re.I)
			if (c == 115):
				options = (options | python_lib_Re.S)
			if (c == 117):
				options = (options | python_lib_Re.U)
			if (c == 103):
				self._hx_global = True
		self.pattern = python_lib_Re.compile(r,options)

	def replace(self,s,by):
		by1 = None
		_this = by.split("$$")
		by1 = "_hx_#repl#__".join([python_Boot.toString1(x1,'') for x1 in _this])
		def _hx_local_0(x):
			res = by1
			g = x.groups()
			_g1 = 0
			_g = len(g)
			while (_g1 < _g):
				i = _g1
				_g1 = (_g1 + 1)
				_this1 = None
				delimiter = ("$" + HxOverrides.stringOrNull(str((i + 1))))
				if (delimiter == ""):
					_this1 = list(res)
				else:
					_this1 = res.split(delimiter)
				res = g[i].join([python_Boot.toString1(x1,'') for x1 in _this1])
			_this2 = res.split("_hx_#repl#__")
			res = "$".join([python_Boot.toString1(x1,'') for x1 in _this2])
			return res
		replace = _hx_local_0
		return python_lib_Re.sub(self.pattern,replace,s,(0 if (self._hx_global) else 1))

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.pattern = None
		_hx_o.matchObj = None
		_hx_o._hx_global = None
EReg._hx_class = EReg
_hx_classes["EReg"] = EReg


class EnumValue:
	_hx_class_name = "EnumValue"
EnumValue._hx_class = EnumValue
_hx_classes["EnumValue"] = EnumValue


class List:
	_hx_class_name = "List"
	_hx_fields = ["h", "q", "length"]
	_hx_methods = ["add", "push", "first", "pop", "isEmpty", "iterator"]

	def __init__(self):
		self.h = None
		self.q = None
		self.length = None
		self.length = 0

	def add(self,item):
		x = [item]
		if (self.h is None):
			self.h = x
		else:
			python_internal_ArrayImpl._set(self.q, 1, x)
		self.q = x
		_hx_local_0 = self
		_hx_local_1 = _hx_local_0.length
		_hx_local_0.length = (_hx_local_1 + 1)
		_hx_local_1

	def push(self,item):
		x = [item, self.h]
		self.h = x
		if (self.q is None):
			self.q = x
		_hx_local_0 = self
		_hx_local_1 = _hx_local_0.length
		_hx_local_0.length = (_hx_local_1 + 1)
		_hx_local_1

	def first(self):
		if (self.h is None):
			return None
		else:
			return (self.h[0] if 0 < len(self.h) else None)

	def pop(self):
		if (self.h is None):
			return None
		x = (self.h[0] if 0 < len(self.h) else None)
		self.h = (self.h[1] if 1 < len(self.h) else None)
		if (self.h is None):
			self.q = None
		_hx_local_0 = self
		_hx_local_1 = _hx_local_0.length
		_hx_local_0.length = (_hx_local_1 - 1)
		_hx_local_1
		return x

	def isEmpty(self):
		return (self.h is None)

	def iterator(self):
		return _List_ListIterator(self.h)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.h = None
		_hx_o.q = None
		_hx_o.length = None
List._hx_class = List
_hx_classes["List"] = List


class _List_ListIterator:
	_hx_class_name = "_List.ListIterator"
	_hx_fields = ["head", "val"]
	_hx_methods = ["hasNext", "next"]

	def __init__(self,head):
		self.head = None
		self.val = None
		self.head = head
		self.val = None

	def hasNext(self):
		return (self.head is not None)

	def next(self):
		self.val = (self.head[0] if 0 < len(self.head) else None)
		self.head = (self.head[1] if 1 < len(self.head) else None)
		return self.val

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.head = None
		_hx_o.val = None
_List_ListIterator._hx_class = _List_ListIterator
_hx_classes["_List.ListIterator"] = _List_ListIterator


class Reflect:
	_hx_class_name = "Reflect"
	_hx_statics = ["field", "setField", "callMethod", "isFunction"]

	@staticmethod
	def field(o,field):
		return python_Boot.field(o,field)

	@staticmethod
	def setField(o,field,value):
		setattr(o,(("_hx_" + field) if (field in python_Boot.keywords) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field)),value)

	@staticmethod
	def callMethod(o,func,args):
		if callable(func):
			return func(*args)
		else:
			return None

	@staticmethod
	def isFunction(f):
		return ((python_lib_Inspect.isfunction(f) or python_lib_Inspect.ismethod(f)) or hasattr(f,"func_code"))
Reflect._hx_class = Reflect
_hx_classes["Reflect"] = Reflect


class Std:
	_hx_class_name = "Std"
	_hx_statics = ["is", "string", "parseInt", "shortenPossibleNumber", "parseFloat"]

	@staticmethod
	def _hx_is(v,t):
		if ((v is None) and ((t is None))):
			return False
		if (t is None):
			return False
		if (t == Dynamic):
			return True
		isBool = isinstance(v,bool)
		if ((t == Bool) and isBool):
			return True
		if ((((not isBool) and (not (t == Bool))) and (t == Int)) and isinstance(v,int)):
			return True
		vIsFloat = isinstance(v,float)
		def _hx_local_0():
			f = v
			return (((f != Math.POSITIVE_INFINITY) and ((f != Math.NEGATIVE_INFINITY))) and (not python_lib_Math.isnan(f)))
		def _hx_local_1():
			x = v
			def _hx_local_4():
				def _hx_local_3():
					_hx_local_2 = None
					try:
						_hx_local_2 = int(x)
					except Exception as _hx_e:
						_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
						e = _hx_e1
						_hx_local_2 = None
					return _hx_local_2
				return _hx_local_3()
			return _hx_local_4()
		if (((((((not isBool) and vIsFloat) and (t == Int)) and _hx_local_0()) and ((v == _hx_local_1()))) and ((v <= 2147483647))) and ((v >= -2147483648))):
			return True
		if (((not isBool) and (t == Float)) and isinstance(v,(float, int))):
			return True
		if (t == str):
			return isinstance(v,str)
		isEnumType = (t == Enum)
		if ((isEnumType and python_lib_Inspect.isclass(v)) and hasattr(v,"_hx_constructs")):
			return True
		if isEnumType:
			return False
		isClassType = (t == Class)
		if ((((isClassType and (not isinstance(v,Enum))) and python_lib_Inspect.isclass(v)) and hasattr(v,"_hx_class_name")) and (not hasattr(v,"_hx_constructs"))):
			return True
		if isClassType:
			return False
		def _hx_local_6():
			_hx_local_5 = None
			try:
				_hx_local_5 = isinstance(v,t)
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				e1 = _hx_e1
				_hx_local_5 = False
			return _hx_local_5
		if _hx_local_6():
			return True
		if python_lib_Inspect.isclass(t):
			loop = None
			loop1 = None
			def _hx_local_8(intf):
				f1 = None
				if hasattr(intf,"_hx_interfaces"):
					f1 = intf._hx_interfaces
				else:
					f1 = []
				if (f1 is not None):
					_g = 0
					while (_g < len(f1)):
						i = (f1[_g] if _g >= 0 and _g < len(f1) else None)
						_g = (_g + 1)
						if HxOverrides.eq(i,t):
							return True
						else:
							l = loop1(i)
							if l:
								return True
					return False
				else:
					return False
			loop1 = _hx_local_8
			loop = loop1
			currentClass = v.__class__
			while (currentClass is not None):
				if loop(currentClass):
					return True
				currentClass = python_Boot.getSuperClass(currentClass)
			return False
		else:
			return False

	@staticmethod
	def string(s):
		return python_Boot.toString1(s,"")

	@staticmethod
	def parseInt(x):
		if (x is None):
			return None
		try:
			return int(x)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			e = _hx_e1
			try:
				prefix = None
				_this = HxString.substr(x,0,2)
				prefix = _this.lower()
				if (prefix == "0x"):
					return int(x,16)
				raise _HxException("fail")
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				e1 = _hx_e1
				r = None
				x1 = Std.parseFloat(x)
				try:
					r = int(x1)
				except Exception as _hx_e:
					_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
					e2 = _hx_e1
					r = None
				if (r is None):
					r1 = Std.shortenPossibleNumber(x)
					if (r1 != x):
						return Std.parseInt(r1)
					else:
						return None
				return r

	@staticmethod
	def shortenPossibleNumber(x):
		r = ""
		_g1 = 0
		_g = len(x)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			c = None
			if ((i < 0) or ((i >= len(x)))):
				c = ""
			else:
				c = x[i]
			_g2 = HxString.charCodeAt(c,0)
			if (_g2 is not None):
				if (((((((((((_g2 == 46) or ((_g2 == 57))) or ((_g2 == 56))) or ((_g2 == 55))) or ((_g2 == 54))) or ((_g2 == 53))) or ((_g2 == 52))) or ((_g2 == 51))) or ((_g2 == 50))) or ((_g2 == 49))) or ((_g2 == 48))):
					r = (("null" if r is None else r) + ("null" if c is None else c))
				else:
					break
			else:
				break
		return r

	@staticmethod
	def parseFloat(x):
		try:
			return float(x)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			e = _hx_e1
			if (x is not None):
				r1 = Std.shortenPossibleNumber(x)
				if (r1 != x):
					return Std.parseFloat(r1)
			return Math.NaN
Std._hx_class = Std
_hx_classes["Std"] = Std


class Float:
	_hx_class_name = "Float"
Float._hx_class = Float
_hx_classes["Float"] = Float


class Int:
	_hx_class_name = "Int"
Int._hx_class = Int
_hx_classes["Int"] = Int


class Bool:
	_hx_class_name = "Bool"
Bool._hx_class = Bool
_hx_classes["Bool"] = Bool


class Dynamic:
	_hx_class_name = "Dynamic"
Dynamic._hx_class = Dynamic
_hx_classes["Dynamic"] = Dynamic


class StringBuf:
	_hx_class_name = "StringBuf"
	_hx_fields = ["b"]

	def __init__(self):
		self.b = None
		self.b = python_lib_io_StringIO()

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.b = None
		_hx_o.length = None
StringBuf._hx_class = StringBuf
_hx_classes["StringBuf"] = StringBuf


class StringTools:
	_hx_class_name = "StringTools"
	_hx_statics = ["htmlUnescape", "startsWith", "isSpace", "ltrim", "rtrim", "trim", "lpad", "replace", "hex"]

	@staticmethod
	def htmlUnescape(s):
		_this = None
		_this1 = None
		_this2 = None
		_this3 = None
		_this4 = None
		_this5 = None
		_this6 = None
		_this7 = None
		_this8 = s.split("&gt;")
		_this7 = ">".join([python_Boot.toString1(x1,'') for x1 in _this8])
		_this6 = _this7.split("&lt;")
		_this5 = "<".join([python_Boot.toString1(x1,'') for x1 in _this6])
		_this4 = _this5.split("&quot;")
		_this3 = "\"".join([python_Boot.toString1(x1,'') for x1 in _this4])
		_this2 = _this3.split("&#039;")
		_this1 = "'".join([python_Boot.toString1(x1,'') for x1 in _this2])
		_this = _this1.split("&amp;")
		return "&".join([python_Boot.toString1(x1,'') for x1 in _this])

	@staticmethod
	def startsWith(s,start):
		return ((len(s) >= len(start)) and ((HxString.substr(s,0,len(start)) == start)))

	@staticmethod
	def isSpace(s,pos):
		if (((len(s) == 0) or ((pos < 0))) or ((pos >= len(s)))):
			return False
		c = HxString.charCodeAt(s,pos)
		return (((c > 8) and ((c < 14))) or ((c == 32)))

	@staticmethod
	def ltrim(s):
		l = len(s)
		r = 0
		while ((r < l) and StringTools.isSpace(s,r)):
			r = (r + 1)
		if (r > 0):
			return HxString.substr(s,r,(l - r))
		else:
			return s

	@staticmethod
	def rtrim(s):
		l = len(s)
		r = 0
		while ((r < l) and StringTools.isSpace(s,((l - r) - 1))):
			r = (r + 1)
		if (r > 0):
			return HxString.substr(s,0,(l - r))
		else:
			return s

	@staticmethod
	def trim(s):
		return StringTools.ltrim(StringTools.rtrim(s))

	@staticmethod
	def lpad(s,c,l):
		if (len(c) <= 0):
			return s
		while (len(s) < l):
			s = (("null" if c is None else c) + ("null" if s is None else s))
		return s

	@staticmethod
	def replace(s,sub,by):
		_this = None
		if (sub == ""):
			_this = list(s)
		else:
			_this = s.split(sub)
		return by.join([python_Boot.toString1(x1,'') for x1 in _this])

	@staticmethod
	def hex(n,digits = None):
		s = ""
		hexChars = "0123456789ABCDEF"
		while True:
			def _hx_local_0():
				index = (n & 15)
				return ("" if (((index < 0) or ((index >= len(hexChars))))) else hexChars[index])
			s = (HxOverrides.stringOrNull(_hx_local_0()) + ("null" if s is None else s))
			n = HxOverrides.rshift(n, 4)
			if (not ((n > 0))):
				break
		if ((digits is not None) and ((len(s) < digits))):
			diff = (digits - len(s))
			_g = 0
			while (_g < diff):
				_ = _g
				_g = (_g + 1)
				s = ("0" + ("null" if s is None else s))
		return s
StringTools._hx_class = StringTools
_hx_classes["StringTools"] = StringTools


class haxe_IMap:
	_hx_class_name = "haxe.IMap"
	_hx_methods = ["get"]
haxe_IMap._hx_class = haxe_IMap
_hx_classes["haxe.IMap"] = haxe_IMap


class haxe_ds_StringMap:
	_hx_class_name = "haxe.ds.StringMap"
	_hx_fields = ["h"]
	_hx_methods = ["get", "remove", "keys", "iterator"]
	_hx_interfaces = [haxe_IMap]

	def __init__(self):
		self.h = None
		self.h = dict()

	def get(self,key):
		return self.h.get(key,None)

	def remove(self,key):
		has = key in self.h
		if has:
			del self.h[key]
		return has

	def keys(self):
		this1 = None
		_this = self.h.keys()
		this1 = iter(_this)
		return python_HaxeIterator(this1)

	def iterator(self):
		this1 = None
		_this = self.h.values()
		this1 = iter(_this)
		return python_HaxeIterator(this1)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.h = None
haxe_ds_StringMap._hx_class = haxe_ds_StringMap
_hx_classes["haxe.ds.StringMap"] = haxe_ds_StringMap


class python_HaxeIterator:
	_hx_class_name = "python.HaxeIterator"
	_hx_fields = ["it", "x", "has", "checked"]
	_hx_methods = ["next", "hasNext"]

	def __init__(self,it):
		self.it = None
		self.x = None
		self.has = None
		self.checked = None
		self.checked = False
		self.has = False
		self.x = None
		self.it = it

	def next(self):
		if (not self.checked):
			self.hasNext()
		self.checked = False
		return self.x

	def hasNext(self):
		if (not self.checked):
			try:
				self.x = self.it.__next__()
				self.has = True
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				if isinstance(_hx_e1, StopIteration):
					s = _hx_e1
					self.has = False
					self.x = None
				else:
					raise _hx_e
			self.checked = True
		return self.has

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.it = None
		_hx_o.x = None
		_hx_o.has = None
		_hx_o.checked = None
python_HaxeIterator._hx_class = python_HaxeIterator
_hx_classes["python.HaxeIterator"] = python_HaxeIterator


class Sys:
	_hx_class_name = "Sys"
	_hx_statics = ["environ", "time", "exit", "print", "println", "args", "getEnv", "putEnv", "environment", "sleep", "getCwd", "setCwd", "systemName", "command", "stdin", "stderr"]

	@staticmethod
	def time():
		return python_lib_Time.time()

	@staticmethod
	def exit(code):
		python_lib_Sys.exit(code)

	@staticmethod
	def print(v):
		python_Lib.print(v)

	@staticmethod
	def println(v):
		python_Lib.println(v)

	@staticmethod
	def args():
		argv = python_lib_Sys.argv
		return argv[1:None]

	@staticmethod
	def getEnv(s):
		return Sys.environ.h.get(s,None)

	@staticmethod
	def putEnv(s,v):
		python_lib_Os.putenv(s,v)
		Sys.environ.h[s] = v

	@staticmethod
	def environment():
		return Sys.environ

	@staticmethod
	def sleep(seconds):
		python_lib_Time.sleep(seconds)

	@staticmethod
	def getCwd():
		return python_lib_Os.getcwd()

	@staticmethod
	def setCwd(s):
		python_lib_Os.chdir(s)

	@staticmethod
	def systemName():
		_g = python_lib_Sys.platform
		x = _g
		if StringTools.startsWith(x,"linux"):
			return "Linux"
		else:
			_hx_local_0 = len(_g)
			if (_hx_local_0 == 5):
				if (_g == "win32"):
					return "Windows"
				else:
					raise _HxException("not supported platform")
			elif (_hx_local_0 == 6):
				if (_g == "darwin"):
					return "Mac"
				elif (_g == "cygwin"):
					return "Windows"
				else:
					raise _HxException("not supported platform")
			else:
				raise _HxException("not supported platform")

	@staticmethod
	def command(cmd,args = None):
		args1 = None
		if (args is None):
			args1 = [cmd]
		else:
			args1 = ([cmd] + args)
		return python_lib_Subprocess.call(args1)

	@staticmethod
	def stdin():
		return python_io_IoTools.createFileInputFromText(python_lib_Sys.stdin)

	@staticmethod
	def stderr():
		return python_io_IoTools.createFileOutputFromText(python_lib_Sys.stderr)
Sys._hx_class = Sys
_hx_classes["Sys"] = Sys

class ValueType(Enum):
	_hx_class_name = "ValueType"
	_hx_constructs = ["TNull", "TInt", "TFloat", "TBool", "TObject", "TFunction", "TClass", "TEnum", "TUnknown"]

	@staticmethod
	def TClass(c):
		return ValueType("TClass", 6, [c])

	@staticmethod
	def TEnum(e):
		return ValueType("TEnum", 7, [e])
ValueType.TNull = ValueType("TNull", 0, list())
ValueType.TInt = ValueType("TInt", 1, list())
ValueType.TFloat = ValueType("TFloat", 2, list())
ValueType.TBool = ValueType("TBool", 3, list())
ValueType.TObject = ValueType("TObject", 4, list())
ValueType.TFunction = ValueType("TFunction", 5, list())
ValueType.TUnknown = ValueType("TUnknown", 8, list())
ValueType._hx_class = ValueType
_hx_classes["ValueType"] = ValueType


class Type:
	_hx_class_name = "Type"
	_hx_statics = ["getClass", "getEnum", "getSuperClass", "getClassName", "getEnumName", "resolveClass", "resolveEnum", "createInstance", "createEmptyInstance", "createEnum", "getEnumConstructs", "typeof"]

	@staticmethod
	def getClass(o):
		if (o is None):
			return None
		if ((o is not None) and (((o == str) or python_lib_Inspect.isclass(o)))):
			return None
		if isinstance(o,_hx_AnonObject):
			return None
		if hasattr(o,"_hx_class"):
			return o._hx_class
		if hasattr(o,"__class__"):
			return o.__class__
		else:
			return None

	@staticmethod
	def getEnum(o):
		if (o is None):
			return None
		return o.__class__

	@staticmethod
	def getSuperClass(c):
		return python_Boot.getSuperClass(c)

	@staticmethod
	def getClassName(c):
		if hasattr(c,"_hx_class_name"):
			return c._hx_class_name
		else:
			if (c == list):
				return "Array"
			if (c == Math):
				return "Math"
			if (c == str):
				return "String"
			try:
				s = c.__name__
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				pass
		res = None
		return res

	@staticmethod
	def getEnumName(e):
		return e._hx_class_name

	@staticmethod
	def resolveClass(name):
		if (name == "Array"):
			return list
		if (name == "Math"):
			return Math
		if (name == "String"):
			return str
		cl = _hx_classes.get(name,None)
		if ((cl is None) or (not (((cl is not None) and (((cl == str) or python_lib_Inspect.isclass(cl))))))):
			return None
		return cl

	@staticmethod
	def resolveEnum(name):
		if (name == "Bool"):
			return Bool
		o = Type.resolveClass(name)
		if hasattr(o,"_hx_constructs"):
			return o
		else:
			return None

	@staticmethod
	def createInstance(cl,args):
		l = len(args)
		if (l == 0):
			return cl()
		elif (l == 1):
			return cl((args[0] if 0 < len(args) else None))
		elif (l == 2):
			return cl((args[0] if 0 < len(args) else None), (args[1] if 1 < len(args) else None))
		elif (l == 3):
			return cl((args[0] if 0 < len(args) else None), (args[1] if 1 < len(args) else None), (args[2] if 2 < len(args) else None))
		elif (l == 4):
			return cl((args[0] if 0 < len(args) else None), (args[1] if 1 < len(args) else None), (args[2] if 2 < len(args) else None), (args[3] if 3 < len(args) else None))
		elif (l == 5):
			return cl((args[0] if 0 < len(args) else None), (args[1] if 1 < len(args) else None), (args[2] if 2 < len(args) else None), (args[3] if 3 < len(args) else None), (args[4] if 4 < len(args) else None))
		elif (l == 6):
			return cl((args[0] if 0 < len(args) else None), (args[1] if 1 < len(args) else None), (args[2] if 2 < len(args) else None), (args[3] if 3 < len(args) else None), (args[4] if 4 < len(args) else None), (args[5] if 5 < len(args) else None))
		elif (l == 7):
			return cl((args[0] if 0 < len(args) else None), (args[1] if 1 < len(args) else None), (args[2] if 2 < len(args) else None), (args[3] if 3 < len(args) else None), (args[4] if 4 < len(args) else None), (args[5] if 5 < len(args) else None), (args[6] if 6 < len(args) else None))
		elif (l == 8):
			return cl((args[0] if 0 < len(args) else None), (args[1] if 1 < len(args) else None), (args[2] if 2 < len(args) else None), (args[3] if 3 < len(args) else None), (args[4] if 4 < len(args) else None), (args[5] if 5 < len(args) else None), (args[6] if 6 < len(args) else None), (args[7] if 7 < len(args) else None))
		else:
			raise _HxException("Too many arguments")

	@staticmethod
	def createEmptyInstance(cl):
		i = cl.__new__(cl)
		callInit = None
		callInit1 = None
		def _hx_local_0(cl1):
			sc = Type.getSuperClass(cl1)
			if (sc is not None):
				callInit1(sc)
			if hasattr(cl1,"_hx_empty_init"):
				cl1._hx_empty_init(i)
		callInit1 = _hx_local_0
		callInit = callInit1
		callInit(cl)
		return i

	@staticmethod
	def createEnum(e,constr,params = None):
		f = Reflect.field(e,constr)
		if (f is None):
			raise _HxException(("No such constructor " + ("null" if constr is None else constr)))
		if Reflect.isFunction(f):
			if (params is None):
				raise _HxException((("Constructor " + ("null" if constr is None else constr)) + " need parameters"))
			return Reflect.callMethod(e,f,params)
		if ((params is not None) and ((len(params) != 0))):
			raise _HxException((("Constructor " + ("null" if constr is None else constr)) + " does not need parameters"))
		return f

	@staticmethod
	def getEnumConstructs(e):
		if hasattr(e,"_hx_constructs"):
			x = e._hx_constructs
			return list(x)
		else:
			return []

	@staticmethod
	def typeof(v):
		if (v is None):
			return ValueType.TNull
		elif isinstance(v,bool):
			return ValueType.TBool
		elif isinstance(v,int):
			return ValueType.TInt
		elif isinstance(v,float):
			return ValueType.TFloat
		elif isinstance(v,str):
			return ValueType.TClass(str)
		elif isinstance(v,list):
			return ValueType.TClass(list)
		elif (isinstance(v,_hx_AnonObject) or python_lib_Inspect.isclass(v)):
			return ValueType.TObject
		elif isinstance(v,Enum):
			return ValueType.TEnum(v.__class__)
		elif (isinstance(v,type) or hasattr(v,"_hx_class")):
			return ValueType.TClass(v.__class__)
		elif callable(v):
			return ValueType.TFunction
		else:
			return ValueType.TUnknown
Type._hx_class = Type
_hx_classes["Type"] = Type


class Xml:
	_hx_class_name = "Xml"
	_hx_fields = ["nodeType", "nodeName", "nodeValue", "parent", "children", "attributeMap"]
	_hx_methods = ["get", "set", "exists", "elements", "elementsNamed", "firstElement", "addChild", "removeChild"]
	_hx_statics = ["Element", "PCData", "CData", "Comment", "DocType", "ProcessingInstruction", "Document", "parse", "createElement", "createPCData", "createCData", "createComment", "createDocType", "createProcessingInstruction", "createDocument"]

	def __init__(self,nodeType):
		self.nodeType = None
		self.nodeName = None
		self.nodeValue = None
		self.parent = None
		self.children = None
		self.attributeMap = None
		self.nodeType = nodeType
		self.children = []
		self.attributeMap = haxe_ds_StringMap()

	def get(self,att):
		if (self.nodeType != Xml.Element):
			raise _HxException(("Bad node type, expected Element but found " + Std.string(self.nodeType)))
		return self.attributeMap.h.get(att,None)

	def set(self,att,value):
		if (self.nodeType != Xml.Element):
			raise _HxException(("Bad node type, expected Element but found " + Std.string(self.nodeType)))
		self.attributeMap.h[att] = value

	def exists(self,att):
		if (self.nodeType != Xml.Element):
			raise _HxException(("Bad node type, expected Element but found " + Std.string(self.nodeType)))
		return att in self.attributeMap.h

	def elements(self):
		if ((self.nodeType != Xml.Document) and ((self.nodeType != Xml.Element))):
			raise _HxException(("Bad node type, expected Element or Document but found " + Std.string(self.nodeType)))
		ret = None
		_g = []
		_g1 = 0
		_g2 = self.children
		while (_g1 < len(_g2)):
			child = (_g2[_g1] if _g1 >= 0 and _g1 < len(_g2) else None)
			_g1 = (_g1 + 1)
			if (child.nodeType == Xml.Element):
				_g.append(child)
		ret = _g
		return python_HaxeIterator(ret.__iter__())

	def elementsNamed(self,name):
		if ((self.nodeType != Xml.Document) and ((self.nodeType != Xml.Element))):
			raise _HxException(("Bad node type, expected Element or Document but found " + Std.string(self.nodeType)))
		ret = None
		_g = []
		_g1 = 0
		_g2 = self.children
		while (_g1 < len(_g2)):
			child = (_g2[_g1] if _g1 >= 0 and _g1 < len(_g2) else None)
			_g1 = (_g1 + 1)
			def _hx_local_1():
				if (child.nodeType != Xml.Element):
					raise _HxException(("Bad node type, expected Element but found " + Std.string(child.nodeType)))
				return child.nodeName
			if ((child.nodeType == Xml.Element) and ((_hx_local_1() == name))):
				_g.append(child)
		ret = _g
		return python_HaxeIterator(ret.__iter__())

	def firstElement(self):
		if ((self.nodeType != Xml.Document) and ((self.nodeType != Xml.Element))):
			raise _HxException(("Bad node type, expected Element or Document but found " + Std.string(self.nodeType)))
		_g = 0
		_g1 = self.children
		while (_g < len(_g1)):
			child = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
			_g = (_g + 1)
			if (child.nodeType == Xml.Element):
				return child
		return None

	def addChild(self,x):
		if ((self.nodeType != Xml.Document) and ((self.nodeType != Xml.Element))):
			raise _HxException(("Bad node type, expected Element or Document but found " + Std.string(self.nodeType)))
		if (x.parent is not None):
			x.parent.removeChild(x)
		_this = self.children
		_this.append(x)
		x.parent = self

	def removeChild(self,x):
		if ((self.nodeType != Xml.Document) and ((self.nodeType != Xml.Element))):
			raise _HxException(("Bad node type, expected Element or Document but found " + Std.string(self.nodeType)))
		if python_internal_ArrayImpl.remove(self.children,x):
			x.parent = None
			return True
		return False

	@staticmethod
	def parse(_hx_str):
		return haxe_xml_Parser.parse(_hx_str)

	@staticmethod
	def createElement(name):
		xml = Xml(Xml.Element)
		if (xml.nodeType != Xml.Element):
			raise _HxException(("Bad node type, expected Element but found " + Std.string(xml.nodeType)))
		xml.nodeName = name
		return xml

	@staticmethod
	def createPCData(data):
		xml = Xml(Xml.PCData)
		if ((xml.nodeType == Xml.Document) or ((xml.nodeType == Xml.Element))):
			raise _HxException(("Bad node type, unexpected " + Std.string(xml.nodeType)))
		xml.nodeValue = data
		return xml

	@staticmethod
	def createCData(data):
		xml = Xml(Xml.CData)
		if ((xml.nodeType == Xml.Document) or ((xml.nodeType == Xml.Element))):
			raise _HxException(("Bad node type, unexpected " + Std.string(xml.nodeType)))
		xml.nodeValue = data
		return xml

	@staticmethod
	def createComment(data):
		xml = Xml(Xml.Comment)
		if ((xml.nodeType == Xml.Document) or ((xml.nodeType == Xml.Element))):
			raise _HxException(("Bad node type, unexpected " + Std.string(xml.nodeType)))
		xml.nodeValue = data
		return xml

	@staticmethod
	def createDocType(data):
		xml = Xml(Xml.DocType)
		if ((xml.nodeType == Xml.Document) or ((xml.nodeType == Xml.Element))):
			raise _HxException(("Bad node type, unexpected " + Std.string(xml.nodeType)))
		xml.nodeValue = data
		return xml

	@staticmethod
	def createProcessingInstruction(data):
		xml = Xml(Xml.ProcessingInstruction)
		if ((xml.nodeType == Xml.Document) or ((xml.nodeType == Xml.Element))):
			raise _HxException(("Bad node type, unexpected " + Std.string(xml.nodeType)))
		xml.nodeValue = data
		return xml

	@staticmethod
	def createDocument():
		return Xml(Xml.Document)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.nodeType = None
		_hx_o.nodeName = None
		_hx_o.nodeValue = None
		_hx_o.parent = None
		_hx_o.children = None
		_hx_o.attributeMap = None
Xml._hx_class = Xml
_hx_classes["Xml"] = Xml


class duell_Duell:
	_hx_class_name = "duell.Duell"
	_hx_methods = ["run"]
	_hx_statics = ["VERSION", "main", "printBanner", "setLocalJavaDistributionHome"]

	def __init__(self):
		pass

	def run(self):
		try:
			if (not duell_objects_Arguments.validateArguments()):
				return
			isMissingSelfSetup = False
			if (not sys_FileSystem.exists(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())):
				isMissingSelfSetup = True
			else:
				duellConfig = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
				if (python_internal_ArrayImpl.indexOf(duellConfig.setupsCompleted,"self",None) == -1):
					isMissingSelfSetup = True
			if (isMissingSelfSetup and ((duell_objects_Arguments.getSelectedCommand().name != "self_setup"))):
				raise _HxException("You are missing the initial setup. Please run the \"self_setup\" command. For more info run with \"-help\".")
			if (duell_objects_Arguments.getSelectedCommand().name != "self_setup"):
				duell_Duell.setLocalJavaDistributionHome()
			if (duell_objects_Arguments.getSelectedCommand().name != "run"):
				duell_Duell.printBanner()
			if isMissingSelfSetup:
				duell_commands_ToolSetupCommand().execute()
			else:
				currentTime = None
				_this = Date.now()
				currentTime = Date.datetimeTimestamp(_this.date,Date.EPOCH_LOCAL)
				duell_objects_Arguments.getSelectedCommand().commandHandler.execute()
				if (duell_objects_Arguments.getSelectedCommand().name != "run"):
					def _hx_local_0():
						_this1 = Date.now()
						return Date.datetimeTimestamp(_this1.date,Date.EPOCH_LOCAL)
					duell_helpers_LogHelper.println(((" Time passed " + Std.string((((_hx_local_0() - currentTime)) / 1000))) + HxOverrides.stringOrNull((((" sec for command \"" + HxOverrides.stringOrNull(duell_objects_Arguments.getSelectedCommand().name)) + "\"")))))
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			error = _hx_e1
			def _hx_local_1():
				_this2 = haxe_CallStack.exceptionStack()
				return "\n".join([python_Boot.toString1(x1,'') for x1 in _this2])
			duell_helpers_LogHelper.info(_hx_local_1())
			duell_helpers_LogHelper.exitWithFormattedError(Std.string(error))
		return

	@staticmethod
	def main():
		duell_Duell().run()

	@staticmethod
	def printBanner():
		duell_helpers_LogHelper.println("\x1B[33;1m                         ")
		duell_helpers_LogHelper.println("    ____   __  __ ______ __     __ ")
		duell_helpers_LogHelper.println("   / __ \\ / / / // ____// /    / / ")
		duell_helpers_LogHelper.println("  / / / // / / // __/  / /    / /  ")
		duell_helpers_LogHelper.println(" / /_/ // /_/ // /___ / /___ / /___")
		duell_helpers_LogHelper.println("/_____/ \\____//_____//_____//_____/")
		duell_helpers_LogHelper.println("                                   \x1B[0m")
		duell_helpers_LogHelper.println("")
		duell_helpers_LogHelper.println("\x1B[1mDuell tool \x1B[0m\x1B[3;37mDuell command line tool\x1B[0m\x1B[0m")

	@staticmethod
	def setLocalJavaDistributionHome():
		duellLibPath = duell_objects_DuellLib.getDuellLib("duell").getPath()
		javaHome = None
		_g = duell_helpers_PlatformHelper.get_hostPlatform()
		if ((_g.index) == 7):
			javaHome = haxe_io_Path.join([duellLibPath, "bin", "mac", "jdk1.7.0_71"])
		elif ((_g.index) == 9):
			javaHome = haxe_io_Path.join([duellLibPath, "bin", "win", "jdk1.7.0_79"])
		else:
			javaHome = None
		if (javaHome is not None):
			Sys.putEnv("JAVA_HOME",javaHome)

	@staticmethod
	def _hx_empty_init(_hx_o):		pass
duell_Duell._hx_class = duell_Duell
_hx_classes["duell.Duell"] = duell_Duell


class duell_commands_IGDCommand:
	_hx_class_name = "duell.commands.IGDCommand"
	_hx_methods = ["execute"]
duell_commands_IGDCommand._hx_class = duell_commands_IGDCommand
_hx_classes["duell.commands.IGDCommand"] = duell_commands_IGDCommand


class duell_commands_BuildCommand:
	_hx_class_name = "duell.commands.BuildCommand"
	_hx_fields = ["libList", "buildLib", "buildGitVers", "platformName", "duellConfig", "currentXMLPath"]
	_hx_methods = ["execute", "checkIfItIsAProjectFolder", "determinePlatformToBuildFromArguments", "checkUpdateTime", "suggestUpdate", "determineAndValidateDependenciesAndDefines", "buildNewExecutableWithBuildLibAndDependencies", "runFast", "parseDuellLibWithName", "parseXML", "handleDuellLibParsed", "resolvePath"]
	_hx_statics = ["HOURS_TO_REQUEST_UPDATE", "validateSchemaIfNamespaceSet"]
	_hx_interfaces = [duell_commands_IGDCommand]

	def __init__(self):
		self.libList = None
		self.buildLib = None
		self.buildGitVers = None
		self.platformName = None
		self.duellConfig = None
		self.currentXMLPath = None
		self.currentXMLPath = []
		self.buildGitVers = None
		self.buildLib = None
		self.libList = []

	def execute(self):
		duell_helpers_LogHelper.info("\n")
		duell_helpers_LogHelper.info("\x1B[2m------")
		duell_helpers_LogHelper.info("Build")
		duell_helpers_LogHelper.info("------\x1B[0m")
		duell_helpers_LogHelper.info("\n")
		if duell_objects_Arguments.isSet("-fast"):
			self.runFast()
		else:
			duell_helpers_LogHelper.println("")
			self.checkIfItIsAProjectFolder()
			duell_helpers_LogHelper.println("")
			self.checkUpdateTime()
			duell_helpers_LogHelper.println("")
			self.determinePlatformToBuildFromArguments()
			duell_helpers_LogHelper.println("")
			self.determineAndValidateDependenciesAndDefines()
			duell_helpers_LogHelper.println("")
			if duell_helpers_ConnectionHelper.isOnline():
				duell_commands_BuildCommand.validateSchemaIfNamespaceSet()
				duell_helpers_LogHelper.println("")
			self.buildNewExecutableWithBuildLibAndDependencies()
		duell_helpers_LogHelper.println("")
		duell_helpers_LogHelper.info("\x1B[2m------")
		duell_helpers_LogHelper.info("end")
		duell_helpers_LogHelper.info("------\x1B[0m")
		return "success"

	def checkIfItIsAProjectFolder(self):
		if (not sys_FileSystem.exists(duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME)):
			raise _HxException(("Running from a folder without a project file " + HxOverrides.stringOrNull(duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME)))

	def determinePlatformToBuildFromArguments(self):
		self.platformName = duell_objects_Arguments.getSelectedPlugin()
		platformNameCorrectnessCheck = EReg("^[a-z0-9]+$", "")
		def _hx_local_0():
			platformNameCorrectnessCheck.matchObj = python_lib_Re.search(platformNameCorrectnessCheck.pattern,self.platformName)
			return (platformNameCorrectnessCheck.matchObj is not None)
		if (not _hx_local_0()):
			raise _HxException((("Unknown platform " + HxOverrides.stringOrNull(self.platformName)) + ", should be composed of only letters or numbers, no spaces of other characters. Example: \"duell build ios\" or \"duell build android\""))
		self.buildLib = duell_objects_DuellLib.getDuellLib(("duellbuild" + HxOverrides.stringOrNull(self.platformName)))
		if (not duell_helpers_DuellLibHelper.isInstalled(self.buildLib.name)):
			answer = duell_helpers_AskHelper.askYesOrNo((("A library for building " + HxOverrides.stringOrNull(self.platformName)) + " is not currently installed. Would you like to try to install it?"))
			stopBuild = True
			if answer:
				duell_helpers_DuellLibHelper.install(self.buildLib.name)
				update = duell_helpers_AskHelper.askYesOrNo("Do you want to run update to set the plugin to the correct version for your project? It is unsafe not to run an update at this stage.")
				if update:
					duell_helpers_CommandHelper.runHaxelib(Sys.getCwd(),["run", "duell_duell", "update"],_hx_AnonObject({}))
					stopBuild = False
			else:
				duell_helpers_LogHelper.println((("Rerun with the library \"duellbuild" + HxOverrides.stringOrNull(self.platformName)) + "\" installed"))
			if stopBuild:
				Sys.exit(0)

	def checkUpdateTime(self):
		self.duellConfig = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		if (self.duellConfig.lastProjectFile != haxe_io_Path.join([Sys.getCwd(), duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME])):
			self.suggestUpdate()
			return
		currentDate = Date.now()
		previousDate = Date.fromString(self.duellConfig.lastProjectTime)
		previousHours = (((Date.datetimeTimestamp(previousDate.date,Date.EPOCH_LOCAL) / 1000.0) / 60.0) / 60.0)
		currentHours = (((Date.datetimeTimestamp(currentDate.date,Date.EPOCH_LOCAL) / 1000.0) / 60.0) / 60.0)
		if ((previousHours + 8) < currentHours):
			self.suggestUpdate()

	def suggestUpdate(self):
		answer = duell_helpers_AskHelper.askYesOrNo("You have not run an update for this project recently. Would like to do so?")
		if answer:
			updateArguments = None
			_this = duell_objects_Arguments.getRawArguments()
			def _hx_local_0(argument):
				return duell_objects_Arguments.isGeneralArgument(argument)
			updateArguments = list(filter(_hx_local_0,_this))
			selectedPlugin = duell_objects_Arguments.getSelectedPlugin()
			updateArguments.append("-target")
			updateArguments.append(selectedPlugin)
			duell_helpers_CommandHelper.runHaxelib(Sys.getCwd(),(["run", "duell_duell", "update"] + updateArguments),_hx_AnonObject({}))
			def _hx_local_1():
				a = duell_objects_Arguments.getRawArguments()
				return (["run", "duell_duell"] + a)
			duell_helpers_CommandHelper.runHaxelib(Sys.getCwd(),_hx_local_1(),_hx_AnonObject({}))
			Sys.exit(0)
		else:
			self.duellConfig.lastProjectFile = haxe_io_Path.join([Sys.getCwd(), duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME])
			self.duellConfig.lastProjectTime = Date.now().toString()
			self.duellConfig.writeToConfig()

	def determineAndValidateDependenciesAndDefines(self):
		if sys_FileSystem.exists(duell_helpers_DuellConfigHelper.getDuellUserFileLocation()):
			self.parseXML(duell_helpers_DuellConfigHelper.getDuellUserFileLocation())
		self.parseXML(haxe_io_Path.join([Sys.getCwd(), duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME]))
		while True:
			def _hx_local_0(l):
				return (not l.parsed)
			filtered = list(filter(_hx_local_0,self.libList))
			if (len(filtered) == 0):
				break
			_g = 0
			while (_g < len(filtered)):
				lib = (filtered[_g] if _g >= 0 and _g < len(filtered) else None)
				_g = (_g + 1)
				lib.parsed = True
				self.parseDuellLibWithName(lib.lib.name)

	def buildNewExecutableWithBuildLibAndDependencies(self):
		outputFolder = haxe_io_Path.join([duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"])
		outputRunArguments = haxe_io_Path.join([("" + ("null" if outputFolder is None else outputFolder)), (("run_" + HxOverrides.stringOrNull(self.platformName)) + ".args")])
		outputRun = haxe_io_Path.join([("" + ("null" if outputFolder is None else outputFolder)), (("run_" + HxOverrides.stringOrNull(self.platformName)) + ".py")])
		buildArguments = list()
		pythonLibPathsToBootstrap = list()
		x = haxe_io_Path.join([duell_helpers_DuellLibHelper.getPath("duell"), "pylib"])
		pythonLibPathsToBootstrap.append(x)
		buildArguments.append("-main")
		buildArguments.append("duell.build.main.BuildMain")
		buildArguments.append("-python")
		buildArguments.append(outputRun)
		buildArguments.append("-cp")
		x1 = duell_helpers_DuellLibHelper.getPath("duell")
		buildArguments.append(x1)
		buildArguments.append("-cp")
		x2 = duell_helpers_DuellLibHelper.getPath(self.buildLib.name)
		buildArguments.append(x2)
		pyLibPath = haxe_io_Path.join([duell_helpers_DuellLibHelper.getPath(self.buildLib.name), "pylib"])
		if sys_FileSystem.exists(pyLibPath):
			pythonLibPathsToBootstrap.append(pyLibPath)
		_g = 0
		_g1 = self.libList
		while (_g < len(_g1)):
			l = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
			_g = (_g + 1)
			buildArguments.append("-cp")
			x3 = duell_helpers_DuellLibHelper.getPath(l.lib.name)
			buildArguments.append(x3)
			if sys_FileSystem.exists(haxe_io_Path.join([duell_helpers_DuellLibHelper.getPath(l.lib.name), "duell", "build", "plugin", "library", l.lib.name, "LibraryXMLParser.hx"])):
				buildArguments.append((("duell.build.plugin.library." + HxOverrides.stringOrNull(l.lib.name)) + ".LibraryXMLParser"))
			if sys_FileSystem.exists(haxe_io_Path.join([duell_helpers_DuellLibHelper.getPath(l.lib.name), "duell", "build", "plugin", "library", l.lib.name, "LibraryBuild.hx"])):
				buildArguments.append((("duell.build.plugin.library." + HxOverrides.stringOrNull(l.lib.name)) + ".LibraryBuild"))
			pyLibPath1 = haxe_io_Path.join([duell_helpers_DuellLibHelper.getPath(l.lib.name), "pylib"])
			if sys_FileSystem.exists(pyLibPath1):
				pythonLibPathsToBootstrap.append(pyLibPath1)
		buildArguments.append("-D")
		buildArguments.append(("platform_" + HxOverrides.stringOrNull(self.platformName)))
		buildArguments.append("-D")
		x4 = None
		def _hx_local_1():
			_this = None
			e = duell_helpers_PlatformHelper.get_hostPlatform()
			_this = e.tag
			return _this.lower()
		x4 = ("host_" + HxOverrides.stringOrNull(_hx_local_1()))
		buildArguments.append(x4)
		buildArguments.append("-D")
		buildArguments.append(("duell_api_level=" + Std.string(duell_defines_DuellDefines.DUELL_API_LEVEL)))
		buildArguments.append("-resource")
		x5 = (HxOverrides.stringOrNull(haxe_io_Path.join([duell_helpers_DuellLibHelper.getPath("duell"), "config.xml"])) + "@generalArguments")
		buildArguments.append(x5)
		duell_helpers_PathHelper.mkdir(outputFolder)
		duell_helpers_CommandHelper.runHaxe("",buildArguments,_hx_AnonObject({'errorMessage': "building the plugin"}))
		runArguments = [outputRun]
		a = duell_objects_Arguments.getRawArguments()
		runArguments = (runArguments + a)
		serializer = haxe_Serializer()
		serializer.serialize(runArguments)
		fileOutput = sys_io_File.write(outputRunArguments,True)
		fileOutput.writeString(serializer.toString())
		fileOutput.close()
		if (len(pythonLibPathsToBootstrap) > 0):
			file = sys_io_File.getBytes(outputRun)
			fileOutput1 = sys_io_File.write(outputRun,True)
			fileOutput1.writeString("import os\n")
			fileOutput1.writeString("import sys\n")
			_g2 = 0
			while (_g2 < len(pythonLibPathsToBootstrap)):
				path = (pythonLibPathsToBootstrap[_g2] if _g2 >= 0 and _g2 < len(pythonLibPathsToBootstrap) else None)
				_g2 = (_g2 + 1)
				fileOutput1.writeString((("sys.path.insert(0, \"" + ("null" if path is None else path)) + "\")\n"))
			fileOutput1.writeBytes(file,0,file.length)
			fileOutput1.close()
		duell_helpers_LogHelper.wrapInfo((("\x1B[2m" + "Building ") + HxOverrides.stringOrNull(self.platformName)),None,"\x1B[2m")
		duell_helpers_PythonImportHelper.runPythonFile(outputRun)

	def runFast(self):
		self.platformName = duell_objects_Arguments.getSelectedPlugin()
		outputFolder = haxe_io_Path.join([duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"])
		outputRun = haxe_io_Path.join([("" + ("null" if outputFolder is None else outputFolder)), (("run" + HxOverrides.stringOrNull(self.platformName)) + ".py")])
		outputRunArguments = haxe_io_Path.join([("" + ("null" if outputFolder is None else outputFolder)), (("run_" + HxOverrides.stringOrNull(self.platformName)) + ".args")])
		if sys_FileSystem.exists(outputRun):
			raise _HxException("Could not find a previous execution for this platform in order to run it fast.")
		s = sys_io_File.getContent(outputRunArguments)
		runArguments = haxe_Unserializer(s).unserialize()
		duell_helpers_LogHelper.info("Running fast with arguments:")
		duell_helpers_LogHelper.info(" ".join([python_Boot.toString1(x1,'') for x1 in runArguments]))
		runArguments.append("-fast")
		Sys.putEnv("HAXELIB_RUN","0")
		result = duell_helpers_CommandHelper.runCommand("",Reflect.field(python_lib_Sys,"executable"),runArguments,_hx_AnonObject({'errorMessage': "running the plugin", 'exitOnError': False}))
		if (result != 0):
			Sys.exit(result)

	def parseDuellLibWithName(self,name):
		if (not sys_FileSystem.exists(((HxOverrides.stringOrNull(duell_helpers_DuellLibHelper.getPath(name)) + "/") + HxOverrides.stringOrNull(duell_defines_DuellDefines.LIB_CONFIG_FILENAME)))):
			duell_helpers_LogHelper.println(((("" + ("null" if name is None else name)) + " does not have a ") + HxOverrides.stringOrNull(duell_defines_DuellDefines.LIB_CONFIG_FILENAME)))
		else:
			path = ((HxOverrides.stringOrNull(duell_helpers_DuellLibHelper.getPath(name)) + "/") + HxOverrides.stringOrNull(duell_defines_DuellDefines.LIB_CONFIG_FILENAME))
			self.parseXML(path)

	def parseXML(self,path):
		xml = haxe_xml_Fast(Xml.parse(sys_io_File.getContent(path)).firstElement())
		_this = self.currentXMLPath
		x = haxe_io_Path.directory(path)
		_this.append(x)
		_hx_local_1 = xml.get_elements()
		while _hx_local_1.hasNext():
			element = _hx_local_1.next()
			_g = element.get_name()
			_hx_local_0 = len(_g)
			if (_hx_local_0 == 7):
				if (_g == "include"):
					if element.has.resolve("path"):
						includePath = self.resolvePath(element.att.resolve("path"))
						self.parseXML(includePath)
			elif (_hx_local_0 == 8):
				if (_g == "duelllib"):
					name = None
					version = None
					if ((not element.has.resolve("version")) or ((element.att.resolve("version") == ""))):
						raise _HxException(("DuellLib dependencies must always specify a version. File: " + ("null" if path is None else path)))
					name = element.att.resolve("name")
					version = element.att.resolve("version")
					if ((name is None) or ((name == ""))):
						continue
					newDuellLib = duell_objects_DuellLib.getDuellLib(name,version)
					self.handleDuellLibParsed(newDuellLib)
			else:
				pass
		_this1 = self.currentXMLPath
		if (len(_this1) == 0):
			None
		else:
			_this1.pop()

	def handleDuellLibParsed(self,newDuellLib):
		_g = 0
		_g1 = self.libList
		while (_g < len(_g1)):
			l = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
			_g = (_g + 1)
			if (l.lib.name != newDuellLib.name):
				continue
			return
		_this = self.libList
		_this.append(_hx_AnonObject({'lib': newDuellLib, 'parsed': False}))

	def resolvePath(self,path):
		path = duell_helpers_PathHelper.unescape(path)
		if duell_helpers_PathHelper.isPathRooted(path):
			return path
		path = haxe_io_Path.join([python_internal_ArrayImpl._get(self.currentXMLPath, (len(self.currentXMLPath) - 1)), path])
		return path

	@staticmethod
	def validateSchemaIfNamespaceSet():
		userFile = duell_helpers_DuellConfigHelper.getDuellUserFileLocation()
		projectFile = haxe_io_Path.join([Sys.getCwd(), duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME])
		if (sys_FileSystem.exists(userFile) and duell_helpers_SchemaHelper.hasDuellNamespace(userFile)):
			duell_helpers_SchemaHelper.validate(userFile)
		if duell_helpers_SchemaHelper.hasDuellNamespace(projectFile):
			duell_helpers_SchemaHelper.validate(projectFile)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.libList = None
		_hx_o.buildLib = None
		_hx_o.buildGitVers = None
		_hx_o.platformName = None
		_hx_o.duellConfig = None
		_hx_o.currentXMLPath = None
duell_commands_BuildCommand._hx_class = duell_commands_BuildCommand
_hx_classes["duell.commands.BuildCommand"] = duell_commands_BuildCommand


class duell_commands_CreateCommand:
	_hx_class_name = "duell.commands.CreateCommand"
	_hx_fields = ["setupLib"]
	_hx_methods = ["execute", "determineDuellLibraryFromArguments", "runPluginLib"]
	_hx_interfaces = [duell_commands_IGDCommand]

	def __init__(self):
		self.setupLib = None
		self.setupLib = None

	def execute(self):
		duell_helpers_LogHelper.info("")
		duell_helpers_LogHelper.info("\x1B[2m------")
		duell_helpers_LogHelper.info("Create")
		duell_helpers_LogHelper.info("------\x1B[0m")
		duell_helpers_LogHelper.info("")
		self.determineDuellLibraryFromArguments()
		duell_helpers_LogHelper.println("")
		self.runPluginLib()
		duell_helpers_LogHelper.println("")
		duell_helpers_LogHelper.info("\x1B[2m------")
		duell_helpers_LogHelper.info("end")
		duell_helpers_LogHelper.info("------\x1B[0m")
		return "success"

	def determineDuellLibraryFromArguments(self):
		pluginName = duell_objects_Arguments.getSelectedPlugin()
		pluginNameCorrectnessCheck = EReg("^[A-Za-z0-9]+$", "")
		def _hx_local_0():
			pluginNameCorrectnessCheck.matchObj = python_lib_Re.search(pluginNameCorrectnessCheck.pattern,pluginName)
			return (pluginNameCorrectnessCheck.matchObj is not None)
		if (not _hx_local_0()):
			raise _HxException((("Unknown plugin " + ("null" if pluginName is None else pluginName)) + ", should be composed of only letters or numbers, no spaces of other characters. Example: \"duell create emptyProject\" or \"duell create helloWorld\""))
		pluginLibName = ("duellcreate" + ("null" if pluginName is None else pluginName))
		self.setupLib = duell_objects_DuellLib.getDuellLib(pluginLibName)
		if duell_helpers_DuellLibHelper.isInstalled(pluginLibName):
			if (duell_helpers_DuellLibHelper.updateNeeded(pluginLibName) == True):
				answer = duell_helpers_AskHelper.askYesOrNo((("The plugin with name " + ("null" if pluginName is None else pluginName)) + " is not up to date on the master branch. Would you like to try to update it?"))
				if answer:
					duell_helpers_DuellLibHelper.update(pluginLibName)
			else:
				duell_helpers_LogHelper.info("","No update needed")
		else:
			answer1 = duell_helpers_AskHelper.askYesOrNo((("The plugin of name " + ("null" if pluginName is None else pluginName)) + " is not currently installed. Would you like to try to install it?"))
			if answer1:
				duell_helpers_DuellLibHelper.install(pluginLibName)
			else:
				duell_helpers_LogHelper.println((("Rerun with the plugin/library \"" + ("null" if pluginName is None else pluginName)) + "\" installed"))
				Sys.exit(0)

	def runPluginLib(self):
		outputFolder = haxe_io_Path.join([duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"])
		outputRun = haxe_io_Path.join([("" + ("null" if outputFolder is None else outputFolder)), "run.py"])
		buildArguments = list()
		buildArguments.append("-main")
		buildArguments.append("duell.create.CreateMain")
		buildArguments.append("-python")
		buildArguments.append(outputRun)
		buildArguments.append("-cp")
		x = duell_helpers_DuellLibHelper.getPath("duell")
		buildArguments.append(x)
		buildArguments.append("-cp")
		x1 = duell_helpers_DuellLibHelper.getPath(self.setupLib.name)
		buildArguments.append(x1)
		buildArguments.append("-resource")
		x2 = (HxOverrides.stringOrNull(haxe_io_Path.join([duell_helpers_DuellLibHelper.getPath("duell"), "config.xml"])) + "@generalArguments")
		buildArguments.append(x2)
		duell_helpers_PathHelper.mkdir(outputFolder)
		duell_helpers_CommandHelper.runHaxe("",buildArguments,_hx_AnonObject({'errorMessage': "building the plugin"}))
		pyLibPath = haxe_io_Path.join([duell_helpers_DuellLibHelper.getPath(self.setupLib.name), "pylib"])
		if sys_FileSystem.exists(pyLibPath):
			file = sys_io_File.getBytes(outputRun)
			fileOutput = sys_io_File.write(outputRun,True)
			fileOutput.writeString("import os\n")
			fileOutput.writeString("import sys\n")
			fileOutput.writeString((("sys.path.insert(0, \"" + ("null" if pyLibPath is None else pyLibPath)) + "\")\n"))
			fileOutput.writeBytes(file,0,file.length)
			fileOutput.close()
		duell_helpers_PythonImportHelper.runPythonFile(outputRun)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.setupLib = None
duell_commands_CreateCommand._hx_class = duell_commands_CreateCommand
_hx_classes["duell.commands.CreateCommand"] = duell_commands_CreateCommand


class duell_commands_DependencyCommand:
	_hx_class_name = "duell.commands.DependencyCommand"
	_hx_fields = ["libraryCache"]
	_hx_methods = ["execute", "buildVisualization", "openVisualization", "createVisualizationConfigFile", "parseProjectDependencies", "parseDuellLibraries", "canBeProcessed", "addParsingLib", "setParsedLib", "logAction", "checkRequirements", "checkIfItIsAProjectFolder"]
	_hx_interfaces = [duell_commands_IGDCommand]

	def __init__(self):
		self.libraryCache = None
		self.libraryCache = haxe_ds_StringMap()

	def execute(self):
		self.checkRequirements()
		if duell_objects_Arguments.isSet("-project"):
			self.parseProjectDependencies()
		return "success"

	def buildVisualization(self,creator):
		duellConfigJSON = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		executablePath = haxe_io_Path.join([duellConfigJSON.localLibraryPath, "duell", "bin", "graphviz"])
		executableFile = None
		if (duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.WINDOWS):
			executableFile = "dot.exe"
		else:
			executableFile = "dot"
		path = haxe_io_Path.join([executablePath, executableFile])
		duell_helpers_CommandHelper.runCommand("","chmod",["+x", path],_hx_AnonObject({'errorMessage': (("setting permissions on the '" + ("null" if executableFile is None else executableFile)) + "' executable.")}))
		targetFolder = haxe_io_Path.join([Sys.getCwd(), "dependencies"])
		if (not sys_FileSystem.exists(targetFolder)):
			sys_FileSystem.createDirectory(targetFolder)
		dotFile = haxe_io_Path.join([duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp", creator.getFilename()])
		args = ["-Tpng", dotFile, "-o", haxe_io_Path.join([Sys.getCwd(), "dependencies", "visualization.png"])]
		duell_helpers_CommandHelper.runCommand(executablePath,executableFile,args,_hx_AnonObject({'systemCommand': False, 'errorMessage': "running dot command"}))
		sys_FileSystem.deleteFile(dotFile)

	def openVisualization(self):
		duell_helpers_CommandHelper.runCommand("","open",[haxe_io_Path.join([Sys.getCwd(), "dependencies", "visualization.png"])])

	def createVisualizationConfigFile(self,rootNode):
		creator = duell_objects_dependencies_DotFileContentCreator()
		creator.parseDuellLibs(rootNode)
		creator.parseHaxeLibs(rootNode)
		configFolder = haxe_io_Path.join([duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"])
		outputFile = haxe_io_Path.join([configFolder, creator.getFilename()])
		fileOutput = sys_io_File.write(outputFile,False)
		fileOutput.writeString(creator.getContent())
		fileOutput.close()
		return creator

	def parseProjectDependencies(self):
		self.logAction("Checking library dependencies for current project")
		file = duell_objects_dependencies_DependencyConfigFile(Sys.getCwd(), duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME)
		rootNode = duell_objects_dependencies_DependencyLibraryObject(file, file.applicationName)
		if ((len(file.duellLibs) > 0) or ((len(file.haxeLibs) > 0))):
			duell_helpers_CommandHelper.runHaxelib(Sys.getCwd(),["run", "duell_duell", "update", "-yestoall"])
		else:
			duell_helpers_LogHelper.info("No dependencies defined.")
			Sys.exit(0)
		self.logAction("Parsing libraries..")
		self.parseDuellLibraries(rootNode)
		creator = self.createVisualizationConfigFile(rootNode)
		self.buildVisualization(creator)
		self.openVisualization()
		self.logAction("DONE")

	def parseDuellLibraries(self,rootNode):
		duellConfigJSON = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		libs = rootNode.configFile.duellLibs
		_g = 0
		while (_g < len(libs)):
			l = (libs[_g] if _g >= 0 and _g < len(libs) else None)
			_g = (_g + 1)
			libPath = haxe_io_Path.join([duellConfigJSON.localLibraryPath, l.name])
			libConfig = duell_defines_DuellDefines.LIB_CONFIG_FILENAME
			config = duell_objects_dependencies_DependencyConfigFile(libPath, libConfig)
			subNode = duell_objects_dependencies_DependencyLibraryObject(config, l.name, l.version)
			rootNode.addDependency(subNode)
			if self.canBeProcessed(subNode.lib):
				self.addParsingLib(subNode.lib)
				self.parseDuellLibraries(subNode)
				self.setParsedLib(subNode.lib)

	def canBeProcessed(self,lib):
		if lib.name in self.libraryCache.h:
			versions = self.libraryCache.h.get(lib.name,None)
			return lib.version in versions.h
		return True

	def addParsingLib(self,lib):
		if (not lib.name in self.libraryCache.h):
			value = haxe_ds_StringMap()
			self.libraryCache.h[lib.name] = value
		versions = self.libraryCache.h.get(lib.name,None)
		versions.h[lib.version] = False

	def setParsedLib(self,lib):
		versions = self.libraryCache.h.get(lib.name,None)
		versions.h[lib.version] = True

	def logAction(self,action):
		duell_helpers_LogHelper.wrapInfo(("\x1B[2m" + ("null" if action is None else action)),None,"\x1B[2m")

	def checkRequirements(self):
		self.logAction("Checking requirements")
		if duell_objects_Arguments.isSet("-project"):
			self.checkIfItIsAProjectFolder()
		else:
			duell_helpers_LogHelper.exitWithFormattedError("Use duell dependencies -help for valid commands.")
		duellConfig = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		if (len(duellConfig.repoListURLs) == 0):
			duell_helpers_LogHelper.exitWithFormattedError("No repository urls defined!.")

	def checkIfItIsAProjectFolder(self):
		if (not sys_FileSystem.exists(duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME)):
			duell_helpers_LogHelper.exitWithFormattedError((("It's not a valid project folder! " + HxOverrides.stringOrNull(duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME)) + " is missing."))

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.libraryCache = None
duell_commands_DependencyCommand._hx_class = duell_commands_DependencyCommand
_hx_classes["duell.commands.DependencyCommand"] = duell_commands_DependencyCommand


class duell_commands_EnvironmentSetupCommand:
	_hx_class_name = "duell.commands.EnvironmentSetupCommand"
	_hx_fields = ["setupLib", "platformName", "gitvers"]
	_hx_methods = ["execute", "determinePlatformToSetupFromArguments", "buildNewEnvironmentWithSetupLib"]
	_hx_interfaces = [duell_commands_IGDCommand]

	def __init__(self):
		self.setupLib = None
		self.platformName = None
		self.gitvers = None
		self.setupLib = None

	def execute(self):
		duell_helpers_LogHelper.info("")
		duell_helpers_LogHelper.info("\x1B[2m------")
		duell_helpers_LogHelper.info("Setup")
		duell_helpers_LogHelper.info("------\x1B[0m")
		duell_helpers_LogHelper.info("")
		self.determinePlatformToSetupFromArguments()
		duell_helpers_LogHelper.println("")
		self.buildNewEnvironmentWithSetupLib()
		duell_helpers_LogHelper.println("")
		duell_helpers_LogHelper.info("\x1B[2m------")
		duell_helpers_LogHelper.info("end")
		duell_helpers_LogHelper.info("------\x1B[0m")
		return "success"

	def determinePlatformToSetupFromArguments(self):
		self.platformName = duell_objects_Arguments.getSelectedPlugin()
		platformNameCorrectnessCheck = EReg("^[a-z0-9]+$", "")
		def _hx_local_0():
			platformNameCorrectnessCheck.matchObj = python_lib_Re.search(platformNameCorrectnessCheck.pattern,self.platformName)
			return (platformNameCorrectnessCheck.matchObj is not None)
		if (not _hx_local_0()):
			raise _HxException((("Unknown platform " + HxOverrides.stringOrNull(self.platformName)) + ", should be composed of only letters or numbers, no spaces of other characters. Example: \"duell setup mac\" or \"duell setup android\""))
		pluginLibName = ("duellsetup" + HxOverrides.stringOrNull(self.platformName))
		self.setupLib = duell_objects_DuellLib.getDuellLib(pluginLibName)
		if (not duell_helpers_DuellLibHelper.isInstalled(pluginLibName)):
			answer = duell_helpers_AskHelper.askYesOrNo((("A library for setup of " + HxOverrides.stringOrNull(self.platformName)) + " environment is not currently installed. Would you like to try to install it?"))
			if answer:
				duell_helpers_DuellLibHelper.install(pluginLibName)
			else:
				duell_helpers_LogHelper.println((("Rerun with the library \"duellsetup" + HxOverrides.stringOrNull(self.platformName)) + "\" installed"))
				Sys.exit(0)
		self.gitvers = duell_versioning_GitVers(self.setupLib.getPath())
		if (duell_objects_Arguments.get("-v") is not None):
			solvedVersion = self.gitvers.solveVersion(duell_objects_Arguments.get("-v"))
			self.gitvers.changeToVersion(solvedVersion)
		else:
			raise _HxException("You must always specify a version. E.g. duell setup android -v 1.0.0")

	def buildNewEnvironmentWithSetupLib(self):
		_g = self
		outputFolder = haxe_io_Path.join([duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"])
		outputRun = haxe_io_Path.join([("" + ("null" if outputFolder is None else outputFolder)), "run.py"])
		buildArguments = list()
		buildArguments.append("-main")
		buildArguments.append("duell.setup.main.SetupMain")
		buildArguments.append("-python")
		buildArguments.append(outputRun)
		buildArguments.append("-cp")
		x = duell_helpers_DuellLibHelper.getPath("duell")
		buildArguments.append(x)
		buildArguments.append("-cp")
		x1 = duell_helpers_DuellLibHelper.getPath(self.setupLib.name)
		buildArguments.append(x1)
		buildArguments.append("-D")
		buildArguments.append("plugin")
		buildArguments.append("-resource")
		x2 = (HxOverrides.stringOrNull(haxe_io_Path.join([duell_helpers_DuellLibHelper.getPath("duell"), "config.xml"])) + "@generalArguments")
		buildArguments.append(x2)
		duell_helpers_PathHelper.mkdir(outputFolder)
		duell_helpers_CommandHelper.runHaxe("",buildArguments,_hx_AnonObject({'errorMessage': "building the plugin"}))
		pyLibPath = haxe_io_Path.join([duell_helpers_DuellLibHelper.getPath(self.setupLib.name), "pylib"])
		if sys_FileSystem.exists(pyLibPath):
			file = sys_io_File.getBytes(outputRun)
			fileOutput = sys_io_File.write(outputRun,True)
			fileOutput.writeString("import os\n")
			fileOutput.writeString("import sys\n")
			fileOutput.writeString((("sys.path.insert(0, \"" + ("null" if pyLibPath is None else pyLibPath)) + "\")\n"))
			fileOutput.writeBytes(file,0,file.length)
			fileOutput.close()
		runArguments = [outputRun]
		a = duell_objects_Arguments.getRawArguments()
		runArguments = (runArguments + a)
		duell_helpers_PythonImportHelper.runPythonFile(outputRun)
		duell_helpers_LogHelper.println("Saving Setup Done Marker... ")
		duellConfig = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		def _hx_local_0(s):
			return (not StringTools.startsWith(HxOverrides.arrayGet(s.split(":"), 0),_g.platformName))
		duellConfig.setupsCompleted = list(filter(_hx_local_0,duellConfig.setupsCompleted))
		_this = duellConfig.setupsCompleted
		_this.append(((HxOverrides.stringOrNull(self.platformName) + ":") + HxOverrides.stringOrNull(self.gitvers.currentVersion)))
		duellConfig.writeToConfig()

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.setupLib = None
		_hx_o.platformName = None
		_hx_o.gitvers = None
duell_commands_EnvironmentSetupCommand._hx_class = duell_commands_EnvironmentSetupCommand
_hx_classes["duell.commands.EnvironmentSetupCommand"] = duell_commands_EnvironmentSetupCommand


class duell_commands_RepoConfigCommand:
	_hx_class_name = "duell.commands.RepoConfigCommand"
	_hx_methods = ["execute", "printRepoList", "printDuplicates"]
	_hx_statics = ["defaultRepoListURL"]
	_hx_interfaces = [duell_commands_IGDCommand]

	def __init__(self):
		pass

	def execute(self):
		duell_helpers_LogHelper.info("\n")
		duellConfig = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		if duell_objects_Arguments.isSet("-addFront"):
			arguments = duell_objects_Arguments.getRawArguments()
			lastArgument = None
			lastArgument = (None if ((len(arguments) == 0)) else arguments.pop())
			if (lastArgument == "-addFront"):
				duell_helpers_LogHelper.info("Was empty String")
			elif (python_internal_ArrayImpl.indexOf(duellConfig.repoListURLs,lastArgument,None) == -1):
				duellConfig.repoListURLs.insert(0, lastArgument)
				duellConfig.writeToConfig()
			else:
				duell_helpers_LogHelper.info("This entry was already in")
		elif duell_objects_Arguments.isSet("-add"):
			arguments1 = duell_objects_Arguments.getRawArguments()
			lastArgument1 = None
			lastArgument1 = (None if ((len(arguments1) == 0)) else arguments1.pop())
			if (lastArgument1 == "-add"):
				duell_helpers_LogHelper.info("Was empty String")
			elif (python_internal_ArrayImpl.indexOf(duellConfig.repoListURLs,lastArgument1,None) == -1):
				_this = duellConfig.repoListURLs
				_this.append(lastArgument1)
				duellConfig.writeToConfig()
			else:
				duell_helpers_LogHelper.info("This entry was already in")
		elif duell_objects_Arguments.isSet("-removeAll"):
			while (len(duellConfig.repoListURLs) > 0):
				_this1 = duellConfig.repoListURLs
				if (len(_this1) == 0):
					None
				else:
					_this1.pop()
			_this2 = duellConfig.repoListURLs
			_this2.append(duell_commands_RepoConfigCommand.defaultRepoListURL)
			duellConfig.writeToConfig()
			duell_helpers_LogHelper.info("Removed all entries, reset to default url")
		elif duell_objects_Arguments.isSet("-remove"):
			arguments2 = duell_objects_Arguments.getRawArguments()
			lastArgument2 = None
			lastArgument2 = (None if ((len(arguments2) == 0)) else arguments2.pop())
			if (lastArgument2 == "-remove"):
				duell_helpers_LogHelper.info("URL was empty string. Did not remove anything.")
			elif python_internal_ArrayImpl.remove(duellConfig.repoListURLs,lastArgument2):
				duellConfig.writeToConfig()
				duell_helpers_LogHelper.info(("Succefully removed " + ("null" if lastArgument2 is None else lastArgument2)))
			else:
				duell_helpers_LogHelper.info((("null" if lastArgument2 is None else lastArgument2) + " was not in the repo list"))
		elif duell_objects_Arguments.isSet("-reverse"):
			duellConfig.repoListURLs.reverse()
			duellConfig.writeToConfig()
			duell_helpers_LogHelper.info("Reversed all entries")
		elif duell_objects_Arguments.isSet("-duplicates"):
			duell_helpers_LogHelper.info("\n")
			duell_helpers_LogHelper.info("\x1B[2m------")
			self.printDuplicates()
			duell_helpers_LogHelper.info("")
			duell_helpers_LogHelper.info("------\x1B[0m")
			duell_helpers_LogHelper.info("\n")
		duell_helpers_LogHelper.info("\n")
		duell_helpers_LogHelper.info("\x1B[2m------")
		duell_helpers_LogHelper.info("Repository List")
		duell_helpers_LogHelper.info("------\x1B[0m")
		self.printRepoList(duellConfig.repoListURLs)
		duell_helpers_LogHelper.info("\n")
		return "success"

	def printRepoList(self,repoList):
		counter = 1
		_g = 0
		while (_g < len(repoList)):
			repo = (repoList[_g] if _g >= 0 and _g < len(repoList) else None)
			_g = (_g + 1)
			duell_helpers_LogHelper.info(((Std.string(counter) + ". ") + ("null" if repo is None else repo)))
			counter = (counter + 1)

	def printDuplicates(self):
		_hx_list = duell_helpers_DuellLibListHelper.getDuplicatesFromRepoLists()
		_hx_local_0 = _hx_list.keys()
		while _hx_local_0.hasNext():
			repo = _hx_local_0.next()
			duell_helpers_LogHelper.info(("Duplicated key: " + ("null" if repo is None else repo)))

	@staticmethod
	def _hx_empty_init(_hx_o):		pass
duell_commands_RepoConfigCommand._hx_class = duell_commands_RepoConfigCommand
_hx_classes["duell.commands.RepoConfigCommand"] = duell_commands_RepoConfigCommand


class duell_commands_RunCommand:
	_hx_class_name = "duell.commands.RunCommand"
	_hx_fields = ["runLib", "buildGitVers", "pluginName", "duellConfig"]
	_hx_methods = ["execute", "determinePluginToRunFromArguments", "checkPluginVersion", "buildNewRunExecutableWithRunLib"]
	_hx_interfaces = [duell_commands_IGDCommand]

	def __init__(self):
		self.runLib = None
		self.buildGitVers = None
		self.pluginName = None
		self.duellConfig = None
		self.buildGitVers = None
		self.runLib = None

	def execute(self):
		self.determinePluginToRunFromArguments()
		self.checkPluginVersion()
		self.buildNewRunExecutableWithRunLib()
		return "success"

	def determinePluginToRunFromArguments(self):
		self.pluginName = duell_objects_Arguments.getSelectedPlugin()
		pluginNameCorrectnessCheck = EReg("^[A-Za-z0-9]+$", "")
		def _hx_local_0():
			pluginNameCorrectnessCheck.matchObj = python_lib_Re.search(pluginNameCorrectnessCheck.pattern,self.pluginName)
			return (pluginNameCorrectnessCheck.matchObj is not None)
		if (not _hx_local_0()):
			raise _HxException((("Unknown plugin " + HxOverrides.stringOrNull(self.pluginName)) + ", should be composed of only letters or numbers, no spaces of other characters. Example: \"duell run myLib\" or \"duell run coverageCheck\""))
		self.runLib = duell_objects_DuellLib.getDuellLib(self.pluginName)
		if (not duell_helpers_DuellLibHelper.isInstalled(self.runLib.name)):
			answer = duell_helpers_AskHelper.askYesOrNo((("A library for running " + HxOverrides.stringOrNull(self.pluginName)) + " is not currently installed. Would you like to try to install it?"))
			stopBuild = True
			if answer:
				duell_helpers_DuellLibHelper.install(self.runLib.name)
				stopBuild = False
			else:
				duell_helpers_LogHelper.println((("Rerun with the library \"" + HxOverrides.stringOrNull(self.pluginName)) + "\" installed"))
			if stopBuild:
				Sys.exit(0)

	def checkPluginVersion(self):
		if (self.runLib.version == "master"):
			if self.runLib.updateNeeded():
				self.runLib.update()

	def buildNewRunExecutableWithRunLib(self):
		outputFolder = haxe_io_Path.join([duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"])
		outputRun = haxe_io_Path.join([("" + ("null" if outputFolder is None else outputFolder)), (("run_" + HxOverrides.stringOrNull(self.pluginName)) + ".py")])
		buildArguments = list()
		buildArguments.append("-main")
		buildArguments.append("duell.run.main.RunMain")
		buildArguments.append("-python")
		buildArguments.append(outputRun)
		buildArguments.append("-cp")
		x = duell_helpers_DuellLibHelper.getPath("duell")
		buildArguments.append(x)
		buildArguments.append("-cp")
		x1 = duell_helpers_DuellLibHelper.getPath(self.runLib.name)
		buildArguments.append(x1)
		buildArguments.append("-D")
		buildArguments.append(("run_plugin_" + HxOverrides.stringOrNull(self.pluginName)))
		buildArguments.append("-D")
		buildArguments.append("plugin")
		buildArguments.append("-resource")
		x2 = (HxOverrides.stringOrNull(haxe_io_Path.join([duell_helpers_DuellLibHelper.getPath("duell"), "config.xml"])) + "@generalArguments")
		buildArguments.append(x2)
		duell_helpers_CommandHelper.runHaxe("",buildArguments,_hx_AnonObject({'errorMessage': "building the plugin"}))
		pyLibPath = haxe_io_Path.join([duell_helpers_DuellLibHelper.getPath(self.pluginName), "pylib"])
		if sys_FileSystem.exists(pyLibPath):
			file = sys_io_File.getBytes(outputRun)
			fileOutput = sys_io_File.write(outputRun,True)
			fileOutput.writeString("import os\n")
			fileOutput.writeString("import sys\n")
			fileOutput.writeString((("sys.path.insert(0, \"" + ("null" if pyLibPath is None else pyLibPath)) + "\")\n"))
			fileOutput.writeBytes(file,0,file.length)
			fileOutput.close()
		duell_helpers_PythonImportHelper.runPythonFile(outputRun)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.runLib = None
		_hx_o.buildGitVers = None
		_hx_o.pluginName = None
		_hx_o.duellConfig = None
duell_commands_RunCommand._hx_class = duell_commands_RunCommand
_hx_classes["duell.commands.RunCommand"] = duell_commands_RunCommand


class duell_commands_ToolSetupCommand:
	_hx_class_name = "duell.commands.ToolSetupCommand"
	_hx_methods = ["execute", "setupHaxe", "setupHaxelib", "setupDuellSettingsDirectory", "installDuell", "installCommandLine", "setupHXCPP", "writeHXCPPDefinitions", "savingSetupDone"]
	_hx_statics = ["haxeURL", "defaultRepoListURL"]
	_hx_interfaces = [duell_commands_IGDCommand]

	def __init__(self):
		pass

	def execute(self):
		duell_helpers_LogHelper.info("")
		duell_helpers_LogHelper.info("\x1B[2m------")
		duell_helpers_LogHelper.info("Base Setup")
		duell_helpers_LogHelper.info("------\x1B[0m")
		duell_helpers_LogHelper.info("")
		self.setupHaxe()
		duell_helpers_LogHelper.println("")
		self.setupHaxelib()
		duell_helpers_LogHelper.println("")
		self.setupDuellSettingsDirectory()
		duell_helpers_LogHelper.println("")
		self.installDuell()
		duell_helpers_LogHelper.println("")
		self.setupHXCPP()
		duell_helpers_LogHelper.println("")
		self.writeHXCPPDefinitions()
		duell_helpers_LogHelper.println("")
		self.savingSetupDone()
		duell_helpers_LogHelper.println("")
		self.installCommandLine()
		duell_helpers_LogHelper.info("\x1B[2m------")
		duell_helpers_LogHelper.info("end")
		duell_helpers_LogHelper.info("------\x1B[0m")
		return "success"

	def setupHaxe(self):
		duell_helpers_LogHelper.println("Checking haxe installation... ")
		haxePath = Sys.getEnv("HAXEPATH")
		systemCommand = None
		if ((haxePath is not None) and ((haxePath != ""))):
			systemCommand = False
		else:
			systemCommand = True
		output = duell_objects_DuellProcess(haxePath, "haxelib", [], _hx_AnonObject({'block': True, 'systemCommand': systemCommand, 'mute': True, 'errorMessage': "checking haxe installation"})).getCompleteStdout().toString()
		if (output.find("Haxe Library Manager") == -1):
			duell_helpers_LogHelper.println("not found.")
			duell_helpers_LogHelper.println("It seems haxe is not installed or not accessible in the command line.")
			answer = duell_helpers_AskHelper.askYesOrNo("Do you want to visit the haxe website to install it?")
			if answer:
				duell_helpers_CommandHelper.openURL(duell_commands_ToolSetupCommand.haxeURL)
			duell_helpers_LogHelper.println("Rerun the script with haxe installed.")
			Sys.exit(0)
		else:
			duell_helpers_LogHelper.println("Installed!")

	def setupHaxelib(self):
		duell_helpers_LogHelper.println("Checking haxelib setup... ")
		haxePath = Sys.getEnv("HAXEPATH")
		systemCommand = None
		if ((haxePath is not None) and ((haxePath != ""))):
			systemCommand = False
		else:
			systemCommand = True
		output = duell_objects_DuellProcess(haxePath, "haxelib", ["config"], _hx_AnonObject({'block': True, 'systemCommand': systemCommand, 'mute': True, 'errorMessage': "checking haxelib setup"})).getCompleteStdout().toString()
		if ((output is None) or ((output.find("This is the first time") != -1))):
			repoPath = duell_helpers_AskHelper.askString("It seems haxelib has not been setup. Where do you want the setup folder?",(HxOverrides.stringOrNull(duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation()) + "/haxelib"))
			repoPath = duell_helpers_PathHelper.unescape(repoPath)
			duell_helpers_PathHelper.mkdir(repoPath)
			repoPath = sys_FileSystem.fullPath(repoPath)
			duell_helpers_CommandHelper.runHaxelib("",["setup", repoPath],_hx_AnonObject({'errorMessage': "setting up haxelib. Rerun the script with 'haxelib setup' executed successfully."}))
		else:
			duell_helpers_LogHelper.println("Installed!")

	def setupDuellSettingsDirectory(self):
		duell_helpers_LogHelper.println("Checking duell settings... ")
		if (not duell_helpers_DuellConfigHelper.checkIfDuellConfigExists()):
			duell_helpers_LogHelper.println("Duell config folder not found.")
			duell_helpers_LogHelper.println(("Creating it in " + HxOverrides.stringOrNull(duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation())))
			duell_helpers_PathHelper.mkdir(duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation())
		if (not sys_FileSystem.exists(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())):
			fileContent = "{}"
			output = sys_io_File.write(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation(),False)
			output.writeString(fileContent)
			output.close()
		if (not sys_FileSystem.exists(duell_helpers_DuellConfigHelper.getDuellUserFileLocation())):
			fileContent1 = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<user xmlns=\"duell\">\n</user>\n"
			output1 = sys_io_File.write(duell_helpers_DuellConfigHelper.getDuellUserFileLocation(),False)
			output1.writeString(fileContent1)
			output1.close()
		repoPath = duell_helpers_AskHelper.askString("Path to store repos from libraries?",(HxOverrides.stringOrNull(duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation()) + "/lib"))
		repoListURL = duell_helpers_AskHelper.askString("URL to repo list?",duell_commands_ToolSetupCommand.defaultRepoListURL)
		duellConfig = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		duellConfig.localLibraryPath = duell_helpers_PathHelper.unescape(repoPath)
		duell_helpers_PathHelper.mkdir(duellConfig.localLibraryPath)
		duellConfig.localLibraryPath = sys_FileSystem.fullPath(duellConfig.localLibraryPath)
		if (python_internal_ArrayImpl.indexOf(duellConfig.repoListURLs,repoListURL,None) == -1):
			if (len(duellConfig.repoListURLs) > 0):
				duell_helpers_LogHelper.println((("There are already a repo list urls configured (" + HxOverrides.stringOrNull(",".join([python_Boot.toString1(x1,'') for x1 in duellConfig.repoListURLs]))) + ")"))
				answer = duell_helpers_AskHelper.askYesOrNo("Do you want to add the new url (answer yes), or override the current ones (answer no)?")
				if (not answer):
					duellConfig.repoListURLs = []
			_this = duellConfig.repoListURLs
			_this.append(repoListURL)
		duellConfig.writeToConfig()
		duell_helpers_LogHelper.println(("You can review this in " + HxOverrides.stringOrNull(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())))

	def installDuell(self):
		duell_helpers_LogHelper.println("Installing the duell command in haxelib...")
		duellConfig = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		duell_helpers_LogHelper.println(("Will install the duell tool from " + HxOverrides.stringOrNull(", ".join([python_Boot.toString1(x1,'') for x1 in duellConfig.repoListURLs]))))
		libMap = duell_helpers_DuellLibListHelper.getDuellLibReferenceList()
		if (not "duell" in libMap.h):
			raise _HxException(("Could not find \"duell\" in " + HxOverrides.stringOrNull(", ".join([python_Boot.toString1(x1,'') for x1 in duellConfig.repoListURLs]))))
		libMap.h.get("duell",None).install()
		duell_helpers_LogHelper.println("installed!")

	def installCommandLine(self):
		duell_helpers_LogHelper.println("Checking duell command line installation... ")
		haxePath = Sys.getEnv("HAXEPATH")
		if (duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.WINDOWS):
			if ((haxePath is None) or ((haxePath == ""))):
				haxePath = "C:\\HaxeToolkit\\haxe\\"
			sys_io_File.copy((HxOverrides.stringOrNull(duell_objects_Haxelib.getHaxelib("duell_duell").getPath()) + "\\bin\\duell.bat"),(("null" if haxePath is None else haxePath) + "\\duell.bat"))
			sys_io_File.copy((HxOverrides.stringOrNull(duell_objects_Haxelib.getHaxelib("duell_duell").getPath()) + "\\bin\\duell.sh"),(("null" if haxePath is None else haxePath) + "\\duell"))
		else:
			if ((haxePath is None) or ((haxePath == ""))):
				haxePath = "/usr/lib/haxe"
			installedCommand = False
			answer = None
			answer = duell_helpers_AskHelper.askYesOrNo("Do you want to install the \"duell\" command?")
			if answer:
				duell_helpers_CommandHelper.runCommand("","sudo",["cp", "-f", (HxOverrides.stringOrNull(duell_helpers_DuellLibHelper.getPath("duell")) + "/bin/duell.sh"), "/usr/bin/duell"],_hx_AnonObject({'errorMessage': "copying duell executable to the path"}))
				duell_helpers_CommandHelper.runCommand("","sudo",["chmod", "755", "/usr/bin/duell"],_hx_AnonObject({'errorMessage': "setting permissions on the duell executable"}))
				installedCommand = True
			if (not installedCommand):
				duell_helpers_LogHelper.println("")
				duell_helpers_LogHelper.println("To finish setup, we recommend you either...")
				duell_helpers_LogHelper.println("")
				duell_helpers_LogHelper.println(" a) Manually add an alias called \"duell\" to run \"haxelib run duell\"")
				duell_helpers_LogHelper.println(" b) Run the following commands:")
				duell_helpers_LogHelper.println("")
				duell_helpers_LogHelper.println((("sudo cp \"" + HxOverrides.stringOrNull(duell_objects_Haxelib.getHaxelib("duell_duell").getPath())) + "/bin/duell.sh\" /usr/bin/duell"))
				duell_helpers_LogHelper.println("sudo chmod 755 /usr/bin/duell")
				duell_helpers_LogHelper.println("")

	def setupHXCPP(self):
		duell_helpers_LogHelper.println("Checking hxcpp installation... ")
		hxcppHaxelib = duell_objects_Haxelib.getHaxelib("hxcpp")
		if (not hxcppHaxelib.exists()):
			duell_helpers_LogHelper.println("not found")
			duell_helpers_LogHelper.println("Installing hxcpp...")
			duell_helpers_CommandHelper.runHaxelib("",["install", "hxcpp"],_hx_AnonObject({'errorMessage': "installing hxcpp"}))
			duell_helpers_LogHelper.println("Rechecking hxcpp installation... ")
			if hxcppHaxelib.exists():
				duell_helpers_LogHelper.println("Installed!")
			else:
				raise _HxException("Still not installed, unknown error occurred...")
		else:
			duell_helpers_LogHelper.println("Installed!")
		duell_helpers_LogHelper.println("Running once to make sure it is initialized...")
		duell_helpers_CommandHelper.runHaxelib("",["run", "hxcpp"],_hx_AnonObject({'errorMessage': "double checking if hxcpp was installed correctly."}))
		duell_helpers_LogHelper.println("Finished running hxcpp.")

	def writeHXCPPDefinitions(self):
		if (duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.MAC):
			hxcppConfigPath = duell_helpers_HXCPPConfigXMLHelper.getProbableHXCPPConfigLocation()
			if (hxcppConfigPath is None):
				raise _HxException("Could not find the home folder, no HOME variable is set. Can't find hxcpp_config.xml")
			hxcppXML = duell_objects_HXCPPConfigXML.getConfig(hxcppConfigPath)
			existingDefines = hxcppXML.getDefines()
			newDefines = haxe_ds_StringMap()
			newDefines.h["MAC_USE_CURRENT_SDK"] = "1"
			duell_helpers_LogHelper.println("\x1B[1mWriting new definitions to hxcpp config file:\x1B[0m")
			_hx_local_0 = newDefines.keys()
			while _hx_local_0.hasNext():
				_hx_def = _hx_local_0.next()
				duell_helpers_LogHelper.println(((("\x1B[1m" + ("null" if _hx_def is None else _hx_def)) + "\x1B[0m:") + HxOverrides.stringOrNull(newDefines.h.get(_hx_def,None))))
			_hx_local_1 = existingDefines.keys()
			while _hx_local_1.hasNext():
				def1 = _hx_local_1.next()
				if (not def1 in newDefines.h):
					value = existingDefines.h.get(def1,None)
					newDefines.h[def1] = value
			hxcppXML.writeDefines(newDefines)

	def savingSetupDone(self):
		duell_helpers_LogHelper.println("Saving Setup Done Marker... ")
		duellConfig = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		if (python_internal_ArrayImpl.indexOf(duellConfig.setupsCompleted,"self",None) == -1):
			_this = duellConfig.setupsCompleted
			_this.append("self")
			duellConfig.writeToConfig()

	@staticmethod
	def _hx_empty_init(_hx_o):		pass
duell_commands_ToolSetupCommand._hx_class = duell_commands_ToolSetupCommand
_hx_classes["duell.commands.ToolSetupCommand"] = duell_commands_ToolSetupCommand

class duell_commands_VersionState(Enum):
	_hx_class_name = "duell.commands.VersionState"
	_hx_constructs = ["Unparsed", "ParsedVersionUnchanged", "ParsedVersionChanged"]
duell_commands_VersionState.Unparsed = duell_commands_VersionState("Unparsed", 0, list())
duell_commands_VersionState.ParsedVersionUnchanged = duell_commands_VersionState("ParsedVersionUnchanged", 1, list())
duell_commands_VersionState.ParsedVersionChanged = duell_commands_VersionState("ParsedVersionChanged", 2, list())
duell_commands_VersionState._hx_class = duell_commands_VersionState
_hx_classes["duell.commands.VersionState"] = duell_commands_VersionState


class duell_commands_UpdateCommand:
	_hx_class_name = "duell.commands.UpdateCommand"
	_hx_fields = ["finalLibList", "finalPluginList", "finalToolList", "haxelibVersions", "duellLibVersions", "pluginVersions", "buildLib", "platformName", "duellToolGitVers", "duellToolRequestedVersion", "isDifferentDuellToolVersion", "targetPlatform", "currentXMLPath"]
	_hx_methods = ["execute", "validateArguments", "synchronizeRemotes", "useVersionFileToRecreateSpecificVersions", "recreateDuellLib", "determineAndValidateDependenciesAndDefines", "parseDuellUserFile", "parseProjectFile", "iterateDuellLibVersionsUntilEverythingIsParsedAndVersioned", "checkVersionsOfPlugins", "checkDuellToolVersion", "checkHaxeVersion", "printFinalResult", "printVersionDiffs", "logVersions", "createFinalLibLists", "sortDuellLibsByName", "sortHaxeLibsByName", "createSchemaXml", "saveUpdateExecution", "lockBuildVersion", "parseDuellLibWithName", "parseXML", "checkDuelllibPreConditions", "handleDuellLibParsed", "handleHaxelibParsed", "handlePluginParsed", "resolvePath"]
	_hx_statics = ["duellFileHasDuellNamespace", "userFileHasDuellNamespace", "validateSchemaXml", "validateUserSchemaXml"]
	_hx_interfaces = [duell_commands_IGDCommand]

	def __init__(self):
		self.finalLibList = None
		self.finalPluginList = None
		self.finalToolList = None
		self.haxelibVersions = None
		self.duellLibVersions = None
		self.pluginVersions = None
		self.buildLib = None
		self.platformName = None
		self.duellToolGitVers = None
		self.duellToolRequestedVersion = None
		self.isDifferentDuellToolVersion = None
		self.targetPlatform = None
		self.currentXMLPath = None
		self.currentXMLPath = []
		self.targetPlatform = None
		self.isDifferentDuellToolVersion = False
		self.duellToolRequestedVersion = None
		self.buildLib = None
		self.pluginVersions = haxe_ds_StringMap()
		self.duellLibVersions = haxe_ds_StringMap()
		self.haxelibVersions = haxe_ds_StringMap()
		self.finalToolList = []
		self.finalPluginList = []
		self.finalLibList = _hx_AnonObject({'duellLibs': [], 'haxelibs': []})

	def execute(self):
		self.validateArguments()
		if duell_objects_Arguments.isSet("-target"):
			self.targetPlatform = duell_objects_Arguments.get("-target")
		else:
			self.targetPlatform = None
		duell_helpers_LogHelper.wrapInfo(("\x1B[2m" + "Update Dependencies"),None,"\x1B[2m")
		self.synchronizeRemotes()
		if duell_objects_Arguments.isSet("-logFile"):
			self.useVersionFileToRecreateSpecificVersions()
			return "success"
		self.determineAndValidateDependenciesAndDefines()
		duell_helpers_LogHelper.info(("\x1B[2m" + "------"))
		duell_helpers_LogHelper.wrapInfo(("\x1B[2m" + "Resulting dependencies update and resolution"),None,"\x1B[2m")
		self.printFinalResult(self.finalLibList.duellLibs,self.finalLibList.haxelibs,self.finalPluginList)
		if duell_objects_Arguments.isSet("-log"):
			self.logVersions()
			self.printVersionDiffs()
		if (duell_commands_UpdateCommand.duellFileHasDuellNamespace() and duell_helpers_ConnectionHelper.isOnline()):
			duell_helpers_LogHelper.info(("\x1B[2m" + "------"))
			duell_helpers_LogHelper.wrapInfo(("\x1B[2m" + "Validating XML schema"),None,"\x1B[2m")
			if duell_commands_UpdateCommand.userFileHasDuellNamespace():
				duell_commands_UpdateCommand.validateUserSchemaXml()
			duell_commands_UpdateCommand.validateSchemaXml()
			duell_helpers_LogHelper.info("Success!")
		self.saveUpdateExecution()
		duell_helpers_LogHelper.wrapInfo(("\x1B[2m" + "end"),None,"\x1B[2m")
		if self.isDifferentDuellToolVersion:
			duell_helpers_LogHelper.info("Rerunning the update because the duell tool version changed.")
			def _hx_local_0():
				a = duell_objects_Arguments.getRawArguments()
				return (["run", "duell_duell"] + a)
			duell_helpers_CommandHelper.runHaxelib(Sys.getCwd(),_hx_local_0(),_hx_AnonObject({}))
		return "success"

	def validateArguments(self):
		if duell_objects_Arguments.isSet("-log"):
			if duell_objects_Arguments.isSet("-logFile"):
				duell_helpers_LogHelper.exitWithFormattedError("'-log' and '-logFile' are excluding eachother.")
		if duell_objects_Arguments.isSet("-logFile"):
			path = duell_objects_Arguments.get("-logFile")
			if (not sys_FileSystem.exists(path)):
				duell_helpers_LogHelper.exitWithFormattedError((("Invalid path: '" + ("null" if path is None else path)) + "'"))

	def synchronizeRemotes(self):
		reflist = duell_helpers_DuellLibListHelper.getDuellLibReferenceList()
		_hx_local_0 = reflist.keys()
		while _hx_local_0.hasNext():
			key = _hx_local_0.next()
			libRef = reflist.h.get(key,None)
			duellLib = duell_objects_DuellLib.getDuellLib(key)
			if (duellLib.isInstalled() and duellLib.isPathValid()):
				remotes = duell_helpers_GitHelper.listRemotes(duellLib.getPath())
				originGitPath = remotes.h.get("origin",None)
				if (originGitPath is None):
					originGitPath = ""
				if (originGitPath != libRef.gitPath):
					duell_helpers_GitHelper.setRemoteURL(duellLib.getPath(),"origin",libRef.gitPath)
					duell_helpers_LogHelper.info(((("Changing remote path for origin from " + ("null" if originGitPath is None else originGitPath)) + " to ") + HxOverrides.stringOrNull(libRef.gitPath)))

	def useVersionFileToRecreateSpecificVersions(self):
		path = duell_objects_Arguments.get("-logFile")
		lockedVersions = duell_versioning_locking_LockedVersionsHelper.getLastLockedVersion(path)
		dLibs = lockedVersions.duelllibs
		hLibs = lockedVersions.haxelibs
		plugins = lockedVersions.plugins
		if ((len(dLibs) == 0) and ((len(hLibs) == 0))):
			duell_helpers_LogHelper.exitWithFormattedError("No libs to reuse.")
		duell_helpers_LogHelper.wrapInfo(("\x1B[2m" + "Recreating Duelllibs"),None,"\x1B[2m")
		_g = 0
		while (_g < len(dLibs)):
			d = (dLibs[_g] if _g >= 0 and _g < len(dLibs) else None)
			_g = (_g + 1)
			self.recreateDuellLib(d)
		duell_helpers_LogHelper.wrapInfo(("\x1B[2m" + "Recreating Haxelibs"),None,"\x1B[2m")
		_g1 = 0
		while (_g1 < len(hLibs)):
			h = (hLibs[_g1] if _g1 >= 0 and _g1 < len(hLibs) else None)
			_g1 = (_g1 + 1)
			self.handleHaxelibParsed(h)
			h.selectVersion()
		duell_helpers_LogHelper.wrapInfo(("\x1B[2m" + "Recreating plugins"),None,"\x1B[2m")
		_g2 = 0
		while (_g2 < len(plugins)):
			p = (plugins[_g2] if _g2 >= 0 and _g2 < len(plugins) else None)
			_g2 = (_g2 + 1)
			self.recreateDuellLib(p)
		dLibs.sort(key= python_lib_Functools.cmp_to_key(self.sortDuellLibsByName))
		hLibs.sort(key= python_lib_Functools.cmp_to_key(self.sortHaxeLibsByName))
		plugins.sort(key= python_lib_Functools.cmp_to_key(self.sortDuellLibsByName))
		self.printFinalResult(dLibs,hLibs,plugins)

	def recreateDuellLib(self,lib):
		self.checkDuelllibPreConditions(lib)
		duell_helpers_GitHelper.fetch(lib.getPath())
		commit = duell_helpers_GitHelper.getCurrentCommit(lib.getPath())
		if (commit != lib.commit):
			if (not duell_helpers_GitHelper.isRepoWithoutLocalChanges(lib.getPath())):
				raise _HxException(("Can't change branch of repo because it has local changes, path: " + HxOverrides.stringOrNull(lib.getPath())))
			duell_helpers_LogHelper.info("",((("Checkout library '" + HxOverrides.stringOrNull(lib.name)) + "' to commit : ") + HxOverrides.stringOrNull(lib.commit)))
			duell_helpers_GitHelper.checkoutCommit(lib.getPath(),lib.commit)

	def determineAndValidateDependenciesAndDefines(self):
		self.handleHaxelibParsed(duell_objects_Haxelib.getHaxelib("hxcpp",duell_defines_DuellDefines.DEFAULT_HXCPP_VERSION))
		self.duellToolGitVers = duell_versioning_GitVers(duell_objects_DuellLib.getDuellLib("duell").getPath())
		duell_helpers_LogHelper.info("\n")
		duell_helpers_LogHelper.info("parsing")
		self.parseDuellUserFile()
		self.parseProjectFile()
		self.iterateDuellLibVersionsUntilEverythingIsParsedAndVersioned()
		self.checkVersionsOfPlugins()
		self.checkDuellToolVersion()
		self.checkHaxeVersion()
		self.createFinalLibLists()
		self.createSchemaXml()

	def parseDuellUserFile(self):
		if sys_FileSystem.exists(duell_helpers_DuellConfigHelper.getDuellUserFileLocation()):
			duell_helpers_LogHelper.info("     parsing user file")
			self.parseXML(duell_helpers_DuellConfigHelper.getDuellUserFileLocation())

	def parseProjectFile(self):
		duell_helpers_LogHelper.info("     parsing configuration file in current directory")
		projectFile = haxe_io_Path.join([Sys.getCwd(), duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME])
		libFile = haxe_io_Path.join([Sys.getCwd(), duell_defines_DuellDefines.LIB_CONFIG_FILENAME])
		if sys_FileSystem.exists(projectFile):
			self.parseXML(projectFile)
		elif sys_FileSystem.exists(libFile):
			self.parseXML(libFile)

	def iterateDuellLibVersionsUntilEverythingIsParsedAndVersioned(self):
		while True:
			foundSomethingNotParsed = False
			libClone = None
			_g = []
			_hx_local_0 = self.duellLibVersions.iterator()
			while _hx_local_0.hasNext():
				l = _hx_local_0.next()
				_g.append(l)
			libClone = _g
			_g1 = 0
			while (_g1 < len(libClone)):
				duellLibVersion = (libClone[_g1] if _g1 >= 0 and _g1 < len(libClone) else None)
				_g1 = (_g1 + 1)
				_g2 = duellLibVersion.versionState
				if ((_g2.index) == 0):
					duell_helpers_LogHelper.info("\n")
					duell_helpers_LogHelper.info(((("checking version of " + "\x1B[1m") + HxOverrides.stringOrNull(duellLibVersion.name)) + "\x1B[0m"))
					duellLibVersion.versionState = duell_commands_VersionState.ParsedVersionUnchanged
					foundSomethingNotParsed = True
					resolvedVersion = duellLibVersion.gitVers.solveVersion(duellLibVersion.versionRequested,duell_objects_Arguments.isSet("-rc"),duell_objects_Arguments.get("-overridebranch"))
					if duellLibVersion.gitVers.needsToChangeVersion(resolvedVersion):
						duell_helpers_LogHelper.info(((("  - changing to version " + "\x1B[1m") + ("null" if resolvedVersion is None else resolvedVersion)) + "\x1B[0m"))
						duellLibVersion.gitVers.changeToVersion(resolvedVersion)
					duell_helpers_LogHelper.info(((("     parsing " + "\x1B[1m") + HxOverrides.stringOrNull(duellLibVersion.name)) + "\x1B[0m"))
					self.parseDuellLibWithName(duellLibVersion.name)
				elif ((_g2.index) == 2):
					duell_helpers_LogHelper.info("\n")
					duell_helpers_LogHelper.info(((("rechecking version of " + "\x1B[1m") + HxOverrides.stringOrNull(duellLibVersion.name)) + "\x1B[0m"))
					duellLibVersion.versionState = duell_commands_VersionState.ParsedVersionUnchanged
					resolvedVersion1 = duellLibVersion.gitVers.solveVersion(duellLibVersion.versionRequested,duell_objects_Arguments.isSet("-rc"),duell_objects_Arguments.get("-overridebranch"))
					if duellLibVersion.gitVers.needsToChangeVersion(resolvedVersion1):
						duell_helpers_LogHelper.info(((("  - changing to version " + "\x1B[1m") + ("null" if resolvedVersion1 is None else resolvedVersion1)) + "\x1B[0m"))
						if duellLibVersion.gitVers.changeToVersion(resolvedVersion1):
							foundSomethingNotParsed = True
							duell_helpers_LogHelper.info(((("     reparsing: " + "\x1B[1m") + HxOverrides.stringOrNull(duellLibVersion.name)) + "\x1B[0m"))
							self.parseDuellLibWithName(duellLibVersion.name)
				elif ((_g2.index) == 1):
					pass
				else:
					pass
			if (not foundSomethingNotParsed):
				break

	def checkVersionsOfPlugins(self):
		_hx_local_0 = self.pluginVersions.iterator()
		while _hx_local_0.hasNext():
			pluginVersion = _hx_local_0.next()
			duell_helpers_LogHelper.info("\n")
			duell_helpers_LogHelper.info(((("checking version of " + "\x1B[1m") + HxOverrides.stringOrNull(pluginVersion.lib.name)) + "\x1B[0m"))
			resolvedVersion = pluginVersion.gitVers.solveVersion(pluginVersion.lib.version,duell_objects_Arguments.isSet("-rc"),duell_objects_Arguments.get("-overridebranch"))
			if pluginVersion.gitVers.needsToChangeVersion(resolvedVersion):
				duell_helpers_LogHelper.info(((("  - changing to version " + "\x1B[1m") + ("null" if resolvedVersion is None else resolvedVersion)) + "\x1B[0m"))
				pluginVersion.gitVers.changeToVersion(resolvedVersion)
			else:
				duell_helpers_LogHelper.info(((("  - using version " + "\x1B[1m") + HxOverrides.stringOrNull(pluginVersion.gitVers.currentVersion)) + "\x1B[0m"))

	def checkDuellToolVersion(self):
		if (self.duellToolRequestedVersion is None):
			return
		duell_helpers_LogHelper.info("\n")
		duell_helpers_LogHelper.info(((("checking version of " + "\x1B[1m") + "duell tool") + "\x1B[0m"))
		resolvedVersion = self.duellToolGitVers.solveVersion(self.duellToolRequestedVersion.version,duell_objects_Arguments.isSet("-rc"),duell_objects_Arguments.get("-overridebranch"))
		if self.duellToolGitVers.needsToChangeVersion(resolvedVersion):
			duell_helpers_LogHelper.info(((("  - changing to version " + "\x1B[1m") + ("null" if resolvedVersion is None else resolvedVersion)) + "\x1B[0m"))
			duellToolPreviousVersion = self.duellToolGitVers.currentVersion
			self.duellToolGitVers.changeToVersion(resolvedVersion)
			duellToolChangedToVersion = self.duellToolGitVers.currentVersion
			if (duellToolPreviousVersion != duellToolChangedToVersion):
				self.isDifferentDuellToolVersion = True
		else:
			duell_helpers_LogHelper.info(((("  - using version " + "\x1B[1m") + HxOverrides.stringOrNull(self.duellToolGitVers.currentVersion)) + "\x1B[0m"))
		_this = self.finalToolList
		_this.append(_hx_AnonObject({'name': "duell tool", 'version': self.duellToolGitVers.currentVersion}))

	def checkHaxeVersion(self):
		duell_helpers_LogHelper.info(((("checking version of " + "\x1B[1m") + "haxe") + "\x1B[0m"))
		haxePath = Sys.getEnv("HAXEPATH")
		options = _hx_AnonObject({'systemCommand': True, 'mute': True, 'shutdownOnError': True, 'errorMessage': "Error retrieving haxe version", 'block': True})
		duellProcess = duell_objects_DuellProcess(Sys.getCwd(), haxe_io_Path.join([haxePath, "haxe"]), ["-version"], options)
		versionString = StringTools.trim(duellProcess.getCompleteStderr().toString())
		haxeVersion = duell_objects_SemVer.ofString(versionString)
		allowedHaxeVersions = None
		_this = duell_defines_DuellDefines.ALLOWED_HAXE_VERSIONS
		allowedHaxeVersions = _this.split(",")
		foundSupportedHaxeVersion = False
		_g = 0
		while (_g < len(allowedHaxeVersions)):
			element = (allowedHaxeVersions[_g] if _g >= 0 and _g < len(allowedHaxeVersions) else None)
			_g = (_g + 1)
			if duell_objects_SemVer.areCompatible(haxeVersion,duell_objects_SemVer.ofString(element)):
				foundSupportedHaxeVersion = True
				break
		if (not foundSupportedHaxeVersion):
			raise _HxException((((("DuellTool allowed Haxe versions " + HxOverrides.stringOrNull(duell_defines_DuellDefines.ALLOWED_HAXE_VERSIONS)) + " and current version ") + HxOverrides.stringOrNull(haxeVersion.toString())) + " are not compatible. Please install a haxe version that is compatible."))
		_this1 = self.finalToolList
		_this1.append(_hx_AnonObject({'name': "haxe", 'version': versionString}))

	def printFinalResult(self,duellLibs,haxelibs,plugins):
		duell_helpers_LogHelper.info((("\x1B[1m" + "DuellLibs:") + "\x1B[0m"))
		duell_helpers_LogHelper.info("\n")
		_g = 0
		while (_g < len(duellLibs)):
			lib = (duellLibs[_g] if _g >= 0 and _g < len(duellLibs) else None)
			_g = (_g + 1)
			duell_helpers_LogHelper.info(((("   " + HxOverrides.stringOrNull(lib.name)) + " - ") + HxOverrides.stringOrNull(lib.version)))
		duell_helpers_LogHelper.info("\n")
		duell_helpers_LogHelper.info((("\x1B[1m" + "HaxeLibs:") + "\x1B[0m"))
		duell_helpers_LogHelper.info("\n")
		_g1 = 0
		while (_g1 < len(haxelibs)):
			lib1 = (haxelibs[_g1] if _g1 >= 0 and _g1 < len(haxelibs) else None)
			_g1 = (_g1 + 1)
			duell_helpers_LogHelper.info(((("   " + HxOverrides.stringOrNull(lib1.name)) + " - ") + HxOverrides.stringOrNull(lib1.version)))
		if (len(plugins) > 0):
			duell_helpers_LogHelper.info("\n")
			duell_helpers_LogHelper.info((("\x1B[1m" + "Build Plugins:") + "\x1B[0m"))
			duell_helpers_LogHelper.info("\n")
			_g2 = 0
			while (_g2 < len(plugins)):
				lib2 = (plugins[_g2] if _g2 >= 0 and _g2 < len(plugins) else None)
				_g2 = (_g2 + 1)
				duell_helpers_LogHelper.info(((("   " + HxOverrides.stringOrNull(lib2.name)) + " - ") + HxOverrides.stringOrNull(lib2.version)))
		if (len(self.finalToolList) > 0):
			duell_helpers_LogHelper.info("\n")
			duell_helpers_LogHelper.info((("\x1B[1m" + "Tools:") + "\x1B[0m"))
			duell_helpers_LogHelper.info("\n")
			_g3 = 0
			_g11 = self.finalToolList
			while (_g3 < len(_g11)):
				tool = (_g11[_g3] if _g3 >= 0 and _g3 < len(_g11) else None)
				_g3 = (_g3 + 1)
				duell_helpers_LogHelper.info(((("   " + HxOverrides.stringOrNull(tool.name)) + " - ") + HxOverrides.stringOrNull(tool.version)))

	def printVersionDiffs(self):
		duell_helpers_LogHelper.info("\n")
		duell_helpers_LogHelper.info((("\x1B[1m" + "Updates to previous version:") + "\x1B[0m"))
		duell_helpers_LogHelper.info("\n")
		outputFilter = haxe_ds_StringMap()
		lockedDiffs = duell_versioning_locking_LockedVersionsHelper.getLastVersionDiffs("")
		if ((lockedDiffs is not None) and ((len(lockedDiffs) != 0))):
			_g = 0
			while (_g < len(lockedDiffs)):
				lockedDiff = (lockedDiffs[_g] if _g >= 0 and _g < len(lockedDiffs) else None)
				_g = (_g + 1)
				if (not lockedDiff.typeReadable in outputFilter.h):
					value = list()
					outputFilter.h[lockedDiff.typeReadable] = value
				_this = outputFilter.h.get(lockedDiff.typeReadable,None)
				_this.append(lockedDiff)
			_hx_local_2 = outputFilter.keys()
			while _hx_local_2.hasNext():
				key = _hx_local_2.next()
				duell_helpers_LogHelper.info((((("\x1B[1m" + "   ") + ("null" if key is None else key)) + ":") + "\x1B[0m"))
				diffs = outputFilter.h.get(key,None)
				_g1 = 0
				while (_g1 < len(diffs)):
					diff = (diffs[_g1] if _g1 >= 0 and _g1 < len(diffs) else None)
					_g1 = (_g1 + 1)
					duell_helpers_LogHelper.info(((((("   " + HxOverrides.stringOrNull(diff.name)) + " - old:") + HxOverrides.stringOrNull(diff.oldVal)) + " - new:") + HxOverrides.stringOrNull(diff.newVal)))
		else:
			duell_helpers_LogHelper.info("   None    ")
		duell_helpers_LogHelper.info("\n")

	def logVersions(self):
		duell_versioning_locking_LockedVersionsHelper.addLockedVersion(self.finalLibList.duellLibs,self.finalLibList.haxelibs,self.finalPluginList)

	def createFinalLibLists(self):
		_hx_local_0 = self.duellLibVersions.iterator()
		while _hx_local_0.hasNext():
			duellLibVersion = _hx_local_0.next()
			_this = self.finalLibList.duellLibs
			x = duell_objects_DuellLib.getDuellLib(duellLibVersion.name,duellLibVersion.gitVers.currentVersion)
			_this.append(x)
		self.finalLibList.duellLibs.sort(key= python_lib_Functools.cmp_to_key(self.sortDuellLibsByName))
		self.finalLibList.haxelibs = []
		_hx_local_1 = self.haxelibVersions.iterator()
		while _hx_local_1.hasNext():
			haxelibVersion = _hx_local_1.next()
			_this1 = self.finalLibList.haxelibs
			_this1.append(haxelibVersion)
		self.finalLibList.haxelibs.sort(key= python_lib_Functools.cmp_to_key(self.sortHaxeLibsByName))
		_hx_local_2 = self.pluginVersions.keys()
		while _hx_local_2.hasNext():
			plugin = _hx_local_2.next()
			_this2 = self.finalPluginList
			x1 = duell_objects_DuellLib.getDuellLib(self.pluginVersions.h.get(plugin,None).lib.name,self.pluginVersions.h.get(plugin,None).gitVers.currentVersion)
			_this2.append(x1)
		self.finalPluginList.sort(key= python_lib_Functools.cmp_to_key(self.sortDuellLibsByName))

	def sortDuellLibsByName(self,a,b):
		if (a.name > b.name):
			return 1
		else:
			return -1

	def sortHaxeLibsByName(self,a,b):
		if (a.name > b.name):
			return 1
		else:
			return -1

	def createSchemaXml(self):
		def _hx_local_0():
			_g = []
			_g1 = 0
			_g2 = self.finalLibList.duellLibs
			while (_g1 < len(_g2)):
				l = (_g2[_g1] if _g1 >= 0 and _g1 < len(_g2) else None)
				_g1 = (_g1 + 1)
				_g.append(l.name)
			return _g
		def _hx_local_2():
			_g11 = []
			_g21 = 0
			_g3 = self.finalPluginList
			while (_g21 < len(_g3)):
				p = (_g3[_g21] if _g21 >= 0 and _g21 < len(_g3) else None)
				_g21 = (_g21 + 1)
				_g11.append(p.name)
			return _g11
		duell_helpers_SchemaHelper.createSchemaXml(_hx_local_0(),_hx_local_2())

	def saveUpdateExecution(self):
		duellConfig = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		duellConfig.lastProjectFile = haxe_io_Path.join([Sys.getCwd(), duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME])
		duellConfig.lastProjectTime = Date.now().toString()
		duellConfig.writeToConfig()

	def lockBuildVersion(self):
		pass

	def parseDuellLibWithName(self,name):
		if (not sys_FileSystem.exists(((HxOverrides.stringOrNull(duell_helpers_DuellLibHelper.getPath(name)) + "/") + HxOverrides.stringOrNull(duell_defines_DuellDefines.LIB_CONFIG_FILENAME)))):
			duell_helpers_LogHelper.println(((("" + ("null" if name is None else name)) + " does not have a ") + HxOverrides.stringOrNull(duell_defines_DuellDefines.LIB_CONFIG_FILENAME)))
		else:
			path = ((HxOverrides.stringOrNull(duell_helpers_DuellLibHelper.getPath(name)) + "/") + HxOverrides.stringOrNull(duell_defines_DuellDefines.LIB_CONFIG_FILENAME))
			self.parseXML(path,name)

	def parseXML(self,path,sourceLibrary = "project"):
		if (sourceLibrary is None):
			sourceLibrary = "project"
		xml = haxe_xml_Fast(Xml.parse(sys_io_File.getContent(path)).firstElement())
		_this = self.currentXMLPath
		x = haxe_io_Path.directory(path)
		_this.append(x)
		_hx_local_1 = xml.get_elements()
		while _hx_local_1.hasNext():
			element = _hx_local_1.next()
			if ((self.targetPlatform is not None) and (not duell_helpers_XMLHelper.isValidElement(element,[self.targetPlatform]))):
				continue
			_g = element.get_name()
			_hx_local_0 = len(_g)
			if (_hx_local_0 == 22):
				if (_g == "supported-build-plugin"):
					name2 = None
					version2 = None
					if ((not element.has.resolve("version")) or ((element.att.resolve("version") == ""))):
						raise _HxException(("Supported builds must always specify a version. File: " + ("null" if path is None else path)))
					name2 = element.att.resolve("name")
					version2 = element.att.resolve("version")
					buildLib = duell_objects_DuellLib.getDuellLib(("duellbuild" + ("null" if name2 is None else name2)),version2)
					duell_helpers_LogHelper.info(((((("      supports build plugin " + "\x1B[1m") + ("null" if name2 is None else name2)) + "\x1B[0m") + " ") + ("null" if version2 is None else version2)))
					if duell_helpers_DuellLibHelper.isInstalled(buildLib.name):
						self.handlePluginParsed(buildLib,sourceLibrary)
					else:
						answer = duell_helpers_AskHelper.askYesOrNo((("A library for building " + ("null" if name2 is None else name2)) + " is not currently installed. Would you like to try to install it?"))
						if answer:
							duell_helpers_DuellLibHelper.install(buildLib.name)
							self.handlePluginParsed(buildLib,sourceLibrary)
						else:
							pass
			elif (_hx_local_0 == 7):
				if (_g == "haxelib"):
					name = element.att.resolve("name")
					if (name == ""):
						continue
					version = None
					if ((not element.has.resolve("version")) or ((element.att.resolve("version") == ""))):
						duell_helpers_LogHelper.info(("WARNING: Haxelib dependencies must always specify a version. This will become an error in future releases. File: " + ("null" if path is None else path)))
						version = ""
					else:
						version = element.att.resolve("version")
					haxelib = duell_objects_Haxelib.getHaxelib(name,version)
					self.handleHaxelibParsed(haxelib)
					duell_helpers_LogHelper.info(((((("      depends on haxelib " + "\x1B[1m") + HxOverrides.stringOrNull(haxelib.name)) + "\x1B[0m") + " ") + HxOverrides.stringOrNull(haxelib.version)))
				elif (_g == "include"):
					if element.has.resolve("path"):
						includePath = self.resolvePath(element.att.resolve("path"))
						self.parseXML(includePath)
			elif (_hx_local_0 == 8):
				if (_g == "duelllib"):
					name1 = None
					version1 = None
					if ((not element.has.resolve("version")) or ((element.att.resolve("version") == ""))):
						raise _HxException(("DuellLib dependencies must always specify a version. File: " + ("null" if path is None else path)))
					name1 = element.att.resolve("name")
					version1 = element.att.resolve("version")
					if ((name1 is None) or ((name1 == ""))):
						continue
					newDuellLib = duell_objects_DuellLib.getDuellLib(name1,version1)
					duell_helpers_LogHelper.info(((((("      depends on " + "\x1B[1m") + HxOverrides.stringOrNull(newDuellLib.name)) + "\x1B[0m") + " ") + HxOverrides.stringOrNull(newDuellLib.version)))
					self.handleDuellLibParsed(newDuellLib,sourceLibrary)
			elif (_hx_local_0 == 20):
				if (_g == "supported-duell-tool"):
					version3 = None
					version3 = element.att.resolve("version")
					duell_helpers_LogHelper.info(((((("      supports " + "\x1B[1m") + "duell tool ") + "\x1B[0m") + " ") + ("null" if version3 is None else version3)))
					if (self.duellToolRequestedVersion is None):
						self.duellToolRequestedVersion = _hx_AnonObject({'version': version3, 'dependTo': sourceLibrary})
					elif (version3 != self.duellToolRequestedVersion.version):
						try:
							self.duellToolRequestedVersion.version = self.duellToolGitVers.resolveVersionConflict([version3, self.duellToolRequestedVersion.version],duell_objects_Arguments.get("-overridebranch"),None,["duell tool", sourceLibrary, self.duellToolRequestedVersion.dependTo])
						except Exception as _hx_e:
							_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
							if isinstance(_hx_e1, str):
								e = _hx_e1
								raise _HxException(e)
							else:
								raise _hx_e
			else:
				pass
		_this1 = self.currentXMLPath
		if (len(_this1) == 0):
			None
		else:
			_this1.pop()

	def checkDuelllibPreConditions(self,duellLib):
		if (not duell_helpers_DuellLibHelper.isInstalled(duellLib.name)):
			answer = duell_helpers_AskHelper.askYesOrNo((("DuellLib " + HxOverrides.stringOrNull(duellLib.name)) + " is missing, would you like to install it?"))
			if answer:
				duell_helpers_DuellLibHelper.install(duellLib.name)
			else:
				raise _HxException("Cannot continue with an uninstalled lib.")
		if (not duell_helpers_DuellLibHelper.isPathValid(duellLib.name)):
			raise _HxException((((("DuellLib " + HxOverrides.stringOrNull(duellLib.name)) + " has an invalid path - ") + HxOverrides.stringOrNull(duell_helpers_DuellLibHelper.getPath(duellLib.name))) + " - check your \"haxelib list\""))

	def handleDuellLibParsed(self,newDuellLib,sourceLibrary):
		self.checkDuelllibPreConditions(newDuellLib)
		_hx_local_0 = self.duellLibVersions.keys()
		while _hx_local_0.hasNext():
			duellLibName = _hx_local_0.next()
			if (duellLibName != newDuellLib.name):
				continue
			duellLibVersion = self.duellLibVersions.h.get(newDuellLib.name,None)
			prevVersion = duellLibVersion.versionRequested
			if (prevVersion == newDuellLib.version):
				return
			newVersion = duellLibVersion.gitVers.resolveVersionConflict([duellLibVersion.versionRequested, newDuellLib.version],duell_objects_Arguments.get("-overridebranch"),None,[newDuellLib.name, duellLibVersion.dependTo, sourceLibrary])
			if (prevVersion != newVersion):
				_g = duellLibVersion.versionState
				if ((_g.index) == 1):
					duellLibVersion.versionState = duell_commands_VersionState.ParsedVersionChanged
				else:
					pass
				duellLibVersion.versionRequested = newVersion
			return
		gitVers = duell_versioning_GitVers(newDuellLib.getPath())
		newVersion1 = gitVers.resolveVersionConflict([newDuellLib.version],duell_objects_Arguments.get("-overridebranch"))
		v = _hx_AnonObject({'name': newDuellLib.name, 'gitVers': gitVers, 'versionRequested': newVersion1, 'versionState': duell_commands_VersionState.Unparsed, 'dependTo': sourceLibrary})
		self.duellLibVersions.h[newDuellLib.name] = v
		v

	def handleHaxelibParsed(self,haxelib):
		if (not haxelib.name in self.haxelibVersions.h):
			if (not haxelib.exists()):
				haxelibMessagePart = None
				haxelibMessagePart = (HxOverrides.stringOrNull(haxelib.name) + HxOverrides.stringOrNull((((" with version " + HxOverrides.stringOrNull(haxelib.version)) if ((haxelib.version != "")) else ""))))
				answer = duell_helpers_AskHelper.askYesOrNo((("Haxelib " + ("null" if haxelibMessagePart is None else haxelibMessagePart)) + " is missing, would you like to install it?"))
				if answer:
					haxelib.install()
				else:
					raise _HxException("Cannot continue with an uninstalled lib.")
			haxelib.selectVersion()
			self.haxelibVersions.h[haxelib.name] = haxelib
		else:
			existingHaxelib = self.haxelibVersions.h.get(haxelib.name,None)
			solvedlib = duell_objects_Haxelib.solveConflict(existingHaxelib,haxelib)
			if (solvedlib is None):
				raise _HxException(((((("Tried to compile with two incompatible versions (\"" + Std.string(haxelib)) + "\" and \"") + Std.string(existingHaxelib)) + "\") of the same library ") + HxOverrides.stringOrNull(haxelib.name)))
			if (solvedlib != existingHaxelib):
				solvedlib.selectVersion()
			self.haxelibVersions.h[haxelib.name] = solvedlib

	def handlePluginParsed(self,buildLib,sourceLibrary = None):
		if (not buildLib.name in self.pluginVersions.h):
			gitvers = duell_versioning_GitVers(buildLib.getPath())
			self.pluginVersions.h[buildLib.name] = _hx_AnonObject({'lib': buildLib, 'gitVers': gitvers, 'dependTo': sourceLibrary})
		else:
			plugin = self.pluginVersions.h.get(buildLib.name,None)
			prevVersion = plugin.lib.version
			newVersion = buildLib.version
			if (prevVersion != newVersion):
				try:
					solvedVersion = plugin.gitVers.resolveVersionConflict([prevVersion, newVersion],duell_objects_Arguments.get("-overridebranch"),None,[buildLib.name, plugin.dependTo, sourceLibrary])
					if (solvedVersion != prevVersion):
						plugin.lib = duell_objects_DuellLib.getDuellLib(buildLib.name,solvedVersion)
				except Exception as _hx_e:
					_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
					if isinstance(_hx_e1, str):
						e = _hx_e1
						raise _HxException(e)
					else:
						raise _hx_e

	def resolvePath(self,path):
		path = duell_helpers_PathHelper.unescape(path)
		if duell_helpers_PathHelper.isPathRooted(path):
			return path
		path = haxe_io_Path.join([python_internal_ArrayImpl._get(self.currentXMLPath, (len(self.currentXMLPath) - 1)), path])
		return path

	@staticmethod
	def duellFileHasDuellNamespace():
		projectFile = haxe_io_Path.join([Sys.getCwd(), duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME])
		libFile = haxe_io_Path.join([Sys.getCwd(), duell_defines_DuellDefines.LIB_CONFIG_FILENAME])
		if sys_FileSystem.exists(projectFile):
			return duell_helpers_SchemaHelper.hasDuellNamespace(projectFile)
		elif sys_FileSystem.exists(libFile):
			return duell_helpers_SchemaHelper.hasDuellNamespace(libFile)
		return False

	@staticmethod
	def userFileHasDuellNamespace():
		userFile = duell_helpers_DuellConfigHelper.getDuellUserFileLocation()
		return (sys_FileSystem.exists(userFile) and duell_helpers_SchemaHelper.hasDuellNamespace(userFile))

	@staticmethod
	def validateSchemaXml():
		projectFile = haxe_io_Path.join([Sys.getCwd(), duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME])
		libFile = haxe_io_Path.join([Sys.getCwd(), duell_defines_DuellDefines.LIB_CONFIG_FILENAME])
		if sys_FileSystem.exists(projectFile):
			duell_helpers_SchemaHelper.validate(projectFile)
		elif sys_FileSystem.exists(libFile):
			duell_helpers_SchemaHelper.validate(libFile)

	@staticmethod
	def validateUserSchemaXml():
		duell_helpers_SchemaHelper.validate(duell_helpers_DuellConfigHelper.getDuellUserFileLocation())

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.finalLibList = None
		_hx_o.finalPluginList = None
		_hx_o.finalToolList = None
		_hx_o.haxelibVersions = None
		_hx_o.duellLibVersions = None
		_hx_o.pluginVersions = None
		_hx_o.buildLib = None
		_hx_o.platformName = None
		_hx_o.duellToolGitVers = None
		_hx_o.duellToolRequestedVersion = None
		_hx_o.isDifferentDuellToolVersion = None
		_hx_o.targetPlatform = None
		_hx_o.currentXMLPath = None
duell_commands_UpdateCommand._hx_class = duell_commands_UpdateCommand
_hx_classes["duell.commands.UpdateCommand"] = duell_commands_UpdateCommand


class duell_defines_DuellDefines:
	_hx_class_name = "duell.defines.DuellDefines"
	_hx_statics = ["USER_CONFIG_FILENAME", "PROJECT_CONFIG_FILENAME", "LIB_CONFIG_FILENAME", "PLATFORM_CONFIG_FILENAME", "DEFAULT_HXCPP_VERSION", "HAXE_VERSION", "ALLOWED_HAXE_VERSIONS", "DUELL_API_LEVEL"]
duell_defines_DuellDefines._hx_class = duell_defines_DuellDefines
_hx_classes["duell.defines.DuellDefines"] = duell_defines_DuellDefines


class duell_helpers_AskHelper:
	_hx_class_name = "duell.helpers.AskHelper"
	_hx_statics = ["askYesOrNo", "askString"]

	@staticmethod
	def askYesOrNo(question):
		while True:
			duell_helpers_LogHelper.print((("\x1B[1m" + ("null" if question is None else question)) + "\x1B[0m \x1B[3;37m[y/n]\x1B[0m? "))
			if duell_objects_Arguments.isSet("-yestoall"):
				duell_helpers_LogHelper.println("y")
				return True
			_g = Sys.stdin().readLine()
			if (_g == "n"):
				return False
			elif (_g == "y"):
				return True
			else:
				pass
		return None

	@staticmethod
	def askString(question,defaultResponse):
		duell_helpers_LogHelper.print((((("\x1B[1m" + ("null" if question is None else question)) + "\x1B[0m \x1B[3;37m[") + ("null" if defaultResponse is None else defaultResponse)) + "]]\x1B[0m? "))
		if duell_objects_Arguments.isSet("-yestoall"):
			duell_helpers_LogHelper.println(defaultResponse)
			return defaultResponse
		response = Sys.stdin().readLine()
		response = duell_helpers_StringHelper.strip(response)
		if (response == ""):
			return defaultResponse
		return response
duell_helpers_AskHelper._hx_class = duell_helpers_AskHelper
_hx_classes["duell.helpers.AskHelper"] = duell_helpers_AskHelper


class duell_helpers_CommandHelper:
	_hx_class_name = "duell.helpers.CommandHelper"
	_hx_statics = ["openFile", "openURL", "runCommand", "runNeko", "runHaxe", "runHaxelib", "runJava"]

	@staticmethod
	def openFile(workingDirectory,targetPath,executable = ""):
		if (executable is None):
			executable = ""
		if (executable is None):
			executable = ""
		if (duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.WINDOWS):
			if (executable == ""):
				if (targetPath.find(":\\") == -1):
					duell_helpers_CommandHelper.runCommand(workingDirectory,targetPath,[])
				else:
					duell_helpers_CommandHelper.runCommand(workingDirectory,(".\\" + ("null" if targetPath is None else targetPath)),[])
			elif (targetPath.find(":\\") == -1):
				duell_helpers_CommandHelper.runCommand(workingDirectory,executable,[targetPath])
			else:
				duell_helpers_CommandHelper.runCommand(workingDirectory,executable,[(".\\" + ("null" if targetPath is None else targetPath))])
		elif (duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.MAC):
			if (executable == ""):
				executable = "/usr/bin/open"
			if (HxString.substr(targetPath,0,1) == "/"):
				duell_helpers_CommandHelper.runCommand(workingDirectory,executable,[targetPath])
			else:
				duell_helpers_CommandHelper.runCommand(workingDirectory,executable,[("./" + ("null" if targetPath is None else targetPath))])
		else:
			if (executable == ""):
				executable = "/usr/bin/xdg-open"
			if (HxString.substr(targetPath,0,1) == "/"):
				duell_helpers_CommandHelper.runCommand(workingDirectory,executable,[targetPath])
			else:
				duell_helpers_CommandHelper.runCommand(workingDirectory,executable,[("./" + ("null" if targetPath is None else targetPath))])

	@staticmethod
	def openURL(url):
		result = 0
		if (duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.WINDOWS):
			result = duell_helpers_CommandHelper.runCommand("","cmd",["/C", "start", url])
		elif (duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.MAC):
			result = duell_helpers_CommandHelper.runCommand("","/usr/bin/open",[url])
		elif (duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.LINUX):
			result = duell_helpers_CommandHelper.runCommand("","/usr/bin/xdg-open",[url])
		else:
			raise _HxException("Unknown platform, cannot start browser")
		return result

	@staticmethod
	def runCommand(path,command,args,options = None):
		command = duell_helpers_PathHelper.escape(command)
		argString = ""
		_g = 0
		while (_g < len(args)):
			arg = (args[_g] if _g >= 0 and _g < len(args) else None)
			_g = (_g + 1)
			if (arg.find(" ") > -1):
				argString = (("null" if argString is None else argString) + HxOverrides.stringOrNull((((" \"" + ("null" if arg is None else arg)) + "\""))))
			else:
				argString = (("null" if argString is None else argString) + HxOverrides.stringOrNull(((" " + ("null" if arg is None else arg)))))
		commandString = (("null" if command is None else command) + ("null" if argString is None else argString))
		systemCommand = None
		if ((options is not None) and ((Reflect.field(options,"systemCommand") is not None))):
			systemCommand = Reflect.field(options,"systemCommand")
		else:
			systemCommand = True
		logOnlyIfVerbose = None
		if ((options is not None) and ((Reflect.field(options,"logOnlyIfVerbose") is not None))):
			logOnlyIfVerbose = Reflect.field(options,"logOnlyIfVerbose")
		else:
			logOnlyIfVerbose = True
		exitOnError = None
		if ((options is not None) and ((Reflect.field(options,"exitOnError") is not None))):
			exitOnError = Reflect.field(options,"exitOnError")
		else:
			exitOnError = True
		errorMessage = None
		if ((options is not None) and ((Reflect.field(options,"errorMessage") is not None))):
			errorMessage = Reflect.field(options,"errorMessage")
		else:
			errorMessage = None
		nonErrorExitCodes = None
		if ((options is not None) and ((Reflect.field(options,"nonErrorExitCodes") is not None))):
			nonErrorExitCodes = Reflect.field(options,"nonErrorExitCodes")
		else:
			nonErrorExitCodes = [0]
		message = None
		message = ((((" - Running command: " + "\x1B[1m") + ("null" if commandString is None else commandString)) + "\x1B[0m") + HxOverrides.stringOrNull((((" - in path: " + ("null" if path is None else path)) if (((path is not None) and ((path != "")))) else ""))))
		if logOnlyIfVerbose:
			duell_helpers_LogHelper.info("",message)
		else:
			duell_helpers_LogHelper.info(message,"")
		if ((not systemCommand) and ((duell_helpers_PlatformHelper.get_hostPlatform() != duell_helpers_Platform.WINDOWS))):
			command = ("./" + ("null" if command is None else command))
		oldPath = ""
		if ((path is not None) and ((path != ""))):
			duell_helpers_LogHelper.info("",(((((" - " + "\x1B[1m") + "Changing directory: ") + "\x1B[0m") + ("null" if path is None else path)) + ""))
			if (not sys_FileSystem.exists(path)):
				raise _HxException((("The path \"" + ("null" if path is None else path)) + "\" does not exist"))
			oldPath = Sys.getCwd()
			Sys.setCwd(path)
		result = 0
		if ((args is not None) and ((len(args) > 0))):
			result = Sys.command(command,args)
		else:
			result = Sys.command(command)
		if ((python_internal_ArrayImpl.indexOf(nonErrorExitCodes,result,None) == -1) and exitOnError):
			pathString = None
			if ((path is not None) and ((path != ""))):
				pathString = (" - in path: " + ("null" if path is None else path))
			else:
				pathString = ""
			additionalMessage = None
			if (errorMessage is not None):
				additionalMessage = (" - Action was: " + ("null" if errorMessage is None else errorMessage))
			else:
				additionalMessage = ""
			raise _HxException((((((((("Failed to run command " + "\x1B[1m") + ("null" if commandString is None else commandString)) + "\x1B[0m") + " ") + ("null" if pathString is None else pathString)) + " -  Exit code:") + Std.string(result)) + ("null" if additionalMessage is None else additionalMessage)))
		if (oldPath != ""):
			Sys.setCwd(oldPath)
		return result

	@staticmethod
	def runNeko(path,args,options = None):
		haxePath = Sys.getEnv("NEKO_INSTPATH")
		if (options is None):
			options = _hx_AnonObject({'systemCommand': True})
		else:
			Reflect.setField(options,"systemCommand",True)
		return duell_helpers_CommandHelper.runCommand(path,haxe_io_Path.join([haxePath, "neko"]),args,options)

	@staticmethod
	def runHaxe(path,args,options = None):
		haxePath = Sys.getEnv("HAXEPATH")
		if (options is None):
			options = _hx_AnonObject({'systemCommand': True})
		else:
			Reflect.setField(options,"systemCommand",True)
		if sys_FileSystem.exists(duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation()):
			outputFolder = haxe_io_Path.join([duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation(), ".tmp"])
			outputFile = haxe_io_Path.join([outputFolder, "commandHelperHaxeExec.hxml"])
			file = sys_io_File.write(outputFile,True)
			file.writeString("\n".join([python_Boot.toString1(x1,'') for x1 in args]))
			file.close()
			return duell_helpers_CommandHelper.runCommand(path,haxe_io_Path.join([haxePath, "haxe"]),[outputFile],options)
		else:
			return duell_helpers_CommandHelper.runCommand(path,haxe_io_Path.join([haxePath, "haxe"]),args,options)

	@staticmethod
	def runHaxelib(path,args,options = None):
		haxePath = Sys.getEnv("HAXEPATH")
		if (options is None):
			options = _hx_AnonObject({'systemCommand': True})
		else:
			Reflect.setField(options,"systemCommand",True)
		return duell_helpers_CommandHelper.runCommand(path,haxe_io_Path.join([haxePath, "haxelib"]),args,options)

	@staticmethod
	def runJava(path,args,options = None):
		javaHome = Sys.getEnv("JAVA_HOME")
		javaBinaryPath = None
		_g = duell_helpers_PlatformHelper.get_hostPlatform()
		if ((_g.index) == 7):
			javaBinaryPath = haxe_io_Path.join([javaHome, "bin", "java"])
		elif ((_g.index) == 9):
			javaBinaryPath = haxe_io_Path.join([javaHome, "bin", "java.exe"])
		else:
			javaBinaryPath = "java"
		return duell_helpers_CommandHelper.runCommand(path,javaBinaryPath,args,options)
duell_helpers_CommandHelper._hx_class = duell_helpers_CommandHelper
_hx_classes["duell.helpers.CommandHelper"] = duell_helpers_CommandHelper


class duell_helpers_ConnectionHelper:
	_hx_class_name = "duell.helpers.ConnectionHelper"
	_hx_statics = ["TIMEOUT", "online", "initialized", "isOnline"]

	@staticmethod
	def isOnline():
		if (not duell_helpers_ConnectionHelper.initialized):
			duell_helpers_ConnectionHelper.initialized = True
			try:
				python_urllib_Request.urlopen("http://www.google.com",**python__KwArgs_KwArgs_Impl_.fromT(_hx_AnonObject({'timeout': 5})))
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				error = _hx_e1
				duell_helpers_LogHelper.println("")
				duell_helpers_LogHelper.warn("Running duell tool in offline mode, this might cause undesired behaviors!")
				duell_helpers_LogHelper.println("")
				duell_helpers_ConnectionHelper.online = False
		return duell_helpers_ConnectionHelper.online
duell_helpers_ConnectionHelper._hx_class = duell_helpers_ConnectionHelper
_hx_classes["duell.helpers.ConnectionHelper"] = duell_helpers_ConnectionHelper


class duell_helpers_DuellConfigHelper:
	_hx_class_name = "duell.helpers.DuellConfigHelper"
	_hx_statics = ["getDuellConfigFolderLocation", "getDuellConfigFileLocation", "checkIfDuellConfigExists", "getDuellUserFileLocation"]

	@staticmethod
	def getDuellConfigFolderLocation():
		env = Sys.environment()
		home = ""
		if "HOME" in env.h:
			home = env.h.get("HOME",None)
		elif "USERPROFILE" in env.h:
			home = env.h.get("USERPROFILE",None)
		else:
			return None
		return haxe_io_Path.join([home, ".duell"])

	@staticmethod
	def getDuellConfigFileLocation():
		return (HxOverrides.stringOrNull(duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation()) + "/config.json")

	@staticmethod
	def checkIfDuellConfigExists():
		return (sys_FileSystem.exists(duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation()) and sys_FileSystem.exists(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation()))

	@staticmethod
	def getDuellUserFileLocation():
		return ((HxOverrides.stringOrNull(duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation()) + "/") + HxOverrides.stringOrNull(duell_defines_DuellDefines.USER_CONFIG_FILENAME))
duell_helpers_DuellConfigHelper._hx_class = duell_helpers_DuellConfigHelper
_hx_classes["duell.helpers.DuellConfigHelper"] = duell_helpers_DuellConfigHelper


class duell_helpers_DuellLibHelper:
	_hx_class_name = "duell.helpers.DuellLibHelper"
	_hx_statics = ["caches", "isInstalled", "getHaxelibPathOutput", "isPathValid", "getPath", "updateNeeded", "update", "install", "serializeCaches", "deserializeCaches"]

	@staticmethod
	def isInstalled(name):
		if (python_internal_ArrayImpl.indexOf(duell_helpers_DuellLibHelper.caches.existsCache,name,None) != -1):
			return True
		haxelibPathOutput = duell_helpers_DuellLibHelper.getHaxelibPathOutput(name)
		if (haxelibPathOutput.find("is not installed") == -1):
			_this = duell_helpers_DuellLibHelper.caches.existsCache
			_this.append(name)
			return True
		return False

	@staticmethod
	def getHaxelibPathOutput(name):
		if name in duell_helpers_DuellLibHelper.caches.haxelibPathOutputCache.h:
			return duell_helpers_DuellLibHelper.caches.haxelibPathOutputCache.h.get(name,None)
		haxePath = Sys.getEnv("HAXEPATH")
		systemCommand = None
		if ((haxePath is not None) and ((haxePath != ""))):
			systemCommand = False
		else:
			systemCommand = True
		proc = duell_objects_DuellProcess(haxePath, "haxelib", ["path", ("duell_" + ("null" if name is None else name))], _hx_AnonObject({'block': True, 'systemCommand': systemCommand, 'errorMessage': "getting path of library"}))
		output = proc.getCompleteStdout()
		stringOutput = output.toString()
		duell_helpers_DuellLibHelper.caches.haxelibPathOutputCache.h[name] = stringOutput
		return stringOutput

	@staticmethod
	def isPathValid(name):
		return sys_FileSystem.exists(duell_helpers_DuellLibHelper.getPath(name))

	@staticmethod
	def getPath(name):
		if name in duell_helpers_DuellLibHelper.caches.pathCache.h:
			return duell_helpers_DuellLibHelper.caches.pathCache.h.get(name,None)
		if (not duell_helpers_DuellLibHelper.isInstalled(name)):
			raise _HxException((("Could not find duellLib '" + ("null" if name is None else name)) + "'."))
		haxeLibPathOutput = duell_helpers_DuellLibHelper.getHaxelibPathOutput(name)
		lines = haxeLibPathOutput.split("\n")
		_g1 = 1
		_g = len(lines)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			if StringTools.startsWith(StringTools.trim((lines[i] if i >= 0 and i < len(lines) else None)),"-D"):
				value = StringTools.trim(python_internal_ArrayImpl._get(lines, (i - 1)))
				duell_helpers_DuellLibHelper.caches.pathCache.h[name] = value
		if (duell_helpers_DuellLibHelper.caches.pathCache.h.get(name,None) == ""):
			try:
				_g2 = 0
				while (_g2 < len(lines)):
					line = (lines[_g2] if _g2 >= 0 and _g2 < len(lines) else None)
					_g2 = (_g2 + 1)
					if ((line != "") and ((HxString.substr(line,0,1) != "-"))):
						if sys_FileSystem.exists(line):
							duell_helpers_DuellLibHelper.caches.pathCache.h[name] = line
							break
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				pass
		return duell_helpers_DuellLibHelper.caches.pathCache.h.get(name,None)

	@staticmethod
	def updateNeeded(name):
		path = duell_helpers_DuellLibHelper.getPath(name)
		return duell_helpers_GitHelper.updateNeeded(path)

	@staticmethod
	def update(name):
		duell_helpers_GitHelper.pull(duell_helpers_DuellLibHelper.getPath(name))

	@staticmethod
	def install(name):
		duell_helpers_DuellLibHelper.caches.haxelibPathOutputCache.remove(name)
		duellLibList = duell_helpers_DuellLibListHelper.getDuellLibReferenceList()
		if name in duellLibList.h:
			duellLibList.h.get(name,None).install()
		else:
			raise _HxException((("Couldn't find the Duell Library reference in the repo list for " + ("null" if name is None else name)) + ". Can't install it."))

	@staticmethod
	def serializeCaches():
		serializer = haxe_Serializer()
		serializer.serialize(duell_helpers_DuellLibHelper.caches)
		s = serializer.toString()
		return s

	@staticmethod
	def deserializeCaches(cache):
		duell_helpers_DuellLibHelper.caches = haxe_Unserializer(cache).unserialize()
duell_helpers_DuellLibHelper._hx_class = duell_helpers_DuellLibHelper
_hx_classes["duell.helpers.DuellLibHelper"] = duell_helpers_DuellLibHelper


class duell_helpers_DuellLibListHelper:
	_hx_class_name = "duell.helpers.DuellLibListHelper"
	_hx_statics = ["DEPENDENCY_LIST_FILENAME", "repoListCache", "getDuellLibReferenceList", "validateAndCleanRepos", "addLibsToTheRepoCache", "getDuplicatesFromRepoLists", "createDuplicateList", "libraryExists"]

	@staticmethod
	def getDuellLibReferenceList():
		if (duell_helpers_DuellLibListHelper.repoListCache is not None):
			return duell_helpers_DuellLibListHelper.repoListCache
		duell_helpers_DuellLibListHelper.repoListCache = haxe_ds_StringMap()
		duellConfig = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		libListFolder = ((HxOverrides.stringOrNull(duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation()) + "/") + "lib_list")
		duell_helpers_DuellLibListHelper.validateAndCleanRepos(duellConfig,libListFolder)
		repoListIndex = 1
		reverseRepoListduellConfig = list(duellConfig.repoListURLs)
		reverseRepoListduellConfig.reverse()
		_g = 0
		while (_g < len(reverseRepoListduellConfig)):
			repoURL = (reverseRepoListduellConfig[_g] if _g >= 0 and _g < len(reverseRepoListduellConfig) else None)
			_g = (_g + 1)
			path = ((("null" if libListFolder is None else libListFolder) + "/") + Std.string(repoListIndex))
			if (duell_helpers_GitHelper.clone(repoURL,path) != 0):
				raise _HxException(((("Can't access the repo list in " + ("null" if repoURL is None else repoURL)) + " or something is wrong with the folder ") + ("null" if path is None else path)))
			try:
				configContent = sys_io_File.getContent((("null" if path is None else path) + "/haxe-repo-list.json"))
				configJSON = python_lib_Json.loads(configContent,**python__KwArgs_KwArgs_Impl_.fromT(_hx_AnonObject({'object_hook': python_Lib.dictToAnon})))
				duell_helpers_DuellLibListHelper.addLibsToTheRepoCache(configJSON)
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				if isinstance(_hx_e1, haxe_io_Error):
					e = _hx_e1
					raise _HxException((("Cannot Parse repo list. Check if this file is correct: " + ("null" if path is None else path)) + "/haxe-repo-list.json"))
				else:
					raise _hx_e
			repoListIndex = (repoListIndex + 1)
		return duell_helpers_DuellLibListHelper.repoListCache

	@staticmethod
	def validateAndCleanRepos(duellConfig,libListFolder):
		if ((duellConfig.repoListURLs is None) or ((len(duellConfig.repoListURLs) == 0))):
			raise _HxException("No repo urls are defined. Run \"duell setup\" to fix this.")
		if sys_FileSystem.exists(libListFolder):
			duell_helpers_LogHelper.info("","Cleaning up existing lib lists...")
			duell_helpers_PathHelper.removeDirectory(libListFolder)

	@staticmethod
	def addLibsToTheRepoCache(configJSON):
		listOfRepos = python_Boot.fields(configJSON)
		duellLibMap = haxe_ds_StringMap()
		duplicates = False
		_g = 0
		while (_g < len(listOfRepos)):
			repo = (listOfRepos[_g] if _g >= 0 and _g < len(listOfRepos) else None)
			_g = (_g + 1)
			repoInfo = Reflect.field(configJSON,repo)
			if repo in duell_helpers_DuellLibListHelper.repoListCache.h:
				duplicates = True
			value = duell_objects_DuellLibReference(repo, repoInfo.git_path, repoInfo.library_path, repoInfo.destination_path)
			duell_helpers_DuellLibListHelper.repoListCache.h[repo] = value
		if duplicates:
			duell_helpers_LogHelper.info("Duplicates found in the repo list URLs. List duplicates by using \"duell repo_list\" command.")
			duell_helpers_LogHelper.info(" ")

	@staticmethod
	def getDuplicatesFromRepoLists():
		duellConfig = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		libListFolder = ((HxOverrides.stringOrNull(duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation()) + "/") + "lib_list")
		duell_helpers_DuellLibListHelper.validateAndCleanRepos(duellConfig,libListFolder)
		source = haxe_ds_StringMap()
		duplicates = haxe_ds_StringMap()
		repoListIndex = 1
		reverseRepoListduellConfig = list(duellConfig.repoListURLs)
		reverseRepoListduellConfig.reverse()
		_g = 0
		while (_g < len(reverseRepoListduellConfig)):
			repoURL = (reverseRepoListduellConfig[_g] if _g >= 0 and _g < len(reverseRepoListduellConfig) else None)
			_g = (_g + 1)
			path = ((("null" if libListFolder is None else libListFolder) + "/") + Std.string(repoListIndex))
			if (duell_helpers_GitHelper.clone(repoURL,path) != 0):
				raise _HxException(((("Can't access the repo list in " + ("null" if repoURL is None else repoURL)) + " or something is wrong with the folder ") + ("null" if path is None else path)))
			try:
				configContent = sys_io_File.getContent((("null" if path is None else path) + "/haxe-repo-list.json"))
				configJSON = python_lib_Json.loads(configContent,**python__KwArgs_KwArgs_Impl_.fromT(_hx_AnonObject({'object_hook': python_Lib.dictToAnon})))
				duell_helpers_DuellLibListHelper.createDuplicateList(configJSON,source,duplicates)
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				if isinstance(_hx_e1, haxe_io_Error):
					e = _hx_e1
					raise _HxException((("Cannot Parse repo list. Check if this file is correct: " + ("null" if path is None else path)) + "/haxe-repo-list.json"))
				else:
					raise _hx_e
			repoListIndex = (repoListIndex + 1)
		return duplicates

	@staticmethod
	def createDuplicateList(configJSON,source,duplicates):
		listOfRepos = python_Boot.fields(configJSON)
		_g = 0
		while (_g < len(listOfRepos)):
			repo = (listOfRepos[_g] if _g >= 0 and _g < len(listOfRepos) else None)
			_g = (_g + 1)
			repoInfo = Reflect.field(configJSON,repo)
			if repo in source.h:
				duplicateList = None
				if (not repo in duplicates.h):
					duplicateList = [source.h.get(repo,None)]
					duplicates.h[repo] = duplicateList
				duplicateList = duplicates.h.get(repo,None)
				x = duell_objects_DuellLibReference(repo, repoInfo.git_path, repoInfo.library_path, repoInfo.destination_path)
				duplicateList.append(x)
			else:
				value = duell_objects_DuellLibReference(repo, repoInfo.git_path, repoInfo.library_path, repoInfo.destination_path)
				source.h[repo] = value

	@staticmethod
	def libraryExists(name):
		if (name is None):
			return False
		_hx_list = duell_helpers_DuellLibListHelper.getDuellLibReferenceList()
		_hx_local_0 = _hx_list.keys()
		while _hx_local_0.hasNext():
			key = _hx_local_0.next()
			if (key == name):
				return True
		return False
duell_helpers_DuellLibListHelper._hx_class = duell_helpers_DuellLibListHelper
_hx_classes["duell.helpers.DuellLibListHelper"] = duell_helpers_DuellLibListHelper


class duell_helpers_FileHelper:
	_hx_class_name = "duell.helpers.FileHelper"
	_hx_statics = ["binaryExtensions", "textExtensions", "isNewer", "isText", "copyIfNewer", "getAllFilesInDir", "recursiveCopyFiles"]

	@staticmethod
	def isNewer(source,destination):
		if ((source is None) or (not sys_FileSystem.exists(source))):
			raise _HxException((("Source path \"" + ("null" if source is None else source)) + "\" does not exist"))
		if sys_FileSystem.exists(destination):
			if (python_lib_Os.stat(source).st_ctime < python_lib_Os.stat(destination).st_ctime):
				return False
		return True

	@staticmethod
	def isText(source):
		if (not sys_FileSystem.exists(source)):
			return False
		input = sys_io_File.read(source,True)
		numChars = 0
		numBytes = 0
		try:
			while (numBytes < 512):
				byte = input.readByte()
				numBytes = (numBytes + 1)
				if (byte == 0):
					input.close()
					return False
				if ((((byte > 8) and ((byte < 16))) or (((byte >= 32) and ((byte < 256))))) or ((byte > 287))):
					numChars = (numChars + 1)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			pass
		input.close()
		if ((numBytes == 0) or (((numChars / numBytes) > 0.7))):
			return True
		return False

	@staticmethod
	def copyIfNewer(source,destination):
		if (not duell_helpers_FileHelper.isNewer(source,destination)):
			return
		duell_helpers_PathHelper.mkdir(haxe_io_Path.directory(destination))
		duell_helpers_LogHelper.info("",(((" - \x1B[1mCopying file:\x1B[0m " + ("null" if source is None else source)) + " \x1B[3;37m->\x1B[0m ") + ("null" if destination is None else destination)))
		try:
			sys_io_File.copy(source,destination)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			e = _hx_e1
			try:
				if sys_FileSystem.exists(destination):
					raise _HxException((("Cannot copy to \"" + ("null" if destination is None else destination)) + "\", is the file in use?"))
					return
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				pass
			raise _HxException((("Cannot open \"" + ("null" if destination is None else destination)) + "\" for writing, do you have correct access permissions?"))

	@staticmethod
	def getAllFilesInDir(source):
		files = None
		retFiles = []
		try:
			files = sys_FileSystem.readDirectory(source)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			e = _hx_e1
			raise _HxException((("Could not find source directory \"" + ("null" if source is None else source)) + "\""))
		_g = 0
		while (_g < len(files)):
			file = (files[_g] if _g >= 0 and _g < len(files) else None)
			_g = (_g + 1)
			if ((file != ".") and ((file != ".."))):
				itemSource = ((("null" if source is None else source) + "/") + ("null" if file is None else file))
				if sys_FileSystem.isDirectory(itemSource):
					duell_helpers_FileHelper.getAllFilesInDir(itemSource)
				else:
					retFiles.append(itemSource)
		return retFiles

	@staticmethod
	def recursiveCopyFiles(source,destination,onlyIfNewer = True,purgeDestination = False):
		if (onlyIfNewer is None):
			onlyIfNewer = True
		if (purgeDestination is None):
			purgeDestination = False
		duell_helpers_PathHelper.mkdir(destination)
		if (duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.WINDOWS):
			purgeArg = None
			if purgeDestination:
				purgeArg = "/MIR"
			else:
				purgeArg = "/E"
			duell_helpers_CommandHelper.runCommand("","robocopy",["/COPY:DAT", "/NJH", "/NJS", purgeArg, source, destination],_hx_AnonObject({'systemCommand': True, 'nonErrorExitCodes': [0, 1, 2, 3, 5]}))
		elif purgeDestination:
			duell_helpers_CommandHelper.runCommand("","cp",["-pR", (("null" if source is None else source) + "/"), destination],_hx_AnonObject({'systemCommand': True}))
		else:
			files = None
			try:
				files = sys_FileSystem.readDirectory(source)
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				e = _hx_e1
				raise _HxException((("Could not find source directory \"" + ("null" if source is None else source)) + "\""))
			_g = 0
			while (_g < len(files)):
				file = (files[_g] if _g >= 0 and _g < len(files) else None)
				_g = (_g + 1)
				if ((file != ".") and ((file != ".."))):
					itemDestination = ((("null" if destination is None else destination) + "/") + ("null" if file is None else file))
					itemSource = ((("null" if source is None else source) + "/") + ("null" if file is None else file))
					if sys_FileSystem.isDirectory(itemSource):
						duell_helpers_FileHelper.recursiveCopyFiles(itemSource,itemDestination,onlyIfNewer)
					elif ((not onlyIfNewer) or duell_helpers_FileHelper.isNewer(itemSource,itemDestination)):
						duell_helpers_CommandHelper.runCommand("","cp",["-p", itemSource, itemDestination],_hx_AnonObject({'systemCommand': True}))
duell_helpers_FileHelper._hx_class = duell_helpers_FileHelper
_hx_classes["duell.helpers.FileHelper"] = duell_helpers_FileHelper


class duell_helpers_GitHelper:
	_hx_class_name = "duell.helpers.GitHelper"
	_hx_statics = ["setRemoteURL", "clone", "pull", "updateNeeded", "isRepoWithoutLocalChanges", "fetch", "getCurrentBranch", "getCurrentCommit", "getCurrentTags", "getCommitForTag", "listRemotes", "listBranches", "listTags", "checkoutBranch", "checkoutCommit"]

	@staticmethod
	def setRemoteURL(path,remoteName,url):
		gitProcess = duell_objects_DuellProcess(path, "git", ["remote", "set-url", remoteName, url], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'errorMessage': "setting git remote url"}))
		gitProcess.blockUntilFinished()
		return gitProcess.exitCode()

	@staticmethod
	def clone(gitURL,path):
		duell_helpers_PathHelper.mkdir(path)
		pathComponents = path.split("/")
		folder = None
		folder = (None if ((len(pathComponents) == 0)) else pathComponents.pop())
		path = "/".join([python_Boot.toString1(x1,'') for x1 in pathComponents])
		gitProcess = duell_objects_DuellProcess(path, "git", ["clone", gitURL, folder], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'errorMessage': "cloning git"}))
		gitProcess.blockUntilFinished()
		return gitProcess.exitCode()

	@staticmethod
	def pull(destination):
		if (not duell_helpers_ConnectionHelper.isOnline()):
			return 0
		gitProcess = duell_objects_DuellProcess(destination, "git", ["pull"], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'errorMessage': "pulling git"}))
		gitProcess.blockUntilFinished()
		return gitProcess.exitCode()

	@staticmethod
	def updateNeeded(destination):
		if (not duell_helpers_ConnectionHelper.isOnline()):
			return False
		result = ""
		gitProcess = duell_objects_DuellProcess(destination, "git", ["remote", "update"], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "checking for update on git"}))
		gitProcess = duell_objects_DuellProcess(destination, "git", ["status", "-b", "--porcelain"], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "checking for update on git"}))
		output = gitProcess.getCompleteStdout().toString()
		if (output.find("[behind") != -1):
			return True
		else:
			return False

	@staticmethod
	def isRepoWithoutLocalChanges(destination):
		gitProcess = duell_objects_DuellProcess(destination, "git", ["status", "-s", "--porcelain"], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "checking for local changes on git"}))
		output = gitProcess.getCompleteStdout().toString()
		changesListStrings = output.split("\n")
		def _hx_local_0(_hx_str):
			return StringTools.trim(_hx_str)
		changesListStringsTrimmed = list(map(_hx_local_0,changesListStrings))
		_g = 0
		while (_g < len(changesListStringsTrimmed)):
			str1 = (changesListStringsTrimmed[_g] if _g >= 0 and _g < len(changesListStringsTrimmed) else None)
			_g = (_g + 1)
			if ((str1 != "") and (not StringTools.startsWith(str1,"??"))):
				return False
		return True

	@staticmethod
	def fetch(destination):
		if (not duell_helpers_ConnectionHelper.isOnline()):
			return
		duell_objects_DuellProcess(destination, "git", ["fetch", "--tags", "--prune"], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "fetching git"}))

	@staticmethod
	def getCurrentBranch(destination):
		gitProcess = duell_objects_DuellProcess(destination, "git", ["rev-parse", "--verify", "--abbrev-ref", "HEAD"], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "getting current branch on git"}))
		output = gitProcess.getCompleteStdout().toString()
		return HxOverrides.arrayGet(output.split("\n"), 0)

	@staticmethod
	def getCurrentCommit(destination):
		gitProcess = duell_objects_DuellProcess(destination, "git", ["rev-parse", "--verify", "HEAD"], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "getting current commit on git"}))
		output = gitProcess.getCompleteStdout().toString()
		return HxOverrides.arrayGet(output.split("\n"), 0)

	@staticmethod
	def getCurrentTags(destination):
		gitProcess = duell_objects_DuellProcess(destination, "git", ["tag", "--contains", "HEAD"], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "getting current tags on git"}))
		output = gitProcess.getCompleteStdout().toString()
		return output.split("\n")

	@staticmethod
	def getCommitForTag(destination,tag):
		gitProcess = duell_objects_DuellProcess(destination, "git", ["rev-parse", (("null" if tag is None else tag) + "~0")], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "getting commit for tag on git"}))
		output = gitProcess.getCompleteStdout().toString()
		return HxOverrides.arrayGet(output.split("\n"), 0)

	@staticmethod
	def listRemotes(destination):
		gitProcess = duell_objects_DuellProcess(destination, "git", ["remote", "-v"], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "listing remotes on git"}))
		allRemotes = gitProcess.getCompleteStdout().toString()
		allRemoteList = allRemotes.split("\n")
		returnedMap = haxe_ds_StringMap()
		_g = 0
		while (_g < len(allRemoteList)):
			line = (allRemoteList[_g] if _g >= 0 and _g < len(allRemoteList) else None)
			_g = (_g + 1)
			remoteParts = None
			_this = StringTools.trim(line)
			remoteParts = _this.split(" ")
			_this1 = (remoteParts[0] if 0 < len(remoteParts) else None)
			remoteParts = _this1.split("\t")
			if (len(remoteParts) < 2):
				continue
			remoteName = StringTools.trim((remoteParts[0] if 0 < len(remoteParts) else None))
			remoteUrl = StringTools.trim((remoteParts[1] if 1 < len(remoteParts) else None))
			if (not remoteName in returnedMap.h):
				returnedMap.h[remoteName] = remoteUrl
		return returnedMap

	@staticmethod
	def listBranches(destination):
		gitProcess = duell_objects_DuellProcess(destination, "git", ["branch", "-a"], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "listing branches on git"}))
		outputAllBranches = gitProcess.getCompleteStdout().toString()
		outputList = outputAllBranches.split("\n")
		returnedList = []
		_g = 0
		while (_g < len(outputList)):
			line = (outputList[_g] if _g >= 0 and _g < len(outputList) else None)
			_g = (_g + 1)
			branch = None
			remote = None
			if ((("" if ((0 >= len(line))) else line[0])) == "*"):
				line = HxString.substr(line,1,None)
			line = StringTools.trim(line)
			if StringTools.startsWith(line,"remotes/"):
				line = HxString.substr(line,len("remotes/"),None)
				_hx_len = line.find("/")
				remote = HxString.substr(line,0,_hx_len)
				pos = (line.find("/") + 1)
				branch = HxString.substr(line,pos,None)
				if (python_internal_ArrayImpl.indexOf(returnedList,branch,None) == -1):
					returnedList.append(branch)
			else:
				branch = line
				returnedList.append(branch)
		return returnedList

	@staticmethod
	def listTags(destination):
		gitProcess = duell_objects_DuellProcess(destination, "git", ["tag"], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "listing tags on git"}))
		output = gitProcess.getCompleteStdout().toString()
		return output.split("\n")

	@staticmethod
	def checkoutBranch(destination,branch):
		gitProcess = duell_objects_DuellProcess(destination, "git", ["checkout", branch], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "checking out branch on git"}))
		return gitProcess.exitCode()

	@staticmethod
	def checkoutCommit(destination,commit):
		gitProcess = duell_objects_DuellProcess(destination, "git", ["checkout", commit], _hx_AnonObject({'systemCommand': True, 'loggingPrefix': "[Git]", 'block': True, 'shutdownOnError': True, 'errorMessage': "checking out commit on git"}))
		return gitProcess.exitCode()
duell_helpers_GitHelper._hx_class = duell_helpers_GitHelper
_hx_classes["duell.helpers.GitHelper"] = duell_helpers_GitHelper


class duell_helpers_HXCPPConfigXMLHelper:
	_hx_class_name = "duell.helpers.HXCPPConfigXMLHelper"
	_hx_statics = ["getProbableHXCPPConfigLocation"]

	@staticmethod
	def getProbableHXCPPConfigLocation():
		env = Sys.environment()
		home = duell_helpers_PathHelper.getHomeFolder()
		return (("null" if home is None else home) + "/.hxcpp_config.xml")
duell_helpers_HXCPPConfigXMLHelper._hx_class = duell_helpers_HXCPPConfigXMLHelper
_hx_classes["duell.helpers.HXCPPConfigXMLHelper"] = duell_helpers_HXCPPConfigXMLHelper


class duell_helpers_LogHelper:
	_hx_class_name = "duell.helpers.LogHelper"
	_hx_statics = ["enableColor", "mute", "verbose", "colorCodes", "colorSupported", "sentWarnings", "RED", "YELLOW", "DARK_GREEN", "NORMAL", "BOLD", "UNDERLINE", "get_enableColor", "get_mute", "get_verbose", "exitWithFormattedError", "info", "print", "println", "warn", "stripColor", "wrapInfo", "cutoutMetadata"]
	enableColor = None
	mute = None
	verbose = None

	@staticmethod
	def get_enableColor():
		return (not duell_objects_Arguments.isSet("-nocolor"))

	@staticmethod
	def get_mute():
		return duell_objects_Arguments.isSet("-mute")

	@staticmethod
	def get_verbose():
		return duell_objects_Arguments.isSet("-verbose")

	@staticmethod
	def exitWithFormattedError(message,verboseMessage = "",e = None):
		if (verboseMessage is None):
			verboseMessage = ""
		if ((message != "") and (not duell_helpers_LogHelper.get_mute())):
			output = None
			if (duell_helpers_LogHelper.get_verbose() and ((verboseMessage != ""))):
				output = (("\x1B[31;1mError:\x1B[0m\x1B[1m " + ("null" if verboseMessage is None else verboseMessage)) + "\x1B[0m\n")
			else:
				output = (("\x1B[31;1mError:\x1B[0m \x1B[1m" + ("null" if message is None else message)) + "\x1B[0m\n")
			Sys.stderr().write(haxe_io_Bytes.ofString(duell_helpers_LogHelper.stripColor(output)))
		Sys.exit(-1)

	@staticmethod
	def info(message,verboseMessage = ""):
		if (verboseMessage is None):
			verboseMessage = ""
		if (not duell_helpers_LogHelper.get_mute()):
			if (duell_helpers_LogHelper.get_verbose() and ((verboseMessage != ""))):
				duell_helpers_LogHelper.println(verboseMessage)
			elif (message != ""):
				duell_helpers_LogHelper.println(message)

	@staticmethod
	def print(message):
		Sys.print(duell_helpers_LogHelper.stripColor(message))

	@staticmethod
	def println(message):
		Sys.println(duell_helpers_LogHelper.stripColor(message))

	@staticmethod
	def warn(message,verboseMessage = "",allowRepeat = False):
		if (verboseMessage is None):
			verboseMessage = ""
		if (allowRepeat is None):
			allowRepeat = False
		if (not duell_helpers_LogHelper.get_mute()):
			output = ""
			if (duell_helpers_LogHelper.get_verbose() and ((verboseMessage != ""))):
				output = (("\x1B[33;1mWarning:\x1B[0m \x1B[1m" + ("null" if verboseMessage is None else verboseMessage)) + "\x1B[0m")
			elif (message != ""):
				output = (("\x1B[33;1mWarning:\x1B[0m \x1B[1m" + ("null" if message is None else message)) + "\x1B[0m")
			if ((not allowRepeat) and output in duell_helpers_LogHelper.sentWarnings.h):
				return
			duell_helpers_LogHelper.sentWarnings.h[output] = True
			duell_helpers_LogHelper.println(output)

	@staticmethod
	def stripColor(output):
		if (duell_helpers_LogHelper.colorSupported is None):
			if (duell_helpers_PlatformHelper.get_hostPlatform() != duell_helpers_Platform.WINDOWS):
				result = -1
				try:
					process = sys_io_Process("tput", ["colors"])
					result = process.exitCode()
					process.close()
				except Exception as _hx_e:
					_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
					pass
				duell_helpers_LogHelper.colorSupported = (result == 0)
			else:
				duell_helpers_LogHelper.colorSupported = (Sys.getEnv("ANSICON") is not None)
		if (duell_helpers_LogHelper.get_enableColor() and duell_helpers_LogHelper.colorSupported):
			return output
		else:
			try:
				return duell_helpers_LogHelper.colorCodes.replace(output,"")
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				e1 = _hx_e1
				print("error on color replace")
				return output

	@staticmethod
	def wrapInfo(message,msgArgs = None,lineColor = "\x1B[31;1m",wrappingSign = "-"):
		if (lineColor is None):
			lineColor = "\x1B[31;1m"
		if (wrappingSign is None):
			wrappingSign = "-"
		if (msgArgs is not None):
			_g1 = 0
			_g = len(msgArgs)
			while (_g1 < _g):
				i = _g1
				_g1 = (_g1 + 1)
				_hx_str = (msgArgs[i] if i >= 0 and i < len(msgArgs) else None)
				message = StringTools.replace(message,(("#{" + Std.string(i)) + "}"),_hx_str)
		rawMessage = duell_helpers_LogHelper.colorCodes.replace(message,"")
		line = ""
		_g11 = 0
		_g2 = len(rawMessage)
		while (_g11 < _g2):
			i1 = _g11
			_g11 = (_g11 + 1)
			line = (("null" if line is None else line) + ("null" if wrappingSign is None else wrappingSign))
		message = (((((((((("\n" + ("null" if lineColor is None else lineColor)) + ("null" if line is None else line)) + "\x1B[0m") + "\n") + ("null" if message is None else message)) + "\n") + ("null" if lineColor is None else lineColor)) + ("null" if line is None else line)) + "\x1B[0m") + "\n")
		duell_helpers_LogHelper.info(message)

	@staticmethod
	def cutoutMetadata(value):
		copy = value
		return duell_helpers_LogHelper.colorCodes.replace(copy,"")
duell_helpers_LogHelper._hx_class = duell_helpers_LogHelper
_hx_classes["duell.helpers.LogHelper"] = duell_helpers_LogHelper


class duell_helpers_PathHelper:
	_hx_class_name = "duell.helpers.PathHelper"
	_hx_statics = ["mkdir", "unescape", "escape", "expand", "stripQuotes", "isLink", "removeDirectory", "getRecursiveFileListUnderFolder", "getRecursiveFolderListUnderFolder", "getFolderListUnderFolder", "getHomeFolder", "isPathRooted"]

	@staticmethod
	def mkdir(directory):
		directory = StringTools.replace(directory,"\\","/")
		total = ""
		if (not duell_helpers_PathHelper.isPathRooted(directory)):
			total = Sys.getCwd()
		elif (duell_helpers_PlatformHelper.get_hostPlatform() != duell_helpers_Platform.WINDOWS):
			total = "/"
		parts = None
		parts = directory.split("/")
		if ((duell_helpers_PlatformHelper.get_hostPlatform() != duell_helpers_Platform.WINDOWS) and (((parts[0] if 0 < len(parts) else None) == "~"))):
			total = (("null" if total is None else total) + HxOverrides.stringOrNull(duell_helpers_PathHelper.getHomeFolder()))
			if (len(parts) == 0):
				None
			else:
				parts.pop(0)
		def _hx_local_1():
			_this = (parts[0] if 0 < len(parts) else None)
			return ("" if ((1 >= len(_this))) else _this[1])
		if (((duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.WINDOWS) and ((len((parts[0] if 0 < len(parts) else None)) == 2))) and ((_hx_local_1() == ":"))):
			total = (("null" if total is None else total) + HxOverrides.stringOrNull((None if ((len(parts) == 0)) else parts.pop(0))))
		oldPath = ""
		_g = 0
		while (_g < len(parts)):
			part = (parts[_g] if _g >= 0 and _g < len(parts) else None)
			_g = (_g + 1)
			if ((part != ".") and ((part != ""))):
				total = haxe_io_Path.join([total, part])
				if (not sys_FileSystem.exists(total)):
					duell_helpers_LogHelper.info("",(" - \x1B[1mCreating directory:\x1B[0m " + ("null" if total is None else total)))
					sys_FileSystem.createDirectory(total)

	@staticmethod
	def unescape(path):
		path = StringTools.replace(path,"\\ "," ")
		if ((duell_helpers_PlatformHelper.get_hostPlatform() != duell_helpers_Platform.WINDOWS) and StringTools.startsWith(path,"~/")):
			path = haxe_io_Path.join([duell_helpers_PathHelper.getHomeFolder(), HxString.substr(path,2,None)])
		return path

	@staticmethod
	def escape(path):
		if (duell_helpers_PlatformHelper.get_hostPlatform() != duell_helpers_Platform.WINDOWS):
			path = StringTools.replace(path,"\\ "," ")
			path = StringTools.replace(path," ","\\ ")
			path = StringTools.replace(path,"\\'","'")
			path = StringTools.replace(path,"'","\\'")
		return duell_helpers_PathHelper.expand(path)

	@staticmethod
	def expand(path):
		if (path is None):
			path = ""
		if (duell_helpers_PlatformHelper.get_hostPlatform() != duell_helpers_Platform.WINDOWS):
			if StringTools.startsWith(path,"~/"):
				path = ((HxOverrides.stringOrNull(Sys.getEnv("HOME")) + "/") + HxOverrides.stringOrNull(HxString.substr(path,2,None)))
		return path

	@staticmethod
	def stripQuotes(path):
		if (path is not None):
			_this = path.split("\"")
			return "".join([python_Boot.toString1(x1,'') for x1 in _this])
		return path

	@staticmethod
	def isLink(path):
		if (duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.MAC):
			process = duell_objects_DuellProcess("", "readlink", [path], _hx_AnonObject({'systemCommand': True, 'block': True, 'mute': True}))
			output = process.getCompleteStdout().toString()
			if ((output is None) or ((output == ""))):
				return False
			else:
				return True
		return False

	@staticmethod
	def removeDirectory(directory):
		if sys_FileSystem.exists(directory):
			if (duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.WINDOWS):
				
				import os
				import stat

				for root, dirs, files in os.walk(directory, topdown=False):
					for name in files:
						filename = os.path.join(root, name)
						os.chmod(filename, stat.S_IWUSR)
						os.remove(filename)
					for name in dirs:
						os.rmdir(os.path.join(root, name))
				os.rmdir(directory)
			else:
				
				import shutil
				shutil.rmtree(directory)

	@staticmethod
	def getRecursiveFileListUnderFolder(folder,gatheredFileList = None,prefix = ""):
		if (prefix is None):
			prefix = ""
		if (gatheredFileList is None):
			gatheredFileList = []
		files = []
		try:
			files = sys_FileSystem.readDirectory(folder)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			e = _hx_e1
			raise _HxException((("Could not find folder directory \"" + ("null" if folder is None else folder)) + "\""))
		_g = 0
		while (_g < len(files)):
			file = (files[_g] if _g >= 0 and _g < len(files) else None)
			_g = (_g + 1)
			if (HxString.substr(file,0,1) != "."):
				fullPath = haxe_io_Path.join([folder, file])
				if sys_FileSystem.isDirectory(fullPath):
					duell_helpers_PathHelper.getRecursiveFileListUnderFolder(fullPath,gatheredFileList,haxe_io_Path.join([prefix, file]))
				else:
					x = haxe_io_Path.join([prefix, file])
					gatheredFileList.append(x)
		return gatheredFileList

	@staticmethod
	def getRecursiveFolderListUnderFolder(folder,gatheredFolderList = None,prefix = ""):
		if (prefix is None):
			prefix = ""
		if (gatheredFolderList is None):
			gatheredFolderList = []
		files = []
		try:
			files = sys_FileSystem.readDirectory(folder)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			e = _hx_e1
			raise _HxException((("Could not find folder directory \"" + ("null" if folder is None else folder)) + "\""))
		_g = 0
		while (_g < len(files)):
			file = (files[_g] if _g >= 0 and _g < len(files) else None)
			_g = (_g + 1)
			if (HxString.substr(file,0,1) != "."):
				fullPath = haxe_io_Path.join([folder, file])
				if sys_FileSystem.isDirectory(fullPath):
					x = haxe_io_Path.join([prefix, file])
					gatheredFolderList.append(x)
					duell_helpers_PathHelper.getRecursiveFolderListUnderFolder(fullPath,gatheredFolderList,haxe_io_Path.join([prefix, file]))
		return gatheredFolderList

	@staticmethod
	def getFolderListUnderFolder(folder,gatheredFolderList = None):
		if (gatheredFolderList is None):
			gatheredFolderList = []
		files = []
		try:
			files = sys_FileSystem.readDirectory(folder)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			e = _hx_e1
			raise _HxException((("Could not find folder directory \"" + ("null" if folder is None else folder)) + "\""))
		_g = 0
		while (_g < len(files)):
			file = (files[_g] if _g >= 0 and _g < len(files) else None)
			_g = (_g + 1)
			if (HxString.substr(file,0,1) != "."):
				fullPath = haxe_io_Path.join([folder, file])
				if sys_FileSystem.isDirectory(fullPath):
					x = haxe_io_Path.join(["", file])
					gatheredFolderList.append(x)
		return gatheredFolderList

	@staticmethod
	def getHomeFolder():
		env = Sys.environment()
		if "HOME" in env.h:
			return env.h.get("HOME",None)
		elif "USERPROFILE" in env.h:
			return env.h.get("USERPROFILE",None)
		else:
			raise _HxException("No home variable is set!!")

	@staticmethod
	def isPathRooted(path):
		if ((((("" if ((0 >= len(path))) else path[0])) == "/") or (((("" if ((0 >= len(path))) else path[0])) == "\\"))) or (((("" if ((1 >= len(path))) else path[1])) == ":"))):
			return True
		return False
duell_helpers_PathHelper._hx_class = duell_helpers_PathHelper
_hx_classes["duell.helpers.PathHelper"] = duell_helpers_PathHelper

class duell_helpers_Platform(Enum):
	_hx_class_name = "duell.helpers.Platform"
	_hx_constructs = ["ANDROID", "BLACKBERRY", "FIREFOXOS", "FLASH", "HTML5", "IOS", "LINUX", "MAC", "TIZEN", "WINDOWS", "WEBOS", "EMSCRIPTEN", "MACANE"]
duell_helpers_Platform.ANDROID = duell_helpers_Platform("ANDROID", 0, list())
duell_helpers_Platform.BLACKBERRY = duell_helpers_Platform("BLACKBERRY", 1, list())
duell_helpers_Platform.FIREFOXOS = duell_helpers_Platform("FIREFOXOS", 2, list())
duell_helpers_Platform.FLASH = duell_helpers_Platform("FLASH", 3, list())
duell_helpers_Platform.HTML5 = duell_helpers_Platform("HTML5", 4, list())
duell_helpers_Platform.IOS = duell_helpers_Platform("IOS", 5, list())
duell_helpers_Platform.LINUX = duell_helpers_Platform("LINUX", 6, list())
duell_helpers_Platform.MAC = duell_helpers_Platform("MAC", 7, list())
duell_helpers_Platform.TIZEN = duell_helpers_Platform("TIZEN", 8, list())
duell_helpers_Platform.WINDOWS = duell_helpers_Platform("WINDOWS", 9, list())
duell_helpers_Platform.WEBOS = duell_helpers_Platform("WEBOS", 10, list())
duell_helpers_Platform.EMSCRIPTEN = duell_helpers_Platform("EMSCRIPTEN", 11, list())
duell_helpers_Platform.MACANE = duell_helpers_Platform("MACANE", 12, list())
duell_helpers_Platform._hx_class = duell_helpers_Platform
_hx_classes["duell.helpers.Platform"] = duell_helpers_Platform

class duell_helpers_Architecture(Enum):
	_hx_class_name = "duell.helpers.Architecture"
	_hx_constructs = ["ARMV5", "ARMV6", "ARMV7", "X86", "X64"]
duell_helpers_Architecture.ARMV5 = duell_helpers_Architecture("ARMV5", 0, list())
duell_helpers_Architecture.ARMV6 = duell_helpers_Architecture("ARMV6", 1, list())
duell_helpers_Architecture.ARMV7 = duell_helpers_Architecture("ARMV7", 2, list())
duell_helpers_Architecture.X86 = duell_helpers_Architecture("X86", 3, list())
duell_helpers_Architecture.X64 = duell_helpers_Architecture("X64", 4, list())
duell_helpers_Architecture._hx_class = duell_helpers_Architecture
_hx_classes["duell.helpers.Architecture"] = duell_helpers_Architecture


class duell_helpers_PlatformHelper:
	_hx_class_name = "duell.helpers.PlatformHelper"
	_hx_statics = ["hostArchitecture", "hostPlatform", "_hostArchitecture", "_hostPlatform", "get_hostArchitecture", "get_hostPlatform"]
	hostArchitecture = None
	hostPlatform = None
	_hostArchitecture = None
	_hostPlatform = None

	@staticmethod
	def get_hostArchitecture():
		if (duell_helpers_PlatformHelper._hostArchitecture is None):
			_g = duell_helpers_PlatformHelper.get_hostPlatform()
			if ((_g.index) == 9):
				architecture = Sys.getEnv("PROCESSOR_ARCHITEW6432")
				if ((architecture is not None) and ((architecture.find("64") > -1))):
					duell_helpers_PlatformHelper._hostArchitecture = duell_helpers_Architecture.X64
				else:
					duell_helpers_PlatformHelper._hostArchitecture = duell_helpers_Architecture.X86
			elif (((_g.index) == 7) or (((_g.index) == 6))):
				process = sys_io_Process("uname", ["-m"])
				output = process.stdout.readAll().toString()
				error = process.stderr.readAll().toString()
				process.exitCode()
				if (output.find("64") > -1):
					duell_helpers_PlatformHelper._hostArchitecture = duell_helpers_Architecture.X64
				else:
					duell_helpers_PlatformHelper._hostArchitecture = duell_helpers_Architecture.X86
			else:
				duell_helpers_PlatformHelper._hostArchitecture = duell_helpers_Architecture.ARMV6
			duell_helpers_LogHelper.info("",(" - \x1B[1mDetected host architecture:\x1B[0m " + HxOverrides.stringOrNull(duell_helpers_StringHelper.formatEnum(duell_helpers_PlatformHelper._hostArchitecture))))
		return duell_helpers_PlatformHelper._hostArchitecture

	@staticmethod
	def get_hostPlatform():
		if (duell_helpers_PlatformHelper._hostPlatform is None):
			systemName = Sys.systemName()
			def _hx_local_0():
				_this = EReg("window", "i")
				_this.matchObj = python_lib_Re.search(_this.pattern,systemName)
				return (_this.matchObj is not None)
			if _hx_local_0():
				duell_helpers_PlatformHelper._hostPlatform = duell_helpers_Platform.WINDOWS
			else:
				def _hx_local_1():
					_this1 = EReg("linux", "i")
					_this1.matchObj = python_lib_Re.search(_this1.pattern,systemName)
					return (_this1.matchObj is not None)
				if _hx_local_1():
					duell_helpers_PlatformHelper._hostPlatform = duell_helpers_Platform.LINUX
				else:
					def _hx_local_2():
						_this2 = EReg("mac", "i")
						_this2.matchObj = python_lib_Re.search(_this2.pattern,systemName)
						return (_this2.matchObj is not None)
					if _hx_local_2():
						duell_helpers_PlatformHelper._hostPlatform = duell_helpers_Platform.MAC
			platformName = duell_helpers_StringHelper.formatEnum(duell_helpers_PlatformHelper._hostPlatform)
			duell_helpers_LogHelper.info("",(" - \x1B[1mDetected host platform:\x1B[0m " + ("null" if platformName is None else platformName)))
		return duell_helpers_PlatformHelper._hostPlatform
duell_helpers_PlatformHelper._hx_class = duell_helpers_PlatformHelper
_hx_classes["duell.helpers.PlatformHelper"] = duell_helpers_PlatformHelper


class duell_helpers_PythonImportHelper:
	_hx_class_name = "duell.helpers.PythonImportHelper"
	_hx_statics = ["runPythonFile"]

	@staticmethod
	def runPythonFile(path):
		python_sys_Path.append(haxe_io_Path.directory(path))
		python_ImportLib.import_module(haxe_io_Path.withoutExtension(haxe_io_Path.withoutDirectory(path)))
duell_helpers_PythonImportHelper._hx_class = duell_helpers_PythonImportHelper
_hx_classes["duell.helpers.PythonImportHelper"] = duell_helpers_PythonImportHelper


class duell_helpers_SchemaHelper:
	_hx_class_name = "duell.helpers.SchemaHelper"
	_hx_statics = ["DUELL_NS", "SCHEMA_FILE", "SCHEMA_FOLDER", "TEMPLATED_SCHEMA_FILE", "COMMON_SCHEMA_FILE", "hasDuellNamespace", "validate", "createSchemaXml"]

	@staticmethod
	def hasDuellNamespace(pathXml):
		data = sys_io_File.getContent(pathXml)
		def _hx_local_1():
			def _hx_local_0():
				_hx_str = (("xmlns=\"" + "duell") + "\"")
				return data.find(_hx_str)
			return (_hx_local_0() != -1)
		return _hx_local_1()

	@staticmethod
	def validate(pathXml):
		if (duell_helpers_PlatformHelper.get_hostPlatform() == duell_helpers_Platform.WINDOWS):
			duell_helpers_LogHelper.info("Currently XML Validation is disabled on Windows pending a bug fix.")
			return
		duellPath = duell_helpers_DuellLibHelper.getPath("duell")
		toolPath = haxe_io_Path.join([duellPath, "bin"])
		schemaPath = haxe_io_Path.join([duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation(), "schema.xsd"])
		duell_helpers_CommandHelper.runJava(toolPath,["-jar", "schema_validator.jar", schemaPath, pathXml],_hx_AnonObject({'errorMessage': ("Failed to validate schema for file: " + ("null" if pathXml is None else pathXml))}))

	@staticmethod
	def createSchemaXml(duelllibs,plugins):
		duellPath = duell_helpers_DuellLibHelper.getPath("duell")
		schemaPath = haxe_io_Path.join([duellPath, "schema", "duell_schema.xsd"])
		librariesWithSchema = []
		pluginsWithSchema = []
		librariesWithoutSchema = []
		pluginsWithoutSchema = []
		_g = 0
		while (_g < len(duelllibs)):
			duelllib = (duelllibs[_g] if _g >= 0 and _g < len(duelllibs) else None)
			_g = (_g + 1)
			duellLibPath = duell_helpers_DuellLibHelper.getPath(duelllib)
			duellLibSchemaPath = haxe_io_Path.join([duellLibPath, "schema.xsd"])
			if sys_FileSystem.exists(duellLibSchemaPath):
				librariesWithSchema.append(_hx_AnonObject({'name': duelllib, 'path': duellLibSchemaPath}))
			else:
				librariesWithoutSchema.append(duelllib)
		_g1 = 0
		while (_g1 < len(plugins)):
			plugin = (plugins[_g1] if _g1 >= 0 and _g1 < len(plugins) else None)
			_g1 = (_g1 + 1)
			duellLibPath1 = duell_helpers_DuellLibHelper.getPath(plugin)
			duellLibSchemaPath1 = haxe_io_Path.join([duellLibPath1, "schema.xsd"])
			rawPluginName = HxString.substr(plugin,10,None)
			if sys_FileSystem.exists(duellLibSchemaPath1):
				pluginsWithSchema.append(_hx_AnonObject({'name': rawPluginName, 'path': duellLibSchemaPath1}))
			else:
				pluginsWithoutSchema.append(rawPluginName)
		outPath = haxe_io_Path.join([duell_helpers_DuellConfigHelper.getDuellConfigFolderLocation(), "schema.xsd"])
		template = _hx_AnonObject({'NS': "duell", 'COMMON_FILE': "https://raw.githubusercontent.com/gameduell/duell/master/schema/common_schema.xsd", 'LIBRARIES_WITH_SCHEMA': librariesWithSchema, 'PLUGINS_WITH_SCHEMA': pluginsWithSchema, 'LIBRARIES_WITHOUT_SCHEMA': librariesWithoutSchema, 'PLUGINS_WITHOUT_SCHEMA': pluginsWithoutSchema})
		duell_helpers_TemplateHelper.copyTemplateFile(schemaPath,outPath,template,None)
duell_helpers_SchemaHelper._hx_class = duell_helpers_SchemaHelper
_hx_classes["duell.helpers.SchemaHelper"] = duell_helpers_SchemaHelper


class duell_helpers_StringHelper:
	_hx_class_name = "duell.helpers.StringHelper"
	_hx_statics = ["seedNumber", "usedFlatNames", "uuidChars", "formatArray", "formatEnum", "formatUppercaseVariable", "generateUUID", "getFlatName", "getUniqueID", "underline", "strip"]

	@staticmethod
	def formatArray(array):
		output = "[ "
		_g1 = 0
		_g = len(array)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			output = (("null" if output is None else output) + Std.string((array[i] if i >= 0 and i < len(array) else None)))
			if (i < ((len(array) - 1))):
				output = (("null" if output is None else output) + ", ")
			else:
				output = (("null" if output is None else output) + " ")
		output = (("null" if output is None else output) + "]")
		return output

	@staticmethod
	def formatEnum(value):
		return ((HxOverrides.stringOrNull(Type.getEnumName(Type.getEnum(value))) + ".") + Std.string(value))

	@staticmethod
	def formatUppercaseVariable(name):
		variableName = ""
		lastWasUpperCase = False
		_g1 = 0
		_g = len(name)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			char = None
			if ((i < 0) or ((i >= len(name)))):
				char = ""
			else:
				char = name[i]
			if ((char == char.upper()) and ((i > 0))):
				if lastWasUpperCase:
					def _hx_local_0():
						index = (i + 1)
						return ("" if (((index < 0) or ((index >= len(name))))) else name[index])
					def _hx_local_1():
						_this = None
						index1 = (i + 1)
						if ((index1 < 0) or ((index1 >= len(name)))):
							_this = ""
						else:
							_this = name[index1]
						return _this.upper()
					if ((i == ((len(name) - 1))) or ((_hx_local_0() == _hx_local_1()))):
						variableName = (("null" if variableName is None else variableName) + ("null" if char is None else char))
					else:
						variableName = (("null" if variableName is None else variableName) + HxOverrides.stringOrNull((("_" + ("null" if char is None else char)))))
				else:
					variableName = (("null" if variableName is None else variableName) + HxOverrides.stringOrNull((("_" + ("null" if char is None else char)))))
				lastWasUpperCase = True
			else:
				variableName = (("null" if variableName is None else variableName) + HxOverrides.stringOrNull(char.upper()))
				lastWasUpperCase = False
		return variableName

	@staticmethod
	def generateUUID(length,radix = None,seed = None):
		chars = None
		_this = duell_helpers_StringHelper.uuidChars
		chars = list(_this)
		if ((radix is None) or ((radix > len(chars)))):
			radix = len(chars)
		elif (radix < 2):
			radix = 2
		if (seed is None):
			seed = Math.floor((python_lib_Random.random() * 2147483647.0))
		uuid = []
		seedValue = None
		v = Reflect.field(Math,"fabs")(seed)
		seedValue = Math.floor((v + 0.5))
		_g = 0
		while (_g < length):
			i = _g
			_g = (_g + 1)
			def _hx_local_1():
				_hx_local_0 = None
				try:
					_hx_local_0 = int(HxOverrides.modf((seedValue * 16807.0), 2147483647.0))
				except Exception as _hx_e:
					_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
					e = _hx_e1
					_hx_local_0 = None
				return _hx_local_0
			seedValue = _hx_local_1()
			def _hx_local_3():
				_hx_local_2 = None
				try:
					_hx_local_2 = int(((seedValue / 2147483647.0) * radix))
				except Exception as _hx_e:
					_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
					e1 = _hx_e1
					_hx_local_2 = None
				return _hx_local_2
			python_internal_ArrayImpl._set(uuid, i, python_internal_ArrayImpl._get(chars, (0 | _hx_local_3())))
		return "".join([python_Boot.toString1(x1,'') for x1 in uuid])

	@staticmethod
	def getFlatName(name):
		chars = name.lower()
		flatName = ""
		_g1 = 0
		_g = len(chars)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			code = HxString.charCodeAt(chars,i)
			if (((((i > 0) and ((code >= HxString.charCodeAt("0",0)))) and ((code <= HxString.charCodeAt("9",0)))) or (((code >= HxString.charCodeAt("a",0)) and ((code <= HxString.charCodeAt("z",0)))))) or ((code == HxString.charCodeAt("_",0)))):
				if ((i < 0) or ((i >= len(chars)))):
					flatName = (("null" if flatName is None else flatName) + "")
				else:
					flatName = (("null" if flatName is None else flatName) + Std.string(chars[i]))
			else:
				flatName = (("null" if flatName is None else flatName) + "_")
		if (flatName == ""):
			flatName = "_"
		if (HxString.substr(flatName,0,1) == "_"):
			flatName = ("file" + ("null" if flatName is None else flatName))
		while flatName in duell_helpers_StringHelper.usedFlatNames.h:
			match = EReg("(.*?)(\\d+)", "")
			def _hx_local_3():
				match.matchObj = python_lib_Re.search(match.pattern,flatName)
				return (match.matchObj is not None)
			if _hx_local_3():
				flatName = (HxOverrides.stringOrNull(match.matchObj.group(1)) + Std.string(((Std.parseInt(match.matchObj.group(2)) + 1))))
			else:
				flatName = (("null" if flatName is None else flatName) + "1")
		duell_helpers_StringHelper.usedFlatNames.h[flatName] = "1"
		return flatName

	@staticmethod
	def getUniqueID():
		def _hx_local_3():
			def _hx_local_2():
				_hx_local_0 = duell_helpers_StringHelper
				_hx_local_1 = _hx_local_0.seedNumber
				_hx_local_0.seedNumber = (_hx_local_1 + 1)
				return _hx_local_1
			return StringTools.hex(_hx_local_2(),8)
		return _hx_local_3()

	@staticmethod
	def underline(string,character = "="):
		if (character is None):
			character = "="
		return ((("null" if string is None else string) + "\n") + HxOverrides.stringOrNull(StringTools.lpad("",character,len(string))))

	@staticmethod
	def strip(string,charsToRemove = " "):
		if (charsToRemove is None):
			charsToRemove = " "
		indexFromLeft = 0
		indexFromRight = 0
		_g1 = 0
		_g = len(string)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			foundCharToRemove = False
			_g3 = 0
			_g2 = len(charsToRemove)
			while (_g3 < _g2):
				j = _g3
				_g3 = (_g3 + 1)
				if ((("" if (((i < 0) or ((i >= len(string))))) else string[i])) == (("" if (((j < 0) or ((j >= len(charsToRemove))))) else charsToRemove[j]))):
					foundCharToRemove = True
					break
			if foundCharToRemove:
				continue
			else:
				indexFromLeft = i
				break
		i1 = (len(string) - 1)
		while (i1 >= 0):
			foundCharToRemove1 = False
			_g11 = 0
			_g4 = len(charsToRemove)
			while (_g11 < _g4):
				j1 = _g11
				_g11 = (_g11 + 1)
				if ((("" if (((i1 < 0) or ((i1 >= len(string))))) else string[i1])) == (("" if (((j1 < 0) or ((j1 >= len(charsToRemove))))) else charsToRemove[j1]))):
					foundCharToRemove1 = True
					break
			if foundCharToRemove1:
				continue
			else:
				indexFromRight = (i1 + 1)
				break
			i1 = (i1 - 1)
		if (indexFromLeft >= indexFromRight):
			return ""
		return HxString.substring(string,indexFromLeft,(indexFromRight - indexFromLeft))
duell_helpers_StringHelper._hx_class = duell_helpers_StringHelper
_hx_classes["duell.helpers.StringHelper"] = duell_helpers_StringHelper

class duell_helpers__TemplateHelper_TemplateExpr(Enum):
	_hx_class_name = "duell.helpers._TemplateHelper.TemplateExpr"
	_hx_constructs = ["OpVar", "OpExpr", "OpIf", "OpStr", "OpBlock", "OpForeach", "OpMacro"]

	@staticmethod
	def OpVar(v):
		return duell_helpers__TemplateHelper_TemplateExpr("OpVar", 0, [v])

	@staticmethod
	def OpExpr(expr):
		return duell_helpers__TemplateHelper_TemplateExpr("OpExpr", 1, [expr])

	@staticmethod
	def OpIf(expr,eif,eelse):
		return duell_helpers__TemplateHelper_TemplateExpr("OpIf", 2, [expr,eif,eelse])

	@staticmethod
	def OpStr(str):
		return duell_helpers__TemplateHelper_TemplateExpr("OpStr", 3, [str])

	@staticmethod
	def OpBlock(l):
		return duell_helpers__TemplateHelper_TemplateExpr("OpBlock", 4, [l])

	@staticmethod
	def OpForeach(expr,loop):
		return duell_helpers__TemplateHelper_TemplateExpr("OpForeach", 5, [expr,loop])

	@staticmethod
	def OpMacro(name,params):
		return duell_helpers__TemplateHelper_TemplateExpr("OpMacro", 6, [name,params])
duell_helpers__TemplateHelper_TemplateExpr._hx_class = duell_helpers__TemplateHelper_TemplateExpr
_hx_classes["duell.helpers._TemplateHelper.TemplateExpr"] = duell_helpers__TemplateHelper_TemplateExpr


class duell_helpers_Template:
	_hx_class_name = "duell.helpers.Template"
	_hx_fields = ["expr", "context", "foreach_index_stack", "macros", "stack", "buf"]
	_hx_methods = ["execute", "resolve", "parseTokens", "parseBlock", "parse", "parseExpr", "makeConst", "makePath", "makeExpr", "makeExpr2", "run"]
	_hx_statics = ["splitter", "expr_splitter", "expr_trim", "expr_int", "expr_float", "globals"]

	def __init__(self,_hx_str):
		self.expr = None
		self.context = None
		self.foreach_index_stack = None
		self.macros = None
		self.stack = None
		self.buf = None
		self.foreach_index_stack = []
		tokens = self.parseTokens(_hx_str)
		self.expr = self.parseBlock(tokens)
		if (not tokens.isEmpty()):
			raise _HxException((("Unexpected '" + Std.string(tokens.first().s)) + "'"))

	def execute(self,context,macros = None):
		if (macros is None):
			self.macros = _hx_AnonObject({})
		else:
			self.macros = macros
		self.context = context
		self.stack = List()
		self.buf = StringBuf()
		self.run(self.expr)
		return self.buf.b.getvalue()

	def resolve(self,v):
		if hasattr(self.context,(("_hx_" + v) if (v in python_Boot.keywords) else (("_hx_" + v) if (((((len(v) > 2) and ((ord(v[0]) == 95))) and ((ord(v[1]) == 95))) and ((ord(v[(len(v) - 1)]) != 95)))) else v))):
			return Reflect.field(self.context,v)
		_g_head = self.stack.h
		_g_val = None
		while (_g_head is not None):
			ctx = None
			_g_val = (_g_head[0] if 0 < len(_g_head) else None)
			_g_head = (_g_head[1] if 1 < len(_g_head) else None)
			ctx = _g_val
			if hasattr(ctx,(("_hx_" + v) if (v in python_Boot.keywords) else (("_hx_" + v) if (((((len(v) > 2) and ((ord(v[0]) == 95))) and ((ord(v[1]) == 95))) and ((ord(v[(len(v) - 1)]) != 95)))) else v))):
				return Reflect.field(ctx,v)
		if (v == "__current__"):
			return self.context
		if (v == "__index__"):
			return python_internal_ArrayImpl._get(self.foreach_index_stack, (len(self.foreach_index_stack) - 1))
		return Reflect.field(duell_helpers_Template.globals,v)

	def parseTokens(self,data):
		tokens = List()
		def _hx_local_0():
			_this = duell_helpers_Template.splitter
			_this.matchObj = python_lib_Re.search(_this.pattern,data)
			return (_this.matchObj is not None)
		while _hx_local_0():
			p = None
			_this1 = duell_helpers_Template.splitter
			p = _hx_AnonObject({'pos': _this1.matchObj.start(), 'len': (_this1.matchObj.end() - _this1.matchObj.start())})
			if (p.pos > 0):
				tokens.add(_hx_AnonObject({'p': HxString.substr(data,0,p.pos), 's': True, 'l': None}))
			if (HxString.charCodeAt(data,p.pos) == 58):
				tokens.add(_hx_AnonObject({'p': HxString.substr(data,(p.pos + 2),(p.len - 4)), 's': False, 'l': None}))
				_this2 = duell_helpers_Template.splitter
				pos = _this2.matchObj.end()
				data = HxString.substr(_this2.matchObj.string,pos,None)
				continue
			parp = (p.pos + p.len)
			npar = 1
			params = []
			part = ""
			while True:
				c = HxString.charCodeAt(data,parp)
				parp = (parp + 1)
				if (c == 40):
					npar = (npar + 1)
				elif (c == 41):
					npar = (npar - 1)
					if (npar <= 0):
						break
				elif (c is None):
					raise _HxException("Unclosed macro parenthesis")
				if ((c == 44) and ((npar == 1))):
					params.append(part)
					part = ""
				else:
					part = (("null" if part is None else part) + HxOverrides.stringOrNull("".join(map(chr,[c]))))
			params.append(part)
			tokens.add(_hx_AnonObject({'p': duell_helpers_Template.splitter.matchObj.group(2), 's': False, 'l': params}))
			data = HxString.substr(data,parp,(len(data) - parp))
		if (len(data) > 0):
			tokens.add(_hx_AnonObject({'p': data, 's': True, 'l': None}))
		return tokens

	def parseBlock(self,tokens):
		l = List()
		while True:
			t = tokens.first()
			if (t is None):
				break
			if ((not t.s) and ((((t.p == "end") or ((t.p == "else"))) or ((HxString.substr(t.p,0,7) == "elseif "))))):
				break
			l.add(self.parse(tokens))
		if (l.length == 1):
			return l.first()
		return duell_helpers__TemplateHelper_TemplateExpr.OpBlock(l)

	def parse(self,tokens):
		t = tokens.pop()
		p = t.p
		if t.s:
			return duell_helpers__TemplateHelper_TemplateExpr.OpStr(p)
		if (t.l is not None):
			pe = List()
			_g = 0
			_g1 = t.l
			while (_g < len(_g1)):
				p1 = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
				_g = (_g + 1)
				pe.add(self.parseBlock(self.parseTokens(p1)))
			return duell_helpers__TemplateHelper_TemplateExpr.OpMacro(p,pe)
		if (HxString.substr(p,0,3) == "if "):
			p = HxString.substr(p,3,(len(p) - 3))
			e = self.parseExpr(p)
			eif = self.parseBlock(tokens)
			t1 = tokens.first()
			eelse = None
			if (t1 is None):
				raise _HxException("Unclosed 'if'")
			if (t1.p == "end"):
				tokens.pop()
				eelse = None
			elif (t1.p == "else"):
				tokens.pop()
				eelse = self.parseBlock(tokens)
				t1 = tokens.pop()
				if ((t1 is None) or ((t1.p != "end"))):
					raise _HxException("Unclosed 'else'")
			else:
				t1.p = HxString.substr(t1.p,4,(len(t1.p) - 4))
				eelse = self.parse(tokens)
			return duell_helpers__TemplateHelper_TemplateExpr.OpIf(e,eif,eelse)
		if (HxString.substr(p,0,8) == "foreach "):
			p = HxString.substr(p,8,(len(p) - 8))
			e1 = self.parseExpr(p)
			efor = self.parseBlock(tokens)
			t2 = tokens.pop()
			if ((t2 is None) or ((t2.p != "end"))):
				raise _HxException("Unclosed 'foreach'")
			return duell_helpers__TemplateHelper_TemplateExpr.OpForeach(e1,efor)
		def _hx_local_1():
			_this = duell_helpers_Template.expr_splitter
			_this.matchObj = python_lib_Re.search(_this.pattern,p)
			return (_this.matchObj is not None)
		if _hx_local_1():
			return duell_helpers__TemplateHelper_TemplateExpr.OpExpr(self.parseExpr(p))
		return duell_helpers__TemplateHelper_TemplateExpr.OpVar(p)

	def parseExpr(self,data):
		l = List()
		expr = data
		def _hx_local_0():
			_this = duell_helpers_Template.expr_splitter
			_this.matchObj = python_lib_Re.search(_this.pattern,data)
			return (_this.matchObj is not None)
		while _hx_local_0():
			p = None
			_this1 = duell_helpers_Template.expr_splitter
			p = _hx_AnonObject({'pos': _this1.matchObj.start(), 'len': (_this1.matchObj.end() - _this1.matchObj.start())})
			k = (p.pos + p.len)
			if (p.pos != 0):
				l.add(_hx_AnonObject({'p': HxString.substr(data,0,p.pos), 's': True}))
			p1 = duell_helpers_Template.expr_splitter.matchObj.group(0)
			l.add(_hx_AnonObject({'p': p1, 's': (p1.find("\"") >= 0)}))
			_this2 = duell_helpers_Template.expr_splitter
			pos = _this2.matchObj.end()
			data = HxString.substr(_this2.matchObj.string,pos,None)
		if (len(data) != 0):
			l.add(_hx_AnonObject({'p': data, 's': True}))
		e = None
		try:
			e = self.makeExpr(l)
			if (not l.isEmpty()):
				raise _HxException(l.first().p)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			if isinstance(_hx_e1, str):
				s = _hx_e1
				raise _HxException(((("Unexpected '" + ("null" if s is None else s)) + "' in ") + ("null" if expr is None else expr)))
			else:
				raise _hx_e
		def _hx_local_1():
			try:
				return e()
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				exc = _hx_e1
				raise _HxException(((("Error : " + Std.string(exc)) + " in ") + ("null" if expr is None else expr)))
		return _hx_local_1

	def makeConst(self,v):
		_this = duell_helpers_Template.expr_trim
		_this.matchObj = python_lib_Re.search(_this.pattern,v)
		(_this.matchObj is not None)
		v = duell_helpers_Template.expr_trim.matchObj.group(1)
		if (HxString.charCodeAt(v,0) == 34):
			_hx_str = HxString.substr(v,1,(len(v) - 2))
			def _hx_local_0():
				return _hx_str
			return _hx_local_0
		def _hx_local_1():
			_this1 = duell_helpers_Template.expr_int
			_this1.matchObj = python_lib_Re.search(_this1.pattern,v)
			return (_this1.matchObj is not None)
		if _hx_local_1():
			i = Std.parseInt(v)
			def _hx_local_2():
				return i
			return _hx_local_2
		def _hx_local_3():
			_this2 = duell_helpers_Template.expr_float
			_this2.matchObj = python_lib_Re.search(_this2.pattern,v)
			return (_this2.matchObj is not None)
		if _hx_local_3():
			f = Std.parseFloat(v)
			def _hx_local_4():
				return f
			return _hx_local_4
		me = self
		def _hx_local_5():
			return me.resolve(v)
		return _hx_local_5

	def makePath(self,e,l):
		p = l.first()
		if ((p is None) or ((p.p != "."))):
			return e
		l.pop()
		field = l.pop()
		if ((field is None) or (not field.s)):
			raise _HxException(field.p)
		f = field.p
		_this = duell_helpers_Template.expr_trim
		_this.matchObj = python_lib_Re.search(_this.pattern,f)
		(_this.matchObj is not None)
		f = duell_helpers_Template.expr_trim.matchObj.group(1)
		def _hx_local_1():
			def _hx_local_0():
				return Reflect.field(e(),f)
			return self.makePath(_hx_local_0,l)
		return _hx_local_1()

	def makeExpr(self,l):
		return self.makePath(self.makeExpr2(l),l)

	def makeExpr2(self,l):
		p = l.pop()
		if (p is None):
			raise _HxException("<eof>")
		if p.s:
			return self.makeConst(p.p)
		_g = p.p
		if (_g == "("):
			e1 = self.makeExpr(l)
			p1 = l.pop()
			if ((p1 is None) or p1.s):
				raise _HxException(p1.p)
			if (p1.p == ")"):
				return e1
			e2 = self.makeExpr(l)
			p2 = l.pop()
			if ((p2 is None) or ((p2.p != ")"))):
				raise _HxException(p2.p)
			_g1 = p1.p
			_hx_local_0 = len(_g1)
			if (_hx_local_0 == 1):
				if (_g1 == "+"):
					def _hx_local_1():
						return python_Boot._add_dynamic(e1(),e2())
					return _hx_local_1
				elif (_g1 == "-"):
					def _hx_local_2():
						return (e1() - e2())
					return _hx_local_2
				elif (_g1 == "*"):
					def _hx_local_3():
						return (e1() * e2())
					return _hx_local_3
				elif (_g1 == "/"):
					def _hx_local_4():
						return (e1() / e2())
					return _hx_local_4
				elif (_g1 == ">"):
					def _hx_local_5():
						return (e1() > e2())
					return _hx_local_5
				elif (_g1 == "<"):
					def _hx_local_6():
						return (e1() < e2())
					return _hx_local_6
				else:
					raise _HxException(("Unknown operation " + HxOverrides.stringOrNull(p1.p)))
			elif (_hx_local_0 == 2):
				if (_g1 == ">="):
					def _hx_local_7():
						return (e1() >= e2())
					return _hx_local_7
				elif (_g1 == "<="):
					def _hx_local_8():
						return (e1() <= e2())
					return _hx_local_8
				elif (_g1 == "=="):
					def _hx_local_9():
						return HxOverrides.eq(e1(),e2())
					return _hx_local_9
				elif (_g1 == "!="):
					def _hx_local_10():
						return not HxOverrides.eq(e1(),e2())
					return _hx_local_10
				elif (_g1 == "&&"):
					def _hx_local_11():
						return (e1() and e2())
					return _hx_local_11
				elif (_g1 == "||"):
					def _hx_local_12():
						return (e1() or e2())
					return _hx_local_12
				else:
					raise _HxException(("Unknown operation " + HxOverrides.stringOrNull(p1.p)))
			else:
				raise _HxException(("Unknown operation " + HxOverrides.stringOrNull(p1.p)))
		elif (_g == "!"):
			e = self.makeExpr(l)
			def _hx_local_13():
				v = e()
				return ((v is None) or ((v == False)))
			return _hx_local_13
		elif (_g == "-"):
			e3 = self.makeExpr(l)
			def _hx_local_14():
				return -e3()
			return _hx_local_14
		else:
			pass
		raise _HxException(p.p)

	def run(self,e):
		if ((e.index) == 0):
			v = e.params[0]
			x = Std.string(self.resolve(v))
			self.buf.b.write(Std.string(x))
		elif ((e.index) == 1):
			e1 = e.params[0]
			x1 = Std.string(e1())
			self.buf.b.write(Std.string(x1))
		elif ((e.index) == 2):
			eelse = e.params[2]
			eif = e.params[1]
			e2 = e.params[0]
			v1 = e2()
			if ((v1 is None) or ((v1 == False))):
				if (eelse is not None):
					self.run(eelse)
			else:
				self.run(eif)
		elif ((e.index) == 3):
			_hx_str = e.params[0]
			self.buf.b.write(Std.string(_hx_str))
		elif ((e.index) == 4):
			l = e.params[0]
			_g_head = l.h
			_g_val = None
			while (_g_head is not None):
				e3 = None
				def _hx_local_0():
					nonlocal _g_head
					nonlocal _g_val
					_g_val = (_g_head[0] if 0 < len(_g_head) else None)
					_g_head = (_g_head[1] if 1 < len(_g_head) else None)
					return _g_val
				e3 = _hx_local_0()
				self.run(e3)
		elif ((e.index) == 5):
			loop = e.params[1]
			e4 = e.params[0]
			v2 = e4()
			try:
				x2 = Reflect.field(v2,"iterator")()
				if (Reflect.field(x2,"hasNext") is None):
					raise _HxException(None)
				v2 = x2
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				e5 = _hx_e1
				try:
					if (Reflect.field(v2,"hasNext") is None):
						raise _HxException(None)
				except Exception as _hx_e:
					_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
					e6 = _hx_e1
					raise _HxException(("Cannot iter on " + Std.string(v2)))
			self.stack.push(self.context)
			v3 = v2
			index = 0
			_this = self.foreach_index_stack
			_this.append(index)
			_hx_local_2 = v3
			while _hx_local_2.hasNext():
				ctx = _hx_local_2.next()
				python_internal_ArrayImpl._set(self.foreach_index_stack, (len(self.foreach_index_stack) - 1), index)
				self.context = ctx
				self.run(loop)
				index = (index + 1)
			self.context = self.stack.pop()
		elif ((e.index) == 6):
			params = e.params[1]
			m = e.params[0]
			v4 = Reflect.field(self.macros,m)
			pl = list()
			old = self.buf
			pl.append(self.resolve)
			_g_head1 = params.h
			_g_val1 = None
			while (_g_head1 is not None):
				p = None
				def _hx_local_3():
					nonlocal _g_head1
					nonlocal _g_val1
					_g_val1 = (_g_head1[0] if 0 < len(_g_head1) else None)
					_g_head1 = (_g_head1[1] if 1 < len(_g_head1) else None)
					return _g_val1
				p = _hx_local_3()
				if ((p.index) == 0):
					v5 = p.params[0]
					x3 = self.resolve(v5)
					pl.append(x3)
				else:
					self.buf = StringBuf()
					self.run(p)
					x4 = self.buf.b.getvalue()
					pl.append(x4)
			self.buf = old
			try:
				x5 = Std.string(Reflect.callMethod(self.macros,v4,pl))
				self.buf.b.write(Std.string(x5))
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				e7 = _hx_e1
				plstr = None
				try:
					plstr = ",".join([python_Boot.toString1(x1,'') for x1 in pl])
				except Exception as _hx_e:
					_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
					e8 = _hx_e1
					plstr = "???"
				msg = (((((("Macro call " + ("null" if m is None else m)) + "(") + ("null" if plstr is None else plstr)) + ") failed (") + Std.string(e7)) + ")")
				raise _HxException(msg)
		else:
			pass

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.expr = None
		_hx_o.context = None
		_hx_o.foreach_index_stack = None
		_hx_o.macros = None
		_hx_o.stack = None
		_hx_o.buf = None
duell_helpers_Template._hx_class = duell_helpers_Template
_hx_classes["duell.helpers.Template"] = duell_helpers_Template


class duell_helpers_TemplateHelper:
	_hx_class_name = "duell.helpers.TemplateHelper"
	_hx_statics = ["copyTemplateFile", "recursiveCopyTemplatedFiles"]

	@staticmethod
	def copyTemplateFile(source,destination,context,templateFunctions,onlyIfNewer = True):
		if (onlyIfNewer is None):
			onlyIfNewer = True
		if duell_helpers_FileHelper.isText(source):
			duell_helpers_LogHelper.info("",(((" - \x1B[1mCopying template file:\x1B[0m " + ("null" if source is None else source)) + " \x1B[3;37m->\x1B[0m ") + ("null" if destination is None else destination)))
			fileContents = sys_io_File.getContent(source)
			template = duell_helpers_Template(fileContents)
			result = template.execute(context,templateFunctions)
			try:
				fileOutput = sys_io_File.write(destination,True)
				fileOutput.writeString(result)
				fileOutput.close()
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				e = _hx_e1
				raise _HxException((("Cannot write to file \"" + ("null" if destination is None else destination)) + "\""))
		elif ((not onlyIfNewer) or duell_helpers_FileHelper.isNewer(source,destination)):
			sys_io_File.copy(source,destination)

	@staticmethod
	def recursiveCopyTemplatedFiles(source,destination,context,templateFunctions):
		duell_helpers_PathHelper.mkdir(destination)
		files = None
		try:
			files = sys_FileSystem.readDirectory(source)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			e = _hx_e1
			raise _HxException((("Could not find source directory \"" + ("null" if source is None else source)) + "\""))
		_g = 0
		while (_g < len(files)):
			file = (files[_g] if _g >= 0 and _g < len(files) else None)
			_g = (_g + 1)
			if ((file != ".") and ((file != ".."))):
				itemDestination = ((("null" if destination is None else destination) + "/") + ("null" if file is None else file))
				itemSource = ((("null" if source is None else source) + "/") + ("null" if file is None else file))
				if sys_FileSystem.isDirectory(itemSource):
					duell_helpers_TemplateHelper.recursiveCopyTemplatedFiles(itemSource,itemDestination,context,templateFunctions)
				else:
					duell_helpers_TemplateHelper.copyTemplateFile(itemSource,itemDestination,context,templateFunctions)
duell_helpers_TemplateHelper._hx_class = duell_helpers_TemplateHelper
_hx_classes["duell.helpers.TemplateHelper"] = duell_helpers_TemplateHelper


class duell_helpers_ThreadHelper:
	_hx_class_name = "duell.helpers.ThreadHelper"
	_hx_statics = ["runInAThread", "getMutex"]

	@staticmethod
	def runInAThread(func):
		def _hx_local_0():
			try:
				func()
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				e = _hx_e1
				duell_helpers_LogHelper.exitWithFormattedError(("Error in thread:" + Std.string(e)))
		thread = duell_helpers_Thread(None, _hx_local_0)
		thread.daemon = True
		thread.start()
		return thread

	@staticmethod
	def getMutex():
		return duell_helpers_Threading.Lock()
duell_helpers_ThreadHelper._hx_class = duell_helpers_ThreadHelper
_hx_classes["duell.helpers.ThreadHelper"] = duell_helpers_ThreadHelper


class duell_helpers_XMLHelper:
	_hx_class_name = "duell.helpers.XMLHelper"
	_hx_statics = ["isValidElement"]

	@staticmethod
	def isValidElement(element,validatingConditions):
		def _hx_local_7(value):
			andDefines = value.split("[and]")
			optionalDefines = None
			if (value.find("||") != -1):
				optionalDefines = value.split("||")
			else:
				optionalDefines = value.split("[or]")
			def _hx_local_0(_hx_str):
				return StringTools.trim(_hx_str)
			list(map(_hx_local_0,andDefines))
			def _hx_local_1(str1):
				return (str1 != "")
			andDefines = list(filter(_hx_local_1,andDefines))
			def _hx_local_2(str2):
				return StringTools.trim(str2)
			list(map(_hx_local_2,optionalDefines))
			def _hx_local_3(str3):
				return (str3 != "")
			optionalDefines = list(filter(_hx_local_3,optionalDefines))
			if ((len(optionalDefines) > 1) and ((len(andDefines) > 1))):
				raise _HxException((("Chaining of [and] and [or] defines is not supported in element: \"" + ("null" if value is None else value)) + "\""))
			result = []
			if (len(andDefines) > 1):
				result.append(andDefines)
			else:
				_g = 0
				while (_g < len(optionalDefines)):
					requiredDefinesString = (optionalDefines[_g] if _g >= 0 and _g < len(optionalDefines) else None)
					_g = (_g + 1)
					requiredDefines = requiredDefinesString.split(" ")
					def _hx_local_5(str4):
						return StringTools.trim(str4)
					list(map(_hx_local_5,requiredDefines))
					def _hx_local_6(str5):
						return (str5 != "")
					requiredDefines = list(filter(_hx_local_6,requiredDefines))
					if (len(requiredDefines) != 0):
						result.append(requiredDefines)
			return result
		processValue = _hx_local_7
		def _hx_local_10(optionalDefines1):
			matchOptional = False
			_g1 = 0
			while (_g1 < len(optionalDefines1)):
				requiredDefines1 = (optionalDefines1[_g1] if _g1 >= 0 and _g1 < len(optionalDefines1) else None)
				_g1 = (_g1 + 1)
				matchRequired = True
				_g11 = 0
				while (_g11 < len(requiredDefines1)):
					required = (requiredDefines1[_g11] if _g11 >= 0 and _g11 < len(requiredDefines1) else None)
					_g11 = (_g11 + 1)
					if (python_internal_ArrayImpl.indexOf(validatingConditions,required,None) == -1):
						matchRequired = False
						break
				if matchRequired:
					matchOptional = True
					break
			return matchOptional
		evaluateValue = _hx_local_10
		unlessValid = True
		ifValid = True
		if element.has.resolve("if"):
			ifValueProcessed = processValue(element.att.resolve("if"))
			if (len(ifValueProcessed) != 0):
				ifValid = evaluateValue(ifValueProcessed)
		if element.has.resolve("unless"):
			unlessValueProcessed = processValue(element.att.resolve("unless"))
			if (len(unlessValueProcessed) != 0):
				unlessValid = (not evaluateValue(unlessValueProcessed))
		return (ifValid and unlessValid)
duell_helpers_XMLHelper._hx_class = duell_helpers_XMLHelper
_hx_classes["duell.helpers.XMLHelper"] = duell_helpers_XMLHelper


class duell_objects_ArgumentSpec_Int:
	_hx_class_name = "duell.objects.ArgumentSpec_Int"
	_hx_fields = ["name", "documentation", "set", "value"]

	def __init__(self,name,documentation):
		self.name = None
		self.documentation = None
		self.set = None
		self.value = None
		self.name = name
		self.documentation = documentation
		self.set = False
		self.value = None

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.name = None
		_hx_o.documentation = None
		_hx_o.set = None
		_hx_o.value = None
duell_objects_ArgumentSpec_Int._hx_class = duell_objects_ArgumentSpec_Int
_hx_classes["duell.objects.ArgumentSpec_Int"] = duell_objects_ArgumentSpec_Int


class duell_objects_ArgumentSpec_String:
	_hx_class_name = "duell.objects.ArgumentSpec_String"
	_hx_fields = ["name", "documentation", "set", "value"]

	def __init__(self,name,documentation):
		self.name = None
		self.documentation = None
		self.set = None
		self.value = None
		self.name = name
		self.documentation = documentation
		self.set = False
		self.value = None

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.name = None
		_hx_o.documentation = None
		_hx_o.set = None
		_hx_o.value = None
duell_objects_ArgumentSpec_String._hx_class = duell_objects_ArgumentSpec_String
_hx_classes["duell.objects.ArgumentSpec_String"] = duell_objects_ArgumentSpec_String


class duell_objects_ArgumentSpec_duell_objects_NoArgumentValue:
	_hx_class_name = "duell.objects.ArgumentSpec_duell_objects_NoArgumentValue"
	_hx_fields = ["name", "documentation", "set", "value"]

	def __init__(self,name,documentation):
		self.name = None
		self.documentation = None
		self.set = None
		self.value = None
		self.name = name
		self.documentation = documentation
		self.set = False
		self.value = None

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.name = None
		_hx_o.documentation = None
		_hx_o.set = None
		_hx_o.value = None
duell_objects_ArgumentSpec_duell_objects_NoArgumentValue._hx_class = duell_objects_ArgumentSpec_duell_objects_NoArgumentValue
_hx_classes["duell.objects.ArgumentSpec_duell_objects_NoArgumentValue"] = duell_objects_ArgumentSpec_duell_objects_NoArgumentValue


class duell_objects_NoArgumentValue:
	_hx_class_name = "duell.objects.NoArgumentValue"
duell_objects_NoArgumentValue._hx_class = duell_objects_NoArgumentValue
_hx_classes["duell.objects.NoArgumentValue"] = duell_objects_NoArgumentValue


class duell_objects_ArgumentSpec:
	_hx_class_name = "duell.objects.ArgumentSpec"
	_hx_fields = ["name", "documentation", "set", "value"]

	def __init__(self,name,documentation):
		self.name = None
		self.documentation = None
		self.set = None
		self.value = None
		self.name = name
		self.documentation = documentation
		self.set = False
		self.value = None

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.name = None
		_hx_o.documentation = None
		_hx_o.set = None
		_hx_o.value = None
duell_objects_ArgumentSpec._hx_class = duell_objects_ArgumentSpec
_hx_classes["duell.objects.ArgumentSpec"] = duell_objects_ArgumentSpec


class duell_objects_CommandSpec:
	_hx_class_name = "duell.objects.CommandSpec"
	_hx_fields = ["name", "hasPlugin", "documentation", "commandHandler", "arguments", "configurationDocumentation"]

	def __init__(self,name,hasPlugin,commandHandler,documentation,arguments,configuration):
		self.name = None
		self.hasPlugin = None
		self.documentation = None
		self.commandHandler = None
		self.arguments = None
		self.configurationDocumentation = None
		self.name = name
		self.hasPlugin = hasPlugin
		self.documentation = documentation
		self.commandHandler = commandHandler
		self.arguments = arguments
		self.configurationDocumentation = configuration

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.name = None
		_hx_o.hasPlugin = None
		_hx_o.documentation = None
		_hx_o.commandHandler = None
		_hx_o.arguments = None
		_hx_o.configurationDocumentation = None
duell_objects_CommandSpec._hx_class = duell_objects_CommandSpec
_hx_classes["duell.objects.CommandSpec"] = duell_objects_CommandSpec


class duell_objects_Arguments:
	_hx_class_name = "duell.objects.Arguments"
	_hx_statics = ["PLUGIN_XML_FILE", "CONFIG_XML_FILE", "generalArgumentSpecs", "commandSpecs", "selectedCommand", "plugin", "pluginDocumentation", "pluginArgumentSpecs", "pluginConfigurationDocumentation", "generalDocumentation", "pluginAcceptsAnyArgument", "defines", "rawArgs", "validateArguments", "parseDefine", "parseConfig", "parsePlugin", "parseCommandSpec", "parseArgumentSpec", "isSet", "get", "isGeneralArgument", "isDefineSet", "getDefine", "getSelectedCommand", "getSelectedPlugin", "getRawArguments", "printGeneralHelp", "printCommandHelp", "printPluginHelp", "printArgument", "printDocumentationConfiguration"]
	rawArgs = None

	@staticmethod
	def validateArguments():
		argSpecInt = duell_objects_ArgumentSpec_Int("something", "something else")
		argSpecNoArgumentValue = duell_objects_ArgumentSpec_duell_objects_NoArgumentValue("something", "something else")
		argSpecString = duell_objects_ArgumentSpec_String("something", "something else")
		duell_objects_Arguments.parseConfig()
		args = Sys.args()
		if (Sys.getEnv("HAXELIB_RUN") == "1"):
			Sys.setCwd((None if ((len(args) == 0)) else args.pop()))
		duell_objects_Arguments.rawArgs = list(args)
		if ((len(args) == 0) or (((args[0] if 0 < len(args) else None) == "-help"))):
			duell_objects_Arguments.printGeneralHelp()
			return False
		def _hx_local_0():
			_this = (args[0] if 0 < len(args) else None)
			return ("" if ((0 >= len(_this))) else _this[0])
		if (_hx_local_0() == "-"):
			Sys.println("The first argument needs to be either a command or \"-help\".")
			return False
		if (not (args[0] if 0 < len(args) else None) in duell_objects_Arguments.commandSpecs.h):
			Sys.println((("The command " + HxOverrides.stringOrNull((args[0] if 0 < len(args) else None))) + " does not exist. Run \"duell -help\" for info on the possible commands."))
			return False
		duell_objects_Arguments.selectedCommand = duell_objects_Arguments.commandSpecs.h.get((args[0] if 0 < len(args) else None),None)
		index = 1
		if ((len(args) > 1) and (((args[index] if index >= 0 and index < len(args) else None) == "-help"))):
			duell_objects_Arguments.printCommandHelp()
			return False
		if duell_objects_Arguments.selectedCommand.hasPlugin:
			def _hx_local_1():
				_this1 = (args[index] if index >= 0 and index < len(args) else None)
				return ("" if ((0 >= len(_this1))) else _this1[0])
			if ((len(args) == 1) or ((_hx_local_1() == "-"))):
				Sys.println((((("For the command \"" + HxOverrides.stringOrNull(duell_objects_Arguments.selectedCommand.name)) + "\", a plugin name needs to be specified after. I.e. duell ") + HxOverrides.stringOrNull(duell_objects_Arguments.selectedCommand.name)) + " <plugin_name>."))
				return False
			duell_objects_Arguments.plugin = (args[index] if index >= 0 and index < len(args) else None)
			index = 2
			duellLibName = ""
			if (duell_objects_Arguments.selectedCommand.name == "run"):
				duellLibName = duell_objects_Arguments.plugin
			else:
				duellLibName = (("duell" + HxOverrides.stringOrNull(duell_objects_Arguments.selectedCommand.name)) + HxOverrides.stringOrNull(duell_objects_Arguments.plugin))
			if duell_helpers_DuellLibHelper.isInstalled(duellLibName):
				path = duell_helpers_DuellLibHelper.getPath(duellLibName)
				path = haxe_io_Path.join([path, "plugin.xml"])
				if sys_FileSystem.exists(path):
					duell_objects_Arguments.parsePlugin(sys_io_File.getContent(path))
		if ((args[index] if index >= 0 and index < len(args) else None) == "-help"):
			duell_objects_Arguments.printPluginHelp()
			return False
		if duell_objects_Arguments.pluginAcceptsAnyArgument:
			return True
		while (index < len(args)):
			def _hx_local_3():
				nonlocal index
				_hx_local_2 = index
				index = (index + 1)
				return _hx_local_2
			argString = python_internal_ArrayImpl._get(args, _hx_local_3())
			if (argString == "-D"):
				def _hx_local_5():
					nonlocal index
					_hx_local_4 = index
					index = (index + 1)
					return _hx_local_4
				duell_objects_Arguments.parseDefine(python_internal_ArrayImpl._get(args, _hx_local_5()))
				continue
			argSpec = None
			if ((duell_objects_Arguments.generalArgumentSpecs is not None) and argString in duell_objects_Arguments.generalArgumentSpecs.h):
				argSpec = duell_objects_Arguments.generalArgumentSpecs.h.get(argString,None)
			elif ((duell_objects_Arguments.selectedCommand.arguments is not None) and argString in duell_objects_Arguments.selectedCommand.arguments.h):
				argSpec = duell_objects_Arguments.selectedCommand.arguments.h.get(argString,None)
			elif ((duell_objects_Arguments.pluginArgumentSpecs is not None) and argString in duell_objects_Arguments.pluginArgumentSpecs.h):
				argSpec = duell_objects_Arguments.pluginArgumentSpecs.h.get(argString,None)
			if (argSpec is None):
				Sys.println((("Unknown argument \"" + ("null" if argString is None else argString)) + "\""))
				return False
			else:
				Reflect.setField(argSpec,"set",True)
				if (Type.getClass(argSpec) == Type.getClass(argSpecNoArgumentValue)):
					pass
				elif (Type.getClass(argSpec) == Type.getClass(argSpecInt)):
					if (len(args) == index):
						Sys.println((("Argument " + ("null" if argString is None else argString)) + " expected an int, but got nothing"))
						return False
					else:
						def _hx_local_7():
							nonlocal index
							_hx_local_6 = index
							index = (index + 1)
							return _hx_local_6
						argParam = python_internal_ArrayImpl._get(args, _hx_local_7())
						argParamInt = Std.parseInt(argParam)
						if (argParamInt is None):
							Sys.println(((("Argument " + ("null" if argString is None else argString)) + " expected an int, but got ") + ("null" if argParam is None else argParam)))
							return False
						else:
							Reflect.setField(argSpec,"value",argParamInt)
				elif (Type.getClass(argSpec) == Type.getClass(argSpecString)):
					def _hx_local_9():
						nonlocal index
						_hx_local_8 = index
						index = (index + 1)
						return _hx_local_8
					argParam1 = python_internal_ArrayImpl._get(args, _hx_local_9())
					Reflect.setField(argSpec,"value",argParam1)
				else:
					raise _HxException("Unsupported type for argument spec. Internal error.")
		return True

	@staticmethod
	def parseDefine(_hx_str):
		array = _hx_str.split("=")
		if (len(array) == 1):
			duell_objects_Arguments.defines.h[(array[0] if 0 < len(array) else None)] = None
		elif (len(array) > 2):
			raise _HxException((("Argument define " + ("null" if _hx_str is None else _hx_str)) + " has incorrect structure, should be like -D SOMETHING or -D SOMETHING=2"))
		else:
			duell_objects_Arguments.defines.h[(array[0] if 0 < len(array) else None)] = (array[1] if 1 < len(array) else None)

	@staticmethod
	def parseConfig():
		xml = None
		xml = haxe_xml_Fast(Xml.parse(haxe_Resource.getString("generalArguments")).firstElement())
		_hx_local_1 = xml.get_elements()
		while _hx_local_1.hasNext():
			element = _hx_local_1.next()
			_g = element.get_name()
			_hx_local_0 = len(_g)
			if (_hx_local_0 == 13):
				if (_g == "documentation"):
					duell_objects_Arguments.generalDocumentation = StringTools.htmlUnescape(element.get_innerData())
			elif (_hx_local_0 == 3):
				if (_g == "arg"):
					argSpec = duell_objects_Arguments.parseArgumentSpec(element)
					key = Reflect.field(argSpec,"name")
					value = argSpec
					value1 = value
					duell_objects_Arguments.generalArgumentSpecs.h[key] = value1
			elif (_hx_local_0 == 7):
				if (_g == "command"):
					commandSpec = duell_objects_Arguments.parseCommandSpec(element)
					duell_objects_Arguments.commandSpecs.h[commandSpec.name] = commandSpec
			else:
				pass

	@staticmethod
	def parsePlugin(fileString):
		xml = haxe_xml_Fast(Xml.parse(fileString).firstElement())
		_hx_local_2 = xml.get_elements()
		while _hx_local_2.hasNext():
			element = _hx_local_2.next()
			_g = element.get_name()
			_hx_local_0 = len(_g)
			if (_hx_local_0 == 13):
				if (_g == "documentation"):
					duell_objects_Arguments.pluginDocumentation = StringTools.htmlUnescape(StringTools.trim(element.get_innerData()))
				elif (_g == "configuration"):
					configurationElements = element.get_elements()
					_hx_local_1 = configurationElements
					while _hx_local_1.hasNext():
						configElem = _hx_local_1.next()
						if (duell_objects_Arguments.pluginConfigurationDocumentation is None):
							duell_objects_Arguments.pluginConfigurationDocumentation = haxe_ds_StringMap()
						name = configElem.att.resolve("name")
						documentation = StringTools.htmlUnescape(StringTools.trim(configElem.get_innerData()))
						duell_objects_Arguments.pluginConfigurationDocumentation.h[name] = documentation
			elif (_hx_local_0 == 3):
				if (_g == "arg"):
					if (duell_objects_Arguments.pluginArgumentSpecs is None):
						duell_objects_Arguments.pluginArgumentSpecs = haxe_ds_StringMap()
					argSpec = duell_objects_Arguments.parseArgumentSpec(element)
					key = Reflect.field(argSpec,"name")
					value = argSpec
					value1 = value
					duell_objects_Arguments.pluginArgumentSpecs.h[key] = value1
			else:
				pass

	@staticmethod
	def parseCommandSpec(command):
		name = command.att.resolve("name")
		hasPlugin = None
		if (command.att.resolve("hasPlugin") == "true"):
			hasPlugin = True
		else:
			hasPlugin = False
		klassName = ("duell.commands." + HxOverrides.stringOrNull(command.att.resolve("class")))
		klass = Type.resolveClass(klassName)
		commandHandler = Type.createInstance(klass,[])
		documentation = StringTools.htmlUnescape(StringTools.trim(command.node.resolve("documentation").get_innerData()))
		args = None
		if command.hasNode.resolve("args"):
			_hx_local_0 = command.node.resolve("args").get_elements()
			while _hx_local_0.hasNext():
				argXML = _hx_local_0.next()
				if (args is None):
					args = haxe_ds_StringMap()
				argSpec = duell_objects_Arguments.parseArgumentSpec(argXML)
				key = Reflect.field(argSpec,"name")
				value = argSpec
				value1 = value
				args.h[key] = value1
		configuration = None
		if command.hasNode.resolve("configuration"):
			_hx_local_1 = command.node.resolve("configuration").get_elements()
			while _hx_local_1.hasNext():
				argXML1 = _hx_local_1.next()
				if (configuration is None):
					configuration = haxe_ds_StringMap()
				name1 = argXML1.att.resolve("name")
				documentation1 = StringTools.htmlUnescape(StringTools.trim(argXML1.get_innerData()))
				configuration.h[name1] = documentation1
		return duell_objects_CommandSpec(name, hasPlugin, commandHandler, documentation, args, configuration)

	@staticmethod
	def parseArgumentSpec(arg):
		name = arg.att.resolve("name")
		documentation = StringTools.htmlUnescape(StringTools.trim(arg.node.resolve("documentation").get_innerData()))
		_hx_type = arg.att.resolve("type")
		_hx_local_0 = len(_hx_type)
		if (_hx_local_0 == 4):
			if (_hx_type == "void"):
				return duell_objects_ArgumentSpec_duell_objects_NoArgumentValue(name, documentation)
			else:
				raise _HxException(("Not yet supported argument type " + ("null" if _hx_type is None else _hx_type)))
		elif (_hx_local_0 == 3):
			if (_hx_type == "any"):
				duell_objects_Arguments.pluginAcceptsAnyArgument = True
				return duell_objects_ArgumentSpec_duell_objects_NoArgumentValue(name, documentation)
			elif (_hx_type == "int"):
				return duell_objects_ArgumentSpec_Int(name, documentation)
			else:
				raise _HxException(("Not yet supported argument type " + ("null" if _hx_type is None else _hx_type)))
		elif (_hx_local_0 == 6):
			if (_hx_type == "string"):
				return duell_objects_ArgumentSpec_String(name, documentation)
			else:
				raise _HxException(("Not yet supported argument type " + ("null" if _hx_type is None else _hx_type)))
		else:
			raise _HxException(("Not yet supported argument type " + ("null" if _hx_type is None else _hx_type)))

	@staticmethod
	def isSet(argument):
		if ((duell_objects_Arguments.generalArgumentSpecs is not None) and argument in duell_objects_Arguments.generalArgumentSpecs.h):
			return Reflect.field(duell_objects_Arguments.generalArgumentSpecs.h.get(argument,None),"set")
		if (((duell_objects_Arguments.selectedCommand is not None) and ((duell_objects_Arguments.selectedCommand.arguments is not None))) and argument in duell_objects_Arguments.selectedCommand.arguments.h):
			return Reflect.field(duell_objects_Arguments.selectedCommand.arguments.h.get(argument,None),"set")
		if ((duell_objects_Arguments.pluginArgumentSpecs is not None) and argument in duell_objects_Arguments.pluginArgumentSpecs.h):
			return Reflect.field(duell_objects_Arguments.pluginArgumentSpecs.h.get(argument,None),"set")
		raise _HxException(("Unknown argument " + ("null" if argument is None else argument)))

	@staticmethod
	def get(argument):
		if ((duell_objects_Arguments.generalArgumentSpecs is not None) and argument in duell_objects_Arguments.generalArgumentSpecs.h):
			return Reflect.field(duell_objects_Arguments.generalArgumentSpecs.h.get(argument,None),"value")
		if (((duell_objects_Arguments.selectedCommand is not None) and ((duell_objects_Arguments.selectedCommand.arguments is not None))) and argument in duell_objects_Arguments.selectedCommand.arguments.h):
			return Reflect.field(duell_objects_Arguments.selectedCommand.arguments.h.get(argument,None),"value")
		if ((duell_objects_Arguments.pluginArgumentSpecs is not None) and argument in duell_objects_Arguments.pluginArgumentSpecs.h):
			return Reflect.field(duell_objects_Arguments.pluginArgumentSpecs.h.get(argument,None),"value")
		raise _HxException(("Unknown argument " + ("null" if argument is None else argument)))

	@staticmethod
	def isGeneralArgument(argument):
		if ((duell_objects_Arguments.generalArgumentSpecs is not None) and argument in duell_objects_Arguments.generalArgumentSpecs.h):
			return Reflect.field(duell_objects_Arguments.generalArgumentSpecs.h.get(argument,None),"set")
		return False

	@staticmethod
	def isDefineSet(define):
		return define in duell_objects_Arguments.defines.h

	@staticmethod
	def getDefine(define):
		return duell_objects_Arguments.defines.h.get(define,None)

	@staticmethod
	def getSelectedCommand():
		return duell_objects_Arguments.selectedCommand

	@staticmethod
	def getSelectedPlugin():
		return duell_objects_Arguments.plugin

	@staticmethod
	def getRawArguments():
		return duell_objects_Arguments.rawArgs

	@staticmethod
	def printGeneralHelp():
		duell_helpers_LogHelper.wrapInfo((((((((("  Help for the " + "\x1B[1m") + "Duell Tool") + "\x1B[0m") + ", Version ") + "\x1B[1m") + "#{0}") + "\x1B[0m") + "  "),[duell_Duell.VERSION])
		duell_helpers_LogHelper.info((("\x1B[4m" + "Description:") + "\x1B[0m"))
		duell_helpers_LogHelper.info(" ")
		duell_helpers_LogHelper.info(duell_objects_Arguments.generalDocumentation)
		duell_helpers_LogHelper.info(" ")
		duell_helpers_LogHelper.info(" ")
		duell_helpers_LogHelper.info((("\x1B[4m" + "Commands:") + "\x1B[0m"))
		duell_helpers_LogHelper.info(" ")
		_hx_local_0 = duell_objects_Arguments.commandSpecs.iterator()
		while _hx_local_0.hasNext():
			command = _hx_local_0.next()
			duell_helpers_LogHelper.info((((("  duell " + "\x1B[1m") + HxOverrides.stringOrNull(command.name)) + " ") + "\x1B[0m"))
		if (duell_objects_Arguments.generalArgumentSpecs is not None):
			duell_helpers_LogHelper.info(" ")
			duell_helpers_LogHelper.info((("\x1B[4m" + "Arguments:") + "\x1B[0m"))
			_hx_local_1 = duell_objects_Arguments.generalArgumentSpecs.iterator()
			while _hx_local_1.hasNext():
				arg = _hx_local_1.next()
				duell_objects_Arguments.printArgument(arg)
		duell_helpers_LogHelper.info((("\x1B[4m" + "Additional Help:") + "\x1B[0m"))
		duell_helpers_LogHelper.info(" ")
		duell_helpers_LogHelper.info((((" This message: " + "\x1B[1m") + "duell -help") + "\x1B[0m"))
		duell_helpers_LogHelper.info(((("For a command: " + "\x1B[1m") + "duell <command> -help") + "\x1B[0m"))
		duell_helpers_LogHelper.info((((" For a plugin: " + "\x1B[1m") + "duell <command> <plugin> -help") + "\x1B[0m"))
		duell_helpers_LogHelper.info(" ")

	@staticmethod
	def printCommandHelp():
		duell_helpers_LogHelper.wrapInfo((((("  Help for the " + "\x1B[1m") + "#{0}") + "\x1B[0m") + " command  "),[duell_objects_Arguments.selectedCommand.name])
		duell_helpers_LogHelper.info((("\x1B[4m" + "Description:") + "\x1B[0m"))
		duell_helpers_LogHelper.info(" ")
		duell_helpers_LogHelper.info(duell_objects_Arguments.selectedCommand.documentation)
		duell_helpers_LogHelper.info(" ")
		if duell_objects_Arguments.selectedCommand.hasPlugin:
			duell_helpers_LogHelper.info((("\x1B[4m" + "Plugins:") + "\x1B[0m"))
			duell_helpers_LogHelper.info(" ")
			libList = duell_helpers_DuellLibListHelper.getDuellLibReferenceList()
			_hx_local_0 = libList.keys()
			while _hx_local_0.hasNext():
				key = _hx_local_0.next()
				if StringTools.startsWith(key,("duell" + HxOverrides.stringOrNull(duell_objects_Arguments.selectedCommand.name))):
					duell_helpers_LogHelper.info(((((("  duell " + HxOverrides.stringOrNull(duell_objects_Arguments.selectedCommand.name)) + " ") + "\x1B[1m") + HxOverrides.stringOrNull(HxString.substr(key,len((("duell" + HxOverrides.stringOrNull(duell_objects_Arguments.selectedCommand.name)))),None))) + "\x1B[0m"))
			duell_helpers_LogHelper.info(" ")
			duell_helpers_LogHelper.info(((((("For additional information on each plugin, run " + "\x1B[1m") + "duell ") + HxOverrides.stringOrNull(duell_objects_Arguments.selectedCommand.name)) + " <plugin> -help ") + "\x1B[0m"))
			duell_helpers_LogHelper.info(" ")
		if (duell_objects_Arguments.selectedCommand.arguments is not None):
			duell_helpers_LogHelper.info((("\x1B[4m" + "Arguments:") + "\x1B[0m"))
			_hx_local_1 = duell_objects_Arguments.selectedCommand.arguments.iterator()
			while _hx_local_1.hasNext():
				arg = _hx_local_1.next()
				duell_objects_Arguments.printArgument(arg)
			duell_helpers_LogHelper.info(" ")
		if (duell_objects_Arguments.selectedCommand.configurationDocumentation is not None):
			duell_helpers_LogHelper.info((("\x1B[4m" + "Project Configuration Documentation:") + "\x1B[0m"))
			_hx_local_2 = duell_objects_Arguments.selectedCommand.configurationDocumentation.keys()
			while _hx_local_2.hasNext():
				doc = _hx_local_2.next()
				duell_objects_Arguments.printDocumentationConfiguration(doc,duell_objects_Arguments.selectedCommand.configurationDocumentation.h.get(doc,None))

	@staticmethod
	def printPluginHelp():
		duell_helpers_LogHelper.wrapInfo((((((((("  Help for the " + "\x1B[1m") + "#{0}") + "\x1B[0m") + " plugin in the ") + "\x1B[1m") + "#{1}") + "\x1B[0m") + " command  "),[duell_objects_Arguments.plugin, duell_objects_Arguments.selectedCommand.name])
		duell_helpers_LogHelper.info((("\x1B[4m" + "Description:") + "\x1B[0m"))
		duell_helpers_LogHelper.info(" ")
		duell_helpers_LogHelper.info(duell_objects_Arguments.pluginDocumentation)
		duell_helpers_LogHelper.info(" ")
		if (duell_objects_Arguments.pluginArgumentSpecs is not None):
			duell_helpers_LogHelper.info((("\x1B[4m" + "Arguments:") + "\x1B[0m"))
			_hx_local_0 = duell_objects_Arguments.pluginArgumentSpecs.iterator()
			while _hx_local_0.hasNext():
				arg = _hx_local_0.next()
				duell_objects_Arguments.printArgument(arg)
		duell_helpers_LogHelper.info(" ")
		if (duell_objects_Arguments.pluginConfigurationDocumentation is not None):
			duell_helpers_LogHelper.info((("\x1B[4m" + "Project Configuration Documentation:") + "\x1B[0m"))
			_hx_local_1 = duell_objects_Arguments.pluginConfigurationDocumentation.keys()
			while _hx_local_1.hasNext():
				doc = _hx_local_1.next()
				duell_objects_Arguments.printDocumentationConfiguration(doc,duell_objects_Arguments.pluginConfigurationDocumentation.h.get(doc,None))

	@staticmethod
	def printArgument(arg):
		duell_helpers_LogHelper.info(" ")
		duell_helpers_LogHelper.info(((("\x1B[1m" + "  ") + Std.string(Reflect.field(arg,"name"))) + "\x1B[0m"))
		duell_helpers_LogHelper.info(" ")
		duell_helpers_LogHelper.info(("  " + Std.string(Reflect.field(arg,"documentation"))))
		duell_helpers_LogHelper.info(" ")

	@staticmethod
	def printDocumentationConfiguration(name,documentation):
		duell_helpers_LogHelper.info(" ")
		duell_helpers_LogHelper.info((((("\x1B[1m" + "  <") + ("null" if name is None else name)) + ">") + "\x1B[0m"))
		duell_helpers_LogHelper.info(" ")
		duell_helpers_LogHelper.info(("  " + ("null" if documentation is None else documentation)))
		duell_helpers_LogHelper.info(" ")
duell_objects_Arguments._hx_class = duell_objects_Arguments
_hx_classes["duell.objects.Arguments"] = duell_objects_Arguments


class duell_objects_DuellConfigJSON:
	_hx_class_name = "duell.objects.DuellConfigJSON"
	_hx_fields = ["localLibraryPath", "repoListURLs", "setupsCompleted", "lastProjectFile", "lastProjectTime", "configJSON", "configPath"]
	_hx_methods = ["writeToConfig"]
	_hx_statics = ["cache", "getConfig"]

	def __init__(self,configPath):
		self.localLibraryPath = None
		self.repoListURLs = None
		self.setupsCompleted = None
		self.lastProjectFile = None
		self.lastProjectTime = None
		self.configJSON = None
		self.configPath = None
		self.configPath = configPath
		configContent = sys_io_File.getContent(configPath)
		self.configJSON = python_lib_Json.loads(configContent,**python__KwArgs_KwArgs_Impl_.fromT(_hx_AnonObject({'object_hook': python_Lib.dictToAnon})))
		self.localLibraryPath = Reflect.field(self.configJSON,"localLibraryPath")
		if (self.localLibraryPath is not None):
			self.localLibraryPath = duell_helpers_PathHelper.unescape(self.localLibraryPath)
		self.repoListURLs = Reflect.field(self.configJSON,"repoListURLs")
		if (self.repoListURLs is None):
			self.repoListURLs = []
		self.setupsCompleted = Reflect.field(self.configJSON,"setupsCompleted")
		if (self.setupsCompleted is None):
			self.setupsCompleted = []
		self.lastProjectFile = Reflect.field(self.configJSON,"lastProjectFile")
		self.lastProjectTime = Reflect.field(self.configJSON,"lastProjectTime")

	def writeToConfig(self):
		Reflect.setField(self.configJSON,"localLibraryPath",self.localLibraryPath)
		Reflect.setField(self.configJSON,"repoListURLs",self.repoListURLs)
		Reflect.setField(self.configJSON,"setupsCompleted",self.setupsCompleted)
		Reflect.setField(self.configJSON,"lastProjectTime",self.lastProjectTime)
		Reflect.setField(self.configJSON,"lastProjectFile",self.lastProjectFile)
		sys_FileSystem.deleteFile(self.configPath)
		output = sys_io_File.write(self.configPath,False)
		output.writeString(haxe_format_JsonPrinter.print(self.configJSON,None,None))
		output.close()
	cache = None

	@staticmethod
	def getConfig(configPath):
		if (duell_objects_DuellConfigJSON.cache is None):
			duell_objects_DuellConfigJSON.cache = duell_objects_DuellConfigJSON(configPath)
			return duell_objects_DuellConfigJSON.cache
		if (duell_objects_DuellConfigJSON.cache.configPath != configPath):
			duell_objects_DuellConfigJSON.cache = duell_objects_DuellConfigJSON(configPath)
			return duell_objects_DuellConfigJSON.cache
		return duell_objects_DuellConfigJSON.cache

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.localLibraryPath = None
		_hx_o.repoListURLs = None
		_hx_o.setupsCompleted = None
		_hx_o.lastProjectFile = None
		_hx_o.lastProjectTime = None
		_hx_o.configJSON = None
		_hx_o.configPath = None
duell_objects_DuellConfigJSON._hx_class = duell_objects_DuellConfigJSON
_hx_classes["duell.objects.DuellConfigJSON"] = duell_objects_DuellConfigJSON


class duell_objects_DuellLib:
	_hx_class_name = "duell.objects.DuellLib"
	_hx_fields = ["name", "version", "commit"]
	_hx_methods = ["isInstalled", "isPathValid", "getPath", "updateNeeded", "update", "install"]
	_hx_statics = ["duellLibCache", "getDuellLib"]

	def __init__(self,name,version = "master",commit = ""):
		if (version is None):
			version = "master"
		if (commit is None):
			commit = ""
		self.name = None
		self.version = None
		self.commit = None
		self.name = name
		self.version = version
		self.commit = commit

	def isInstalled(self):
		return duell_helpers_DuellLibHelper.isInstalled(self.name)

	def isPathValid(self):
		return duell_helpers_DuellLibHelper.isPathValid(self.name)

	def getPath(self):
		return duell_helpers_DuellLibHelper.getPath(self.name)

	def updateNeeded(self):
		return duell_helpers_DuellLibHelper.updateNeeded(self.name)

	def update(self):
		duell_helpers_DuellLibHelper.update(self.name)
		return

	def install(self):
		duell_helpers_DuellLibHelper.install(self.name)
		return

	@staticmethod
	def getDuellLib(name,version = "master",commit = ""):
		if (version is None):
			version = "master"
		if (commit is None):
			commit = ""
		if ((version is None) or ((version == ""))):
			raise _HxException((("Empty version is not allowed for " + ("null" if name is None else name)) + " library!"))
		if name in duell_objects_DuellLib.duellLibCache.h:
			versionMap = duell_objects_DuellLib.duellLibCache.h.get(name,None)
			if (not version in versionMap.h):
				value = duell_objects_DuellLib(name, version, commit)
				versionMap.h[version] = value
		else:
			versionMap1 = haxe_ds_StringMap()
			value1 = duell_objects_DuellLib(name, version, commit)
			versionMap1.h[version] = value1
			duell_objects_DuellLib.duellLibCache.h[name] = versionMap1
		this1 = duell_objects_DuellLib.duellLibCache.h.get(name,None)
		return this1.get(version)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.name = None
		_hx_o.version = None
		_hx_o.commit = None
duell_objects_DuellLib._hx_class = duell_objects_DuellLib
_hx_classes["duell.objects.DuellLib"] = duell_objects_DuellLib


class duell_objects_DuellLibReference:
	_hx_class_name = "duell.objects.DuellLibReference"
	_hx_fields = ["name", "gitPath", "libPath", "destinationPath"]
	_hx_methods = ["install"]

	def __init__(self,name,gitPath,libPath,destinationPath):
		self.name = None
		self.gitPath = None
		self.libPath = None
		self.destinationPath = None
		self.name = name
		self.gitPath = gitPath
		self.libPath = libPath
		self.destinationPath = destinationPath

	def install(self):
		duellConfigJSON = duell_objects_DuellConfigJSON.getConfig(duell_helpers_DuellConfigHelper.getDuellConfigFileLocation())
		duell_helpers_LogHelper.println((("Installing lib " + HxOverrides.stringOrNull(self.name)) + "==============================================="))
		duell_helpers_LogHelper.println((("Creating directory : [" + HxOverrides.stringOrNull(self.destinationPath)) + "]"))
		path = haxe_io_Path.join([duellConfigJSON.localLibraryPath, self.destinationPath])
		duell_helpers_LogHelper.println((("Checking out library in directory : [" + HxOverrides.stringOrNull(self.destinationPath)) + "]"))
		if sys_FileSystem.exists(path):
			if (duell_helpers_GitHelper.pull(path) != 0):
				raise _HxException(("Can't Install library " + HxOverrides.stringOrNull(self.name)))
		elif (duell_helpers_GitHelper.clone(self.gitPath,path) != 0):
			raise _HxException(("Can't Install library " + HxOverrides.stringOrNull(self.name)))
		duell_helpers_LogHelper.println("Setting repo as haxelib dev")
		duell_helpers_CommandHelper.runHaxelib("",["dev", ("duell_" + HxOverrides.stringOrNull(self.name)), ((HxOverrides.stringOrNull(duellConfigJSON.localLibraryPath) + "/") + HxOverrides.stringOrNull(self.libPath))],_hx_AnonObject({'errorMessage': "configuring 'haxelib dev' on the downloaded library"}))
		duell_helpers_LogHelper.info((("Done Installing lib " + HxOverrides.stringOrNull(self.name)) + " =========================================="))

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.name = None
		_hx_o.gitPath = None
		_hx_o.libPath = None
		_hx_o.destinationPath = None
duell_objects_DuellLibReference._hx_class = duell_objects_DuellLibReference
_hx_classes["duell.objects.DuellLibReference"] = duell_objects_DuellLibReference


class duell_objects_DuellProcess:
	_hx_class_name = "duell.objects.DuellProcess"
	_hx_fields = ["stdin", "stdoutLineBuffer", "stdout", "totalStdout", "stdoutMutex", "stderr", "totalStderr", "stderrMutex", "stderrLineBuffer", "waitingOnStderrMutex", "waitingOnStdoutMutex", "timeoutTicker", "exitCodeMutex", "exitCodeCache", "finished", "killed", "closed", "timedout", "stdoutFinished", "stderrFinished", "process", "systemCommand", "loggingPrefix", "logOnlyIfVerbose", "timeout", "block", "mute", "shutdownOnError", "errorMessage", "command", "path", "args", "argString"]
	_hx_methods = ["log", "startStdOutListener", "startStdErrListener", "startTimeoutListener", "blockUntilFinished", "kill", "hasFinished", "readCurrentStdout", "readCurrentStderr", "getCompleteStdout", "getCompleteStderr", "exitCode", "exitCodeBlocking", "isTimedout"]

	def __init__(self,path,comm,args,options = None):
		self.stdin = None
		self.stdoutLineBuffer = None
		self.stdout = None
		self.totalStdout = None
		self.stdoutMutex = None
		self.stderr = None
		self.totalStderr = None
		self.stderrMutex = None
		self.stderrLineBuffer = None
		self.waitingOnStderrMutex = None
		self.waitingOnStdoutMutex = None
		self.timeoutTicker = None
		self.exitCodeMutex = None
		self.exitCodeCache = None
		self.finished = None
		self.killed = None
		self.closed = None
		self.timedout = None
		self.stdoutFinished = None
		self.stderrFinished = None
		self.process = None
		self.systemCommand = None
		self.loggingPrefix = None
		self.logOnlyIfVerbose = None
		self.timeout = None
		self.block = None
		self.mute = None
		self.shutdownOnError = None
		self.errorMessage = None
		self.command = None
		self.path = None
		self.args = None
		self.argString = None
		self.stderrFinished = False
		self.stdoutFinished = False
		self.timedout = False
		self.closed = False
		self.killed = False
		self.finished = False
		self.exitCodeCache = None
		self.command = duell_helpers_PathHelper.escape(comm)
		self.args = args
		if (path is None):
			self.path = ""
		else:
			self.path = path
		self.exitCodeMutex = duell_helpers_ThreadHelper.getMutex()
		self.waitingOnStderrMutex = duell_helpers_ThreadHelper.getMutex()
		self.waitingOnStdoutMutex = duell_helpers_ThreadHelper.getMutex()
		if ((options is not None) and ((Reflect.field(options,"systemCommand") is not None))):
			self.systemCommand = Reflect.field(options,"systemCommand")
		else:
			self.systemCommand = False
		if ((options is not None) and ((Reflect.field(options,"loggingPrefix") is not None))):
			self.loggingPrefix = Reflect.field(options,"loggingPrefix")
		else:
			self.loggingPrefix = ""
		if ((options is not None) and ((Reflect.field(options,"logOnlyIfVerbose") is not None))):
			self.logOnlyIfVerbose = Reflect.field(options,"logOnlyIfVerbose")
		else:
			self.logOnlyIfVerbose = True
		if ((options is not None) and ((Reflect.field(options,"timeout") is not None))):
			self.timeout = Reflect.field(options,"timeout")
		else:
			self.timeout = 0.0
		if ((options is not None) and ((Reflect.field(options,"block") is not None))):
			self.block = Reflect.field(options,"block")
		else:
			self.block = False
		if ((options is not None) and ((Reflect.field(options,"shutdownOnError") is not None))):
			self.shutdownOnError = Reflect.field(options,"shutdownOnError")
		else:
			self.shutdownOnError = False
		if ((options is not None) and ((Reflect.field(options,"errorMessage") is not None))):
			self.errorMessage = Reflect.field(options,"errorMessage")
		else:
			self.errorMessage = ""
		if ((options is not None) and ((Reflect.field(options,"mute") is not None))):
			self.mute = Reflect.field(options,"mute")
		else:
			self.mute = False
		if ((not self.systemCommand) and ((duell_helpers_PlatformHelper.get_hostPlatform() != duell_helpers_Platform.WINDOWS))):
			self.command = ("./" + HxOverrides.stringOrNull(self.command))
		oldPath = ""
		if ((path is not None) and ((path != ""))):
			duell_helpers_LogHelper.info("",((" - \x1B[1mChanging directory for running the process:\x1B[0m " + ("null" if path is None else path)) + ""))
			if (not sys_FileSystem.exists(path)):
				raise _HxException((("The path \"" + ("null" if path is None else path)) + "\" does not exist"))
			oldPath = Sys.getCwd()
			Sys.setCwd(path)
		self.argString = ""
		_g = 0
		while (_g < len(args)):
			arg = (args[_g] if _g >= 0 and _g < len(args) else None)
			_g = (_g + 1)
			if (arg.find(" ") > -1):
				_hx_local_1 = self
				_hx_local_2 = _hx_local_1.argString
				_hx_local_1.argString = (("null" if _hx_local_2 is None else _hx_local_2) + HxOverrides.stringOrNull((((" \"" + ("null" if arg is None else arg)) + "\""))))
				_hx_local_1.argString
			else:
				_hx_local_3 = self
				_hx_local_4 = _hx_local_3.argString
				_hx_local_3.argString = (("null" if _hx_local_4 is None else _hx_local_4) + HxOverrides.stringOrNull(((" " + ("null" if arg is None else arg)))))
				_hx_local_3.argString
		duell_helpers_LogHelper.info("",((" - \x1B[1mRunning process:\x1B[0m " + HxOverrides.stringOrNull(self.command)) + HxOverrides.stringOrNull(self.argString)))
		self.timeoutTicker = True
		self.process = sys_io_Process(self.command, args)
		self.stdin = self.process.stdin
		self.startStdOutListener()
		self.startStdErrListener()
		self.startTimeoutListener()
		if (oldPath != ""):
			Sys.setCwd(oldPath)
		if self.block:
			self.blockUntilFinished()

	def log(self,logMessage):
		if (logMessage == ""):
			return
		if self.mute:
			return
		message = ((("\x1B[1m" + HxOverrides.stringOrNull(self.loggingPrefix)) + "\x1B[0m ") + ("null" if logMessage is None else logMessage))
		if self.logOnlyIfVerbose:
			duell_helpers_LogHelper.info("",message)
		else:
			duell_helpers_LogHelper.info(message,"")

	def startStdOutListener(self):
		_g = self
		self.stdout = haxe_io_BytesOutput()
		self.totalStdout = haxe_io_BytesOutput()
		self.stdoutMutex = duell_helpers_Threading.Lock()
		self.stdoutLineBuffer = haxe_io_BytesOutput()
		def _hx_local_2():
			_g.waitingOnStdoutMutex.acquire()
			def _hx_local_1():
				_this = haxe_CallStack.exceptionStack()
				return "\n".join([python_Boot.toString1(x1,'') for x1 in _this])
			try:
				while True:
					_hx_str = Reflect.field(_g.process.p.stdout.readline(),"decode")("utf-8")
					if ((_hx_str is None) or ((_hx_str == ""))):
						break
					_g.stdoutMutex.acquire()
					_g.stdout.writeString(_hx_str)
					_g.totalStdout.writeString(_hx_str)
					_g.stdoutMutex.release()
					def _hx_local_0():
						index = (len(_hx_str) - 1)
						return ("" if (((index < 0) or ((index >= len(_hx_str))))) else _hx_str[index])
					if (_hx_local_0() == "\n"):
						_hx_str = HxString.substring(_hx_str,0,(len(_hx_str) - 1))
						_g.stdoutLineBuffer.writeString(_hx_str)
						line = _g.stdoutLineBuffer.getBytes().toString()
						_g.log(line)
						_g.stdoutLineBuffer = haxe_io_BytesOutput()
					else:
						_g.stdoutLineBuffer.writeString(_hx_str)
					_g.timeoutTicker = True
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				if isinstance(_hx_e1, haxe_io_Eof):
						pass
				else:
					e1 = _hx_e1
					duell_helpers_LogHelper.info(("Exception with stackTrace:\n" + HxOverrides.stringOrNull(_hx_local_1())))
			_g.log(_g.stdoutLineBuffer.getBytes().toString())
			_g.finished = True
			_g.stdoutFinished = True
			_g.waitingOnStdoutMutex.release()
			_g.exitCodeBlocking()
		duell_helpers_ThreadHelper.runInAThread(_hx_local_2)

	def startStdErrListener(self):
		_g = self
		self.stderr = haxe_io_BytesOutput()
		self.totalStderr = haxe_io_BytesOutput()
		self.stderrMutex = duell_helpers_Threading.Lock()
		self.stderrLineBuffer = haxe_io_BytesOutput()
		def _hx_local_2():
			_g.waitingOnStderrMutex.acquire()
			def _hx_local_1():
				_this = haxe_CallStack.exceptionStack()
				return "\n".join([python_Boot.toString1(x1,'') for x1 in _this])
			try:
				while True:
					_hx_str = Reflect.field(_g.process.p.stderr.readline(),"decode")("utf-8")
					if ((_hx_str is None) or ((_hx_str == ""))):
						break
					_g.stderrMutex.acquire()
					_g.stderr.writeString(_hx_str)
					_g.totalStderr.writeString(_hx_str)
					_g.stderrMutex.release()
					def _hx_local_0():
						index = (len(_hx_str) - 1)
						return ("" if (((index < 0) or ((index >= len(_hx_str))))) else _hx_str[index])
					if (_hx_local_0() == "\n"):
						_hx_str = HxString.substring(_hx_str,0,(len(_hx_str) - 1))
						_g.stderrLineBuffer.writeString(_hx_str)
						line = _g.stderrLineBuffer.getBytes().toString()
						_g.log(line)
						_g.stderrLineBuffer = haxe_io_BytesOutput()
					else:
						_g.stderrLineBuffer.writeString(_hx_str)
					_g.timeoutTicker = True
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				if isinstance(_hx_e1, haxe_io_Eof):
						pass
				else:
					e1 = _hx_e1
					duell_helpers_LogHelper.info(("Exception with stackTrace:\n" + HxOverrides.stringOrNull(_hx_local_1())))
			_g.log(_g.stderrLineBuffer.getBytes().toString())
			_g.finished = True
			_g.stderrFinished = True
			_g.waitingOnStderrMutex.release()
			_g.exitCodeBlocking()
		duell_helpers_ThreadHelper.runInAThread(_hx_local_2)

	def startTimeoutListener(self):
		_g = self
		if (self.timeout != 0):
			def _hx_local_0():
				while (not _g.finished):
					if (not _g.timeoutTicker):
						_g.finished = True
						_g.timedout = True
						duell_helpers_LogHelper.println((((("Process \"" + HxOverrides.stringOrNull(_g.command)) + " ") + HxOverrides.stringOrNull(" ".join([python_Boot.toString1(x1,'') for x1 in _g.args]))) + "\" timed out."))
						_g.process.kill()
						_g.process.close()
						break
					_g.timeoutTicker = False
					Sys.sleep(_g.timeout)
				_g.exitCodeBlocking()
			duell_helpers_ThreadHelper.runInAThread(_hx_local_0)

	def blockUntilFinished(self):
		self.exitCodeBlocking()

	def kill(self):
		if ((not self.finished) and (not self.killed)):
			self.killed = True
			self.process.kill()
			self.process.close()
			self.exitCodeBlocking()

	def hasFinished(self):
		return self.finished

	def readCurrentStdout(self):
		if (len(self.stdout.b.b) == 0):
			return None
		self.stdoutMutex.acquire()
		_hx_bytes = self.stdout.getBytes()
		self.stdout = haxe_io_BytesOutput()
		self.stdoutMutex.release()
		return _hx_bytes

	def readCurrentStderr(self):
		if (len(self.stderr.b.b) == 0):
			return None
		self.stderrMutex.acquire()
		_hx_bytes = self.stderr.getBytes()
		self.stderr = haxe_io_BytesOutput()
		self.stderrMutex.release()
		return _hx_bytes

	def getCompleteStdout(self):
		if (not self.finished):
			return None
		self.waitingOnStdoutMutex.acquire()
		self.waitingOnStdoutMutex.release()
		self.stdoutMutex.acquire()
		_hx_bytes = self.totalStdout.getBytes()
		self.totalStdout = haxe_io_BytesOutput()
		self.stdoutMutex.release()
		return _hx_bytes

	def getCompleteStderr(self):
		if (not self.finished):
			return None
		self.waitingOnStderrMutex.acquire()
		self.waitingOnStderrMutex.release()
		self.stderrMutex.acquire()
		_hx_bytes = self.totalStderr.getBytes()
		self.totalStderr = haxe_io_BytesOutput()
		self.stderrMutex.release()
		return _hx_bytes

	def exitCode(self):
		if (not self.finished):
			raise _HxException("Duell Process exitCode() called without the process having ended. Please call blockUntilFinished, before retrieving the exitCode")
		return self.exitCodeBlocking()

	def exitCodeBlocking(self):
		self.exitCodeMutex.acquire()
		if (self.exitCodeCache is None):
			self.waitingOnStderrMutex.acquire()
			self.waitingOnStderrMutex.release()
			self.waitingOnStdoutMutex.acquire()
			self.waitingOnStdoutMutex.release()
			while (not self.finished):
				pass
			if self.killed:
				self.exitCodeCache = 0
			elif self.closed:
				self.exitCodeCache = 0
			elif self.timedout:
				self.exitCodeCache = 1
			else:
				self.exitCodeCache = self.process.exitCode()
			if (self.shutdownOnError and ((self.timedout or ((self.exitCodeCache != 0))))):
				failureType = (" - Exit code: " + Std.string(self.exitCodeCache))
				if self.timedout:
					failureType = " - timedout"
				postfix = ""
				if ((self.errorMessage is not None) and ((self.errorMessage != ""))):
					postfix = (" - Action was: " + HxOverrides.stringOrNull(self.errorMessage))
				commandString = ((HxOverrides.stringOrNull(self.command) + " ") + HxOverrides.stringOrNull(self.argString))
				pathString = None
				if (self.path != ""):
					pathString = (" - in path: " + HxOverrides.stringOrNull(self.path))
				else:
					pathString = ""
				self.exitCodeMutex.release()
				raise _HxException(((((((((((("Process " + "\x1B[1m") + " ") + ("null" if commandString is None else commandString)) + " ") + "\x1B[0m") + " ") + ("null" if pathString is None else pathString)) + " ") + ("null" if failureType is None else failureType)) + " ") + ("null" if postfix is None else postfix)))
		self.exitCodeMutex.release()
		return self.exitCodeCache

	def isTimedout(self):
		return self.timedout

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.stdin = None
		_hx_o.stdoutLineBuffer = None
		_hx_o.stdout = None
		_hx_o.totalStdout = None
		_hx_o.stdoutMutex = None
		_hx_o.stderr = None
		_hx_o.totalStderr = None
		_hx_o.stderrMutex = None
		_hx_o.stderrLineBuffer = None
		_hx_o.waitingOnStderrMutex = None
		_hx_o.waitingOnStdoutMutex = None
		_hx_o.timeoutTicker = None
		_hx_o.exitCodeMutex = None
		_hx_o.exitCodeCache = None
		_hx_o.finished = None
		_hx_o.killed = None
		_hx_o.closed = None
		_hx_o.timedout = None
		_hx_o.stdoutFinished = None
		_hx_o.stderrFinished = None
		_hx_o.process = None
		_hx_o.systemCommand = None
		_hx_o.loggingPrefix = None
		_hx_o.logOnlyIfVerbose = None
		_hx_o.timeout = None
		_hx_o.block = None
		_hx_o.mute = None
		_hx_o.shutdownOnError = None
		_hx_o.errorMessage = None
		_hx_o.command = None
		_hx_o.path = None
		_hx_o.args = None
		_hx_o.argString = None
duell_objects_DuellProcess._hx_class = duell_objects_DuellProcess
_hx_classes["duell.objects.DuellProcess"] = duell_objects_DuellProcess


class duell_objects_HXCPPConfigXML:
	_hx_class_name = "duell.objects.HXCPPConfigXML"
	_hx_fields = ["xml", "configPath"]
	_hx_methods = ["getDefines", "writeDefines", "getDefinesFromSectionVars"]
	_hx_statics = ["cache", "getConfig"]

	def __init__(self,configPath):
		self.xml = None
		self.configPath = None
		self.xml = None
		self.configPath = configPath
		self.xml = haxe_xml_Fast(Xml.parse(sys_io_File.getContent(configPath)).firstElement())

	def getDefines(self):
		_hx_local_0 = self.xml.get_elements()
		while _hx_local_0.hasNext():
			element = _hx_local_0.next()
			_g = element.get_name()
			if (_g == "section"):
				if element.has.resolve("id"):
					if (element.att.resolve("id") == "vars"):
						return self.getDefinesFromSectionVars(element)
			else:
				pass
		return haxe_ds_StringMap()

	def writeDefines(self,defines):
		newContent = ""
		definesText = ""
		env = Sys.environment()
		_hx_local_1 = defines.keys()
		while _hx_local_1.hasNext():
			key = _hx_local_1.next()
			if ((not key in env.h) or ((env.h.get(key,None) != defines.h.get(key,None)))):
				definesText = (("null" if definesText is None else definesText) + HxOverrides.stringOrNull(((((("\t\t<set name=\"" + ("null" if key is None else key)) + "\" value=\"") + HxOverrides.stringOrNull(duell_helpers_PathHelper.stripQuotes(defines.h.get(key,None)))) + "\" />\n"))))
		if sys_FileSystem.exists(self.configPath):
			_hx_bytes = sys_io_File.getBytes(self.configPath)
			backup = sys_io_File.write(((HxOverrides.stringOrNull(self.configPath) + ".bak.") + Std.string(haxe_Timer.stamp())),False)
			backup.writeBytes(_hx_bytes,0,_hx_bytes.length)
			backup.close()
			content = _hx_bytes.getString(0,_hx_bytes.length)
			startIndex = content.find("<section id=\"vars\">")
			endIndex = None
			endIndex = (content.find("</section>") if ((startIndex is None)) else content.find("</section>", startIndex))
			newContent = (("null" if newContent is None else newContent) + HxOverrides.stringOrNull(((HxOverrides.stringOrNull(HxString.substr(content,0,startIndex)) + "<section id=\"vars\">\n\t\t\n"))))
			newContent = (("null" if newContent is None else newContent) + ("null" if definesText is None else definesText))
			newContent = (("null" if newContent is None else newContent) + HxOverrides.stringOrNull((("\t\t\n\t" + HxOverrides.stringOrNull(HxString.substr(content,endIndex,None))))))
		else:
			newContent = (("null" if newContent is None else newContent) + "<xml>\n\n")
			newContent = (("null" if newContent is None else newContent) + "\t<section id=\"vars\">\n\n")
			newContent = (("null" if newContent is None else newContent) + ("null" if definesText is None else definesText))
			newContent = (("null" if newContent is None else newContent) + "\t</section>\n\n</xml>")
		output = sys_io_File.write(self.configPath,False)
		output.writeString(newContent)
		output.close()

	def getDefinesFromSectionVars(self,sectionElement):
		defines = haxe_ds_StringMap()
		_hx_local_0 = sectionElement.get_elements()
		while _hx_local_0.hasNext():
			element = _hx_local_0.next()
			_g = element.get_name()
			if (_g == "set"):
				if element.has.resolve("name"):
					name = element.att.resolve("name")
					value = ""
					if element.has.resolve("value"):
						value = element.att.resolve("value")
					defines.h[name] = value
					value
			else:
				pass
		return defines
	cache = None

	@staticmethod
	def getConfig(configPath):
		if (duell_objects_HXCPPConfigXML.cache is None):
			duell_objects_HXCPPConfigXML.cache = duell_objects_HXCPPConfigXML(configPath)
			return duell_objects_HXCPPConfigXML.cache
		if (duell_objects_HXCPPConfigXML.cache.configPath != configPath):
			duell_objects_HXCPPConfigXML.cache = duell_objects_HXCPPConfigXML(configPath)
			return duell_objects_HXCPPConfigXML.cache
		return duell_objects_HXCPPConfigXML.cache

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.xml = None
		_hx_o.configPath = None
duell_objects_HXCPPConfigXML._hx_class = duell_objects_HXCPPConfigXML
_hx_classes["duell.objects.HXCPPConfigXML"] = duell_objects_HXCPPConfigXML


class duell_objects_Haxelib:
	_hx_class_name = "duell.objects.Haxelib"
	_hx_fields = ["name", "version", "path"]
	_hx_methods = ["setPath", "exists", "isHaxelibInstalled", "getPath", "isValidLibPath", "getHaxelibPathOutput", "selectVersion", "uninstall", "install", "isGitVersion", "toString"]
	_hx_statics = ["haxelibCache", "getHaxelib", "solveConflict"]

	def __init__(self,name,version = ""):
		if (version is None):
			version = ""
		self.name = None
		self.version = None
		self.path = None
		self.path = None
		self.name = name
		if (version is None):
			version = ""
		self.version = version

	def setPath(self,path):
		self.path = path

	def exists(self):
		if self.isHaxelibInstalled():
			if (self.version == ""):
				return True
			compareVersion = StringTools.replace(self.version,".",",")
			def _hx_local_0():
				_this = self.getPath()
				delimiter = self.name
				return (list(_this) if ((delimiter == "")) else _this.split(delimiter))
			versionPath = (HxOverrides.stringOrNull(python_internal_ArrayImpl._get((_hx_local_0()), 0)) + HxOverrides.stringOrNull(self.name))
			versionArray = duell_helpers_PathHelper.getFolderListUnderFolder(versionPath)
			if (python_internal_ArrayImpl.indexOf(versionArray,compareVersion,None) != -1):
				return True
			else:
				return False
		else:
			return False

	def isHaxelibInstalled(self):
		output = self.getHaxelibPathOutput()
		if (output.find("is not installed") != -1):
			return False
		else:
			return True

	def getPath(self):
		if (self.path is not None):
			return self.path
		if (not self.isHaxelibInstalled()):
			if (self.version != ""):
				raise _HxException((((("Could not find haxelib \"" + HxOverrides.stringOrNull(self.name)) + "\" version \"") + HxOverrides.stringOrNull(self.version)) + "\", does it need to be installed?"))
			else:
				raise _HxException((("Could not find haxelib \"" + HxOverrides.stringOrNull(self.name)) + "\", does it need to be installed?"))
		output = self.getHaxelibPathOutput()
		lines = output.split("\n")
		duell_helpers_LogHelper.info("---------------- ")
		duell_helpers_LogHelper.info(("name: " + HxOverrides.stringOrNull(self.name)))
		_g1 = 1
		_g = len(lines)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			if StringTools.startsWith(StringTools.trim((lines[i] if i >= 0 and i < len(lines) else None)),"-D"):
				self.path = StringTools.trim(python_internal_ArrayImpl._get(lines, (i - 1)))
				duell_helpers_LogHelper.info(("path after trim: " + HxOverrides.stringOrNull(self.path)))
				if self.isValidLibPath(self.path,self.name):
					break
		duell_helpers_LogHelper.info(("path after loop: " + HxOverrides.stringOrNull(self.path)))
		duell_helpers_LogHelper.info("---------------- ")
		if (self.path == ""):
			try:
				_g2 = 0
				while (_g2 < len(lines)):
					line = (lines[_g2] if _g2 >= 0 and _g2 < len(lines) else None)
					_g2 = (_g2 + 1)
					if ((line != "") and ((HxString.substr(line,0,1) != "-"))):
						if sys_FileSystem.exists(line):
							self.path = line
							break
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				pass
		return self.path

	def isValidLibPath(self,libPath,libName):
		return (sys_FileSystem.exists(libPath) and ((libPath.find(libName) != -1)))

	def getHaxelibPathOutput(self):
		nameToTry = self.name
		haxePath = Sys.getEnv("HAXEPATH")
		systemCommand = None
		if ((haxePath is not None) and ((haxePath != ""))):
			systemCommand = False
		else:
			systemCommand = True
		proc = duell_objects_DuellProcess(haxePath, "haxelib", ["path", nameToTry], _hx_AnonObject({'block': True, 'systemCommand': True, 'errorMessage': "getting path of library"}))
		output = proc.getCompleteStdout()
		return output.toString()

	def selectVersion(self):
		if ((self.version is None) or ((self.version == ""))):
			return
		arguments = []
		if self.isGitVersion():
			arguments.append("git")
			arguments.append(self.name)
			a = None
			_this = self.version
			a = _this.split(" ")
			arguments = (arguments + a)
		else:
			arguments.append("set")
			arguments.append(self.name)
			arguments.append(self.version)
		haxePath = Sys.getEnv("HAXEPATH")
		systemCommand = None
		if ((haxePath is not None) and ((haxePath != ""))):
			systemCommand = False
		else:
			systemCommand = True
		process = duell_objects_DuellProcess(haxePath, "haxelib", arguments, _hx_AnonObject({'systemCommand': systemCommand, 'errorMessage': "set haxelib version"}))
		process.stdin.writeString("y\n")
		process.blockUntilFinished()

	def uninstall(self):
		args = ["remove", self.name]
		haxePath = Sys.getEnv("HAXEPATH")
		systemCommand = None
		if ((haxePath is not None) and ((haxePath != ""))):
			systemCommand = False
		else:
			systemCommand = True
		process = duell_objects_DuellProcess(haxePath, "haxelib", args, _hx_AnonObject({'systemCommand': systemCommand, 'errorMessage': (("uninstalling the library \"" + HxOverrides.stringOrNull(self.name)) + "\""), 'mute': True}))
		process.blockUntilFinished()

	def install(self):
		if self.isGitVersion():
			self.selectVersion()
		elif duell_helpers_ConnectionHelper.isOnline():
			args = ["install", self.name]
			if (self.version != ""):
				args.append(self.version)
			haxePath = Sys.getEnv("HAXEPATH")
			systemCommand = None
			if ((haxePath is not None) and ((haxePath != ""))):
				systemCommand = False
			else:
				systemCommand = True
			process = duell_objects_DuellProcess(haxePath, "haxelib", args, _hx_AnonObject({'systemCommand': systemCommand, 'errorMessage': (("installing the library \"" + HxOverrides.stringOrNull(self.name)) + "\""), 'mute': True}))
			process.stdin.writeString("y\n")
			process.blockUntilFinished()

	def isGitVersion(self):
		return ((self.version is not None) and ((StringTools.startsWith(self.version,"ssh") or StringTools.startsWith(self.version,"http"))))

	def toString(self):
		return ((("haxelib " + HxOverrides.stringOrNull(self.name)) + " version ") + HxOverrides.stringOrNull(self.version))

	@staticmethod
	def getHaxelib(name,version = ""):
		if (version is None):
			version = ""
		if name in duell_objects_Haxelib.haxelibCache.h:
			versionMap = duell_objects_Haxelib.haxelibCache.h.get(name,None)
			if (not version in versionMap.h):
				value = duell_objects_Haxelib(name, version)
				versionMap.h[version] = value
		else:
			versionMap1 = haxe_ds_StringMap()
			value1 = duell_objects_Haxelib(name, version)
			versionMap1.h[version] = value1
			duell_objects_Haxelib.haxelibCache.h[name] = versionMap1
		this1 = duell_objects_Haxelib.haxelibCache.h.get(name,None)
		return this1.get(version)

	@staticmethod
	def solveConflict(left,right):
		if (left.isGitVersion() and right.isGitVersion()):
			if (left.version != right.version):
				return None
			return left
		if left.isGitVersion():
			return left
		if right.isGitVersion():
			return right
		if ((left.version is None) or ((left.version == ""))):
			return right
		if ((right.version is None) or ((right.version == ""))):
			return left
		if (left.version == right.version):
			return left
		return None

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.name = None
		_hx_o.version = None
		_hx_o.path = None
duell_objects_Haxelib._hx_class = duell_objects_Haxelib
_hx_classes["duell.objects.Haxelib"] = duell_objects_Haxelib


class duell_objects_SemVer:
	_hx_class_name = "duell.objects.SemVer"
	_hx_fields = ["major", "minor", "patch", "plus", "rc"]
	_hx_methods = ["toString"]
	_hx_statics = ["parse", "ofString", "areCompatible", "getMostSpecific", "START_OFFSET", "OFFSET_REDUCTION", "compare"]

	def __init__(self,major,minor,patch,rc,plus):
		self.major = None
		self.minor = None
		self.patch = None
		self.plus = None
		self.rc = None
		self.major = major
		self.minor = minor
		self.patch = patch
		self.rc = rc
		self.plus = plus
		if (self.major is None):
			self.major = 0
			self.plus = True
			duell_helpers_LogHelper.info("asterisks on versions as been deprecated. Please use 1.0.0+ instead of 1.*.*")
		if (self.minor is None):
			self.minor = 0
			self.plus = True
			duell_helpers_LogHelper.info("asterisks on versions as been deprecated. Please use 1.0.0+ instead of 1.*.*")
		if (self.patch is None):
			self.patch = 0
			self.plus = True
			duell_helpers_LogHelper.info("asterisks on versions as been deprecated. Please use 1.0.0+ instead of 1.*.*")

	def toString(self):
		ret = ""
		ret = (("null" if ret is None else ret) + HxOverrides.stringOrNull((("" + Std.string(self.major)))))
		ret = (("null" if ret is None else ret) + HxOverrides.stringOrNull((("." + Std.string(self.minor)))))
		ret = (("null" if ret is None else ret) + HxOverrides.stringOrNull((("." + Std.string(self.patch)))))
		if self.rc:
			ret = (("null" if ret is None else ret) + "-rc")
		if self.plus:
			ret = (("null" if ret is None else ret) + "+")
		return ret

	@staticmethod
	def ofString(s):
		if (s is None):
			return None
		major = None
		minor = None
		patch = None
		rc = False
		plus = False
		def _hx_local_0():
			_this = duell_objects_SemVer.parse
			s1 = s.lower()
			_this.matchObj = python_lib_Re.search(_this.pattern,s1)
			return (_this.matchObj is not None)
		if _hx_local_0():
			if (duell_objects_SemVer.parse.matchObj.group(1) != "*"):
				major = Std.parseInt(duell_objects_SemVer.parse.matchObj.group(1))
			if (duell_objects_SemVer.parse.matchObj.group(2) != "*"):
				minor = Std.parseInt(duell_objects_SemVer.parse.matchObj.group(2))
			if (duell_objects_SemVer.parse.matchObj.group(3) != "*"):
				patch = Std.parseInt(duell_objects_SemVer.parse.matchObj.group(3))
			_g = duell_objects_SemVer.parse.matchObj.group(4)
			v = _g
			if (v is None):
				rc = False
			else:
				v1 = _g
				rc = True
			_g1 = duell_objects_SemVer.parse.matchObj.group(5)
			v2 = _g1
			if (v2 is None):
				plus = False
			else:
				v3 = _g1
				plus = True
		else:
			return None
		return duell_objects_SemVer(major, minor, patch, rc, plus)

	@staticmethod
	def areCompatible(left,right):
		if (left.major != right.major):
			return False
		if ((not left.plus) and (not right.plus)):
			return ((left.minor == right.minor) and ((left.patch == right.patch)))
		if (left.plus and right.plus):
			return True
		if (not left.plus):
			if (left.minor < right.minor):
				return False
			if ((left.minor == right.minor) and ((left.patch < right.patch))):
				return False
		else:
			if (right.minor < left.minor):
				return False
			if ((left.minor == right.minor) and ((right.patch < left.patch))):
				return False
		return True

	@staticmethod
	def getMostSpecific(left,right):
		if left.plus:
			return right
		if right.plus:
			return left
		return left

	@staticmethod
	def compare(left,right):
		def _hx_local_6(ver):
			output = 0
			offset = 10000000
			output = (offset * ver.major)
			def _hx_local_1():
				_hx_local_0 = None
				try:
					_hx_local_0 = int((offset / 100))
				except Exception as _hx_e:
					_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
					e = _hx_e1
					_hx_local_0 = None
				return _hx_local_0
			offset = _hx_local_1()
			output = (output + ((offset * ver.minor)))
			def _hx_local_4():
				_hx_local_3 = None
				try:
					_hx_local_3 = int((offset / 100))
				except Exception as _hx_e:
					_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
					e1 = _hx_e1
					_hx_local_3 = None
				return _hx_local_3
			offset = _hx_local_4()
			output = (output + ((offset * ver.patch)))
			return output
		accumulator = _hx_local_6
		leftAccum = accumulator(left)
		rightAccum = accumulator(right)
		return (rightAccum - leftAccum)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.major = None
		_hx_o.minor = None
		_hx_o.patch = None
		_hx_o.plus = None
		_hx_o.rc = None
duell_objects_SemVer._hx_class = duell_objects_SemVer
_hx_classes["duell.objects.SemVer"] = duell_objects_SemVer


class duell_objects_dependencies_DependencyConfigFile:
	_hx_class_name = "duell.objects.dependencies.DependencyConfigFile"
	_hx_fields = ["path", "fileName", "applicationName", "duellLibs", "haxeLibs"]
	_hx_methods = ["parse", "parseHaxeLib", "parseApp", "parseDuellLib", "getAbsolutePath", "hasHaxeLibs"]

	def __init__(self,path,fileName):
		self.path = None
		self.fileName = None
		self.applicationName = None
		self.duellLibs = None
		self.haxeLibs = None
		self.path = path
		self.fileName = fileName
		self.duellLibs = list()
		self.haxeLibs = list()
		self.parse()

	def parse(self):
		filePath = self.getAbsolutePath()
		if (not sys_FileSystem.exists(filePath)):
			return
		fileContent = sys_io_File.getContent(filePath)
		try:
			fileXmlContent = Xml.parse(fileContent)
			content = haxe_xml_Fast(fileXmlContent.firstElement())
			_hx_local_1 = content.get_elements()
			while _hx_local_1.hasNext():
				element = _hx_local_1.next()
				_g = element.get_name()
				_hx_local_0 = len(_g)
				if (_hx_local_0 == 3):
					if (_g == "app"):
						self.parseApp(element)
				elif (_hx_local_0 == 7):
					if (_g == "haxelib"):
						self.parseHaxeLib(element)
				elif (_hx_local_0 == 8):
					if (_g == "duelllib"):
						self.parseDuellLib(element)
				else:
					pass
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			e = _hx_e1
			raise _HxException((("Invalid file \"" + ("null" if filePath is None else filePath)) + "\"!"))

	def parseHaxeLib(self,e):
		name = None
		if e.has.resolve("name"):
			name = e.att.resolve("name")
		else:
			name = ""
		version = None
		if e.has.resolve("version"):
			version = e.att.resolve("version")
		else:
			version = ""
		_this = self.haxeLibs
		x = duell_objects_Haxelib.getHaxelib(name,version)
		_this.append(x)

	def parseApp(self,e):
		if (e.has.resolve("title") and e.has.resolve("company")):
			self.applicationName = e.att.resolve("title")

	def parseDuellLib(self,e):
		name = None
		if e.has.resolve("name"):
			name = e.att.resolve("name")
		else:
			name = ""
		version = None
		if e.has.resolve("version"):
			version = e.att.resolve("version")
		else:
			version = ""
		_this = self.duellLibs
		x = duell_objects_DuellLib.getDuellLib(name,version)
		_this.append(x)

	def getAbsolutePath(self):
		return haxe_io_Path.join([self.path, self.fileName])

	def hasHaxeLibs(self):
		return (len(self.haxeLibs) > 0)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.path = None
		_hx_o.fileName = None
		_hx_o.applicationName = None
		_hx_o.duellLibs = None
		_hx_o.haxeLibs = None
duell_objects_dependencies_DependencyConfigFile._hx_class = duell_objects_dependencies_DependencyConfigFile
_hx_classes["duell.objects.dependencies.DependencyConfigFile"] = duell_objects_dependencies_DependencyConfigFile


class duell_objects_dependencies_DependencyLibraryObject:
	_hx_class_name = "duell.objects.dependencies.DependencyLibraryObject"
	_hx_fields = ["name", "configFile", "lib", "libraryDependencyObjects"]
	_hx_methods = ["addDependency", "toString"]

	def __init__(self,configFile,name,version = "master"):
		if (version is None):
			version = "master"
		self.name = None
		self.configFile = None
		self.lib = None
		self.libraryDependencyObjects = None
		self.name = name
		self.configFile = configFile
		self.lib = duell_objects_DuellLib.getDuellLib(name,version)
		self.libraryDependencyObjects = list()

	def addDependency(self,libraryObject):
		_this = self.libraryDependencyObjects
		_this.append(libraryObject)

	def toString(self):
		return ((("DependencyLibraryObject :: name: " + HxOverrides.stringOrNull(self.name)) + " dependencies: ") + Std.string(self.libraryDependencyObjects))

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.name = None
		_hx_o.configFile = None
		_hx_o.lib = None
		_hx_o.libraryDependencyObjects = None
duell_objects_dependencies_DependencyLibraryObject._hx_class = duell_objects_dependencies_DependencyLibraryObject
_hx_classes["duell.objects.dependencies.DependencyLibraryObject"] = duell_objects_dependencies_DependencyLibraryObject


class duell_objects_dependencies_IFileContentCreator:
	_hx_class_name = "duell.objects.dependencies.IFileContentCreator"
	_hx_methods = ["parseDuellLibs", "parseHaxeLibs", "getContent", "getFilename"]
duell_objects_dependencies_IFileContentCreator._hx_class = duell_objects_dependencies_IFileContentCreator
_hx_classes["duell.objects.dependencies.IFileContentCreator"] = duell_objects_dependencies_IFileContentCreator


class duell_objects_dependencies_DotFileContentCreator:
	_hx_class_name = "duell.objects.dependencies.DotFileContentCreator"
	_hx_fields = ["duellLibContent", "haxeLibsContent"]
	_hx_methods = ["parseDuellLibs", "parseHaxeLibs", "getDuellLibContent", "getHaxeLibsContent", "getContent", "getFilename", "getBaseFormat", "getHaxelibsFormat"]
	_hx_interfaces = [duell_objects_dependencies_IFileContentCreator]

	def __init__(self):
		self.duellLibContent = None
		self.haxeLibsContent = None
		self.haxeLibsContent = ""
		self.duellLibContent = ""

	def parseDuellLibs(self,rootNode):
		subnodes = rootNode.libraryDependencyObjects
		nodeName = rootNode.name
		if ((len(self.duellLibContent) == 0) and ((len(subnodes) == 0))):
			self.duellLibContent = (("null" if nodeName is None else nodeName) + ";\n    ")
		_g = 0
		while (_g < len(subnodes)):
			subnode = (subnodes[_g] if _g >= 0 and _g < len(subnodes) else None)
			_g = (_g + 1)
			lib = subnode.lib
			label = None
			if (lib is not None):
				label = ((" [label=\"" + HxOverrides.stringOrNull(lib.version)) + "\", fontsize=10]")
			else:
				label = ""
			_hx_local_1 = self
			_hx_local_2 = _hx_local_1.duellLibContent
			_hx_local_1.duellLibContent = (("null" if _hx_local_2 is None else _hx_local_2) + HxOverrides.stringOrNull(((((((("    \"" + ("null" if nodeName is None else nodeName)) + "\" -> \"") + HxOverrides.stringOrNull(subnode.name)) + "\"") + ("null" if label is None else label)) + ";\n"))))
			_hx_local_1.duellLibContent
		_g1 = 0
		while (_g1 < len(subnodes)):
			subnode1 = (subnodes[_g1] if _g1 >= 0 and _g1 < len(subnodes) else None)
			_g1 = (_g1 + 1)
			self.parseDuellLibs(subnode1)

	def parseHaxeLibs(self,rootNode):
		config = rootNode.configFile
		if config.hasHaxeLibs():
			haxeLibs = config.haxeLibs
			_g = 0
			while (_g < len(haxeLibs)):
				lib = (haxeLibs[_g] if _g >= 0 and _g < len(haxeLibs) else None)
				_g = (_g + 1)
				label = ((" [label=\"" + HxOverrides.stringOrNull(lib.version)) + "\", fontcolor=\"#999999\", fontsize=10]")
				_hx_local_1 = self
				_hx_local_2 = _hx_local_1.haxeLibsContent
				_hx_local_1.haxeLibsContent = (("null" if _hx_local_2 is None else _hx_local_2) + HxOverrides.stringOrNull(((((((("   \"" + HxOverrides.stringOrNull(rootNode.name)) + "\" -> \"") + HxOverrides.stringOrNull(lib.name)) + "\"") + ("null" if label is None else label)) + ";\n"))))
				_hx_local_1.haxeLibsContent
		subNodes = rootNode.libraryDependencyObjects
		_g1 = 0
		while (_g1 < len(subNodes)):
			subNode = (subNodes[_g1] if _g1 >= 0 and _g1 < len(subNodes) else None)
			_g1 = (_g1 + 1)
			self.parseHaxeLibs(subNode)

	def getDuellLibContent(self):
		if (len(self.duellLibContent) > 0):
			return (HxOverrides.stringOrNull(self.getBaseFormat()) + HxOverrides.stringOrNull(self.duellLibContent))
		return ""

	def getHaxeLibsContent(self):
		if (len(self.haxeLibsContent) > 0):
			return (HxOverrides.stringOrNull(self.getHaxelibsFormat()) + HxOverrides.stringOrNull(self.haxeLibsContent))
		return ""

	def getContent(self):
		return (((("digraph G {\n" + "    graph [size=\"10.3,5.3\", ranksep=0.5, nodesep=0.1, overlap=false, start=1]") + HxOverrides.stringOrNull(self.getDuellLibContent())) + HxOverrides.stringOrNull(self.getHaxeLibsContent())) + "}")

	def getFilename(self):
		return "dotFile.dot"

	def getBaseFormat(self):
		return (((("    node [fontname=Verdana,fontsize=12]\n" + "    node [style=filled]\n") + "    node [fillcolor=\"#FC861C44\"]\n") + "    node [color=\"#FC332244\"]\n") + "    edge [color=\"#FC861C\"]\n")

	def getHaxelibsFormat(self):
		return (((("    node [fontname=Verdana,fontsize=12, fontcolor=\"#999999\"]\n" + "    node [style=filled]\n") + "    node [fillcolor=\"#EEEEEE\"]\n") + "    node [color=\"#AAAAAA\"]\n") + "    edge [color=\"#AAAAAA\"]\n")

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.duellLibContent = None
		_hx_o.haxeLibsContent = None
duell_objects_dependencies_DotFileContentCreator._hx_class = duell_objects_dependencies_DotFileContentCreator
_hx_classes["duell.objects.dependencies.DotFileContentCreator"] = duell_objects_dependencies_DotFileContentCreator

class duell_versioning_VersionType(Enum):
	_hx_class_name = "duell.versioning.VersionType"
	_hx_constructs = ["Branch", "Override", "Version", "Unavailable"]
duell_versioning_VersionType.Branch = duell_versioning_VersionType("Branch", 0, list())
duell_versioning_VersionType.Override = duell_versioning_VersionType("Override", 1, list())
duell_versioning_VersionType.Version = duell_versioning_VersionType("Version", 2, list())
duell_versioning_VersionType.Unavailable = duell_versioning_VersionType("Unavailable", 3, list())
duell_versioning_VersionType._hx_class = duell_versioning_VersionType
_hx_classes["duell.versioning.VersionType"] = duell_versioning_VersionType


class duell_versioning_GitVers:
	_hx_class_name = "duell.versioning.GitVers"
	_hx_fields = ["dir", "branchList", "tagList", "currentVersion"]
	_hx_methods = ["getCurrentVersionOfDirectory", "resolveVersionConflict", "solveVersion", "needsToChangeVersion", "changeToVersion", "handleChangeToBranch", "handleChangeToTag", "determineRequestedSemanticVersions", "determineExistingSemanticVersions", "determineRequestedBranches"]
	_hx_statics = ["removeDuplicateVersions"]

	def __init__(self,dir):
		self.dir = None
		self.branchList = None
		self.tagList = None
		self.currentVersion = None
		self.tagList = []
		self.branchList = []
		self.dir = None
		self.dir = dir
		duell_helpers_GitHelper.fetch(dir)
		self.branchList = duell_helpers_GitHelper.listBranches(dir)
		self.tagList = duell_helpers_GitHelper.listTags(dir)
		self.tagList.reverse()
		self.currentVersion = self.getCurrentVersionOfDirectory()

	def getCurrentVersionOfDirectory(self):
		currentBranch = duell_helpers_GitHelper.getCurrentBranch(self.dir)
		commit = duell_helpers_GitHelper.getCurrentCommit(self.dir)
		_g = 0
		_g1 = self.tagList
		while (_g < len(_g1)):
			tag = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
			_g = (_g + 1)
			if (duell_objects_SemVer.ofString(tag) is not None):
				if (duell_helpers_GitHelper.getCommitForTag(self.dir,tag) == commit):
					return tag
		return currentBranch

	def resolveVersionConflict(self,requestedVersions,rc = False,overrideVersion = None,libs = None):
		if (rc is None):
			rc = False
		if (overrideVersion is not None):
			if (python_internal_ArrayImpl.indexOf(self.branchList,overrideVersion,None) != -1):
				return overrideVersion
		if (len(requestedVersions) == 0):
			raise _HxException(("Cannot solve versioning with empty requested version list for path: " + HxOverrides.stringOrNull(self.dir)))
		requestedVersions = duell_versioning_GitVers.removeDuplicateVersions(requestedVersions)
		requestedBranches = self.determineRequestedBranches(requestedVersions)
		if (len(requestedBranches) > 1):
			raise _HxException(((("Cannot solve version conflict because more than one branch was requested for the library in path " + HxOverrides.stringOrNull(self.dir)) + " - branches: ") + Std.string(requestedVersions)))
		if (len(requestedBranches) > 0):
			return (requestedBranches[0] if 0 < len(requestedBranches) else None)
		requestedSemanticVersions = self.determineRequestedSemanticVersions(requestedVersions)
		if (len(requestedSemanticVersions) == 0):
			raise _HxException(((("Cannot solve version conflict because there are no valid versions or branches for library in path " + HxOverrides.stringOrNull(self.dir)) + " - branches: ") + Std.string(requestedVersions)))
		firstSemVer = (requestedSemanticVersions[0] if 0 < len(requestedSemanticVersions) else None)
		_g = 0
		while (_g < len(requestedSemanticVersions)):
			semVer = (requestedSemanticVersions[_g] if _g >= 0 and _g < len(requestedSemanticVersions) else None)
			_g = (_g + 1)
			if (not duell_objects_SemVer.areCompatible(firstSemVer,semVer)):
				msg = None
				if (libs is None):
					msg = (((((("Version conflict for " + HxOverrides.stringOrNull(self.dir)) + ". Versions ") + HxOverrides.stringOrNull(semVer.toString())) + " and ") + HxOverrides.stringOrNull(firstSemVer.toString())) + " are incompatible!")
				else:
					msg = (((((("Version conflict for '" + HxOverrides.stringOrNull((libs[0] if 0 < len(libs) else None))) + "' (") + HxOverrides.stringOrNull(self.dir)) + ")\n") + HxOverrides.stringOrNull(((((((("'" + HxOverrides.stringOrNull((libs[1] if 1 < len(libs) else None))) + "' depends on '") + HxOverrides.stringOrNull((libs[0] if 0 < len(libs) else None))) + "' ") + HxOverrides.stringOrNull(firstSemVer.toString())) + "\n")))) + HxOverrides.stringOrNull((((((("'" + HxOverrides.stringOrNull((libs[2] if 2 < len(libs) else None))) + "' depends on '") + HxOverrides.stringOrNull((libs[0] if 0 < len(libs) else None))) + "' ") + HxOverrides.stringOrNull(semVer.toString())))))
				raise _HxException(msg)
		def _hx_local_1(s):
			return s.rc
		rcVersions = list(filter(_hx_local_1,requestedSemanticVersions))
		if (len(rcVersions) > 0):
			requestedSemanticVersions = rcVersions
		requestedSemanticVersions.sort(key= python_lib_Functools.cmp_to_key(duell_objects_SemVer.compare))
		bestVersion = (requestedSemanticVersions[0] if 0 < len(requestedSemanticVersions) else None)
		_g1 = 0
		while (_g1 < len(requestedSemanticVersions)):
			version = (requestedSemanticVersions[_g1] if _g1 >= 0 and _g1 < len(requestedSemanticVersions) else None)
			_g1 = (_g1 + 1)
			bestVersion = duell_objects_SemVer.getMostSpecific(bestVersion,version)
		return bestVersion.toString()

	def solveVersion(self,version,rc = False,overrideVersion = None):
		if (rc is None):
			rc = False
		if (overrideVersion is not None):
			if (python_internal_ArrayImpl.indexOf(self.branchList,overrideVersion,None) != -1):
				return overrideVersion
		if (python_internal_ArrayImpl.indexOf(self.branchList,version,None) != -1):
			return version
		semVer = duell_objects_SemVer.ofString(version)
		if (semVer is None):
			raise _HxException("version is neither a branch or a semantic version")
		existingSemanticVersions = self.determineExistingSemanticVersions()
		if ((not semVer.rc) and (not rc)):
			def _hx_local_0(s):
				return (not s.rc)
			existingSemanticVersions = list(filter(_hx_local_0,existingSemanticVersions))
		existingSemanticVersions.sort(key= python_lib_Functools.cmp_to_key(duell_objects_SemVer.compare))
		usedVersion = None
		_g = 0
		while (_g < len(existingSemanticVersions)):
			existing = (existingSemanticVersions[_g] if _g >= 0 and _g < len(existingSemanticVersions) else None)
			_g = (_g + 1)
			if duell_objects_SemVer.areCompatible(existing,semVer):
				usedVersion = existing
				break
		if (usedVersion is None):
			def _hx_local_2(s1):
				return s1.toString()
			raise _HxException(((("could not find any version that is compatible with " + HxOverrides.stringOrNull(semVer.toString())) + " in existing versions: ") + Std.string(list(map(_hx_local_2,existingSemanticVersions)))))
		return usedVersion.toString()

	def needsToChangeVersion(self,version):
		if (python_internal_ArrayImpl.indexOf(self.branchList,version,None) != -1):
			if (duell_helpers_GitHelper.getCurrentBranch(self.dir) != version):
				return True
			if duell_helpers_GitHelper.updateNeeded(self.dir):
				return True
			return False
		if (python_internal_ArrayImpl.indexOf(self.tagList,version,None) != -1):
			commit = duell_helpers_GitHelper.getCommitForTag(self.dir,version)
			if (duell_helpers_GitHelper.getCurrentCommit(self.dir) != commit):
				return True
			return False
		raise _HxException((("version requested for change '" + ("null" if version is None else version)) + "' is neither a version nor an existing branch"))

	def changeToVersion(self,version):
		self.currentVersion = version
		if (python_internal_ArrayImpl.indexOf(self.branchList,version,None) != -1):
			return self.handleChangeToBranch(version)
		if (python_internal_ArrayImpl.indexOf(self.tagList,version,None) != -1):
			return self.handleChangeToTag(version)
		raise _HxException((("version requested for change '" + ("null" if version is None else version)) + "' is neither a version nor an existing branch"))

	def handleChangeToBranch(self,branch):
		changed = False
		if (duell_helpers_GitHelper.getCurrentBranch(self.dir) != branch):
			if (not duell_helpers_GitHelper.isRepoWithoutLocalChanges(self.dir)):
				raise _HxException(("can't change branch of repo because it has local changes, path: " + HxOverrides.stringOrNull(self.dir)))
			duell_helpers_GitHelper.checkoutBranch(self.dir,branch)
			changed = True
		if duell_helpers_GitHelper.updateNeeded(self.dir):
			if (not duell_helpers_GitHelper.isRepoWithoutLocalChanges(self.dir)):
				raise _HxException(("can't change update repo because it has local changes, path: " + HxOverrides.stringOrNull(self.dir)))
			duell_helpers_GitHelper.pull(self.dir)
			changed = True
		return changed

	def handleChangeToTag(self,version):
		changed = False
		commit = duell_helpers_GitHelper.getCommitForTag(self.dir,version)
		if (duell_helpers_GitHelper.getCurrentCommit(self.dir) != commit):
			if (not duell_helpers_GitHelper.isRepoWithoutLocalChanges(self.dir)):
				raise _HxException(("can't change to tagged commit of repo because it has local changes, path: " + HxOverrides.stringOrNull(self.dir)))
			duell_helpers_GitHelper.checkoutCommit(self.dir,commit)
			changed = True
		return changed

	def determineRequestedSemanticVersions(self,requestedVersions):
		requestedSemanticVersions = []
		_g = 0
		while (_g < len(requestedVersions)):
			version = (requestedVersions[_g] if _g >= 0 and _g < len(requestedVersions) else None)
			_g = (_g + 1)
			semVer = duell_objects_SemVer.ofString(version)
			if (semVer is not None):
				requestedSemanticVersions.append(semVer)
		return requestedSemanticVersions

	def determineExistingSemanticVersions(self):
		existingSemanticVersions = []
		_g = 0
		_g1 = self.tagList
		while (_g < len(_g1)):
			version = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
			_g = (_g + 1)
			semVer = duell_objects_SemVer.ofString(version)
			if (semVer is not None):
				existingSemanticVersions.append(semVer)
		return existingSemanticVersions

	def determineRequestedBranches(self,requestedVersions):
		requestedBranches = []
		_g = 0
		while (_g < len(requestedVersions)):
			version = (requestedVersions[_g] if _g >= 0 and _g < len(requestedVersions) else None)
			_g = (_g + 1)
			if (python_internal_ArrayImpl.indexOf(self.branchList,version,None) != -1):
				requestedBranches.append(version)
		return requestedBranches

	@staticmethod
	def removeDuplicateVersions(requestedVersions):
		newList = []
		_g = 0
		while (_g < len(requestedVersions)):
			version = (requestedVersions[_g] if _g >= 0 and _g < len(requestedVersions) else None)
			_g = (_g + 1)
			if (python_internal_ArrayImpl.indexOf(newList,version,None) == -1):
				newList.append(version)
		return newList

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.dir = None
		_hx_o.branchList = None
		_hx_o.tagList = None
		_hx_o.currentVersion = None
duell_versioning_GitVers._hx_class = duell_versioning_GitVers
_hx_classes["duell.versioning.GitVers"] = duell_versioning_GitVers


class duell_versioning_locking_LockedVersionsHelper:
	_hx_class_name = "duell.versioning.locking.LockedVersionsHelper"
	_hx_statics = ["DEFAULT_FOLDER", "DEFAULT_FILE", "versionMap", "getLastLockedVersion", "getLastVersionDiffs", "getVersions", "addLockedVersion"]

	@staticmethod
	def getLastLockedVersion(path):
		versions = duell_versioning_locking_LockedVersionsHelper.getVersions(path)
		return versions.getLastLockedLibraries()

	@staticmethod
	def getLastVersionDiffs(path):
		versions = duell_versioning_locking_LockedVersionsHelper.getVersions(path)
		return versions.getLastVersionDiffs()

	@staticmethod
	def getVersions(path):
		if (path == ""):
			path = haxe_io_Path.join([Sys.getCwd(), "versions", "log.xml"])
		else:
			path = path
		if (not path in duell_versioning_locking_LockedVersionsHelper.versionMap.h):
			versions = duell_versioning_locking_LockedVersions(duell_versioning_locking_file_LockingFileXMLParser(), path)
			versions.setupFileSystem()
			versions.loadAndParseFile()
			duell_versioning_locking_LockedVersionsHelper.versionMap.h[path] = versions
		return duell_versioning_locking_LockedVersionsHelper.versionMap.h.get(path,None)

	@staticmethod
	def addLockedVersion(duelllibs,haxelibs,plugins):
		versions = duell_versioning_locking_LockedVersionsHelper.getVersions("")
		versions.addLibraries(duelllibs,haxelibs,plugins)
duell_versioning_locking_LockedVersionsHelper._hx_class = duell_versioning_locking_LockedVersionsHelper
_hx_classes["duell.versioning.locking.LockedVersionsHelper"] = duell_versioning_locking_LockedVersionsHelper


class duell_versioning_locking_LockedVersions:
	_hx_class_name = "duell.versioning.locking.LockedVersions"
	_hx_fields = ["lockedVersions", "parser", "path"]
	_hx_methods = ["setupFileSystem", "loadAndParseFile", "getLastLockedVersion", "addLibraries", "getLastLockedLibraries", "getLastVersionDiffs", "checkUpdates", "checkNumberTrackedVersions", "saveFile"]
	_hx_statics = ["NUMBER_MAX_TRACKED_VERSIONS"]

	def __init__(self,parser,path):
		self.lockedVersions = None
		self.parser = None
		self.path = None
		self.lockedVersions = list()
		self.parser = parser
		self.path = path

	def setupFileSystem(self):
		dir = haxe_io_Path.directory(self.path)
		if (not sys_FileSystem.exists(dir)):
			sys_FileSystem.createDirectory(dir)

	def loadAndParseFile(self):
		stringContent = ""
		if sys_FileSystem.exists(self.path):
			stringContent = sys_io_File.getContent(self.path)
		self.lockedVersions = self.parser.parseFile(stringContent)

	def getLastLockedVersion(self):
		version = None
		_g = 0
		_g1 = self.lockedVersions
		while (_g < len(_g1)):
			lv = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
			_g = (_g + 1)
			if (version is not None):
				lvTime = Date.fromString(lv.ts)
				vTime = Date.fromString(version.ts)
				if (Date.datetimeTimestamp(lvTime.date,Date.EPOCH_LOCAL) > Date.datetimeTimestamp(vTime.date,Date.EPOCH_LOCAL)):
					version = lv
				else:
					version = version
			else:
				version = lv
		return version

	def addLibraries(self,duell1,haxe,plugins):
		now = Date.now().toString()
		currentVersion = duell_versioning_objects_LockedVersion(now)
		_g = 0
		while (_g < len(duell1)):
			dLib = (duell1[_g] if _g >= 0 and _g < len(duell1) else None)
			_g = (_g + 1)
			currentCommit = duell_helpers_GitHelper.getCurrentCommit(dLib.getPath())
			lockedLib = _hx_AnonObject({'name': dLib.name, 'type': "duelllib", 'version': dLib.version, 'commitHash': currentCommit})
			currentVersion.addUsedLib(lockedLib)
		_g1 = 0
		while (_g1 < len(haxe)):
			hLib = (haxe[_g1] if _g1 >= 0 and _g1 < len(haxe) else None)
			_g1 = (_g1 + 1)
			lockedLib1 = _hx_AnonObject({'name': hLib.name, 'type': "haxelib", 'version': hLib.version, 'commitHash': ""})
			currentVersion.addUsedLib(lockedLib1)
		_g2 = 0
		while (_g2 < len(plugins)):
			p = (plugins[_g2] if _g2 >= 0 and _g2 < len(plugins) else None)
			_g2 = (_g2 + 1)
			currentCommit1 = duell_helpers_GitHelper.getCurrentCommit(p.getPath())
			lockedLib2 = _hx_AnonObject({'name': p.name, 'type': "plugin", 'version': p.version, 'commitHash': currentCommit1})
			currentVersion.addPlugin(lockedLib2)
		lastLockedVersion = self.getLastLockedVersion()
		_this = self.lockedVersions
		_this.append(currentVersion)
		self.checkUpdates(lastLockedVersion,currentVersion)
		self.checkNumberTrackedVersions()
		self.saveFile()

	def getLastLockedLibraries(self):
		libraries = self.getLastLockedVersion()
		usedLibraries = None
		if (libraries is not None):
			usedLibraries = libraries.usedLibs
		else:
			usedLibraries = haxe_ds_StringMap()
		dLibs = list()
		hLibs = list()
		plugins = list()
		_hx_local_1 = usedLibraries.keys()
		while _hx_local_1.hasNext():
			key = _hx_local_1.next()
			lockedLib = usedLibraries.h.get(key,None)
			_g = lockedLib.type
			_hx_local_0 = len(_g)
			if (_hx_local_0 == 7):
				if (_g == "haxelib"):
					x1 = duell_objects_Haxelib.getHaxelib(lockedLib.name,lockedLib.version)
					hLibs.append(x1)
			elif (_hx_local_0 == 8):
				if (_g == "duelllib"):
					x = duell_objects_DuellLib.getDuellLib(lockedLib.name,lockedLib.version,lockedLib.commitHash)
					dLibs.append(x)
			elif (_hx_local_0 == 6):
				if (_g == "plugin"):
					x2 = duell_objects_DuellLib.getDuellLib(lockedLib.name,lockedLib.version,lockedLib.commitHash)
					plugins.append(x2)
			else:
				pass
		return _hx_AnonObject({'duelllibs': dLibs, 'haxelibs': hLibs, 'plugins': plugins})

	def getLastVersionDiffs(self):
		version = self.getLastLockedVersion()
		updates = None
		if (version is not None):
			updates = version.updates
		else:
			updates = haxe_ds_StringMap()
		diffs = list()
		_hx_local_1 = updates.keys()
		while _hx_local_1.hasNext():
			key = _hx_local_1.next()
			updates1 = updates.h.get(key,None)
			_g = 0
			while (_g < len(updates1)):
				u = (updates1[_g] if _g >= 0 and _g < len(updates1) else None)
				_g = (_g + 1)
				x = _hx_AnonObject({'name': key, 'type': duell_versioning_objects_LockedVersion.getLibChangeTypeAsString(u.name), 'typeReadable': duell_versioning_objects_LockedVersion.getLibChangeTypeReadable(u.name), 'oldVal': u.oldValue, 'newVal': u.newValue})
				diffs.append(x)
		return diffs

	def checkUpdates(self,oldVersion,newVersion):
		if (oldVersion is None):
			return
		_hx_local_0 = newVersion.usedLibs.iterator()
		while _hx_local_0.hasNext():
			newLib = _hx_local_0.next()
			if (not newLib.name in oldVersion.usedLibs.h):
				update = _hx_AnonObject({'name': duell_versioning_objects_LibChangeType.NEW_LIB, 'oldValue': "0.0.0", 'newValue': newLib.version})
				newVersion.addUpdatedLib(newLib.name,update)
				continue
			oldLib = oldVersion.usedLibs.h.get(newLib.name,None)
			if (oldLib.version != newLib.version):
				update1 = _hx_AnonObject({'name': duell_versioning_objects_LibChangeType.VERSION, 'oldValue': oldLib.version, 'newValue': newLib.version})
				newVersion.addUpdatedLib(newLib.name,update1)
			if (oldLib.commitHash != newLib.commitHash):
				update2 = _hx_AnonObject({'name': duell_versioning_objects_LibChangeType.COMMITHASH, 'oldValue': oldLib.commitHash, 'newValue': newLib.commitHash})
				newVersion.addUpdatedLib(newLib.name,update2)
		_hx_local_1 = oldVersion.usedLibs.iterator()
		while _hx_local_1.hasNext():
			oldLib1 = _hx_local_1.next()
			if (not oldLib1.name in newVersion.usedLibs.h):
				update3 = _hx_AnonObject({'name': duell_versioning_objects_LibChangeType.REMOVED_LIB, 'oldValue': oldLib1.version, 'newValue': "0.0.0"})
				newVersion.addUpdatedLib(oldLib1.name,update3)

	def checkNumberTrackedVersions(self):
		num = (len(self.lockedVersions) - 5)
		if (num > 0):
			_this = self.lockedVersions
			pos = 0
			if (pos < 0):
				pos = (len(_this) + pos)
			if (pos < 0):
				pos = 0
			res = _this[pos:(pos + num)]
			del _this[pos:(pos + num)]
			res

	def saveFile(self):
		content = self.parser.createFileContent(self.lockedVersions)
		fileOutput = sys_io_File.write(self.path,False)
		fileOutput.writeString(content)
		fileOutput.close()

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.lockedVersions = None
		_hx_o.parser = None
		_hx_o.path = None
duell_versioning_locking_LockedVersions._hx_class = duell_versioning_locking_LockedVersions
_hx_classes["duell.versioning.locking.LockedVersions"] = duell_versioning_locking_LockedVersions


class duell_versioning_locking_file_ILockingFileParser:
	_hx_class_name = "duell.versioning.locking.file.ILockingFileParser"
	_hx_methods = ["parseFile", "createFileContent"]
duell_versioning_locking_file_ILockingFileParser._hx_class = duell_versioning_locking_file_ILockingFileParser
_hx_classes["duell.versioning.locking.file.ILockingFileParser"] = duell_versioning_locking_file_ILockingFileParser


class duell_versioning_locking_file_LockingFileXMLParser:
	_hx_class_name = "duell.versioning.locking.file.LockingFileXMLParser"
	_hx_fields = ["builds"]
	_hx_methods = ["parseFile", "parse", "parseBuild", "parseLibs", "parseChanges", "createFileContent", "getLibsContent", "sortStrings", "getUpdatedContent"]
	_hx_interfaces = [duell_versioning_locking_file_ILockingFileParser]

	def __init__(self):
		self.builds = None
		self.builds = list()

	def parseFile(self,stringContent):
		if ((stringContent is None) or ((len(stringContent) == 0))):
			return list()
		xmlContent = haxe_xml_Fast(Xml.parse(stringContent).firstElement())
		self.parse(xmlContent)
		return self.builds

	def parse(self,source):
		_hx_local_0 = source.get_elements()
		while _hx_local_0.hasNext():
			element = _hx_local_0.next()
			_g = element.get_name()
			if (_g == "build"):
				self.parseBuild(element)
			else:
				pass

	def parseBuild(self,element):
		ts = None
		if element.has.resolve("date"):
			ts = element.att.resolve("date")
		else:
			ts = "0"
		build = duell_versioning_objects_LockedVersion(ts)
		_hx_local_1 = element.get_elements()
		while _hx_local_1.hasNext():
			child = _hx_local_1.next()
			_g = child.get_name()
			_hx_local_0 = len(_g)
			if (_hx_local_0 == 4):
				if (_g == "libs"):
					self.parseLibs(build,child)
			elif (_hx_local_0 == 7):
				if (_g == "updates"):
					self.parseChanges(build,child)
			else:
				pass
		_this = self.builds
		_this.append(build)

	def parseLibs(self,currentBuild,element):
		_hx_local_0 = element.get_elements()
		while _hx_local_0.hasNext():
			e = _hx_local_0.next()
			_hx_type = e.get_name()
			name = None
			if e.has.resolve("name"):
				name = e.att.resolve("name")
			else:
				name = ""
			version = None
			if e.has.resolve("version"):
				version = e.att.resolve("version")
			else:
				version = "0.0.0"
			commitHash = None
			if e.has.resolve("commitHash"):
				commitHash = e.att.resolve("commitHash")
			else:
				commitHash = ""
			currentBuild.addUsedLib(_hx_AnonObject({'type': _hx_type, 'name': name, 'version': version, 'commitHash': commitHash}))

	def parseChanges(self,currentBuild,element):
		_hx_local_1 = element.get_elements()
		while _hx_local_1.hasNext():
			l = _hx_local_1.next()
			libname = None
			if l.has.resolve("name"):
				libname = l.att.resolve("name")
			else:
				libname = ""
			_hx_local_0 = l.get_elements()
			while _hx_local_0.hasNext():
				c = _hx_local_0.next()
				changeType = c.get_name()
				oldValue = None
				if c.has.resolve("oldValue"):
					oldValue = c.att.resolve("oldValue")
				else:
					oldValue = ""
				newValue = None
				if c.has.resolve("newValue"):
					newValue = c.att.resolve("newValue")
				else:
					newValue = ""
				currentBuild.addUpdatedLib(libname,_hx_AnonObject({'name': duell_versioning_objects_LockedVersion.getLibChangeType(changeType), 'oldValue': oldValue, 'newValue': newValue}))

	def createFileContent(self,objects):
		result = ""
		buildResult = None
		_g1 = 0
		_g = len(objects)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			b = (objects[i] if i >= 0 and i < len(objects) else None)
			libs = self.getLibsContent(b.usedLibs)
			changes = self.getUpdatedContent(b.updates)
			buildResult = (("  <build date=\"" + HxOverrides.stringOrNull(b.ts)) + "\">\n")
			buildResult = (("null" if buildResult is None else buildResult) + HxOverrides.stringOrNull(((("    <libs>\n" + ("null" if libs is None else libs)) + "    </libs>\n"))))
			buildResult = (("null" if buildResult is None else buildResult) + HxOverrides.stringOrNull(((("    <updates>\n" + ("null" if changes is None else changes)) + "    </updates>\n"))))
			buildResult = (("null" if buildResult is None else buildResult) + "  </build>\n")
			result = (("null" if result is None else result) + ("null" if buildResult is None else buildResult))
		return (("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<builds>\n" + ("null" if result is None else result)) + "</builds>")

	def getLibsContent(self,libs):
		results = list()
		_hx_local_0 = libs.keys()
		while _hx_local_0.hasNext():
			key = _hx_local_0.next()
			lib = libs.h.get(key,None)
			results.append((((((((("      <" + HxOverrides.stringOrNull(lib.type)) + " name=\"") + HxOverrides.stringOrNull(lib.name)) + "\" version=\"") + HxOverrides.stringOrNull(lib.version)) + "\" ") + HxOverrides.stringOrNull((((("commitHash=\"" + HxOverrides.stringOrNull(lib.commitHash)) + "\" ") if ((lib.commitHash != "")) else "")))) + "/>"))
		results.sort(key= python_lib_Functools.cmp_to_key(self.sortStrings))
		if (len(results) == 0):
			return ""
		else:
			return (HxOverrides.stringOrNull("\n".join([python_Boot.toString1(x1,'') for x1 in results])) + "\n")

	def sortStrings(self,lib1,lib2):
		if (lib1 > lib2):
			return 1
		else:
			return -1

	def getUpdatedContent(self,updates):
		results = list()
		_hx_local_2 = updates.keys()
		while _hx_local_2.hasNext():
			key = _hx_local_2.next()
			changes = updates.h.get(key,None)
			changeList = ""
			_g = 0
			while (_g < len(changes)):
				u = (changes[_g] if _g >= 0 and _g < len(changes) else None)
				_g = (_g + 1)
				changeList = (("null" if changeList is None else changeList) + HxOverrides.stringOrNull(((((((("        <" + HxOverrides.stringOrNull(duell_versioning_objects_LockedVersion.getLibChangeTypeAsString(u.name))) + " oldValue=\"") + HxOverrides.stringOrNull(u.oldValue)) + "\" newValue=\"") + HxOverrides.stringOrNull(u.newValue)) + "\" />\n"))))
			results.append((((("      <update name=\"" + ("null" if key is None else key)) + "\">\n") + ("null" if changeList is None else changeList)) + "      </update>"))
		results.sort(key= python_lib_Functools.cmp_to_key(self.sortStrings))
		if (len(results) == 0):
			return ""
		else:
			return (HxOverrides.stringOrNull("\n".join([python_Boot.toString1(x1,'') for x1 in results])) + "\n")

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.builds = None
duell_versioning_locking_file_LockingFileXMLParser._hx_class = duell_versioning_locking_file_LockingFileXMLParser
_hx_classes["duell.versioning.locking.file.LockingFileXMLParser"] = duell_versioning_locking_file_LockingFileXMLParser

class duell_versioning_objects_LibChangeType(Enum):
	_hx_class_name = "duell.versioning.objects.LibChangeType"
	_hx_constructs = ["VERSION", "NEW_LIB", "REMOVED_LIB", "COMMITHASH"]
duell_versioning_objects_LibChangeType.VERSION = duell_versioning_objects_LibChangeType("VERSION", 0, list())
duell_versioning_objects_LibChangeType.NEW_LIB = duell_versioning_objects_LibChangeType("NEW_LIB", 1, list())
duell_versioning_objects_LibChangeType.REMOVED_LIB = duell_versioning_objects_LibChangeType("REMOVED_LIB", 2, list())
duell_versioning_objects_LibChangeType.COMMITHASH = duell_versioning_objects_LibChangeType("COMMITHASH", 3, list())
duell_versioning_objects_LibChangeType._hx_class = duell_versioning_objects_LibChangeType
_hx_classes["duell.versioning.objects.LibChangeType"] = duell_versioning_objects_LibChangeType


class duell_versioning_objects_LockedVersion:
	_hx_class_name = "duell.versioning.objects.LockedVersion"
	_hx_fields = ["ts", "usedLibs", "updates"]
	_hx_methods = ["addUsedLib", "addPlugin", "addUpdatedLib", "toString"]
	_hx_statics = ["getLibChangeType", "getLibChangeTypeAsString", "getLibChangeTypeReadable"]

	def __init__(self,time):
		self.ts = None
		self.usedLibs = None
		self.updates = None
		self.ts = time
		self.usedLibs = haxe_ds_StringMap()
		self.updates = haxe_ds_StringMap()

	def addUsedLib(self,lib):
		self.usedLibs.h[lib.name] = lib

	def addPlugin(self,plugin):
		self.usedLibs.h[plugin.name] = plugin

	def addUpdatedLib(self,libName,change):
		if (not libName in self.updates.h):
			value = list()
			self.updates.h[libName] = value
		_hx_list = self.updates.h.get(libName,None)
		_hx_list.append(change)

	def toString(self):
		return ("Class::LockedVersion:: ts:" + HxOverrides.stringOrNull(self.ts))

	@staticmethod
	def getLibChangeType(value):
		_hx_local_0 = len(value)
		if (_hx_local_0 == 10):
			if (value == "commitHash"):
				return duell_versioning_objects_LibChangeType.COMMITHASH
			elif (value == "removedLib"):
				return duell_versioning_objects_LibChangeType.REMOVED_LIB
		elif (_hx_local_0 == 7):
			if (value == "version"):
				return duell_versioning_objects_LibChangeType.VERSION
		elif (_hx_local_0 == 6):
			if (value == "newLib"):
				return duell_versioning_objects_LibChangeType.NEW_LIB
		else:
			pass
		return None

	@staticmethod
	def getLibChangeTypeAsString(value):
		if ((value.index) == 0):
			return "version"
		elif ((value.index) == 3):
			return "commitHash"
		elif ((value.index) == 1):
			return "newLib"
		elif ((value.index) == 2):
			return "removedLib"
		else:
			pass
		return None

	@staticmethod
	def getLibChangeTypeReadable(value):
		if ((value.index) == 0):
			return "Versions"
		elif ((value.index) == 3):
			return "Commithashes"
		elif ((value.index) == 1):
			return "New libraries"
		elif ((value.index) == 2):
			return "Removed libraries"
		else:
			pass
		return None

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.ts = None
		_hx_o.usedLibs = None
		_hx_o.updates = None
duell_versioning_objects_LockedVersion._hx_class = duell_versioning_objects_LockedVersion
_hx_classes["duell.versioning.objects.LockedVersion"] = duell_versioning_objects_LockedVersion

class haxe_StackItem(Enum):
	_hx_class_name = "haxe.StackItem"
	_hx_constructs = ["CFunction", "Module", "FilePos", "Method", "LocalFunction"]

	@staticmethod
	def Module(m):
		return haxe_StackItem("Module", 1, [m])

	@staticmethod
	def FilePos(s,file,line):
		return haxe_StackItem("FilePos", 2, [s,file,line])

	@staticmethod
	def Method(classname,method):
		return haxe_StackItem("Method", 3, [classname,method])

	@staticmethod
	def LocalFunction(v = None):
		return haxe_StackItem("LocalFunction", 4, [v])
haxe_StackItem.CFunction = haxe_StackItem("CFunction", 0, list())
haxe_StackItem._hx_class = haxe_StackItem
_hx_classes["haxe.StackItem"] = haxe_StackItem


class haxe_CallStack:
	_hx_class_name = "haxe.CallStack"
	_hx_statics = ["exceptionStack"]

	@staticmethod
	def exceptionStack():
		stack = []
		exc = python_lib_Sys.exc_info()
		if (exc[2] is not None):
			infos = python_lib_Traceback.extract_tb(exc[2])
			infos.reverse()
			_g = 0
			while (_g < len(infos)):
				elem = (infos[_g] if _g >= 0 and _g < len(infos) else None)
				_g = (_g + 1)
				x = haxe_StackItem.FilePos(None,elem[0],elem[1])
				stack.append(x)
		return stack
haxe_CallStack._hx_class = haxe_CallStack
_hx_classes["haxe.CallStack"] = haxe_CallStack


class haxe_Resource:
	_hx_class_name = "haxe.Resource"
	_hx_statics = ["content", "getContent", "getString"]
	content = None

	@staticmethod
	def getContent():
		if (haxe_Resource.content is None):
			haxe_Resource.content = _hx_resources__()
		return haxe_Resource.content

	@staticmethod
	def getString(name):
		def _hx_local_0():
			_this = haxe_Resource.getContent()
			return name in _this
		if _hx_local_0():
			return haxe_io_Bytes.ofData(haxe_Resource.getContent().get(name,None)).toString()
		else:
			return None
haxe_Resource._hx_class = haxe_Resource
_hx_classes["haxe.Resource"] = haxe_Resource


class haxe_Serializer:
	_hx_class_name = "haxe.Serializer"
	_hx_fields = ["buf", "cache", "shash", "scount", "useCache", "useEnumIndex"]
	_hx_methods = ["toString", "serializeString", "serializeRef", "serializeFields", "serialize"]
	_hx_statics = ["USE_CACHE", "USE_ENUM_INDEX", "BASE64"]

	def __init__(self):
		self.buf = None
		self.cache = None
		self.shash = None
		self.scount = None
		self.useCache = None
		self.useEnumIndex = None
		self.buf = StringBuf()
		self.cache = list()
		self.useCache = haxe_Serializer.USE_CACHE
		self.useEnumIndex = haxe_Serializer.USE_ENUM_INDEX
		self.shash = haxe_ds_StringMap()
		self.scount = 0

	def toString(self):
		return self.buf.b.getvalue()

	def serializeString(self,s):
		x = self.shash.h.get(s,None)
		if (x is not None):
			self.buf.b.write("R")
			self.buf.b.write(Std.string(x))
			return
		value = self.scount
		self.scount = (self.scount + 1)
		self.shash.h[s] = value
		self.buf.b.write("y")
		s = python_lib_urllib_Parse.quote(s,"")
		self.buf.b.write(Std.string(len(s)))
		self.buf.b.write(":")
		self.buf.b.write(Std.string(s))

	def serializeRef(self,v):
		_g1 = 0
		_g = len(self.cache)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			if ((self.cache[i] if i >= 0 and i < len(self.cache) else None) == v):
				self.buf.b.write("r")
				self.buf.b.write(Std.string(i))
				return True
		_this = self.cache
		_this.append(v)
		return False

	def serializeFields(self,v):
		_g = 0
		_g1 = python_Boot.fields(v)
		while (_g < len(_g1)):
			f = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
			_g = (_g + 1)
			self.serializeString(f)
			self.serialize(Reflect.field(v,f))
		self.buf.b.write("g")

	def serialize(self,v):
		_g = Type.typeof(v)
		if ((_g.index) == 0):
			self.buf.b.write("n")
		elif ((_g.index) == 1):
			v1 = v
			if (v1 == 0):
				self.buf.b.write("z")
				return
			self.buf.b.write("i")
			self.buf.b.write(Std.string(v1))
		elif ((_g.index) == 2):
			v2 = v
			if python_lib_Math.isnan(v2):
				self.buf.b.write("k")
			elif (not ((((v2 != Math.POSITIVE_INFINITY) and ((v2 != Math.NEGATIVE_INFINITY))) and (not python_lib_Math.isnan(v2))))):
				self.buf.b.write(("m" if ((v2 < 0)) else "p"))
			else:
				self.buf.b.write("d")
				self.buf.b.write(Std.string(v2))
		elif ((_g.index) == 3):
			self.buf.b.write(("t" if v else "f"))
		elif ((_g.index) == 6):
			c = _g.params[0]
			if (c == str):
				self.serializeString(v)
				return
			if (self.useCache and self.serializeRef(v)):
				return
			_g1 = Type.getClassName(c)
			_hx_local_0 = len(_g1)
			if (_hx_local_0 == 17):
				if (_g1 == "haxe.ds.StringMap"):
					self.buf.b.write("b")
					v5 = v
					_hx_local_1 = v5.keys()
					while _hx_local_1.hasNext():
						k = _hx_local_1.next()
						self.serializeString(k)
						self.serialize(v5.h.get(k,None))
					self.buf.b.write("h")
				elif (_g1 == "haxe.ds.ObjectMap"):
					self.buf.b.write("M")
					v7 = v
					_hx_local_2 = v7.keys()
					while _hx_local_2.hasNext():
						k2 = _hx_local_2.next()
						self.serialize(k2)
						self.serialize(v7.h.get(k2,None))
					self.buf.b.write("h")
				else:
					if self.useCache:
						_this = self.cache
						if (len(_this) == 0):
							None
						else:
							_this.pop()
					if hasattr(v,(("_hx_" + "hxSerialize") if ("hxSerialize" in python_Boot.keywords) else (("_hx_" + "hxSerialize") if (((((len("hxSerialize") > 2) and ((ord("hxSerialize"[0]) == 95))) and ((ord("hxSerialize"[1]) == 95))) and ((ord("hxSerialize"[(len("hxSerialize") - 1)]) != 95)))) else "hxSerialize"))):
						self.buf.b.write("C")
						self.serializeString(Type.getClassName(c))
						if self.useCache:
							_this1 = self.cache
							x10 = v
							_this1.append(x10)
						Reflect.field(v,"hxSerialize")(self)
						self.buf.b.write("g")
					else:
						self.buf.b.write("c")
						self.serializeString(Type.getClassName(c))
						if self.useCache:
							_this2 = self.cache
							x11 = v
							_this2.append(x11)
						self.serializeFields(v)
			elif (_hx_local_0 == 5):
				if (_g1 == "Array"):
					ucount = 0
					self.buf.b.write("a")
					v3 = v
					l = len(v3)
					_g2 = 0
					while (_g2 < l):
						i = _g2
						_g2 = (_g2 + 1)
						if ((v3[i] if i >= 0 and i < len(v3) else None) is None):
							ucount = (ucount + 1)
						else:
							if (ucount > 0):
								if (ucount == 1):
									self.buf.b.write("n")
								else:
									self.buf.b.write("u")
									self.buf.b.write(Std.string(ucount))
								ucount = 0
							self.serialize((v3[i] if i >= 0 and i < len(v3) else None))
					if (ucount > 0):
						if (ucount == 1):
							self.buf.b.write("n")
						else:
							self.buf.b.write("u")
							self.buf.b.write(Std.string(ucount))
					self.buf.b.write("h")
				else:
					if self.useCache:
						_this = self.cache
						if (len(_this) == 0):
							None
						else:
							_this.pop()
					if hasattr(v,(("_hx_" + "hxSerialize") if ("hxSerialize" in python_Boot.keywords) else (("_hx_" + "hxSerialize") if (((((len("hxSerialize") > 2) and ((ord("hxSerialize"[0]) == 95))) and ((ord("hxSerialize"[1]) == 95))) and ((ord("hxSerialize"[(len("hxSerialize") - 1)]) != 95)))) else "hxSerialize"))):
						self.buf.b.write("C")
						self.serializeString(Type.getClassName(c))
						if self.useCache:
							_this1 = self.cache
							x10 = v
							_this1.append(x10)
						Reflect.field(v,"hxSerialize")(self)
						self.buf.b.write("g")
					else:
						self.buf.b.write("c")
						self.serializeString(Type.getClassName(c))
						if self.useCache:
							_this2 = self.cache
							x11 = v
							_this2.append(x11)
						self.serializeFields(v)
			elif (_hx_local_0 == 4):
				if (_g1 == "List"):
					self.buf.b.write("l")
					v4 = v
					_g2_head = v4.h
					_g2_val = None
					while (_g2_head is not None):
						i1 = None
						_g2_val = (_g2_head[0] if 0 < len(_g2_head) else None)
						_g2_head = (_g2_head[1] if 1 < len(_g2_head) else None)
						i1 = _g2_val
						self.serialize(i1)
					self.buf.b.write("h")
				elif (_g1 == "Date"):
					d = v
					self.buf.b.write("v")
					x = Date.datetimeTimestamp(d.date,Date.EPOCH_LOCAL)
					self.buf.b.write(Std.string(x))
				else:
					if self.useCache:
						_this = self.cache
						if (len(_this) == 0):
							None
						else:
							_this.pop()
					if hasattr(v,(("_hx_" + "hxSerialize") if ("hxSerialize" in python_Boot.keywords) else (("_hx_" + "hxSerialize") if (((((len("hxSerialize") > 2) and ((ord("hxSerialize"[0]) == 95))) and ((ord("hxSerialize"[1]) == 95))) and ((ord("hxSerialize"[(len("hxSerialize") - 1)]) != 95)))) else "hxSerialize"))):
						self.buf.b.write("C")
						self.serializeString(Type.getClassName(c))
						if self.useCache:
							_this1 = self.cache
							x10 = v
							_this1.append(x10)
						Reflect.field(v,"hxSerialize")(self)
						self.buf.b.write("g")
					else:
						self.buf.b.write("c")
						self.serializeString(Type.getClassName(c))
						if self.useCache:
							_this2 = self.cache
							x11 = v
							_this2.append(x11)
						self.serializeFields(v)
			elif (_hx_local_0 == 13):
				if (_g1 == "haxe.io.Bytes"):
					v8 = v
					i2 = 0
					_hx_max = (v8.length - 2)
					charsBuf_b = python_lib_io_StringIO()
					b64 = haxe_Serializer.BASE64
					while (i2 < _hx_max):
						b1 = None
						pos = i2
						i2 = (i2 + 1)
						b1 = v8.b[pos]
						b2 = None
						pos1 = i2
						i2 = (i2 + 1)
						b2 = v8.b[pos1]
						b3 = None
						pos2 = i2
						i2 = (i2 + 1)
						b3 = v8.b[pos2]
						x1 = None
						index = (b1 >> 2)
						if ((index < 0) or ((index >= len(b64)))):
							x1 = ""
						else:
							x1 = b64[index]
						charsBuf_b.write(Std.string(x1))
						x2 = None
						index1 = ((((b1 << 4) | ((b2 >> 4)))) & 63)
						if ((index1 < 0) or ((index1 >= len(b64)))):
							x2 = ""
						else:
							x2 = b64[index1]
						charsBuf_b.write(Std.string(x2))
						x3 = None
						index2 = ((((b2 << 2) | ((b3 >> 6)))) & 63)
						if ((index2 < 0) or ((index2 >= len(b64)))):
							x3 = ""
						else:
							x3 = b64[index2]
						charsBuf_b.write(Std.string(x3))
						x4 = None
						index3 = (b3 & 63)
						if ((index3 < 0) or ((index3 >= len(b64)))):
							x4 = ""
						else:
							x4 = b64[index3]
						charsBuf_b.write(Std.string(x4))
					if (i2 == _hx_max):
						b11 = None
						pos3 = i2
						i2 = (i2 + 1)
						b11 = v8.b[pos3]
						b21 = None
						pos4 = i2
						i2 = (i2 + 1)
						b21 = v8.b[pos4]
						x5 = None
						index4 = (b11 >> 2)
						if ((index4 < 0) or ((index4 >= len(b64)))):
							x5 = ""
						else:
							x5 = b64[index4]
						charsBuf_b.write(Std.string(x5))
						x6 = None
						index5 = ((((b11 << 4) | ((b21 >> 4)))) & 63)
						if ((index5 < 0) or ((index5 >= len(b64)))):
							x6 = ""
						else:
							x6 = b64[index5]
						charsBuf_b.write(Std.string(x6))
						x7 = None
						index6 = ((b21 << 2) & 63)
						if ((index6 < 0) or ((index6 >= len(b64)))):
							x7 = ""
						else:
							x7 = b64[index6]
						charsBuf_b.write(Std.string(x7))
					elif (i2 == ((_hx_max + 1))):
						b12 = None
						pos5 = i2
						i2 = (i2 + 1)
						b12 = v8.b[pos5]
						x8 = None
						index7 = (b12 >> 2)
						if ((index7 < 0) or ((index7 >= len(b64)))):
							x8 = ""
						else:
							x8 = b64[index7]
						charsBuf_b.write(Std.string(x8))
						x9 = None
						index8 = ((b12 << 4) & 63)
						if ((index8 < 0) or ((index8 >= len(b64)))):
							x9 = ""
						else:
							x9 = b64[index8]
						charsBuf_b.write(Std.string(x9))
					chars = charsBuf_b.getvalue()
					self.buf.b.write("s")
					self.buf.b.write(Std.string(len(chars)))
					self.buf.b.write(":")
					self.buf.b.write(Std.string(chars))
				else:
					if self.useCache:
						_this = self.cache
						if (len(_this) == 0):
							None
						else:
							_this.pop()
					if hasattr(v,(("_hx_" + "hxSerialize") if ("hxSerialize" in python_Boot.keywords) else (("_hx_" + "hxSerialize") if (((((len("hxSerialize") > 2) and ((ord("hxSerialize"[0]) == 95))) and ((ord("hxSerialize"[1]) == 95))) and ((ord("hxSerialize"[(len("hxSerialize") - 1)]) != 95)))) else "hxSerialize"))):
						self.buf.b.write("C")
						self.serializeString(Type.getClassName(c))
						if self.useCache:
							_this1 = self.cache
							x10 = v
							_this1.append(x10)
						Reflect.field(v,"hxSerialize")(self)
						self.buf.b.write("g")
					else:
						self.buf.b.write("c")
						self.serializeString(Type.getClassName(c))
						if self.useCache:
							_this2 = self.cache
							x11 = v
							_this2.append(x11)
						self.serializeFields(v)
			elif (_hx_local_0 == 14):
				if (_g1 == "haxe.ds.IntMap"):
					self.buf.b.write("q")
					v6 = v
					_hx_local_4 = v6.keys()
					while _hx_local_4.hasNext():
						k1 = _hx_local_4.next()
						self.buf.b.write(":")
						self.buf.b.write(Std.string(k1))
						self.serialize(v6.h.get(k1,None))
					self.buf.b.write("h")
				else:
					if self.useCache:
						_this = self.cache
						if (len(_this) == 0):
							None
						else:
							_this.pop()
					if hasattr(v,(("_hx_" + "hxSerialize") if ("hxSerialize" in python_Boot.keywords) else (("_hx_" + "hxSerialize") if (((((len("hxSerialize") > 2) and ((ord("hxSerialize"[0]) == 95))) and ((ord("hxSerialize"[1]) == 95))) and ((ord("hxSerialize"[(len("hxSerialize") - 1)]) != 95)))) else "hxSerialize"))):
						self.buf.b.write("C")
						self.serializeString(Type.getClassName(c))
						if self.useCache:
							_this1 = self.cache
							x10 = v
							_this1.append(x10)
						Reflect.field(v,"hxSerialize")(self)
						self.buf.b.write("g")
					else:
						self.buf.b.write("c")
						self.serializeString(Type.getClassName(c))
						if self.useCache:
							_this2 = self.cache
							x11 = v
							_this2.append(x11)
						self.serializeFields(v)
			else:
				if self.useCache:
					_this = self.cache
					if (len(_this) == 0):
						None
					else:
						_this.pop()
				if hasattr(v,(("_hx_" + "hxSerialize") if ("hxSerialize" in python_Boot.keywords) else (("_hx_" + "hxSerialize") if (((((len("hxSerialize") > 2) and ((ord("hxSerialize"[0]) == 95))) and ((ord("hxSerialize"[1]) == 95))) and ((ord("hxSerialize"[(len("hxSerialize") - 1)]) != 95)))) else "hxSerialize"))):
					self.buf.b.write("C")
					self.serializeString(Type.getClassName(c))
					if self.useCache:
						_this1 = self.cache
						x10 = v
						_this1.append(x10)
					Reflect.field(v,"hxSerialize")(self)
					self.buf.b.write("g")
				else:
					self.buf.b.write("c")
					self.serializeString(Type.getClassName(c))
					if self.useCache:
						_this2 = self.cache
						x11 = v
						_this2.append(x11)
					self.serializeFields(v)
		elif ((_g.index) == 4):
			if Std._hx_is(v,Class):
				className = Type.getClassName(v)
				self.buf.b.write("A")
				self.serializeString(className)
			elif Std._hx_is(v,Enum):
				self.buf.b.write("B")
				self.serializeString(Type.getEnumName(v))
			else:
				if (self.useCache and self.serializeRef(v)):
					return
				self.buf.b.write("o")
				self.serializeFields(v)
		elif ((_g.index) == 7):
			e = _g.params[0]
			if self.useCache:
				if self.serializeRef(v):
					return
				_this3 = self.cache
				if (len(_this3) == 0):
					None
				else:
					_this3.pop()
			self.buf.b.write(("j" if (self.useEnumIndex) else "w"))
			self.serializeString(Type.getEnumName(e))
			if self.useEnumIndex:
				self.buf.b.write(":")
				def _hx_local_5():
					e1 = v
					return e1.index
				self.buf.b.write(Std.string(_hx_local_5()))
			else:
				def _hx_local_6():
					e2 = v
					return e2.tag
				self.serializeString(_hx_local_6())
			self.buf.b.write(":")
			arr = None
			e3 = v
			arr = e3.params
			if (arr is not None):
				self.buf.b.write(Std.string(len(arr)))
				_g11 = 0
				while (_g11 < len(arr)):
					v9 = (arr[_g11] if _g11 >= 0 and _g11 < len(arr) else None)
					_g11 = (_g11 + 1)
					self.serialize(v9)
			else:
				self.buf.b.write("0")
			if self.useCache:
				_this4 = self.cache
				x12 = v
				_this4.append(x12)
		elif ((_g.index) == 5):
			raise _HxException("Cannot serialize function")
		else:
			raise _HxException(("Cannot serialize " + Std.string(v)))

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.buf = None
		_hx_o.cache = None
		_hx_o.shash = None
		_hx_o.scount = None
		_hx_o.useCache = None
		_hx_o.useEnumIndex = None
haxe_Serializer._hx_class = haxe_Serializer
_hx_classes["haxe.Serializer"] = haxe_Serializer


class haxe_Timer:
	_hx_class_name = "haxe.Timer"
	_hx_statics = ["stamp"]

	@staticmethod
	def stamp():
		return Sys.time()
haxe_Timer._hx_class = haxe_Timer
_hx_classes["haxe.Timer"] = haxe_Timer


class haxe_Unserializer:
	_hx_class_name = "haxe.Unserializer"
	_hx_fields = ["buf", "pos", "length", "cache", "scache", "resolver"]
	_hx_methods = ["setResolver", "readDigits", "readFloat", "unserializeObject", "unserializeEnum", "unserialize"]
	_hx_statics = ["DEFAULT_RESOLVER", "BASE64", "CODES", "initCodes"]

	def __init__(self,buf):
		self.buf = None
		self.pos = None
		self.length = None
		self.cache = None
		self.scache = None
		self.resolver = None
		self.buf = buf
		self.length = len(buf)
		self.pos = 0
		self.scache = list()
		self.cache = list()
		r = haxe_Unserializer.DEFAULT_RESOLVER
		if (r is None):
			r = Type
			haxe_Unserializer.DEFAULT_RESOLVER = r
		self.setResolver(r)

	def setResolver(self,r):
		if (r is None):
			def _hx_local_0(_):
				return None
			def _hx_local_1(_1):
				return None
			self.resolver = _hx_AnonObject({'resolveClass': _hx_local_0, 'resolveEnum': _hx_local_1})
		else:
			self.resolver = r

	def readDigits(self):
		k = 0
		s = False
		fpos = self.pos
		while True:
			c = None
			p = self.pos
			s1 = self.buf
			if (p >= len(s1)):
				c = -1
			else:
				c = ord(s1[p])
			if (c == -1):
				break
			if (c == 45):
				if (self.pos != fpos):
					break
				s = True
				_hx_local_0 = self
				_hx_local_1 = _hx_local_0.pos
				_hx_local_0.pos = (_hx_local_1 + 1)
				_hx_local_1
				continue
			if ((c < 48) or ((c > 57))):
				break
			k = ((k * 10) + ((c - 48)))
			_hx_local_2 = self
			_hx_local_3 = _hx_local_2.pos
			_hx_local_2.pos = (_hx_local_3 + 1)
			_hx_local_3
		if s:
			k = (k * -1)
		return k

	def readFloat(self):
		p1 = self.pos
		while True:
			c = None
			p = self.pos
			s = self.buf
			if (p >= len(s)):
				c = -1
			else:
				c = ord(s[p])
			if ((((c >= 43) and ((c < 58))) or ((c == 101))) or ((c == 69))):
				_hx_local_0 = self
				_hx_local_1 = _hx_local_0.pos
				_hx_local_0.pos = (_hx_local_1 + 1)
				_hx_local_1
			else:
				break
		return Std.parseFloat(HxString.substr(self.buf,p1,(self.pos - p1)))

	def unserializeObject(self,o):
		while True:
			if (self.pos >= self.length):
				raise _HxException("Invalid object")
			def _hx_local_0():
				p = self.pos
				def _hx_local_2():
					def _hx_local_1():
						s = self.buf
						return (-1 if ((p >= len(s))) else ord(s[p]))
					return _hx_local_1()
				return _hx_local_2()
			if (_hx_local_0() == 103):
				break
			k = self.unserialize()
			if (not Std._hx_is(k,str)):
				raise _HxException("Invalid object key")
			v = self.unserialize()
			setattr(o,(("_hx_" + k) if (k in python_Boot.keywords) else (("_hx_" + k) if (((((len(k) > 2) and ((ord(k[0]) == 95))) and ((ord(k[1]) == 95))) and ((ord(k[(len(k) - 1)]) != 95)))) else k)),v)
		_hx_local_3 = self
		_hx_local_4 = _hx_local_3.pos
		_hx_local_3.pos = (_hx_local_4 + 1)
		_hx_local_4

	def unserializeEnum(self,edecl,tag):
		def _hx_local_0():
			p = self.pos
			self.pos = (self.pos + 1)
			def _hx_local_2():
				def _hx_local_1():
					s = self.buf
					return (-1 if ((p >= len(s))) else ord(s[p]))
				return _hx_local_1()
			return _hx_local_2()
		if (_hx_local_0() != 58):
			raise _HxException("Invalid enum format")
		nargs = self.readDigits()
		if (nargs == 0):
			return Type.createEnum(edecl,tag)
		args = list()
		def _hx_local_4():
			nonlocal nargs
			_hx_local_3 = nargs
			nargs = (nargs - 1)
			return _hx_local_3
		while (_hx_local_4() > 0):
			x = self.unserialize()
			args.append(x)
		return Type.createEnum(edecl,tag,args)

	def unserialize(self):
		_g = None
		p = self.pos
		self.pos = (self.pos + 1)
		s = self.buf
		if (p >= len(s)):
			_g = -1
		else:
			_g = ord(s[p])
		if (_g == 110):
			return None
		elif (_g == 116):
			return True
		elif (_g == 102):
			return False
		elif (_g == 122):
			return 0
		elif (_g == 105):
			return self.readDigits()
		elif (_g == 100):
			return self.readFloat()
		elif (_g == 121):
			_hx_len = self.readDigits()
			def _hx_local_0():
				p1 = self.pos
				self.pos = (self.pos + 1)
				def _hx_local_2():
					def _hx_local_1():
						s1 = self.buf
						return (-1 if ((p1 >= len(s1))) else ord(s1[p1]))
					return _hx_local_1()
				return _hx_local_2()
			if ((_hx_local_0() != 58) or (((self.length - self.pos) < _hx_len))):
				raise _HxException("Invalid string length")
			s2 = HxString.substr(self.buf,self.pos,_hx_len)
			_hx_local_3 = self
			_hx_local_4 = _hx_local_3.pos
			_hx_local_3.pos = (_hx_local_4 + _hx_len)
			_hx_local_3.pos
			s2 = python_lib_urllib_Parse.unquote(s2)
			_this = self.scache
			_this.append(s2)
			return s2
		elif (_g == 107):
			return Math.NaN
		elif (_g == 109):
			return Math.NEGATIVE_INFINITY
		elif (_g == 112):
			return Math.POSITIVE_INFINITY
		elif (_g == 97):
			buf = self.buf
			a = list()
			_this1 = self.cache
			_this1.append(a)
			while True:
				c = None
				p2 = self.pos
				s3 = self.buf
				if (p2 >= len(s3)):
					c = -1
				else:
					c = ord(s3[p2])
				if (c == 104):
					_hx_local_5 = self
					_hx_local_6 = _hx_local_5.pos
					_hx_local_5.pos = (_hx_local_6 + 1)
					_hx_local_6
					break
				if (c == 117):
					_hx_local_7 = self
					_hx_local_8 = _hx_local_7.pos
					_hx_local_7.pos = (_hx_local_8 + 1)
					_hx_local_8
					n = self.readDigits()
					python_internal_ArrayImpl._set(a, ((len(a) + n) - 1), None)
				else:
					x = self.unserialize()
					a.append(x)
			return a
		elif (_g == 111):
			o = _hx_AnonObject({})
			_this2 = self.cache
			_this2.append(o)
			self.unserializeObject(o)
			return o
		elif (_g == 114):
			n1 = self.readDigits()
			if ((n1 < 0) or ((n1 >= len(self.cache)))):
				raise _HxException("Invalid reference")
			return (self.cache[n1] if n1 >= 0 and n1 < len(self.cache) else None)
		elif (_g == 82):
			n2 = self.readDigits()
			if ((n2 < 0) or ((n2 >= len(self.scache)))):
				raise _HxException("Invalid string reference")
			return (self.scache[n2] if n2 >= 0 and n2 < len(self.scache) else None)
		elif (_g == 120):
			raise _HxException(self.unserialize())
		elif (_g == 99):
			name = self.unserialize()
			cl = self.resolver.resolveClass(name)
			if (cl is None):
				raise _HxException(("Class not found " + ("null" if name is None else name)))
			o1 = Type.createEmptyInstance(cl)
			_this3 = self.cache
			_this3.append(o1)
			self.unserializeObject(o1)
			return o1
		elif (_g == 119):
			name1 = self.unserialize()
			edecl = self.resolver.resolveEnum(name1)
			if (edecl is None):
				raise _HxException(("Enum not found " + ("null" if name1 is None else name1)))
			e = self.unserializeEnum(edecl,self.unserialize())
			_this4 = self.cache
			_this4.append(e)
			return e
		elif (_g == 106):
			name2 = self.unserialize()
			edecl1 = self.resolver.resolveEnum(name2)
			if (edecl1 is None):
				raise _HxException(("Enum not found " + ("null" if name2 is None else name2)))
			_hx_local_9 = self
			_hx_local_10 = _hx_local_9.pos
			_hx_local_9.pos = (_hx_local_10 + 1)
			_hx_local_10
			index = self.readDigits()
			tag = python_internal_ArrayImpl._get(Type.getEnumConstructs(edecl1), index)
			if (tag is None):
				raise _HxException(((("Unknown enum index " + ("null" if name2 is None else name2)) + "@") + Std.string(index)))
			e1 = self.unserializeEnum(edecl1,tag)
			_this5 = self.cache
			_this5.append(e1)
			return e1
		elif (_g == 108):
			l = List()
			_this6 = self.cache
			_this6.append(l)
			buf1 = self.buf
			def _hx_local_11():
				p3 = self.pos
				def _hx_local_13():
					def _hx_local_12():
						s4 = self.buf
						return (-1 if ((p3 >= len(s4))) else ord(s4[p3]))
					return _hx_local_12()
				return _hx_local_13()
			while (_hx_local_11() != 104):
				l.add(self.unserialize())
			_hx_local_14 = self
			_hx_local_15 = _hx_local_14.pos
			_hx_local_14.pos = (_hx_local_15 + 1)
			_hx_local_15
			return l
		elif (_g == 98):
			h = haxe_ds_StringMap()
			_this7 = self.cache
			_this7.append(h)
			buf2 = self.buf
			def _hx_local_16():
				p4 = self.pos
				def _hx_local_18():
					def _hx_local_17():
						s5 = self.buf
						return (-1 if ((p4 >= len(s5))) else ord(s5[p4]))
					return _hx_local_17()
				return _hx_local_18()
			while (_hx_local_16() != 104):
				s6 = self.unserialize()
				value = self.unserialize()
				h.h[s6] = value
			_hx_local_19 = self
			_hx_local_20 = _hx_local_19.pos
			_hx_local_19.pos = (_hx_local_20 + 1)
			_hx_local_20
			return h
		elif (_g == 113):
			h1 = haxe_ds_IntMap()
			_this8 = self.cache
			_this8.append(h1)
			buf3 = self.buf
			c1 = None
			p5 = self.pos
			self.pos = (self.pos + 1)
			s7 = self.buf
			if (p5 >= len(s7)):
				c1 = -1
			else:
				c1 = ord(s7[p5])
			while (c1 == 58):
				i = self.readDigits()
				h1.set(i,self.unserialize())
				p6 = self.pos
				self.pos = (self.pos + 1)
				s8 = self.buf
				if (p6 >= len(s8)):
					c1 = -1
				else:
					c1 = ord(s8[p6])
			if (c1 != 104):
				raise _HxException("Invalid IntMap format")
			return h1
		elif (_g == 77):
			h2 = haxe_ds_ObjectMap()
			_this9 = self.cache
			_this9.append(h2)
			buf4 = self.buf
			def _hx_local_21():
				p7 = self.pos
				def _hx_local_23():
					def _hx_local_22():
						s9 = self.buf
						return (-1 if ((p7 >= len(s9))) else ord(s9[p7]))
					return _hx_local_22()
				return _hx_local_23()
			while (_hx_local_21() != 104):
				s10 = self.unserialize()
				h2.set(s10,self.unserialize())
			_hx_local_24 = self
			_hx_local_25 = _hx_local_24.pos
			_hx_local_24.pos = (_hx_local_25 + 1)
			_hx_local_25
			return h2
		elif (_g == 118):
			d = None
			def _hx_local_26():
				p8 = self.pos
				def _hx_local_28():
					def _hx_local_27():
						s11 = self.buf
						return (-1 if ((p8 >= len(s11))) else ord(s11[p8]))
					return _hx_local_27()
				return _hx_local_28()
			def _hx_local_29():
				p9 = self.pos
				def _hx_local_31():
					def _hx_local_30():
						s12 = self.buf
						return (-1 if ((p9 >= len(s12))) else ord(s12[p9]))
					return _hx_local_30()
				return _hx_local_31()
			def _hx_local_32():
				p10 = (self.pos + 1)
				def _hx_local_34():
					def _hx_local_33():
						s13 = self.buf
						return (-1 if ((p10 >= len(s13))) else ord(s13[p10]))
					return _hx_local_33()
				return _hx_local_34()
			def _hx_local_35():
				p11 = (self.pos + 1)
				def _hx_local_37():
					def _hx_local_36():
						s14 = self.buf
						return (-1 if ((p11 >= len(s14))) else ord(s14[p11]))
					return _hx_local_36()
				return _hx_local_37()
			def _hx_local_38():
				p12 = (self.pos + 2)
				def _hx_local_40():
					def _hx_local_39():
						s15 = self.buf
						return (-1 if ((p12 >= len(s15))) else ord(s15[p12]))
					return _hx_local_39()
				return _hx_local_40()
			def _hx_local_41():
				p13 = (self.pos + 2)
				def _hx_local_43():
					def _hx_local_42():
						s16 = self.buf
						return (-1 if ((p13 >= len(s16))) else ord(s16[p13]))
					return _hx_local_42()
				return _hx_local_43()
			def _hx_local_44():
				p14 = (self.pos + 3)
				def _hx_local_46():
					def _hx_local_45():
						s17 = self.buf
						return (-1 if ((p14 >= len(s17))) else ord(s17[p14]))
					return _hx_local_45()
				return _hx_local_46()
			def _hx_local_47():
				p15 = (self.pos + 3)
				def _hx_local_49():
					def _hx_local_48():
						s18 = self.buf
						return (-1 if ((p15 >= len(s18))) else ord(s18[p15]))
					return _hx_local_48()
				return _hx_local_49()
			def _hx_local_50():
				p16 = (self.pos + 4)
				def _hx_local_52():
					def _hx_local_51():
						s19 = self.buf
						return (-1 if ((p16 >= len(s19))) else ord(s19[p16]))
					return _hx_local_51()
				return _hx_local_52()
			if (((((((((_hx_local_26() >= 48) and ((_hx_local_29() <= 57))) and ((_hx_local_32() >= 48))) and ((_hx_local_35() <= 57))) and ((_hx_local_38() >= 48))) and ((_hx_local_41() <= 57))) and ((_hx_local_44() >= 48))) and ((_hx_local_47() <= 57))) and ((_hx_local_50() == 45))):
				d = Date.fromString(HxString.substr(self.buf,self.pos,19))
				_hx_local_53 = self
				_hx_local_54 = _hx_local_53.pos
				_hx_local_53.pos = (_hx_local_54 + 19)
				_hx_local_53.pos
			else:
				d = Date.fromTime(self.readFloat())
			_this10 = self.cache
			_this10.append(d)
			return d
		elif (_g == 115):
			len1 = self.readDigits()
			buf5 = self.buf
			def _hx_local_55():
				p17 = self.pos
				self.pos = (self.pos + 1)
				def _hx_local_57():
					def _hx_local_56():
						s20 = self.buf
						return (-1 if ((p17 >= len(s20))) else ord(s20[p17]))
					return _hx_local_56()
				return _hx_local_57()
			if ((_hx_local_55() != 58) or (((self.length - self.pos) < len1))):
				raise _HxException("Invalid bytes length")
			codes = haxe_Unserializer.CODES
			if (codes is None):
				codes = haxe_Unserializer.initCodes()
				haxe_Unserializer.CODES = codes
			i1 = self.pos
			rest = (len1 & 3)
			size = None
			size = ((((len1 >> 2)) * 3) + (((rest - 1) if ((rest >= 2)) else 0)))
			_hx_max = (i1 + ((len1 - rest)))
			_hx_bytes = haxe_io_Bytes.alloc(size)
			bpos = 0
			while (i1 < _hx_max):
				def _hx_local_58():
					nonlocal i1
					index1 = i1
					i1 = (i1 + 1)
					return (-1 if ((index1 >= len(buf5))) else ord(buf5[index1]))
				c11 = python_internal_ArrayImpl._get(codes, _hx_local_58())
				def _hx_local_59():
					nonlocal i1
					index2 = i1
					i1 = (i1 + 1)
					return (-1 if ((index2 >= len(buf5))) else ord(buf5[index2]))
				c2 = python_internal_ArrayImpl._get(codes, _hx_local_59())
				pos = bpos
				bpos = (bpos + 1)
				_hx_bytes.b[pos] = ((((c11 << 2) | ((c2 >> 4)))) & 255)
				def _hx_local_60():
					nonlocal i1
					index3 = i1
					i1 = (i1 + 1)
					return (-1 if ((index3 >= len(buf5))) else ord(buf5[index3]))
				c3 = python_internal_ArrayImpl._get(codes, _hx_local_60())
				pos1 = bpos
				bpos = (bpos + 1)
				_hx_bytes.b[pos1] = ((((c2 << 4) | ((c3 >> 2)))) & 255)
				def _hx_local_61():
					nonlocal i1
					index4 = i1
					i1 = (i1 + 1)
					return (-1 if ((index4 >= len(buf5))) else ord(buf5[index4]))
				c4 = python_internal_ArrayImpl._get(codes, _hx_local_61())
				pos2 = bpos
				bpos = (bpos + 1)
				_hx_bytes.b[pos2] = ((((c3 << 6) | c4)) & 255)
			if (rest >= 2):
				def _hx_local_62():
					nonlocal i1
					index5 = i1
					i1 = (i1 + 1)
					return (-1 if ((index5 >= len(buf5))) else ord(buf5[index5]))
				c12 = python_internal_ArrayImpl._get(codes, _hx_local_62())
				def _hx_local_63():
					nonlocal i1
					index6 = i1
					i1 = (i1 + 1)
					return (-1 if ((index6 >= len(buf5))) else ord(buf5[index6]))
				c21 = python_internal_ArrayImpl._get(codes, _hx_local_63())
				pos3 = bpos
				bpos = (bpos + 1)
				_hx_bytes.b[pos3] = ((((c12 << 2) | ((c21 >> 4)))) & 255)
				if (rest == 3):
					def _hx_local_64():
						nonlocal i1
						index7 = i1
						i1 = (i1 + 1)
						return (-1 if ((index7 >= len(buf5))) else ord(buf5[index7]))
					c31 = python_internal_ArrayImpl._get(codes, _hx_local_64())
					pos4 = bpos
					bpos = (bpos + 1)
					_hx_bytes.b[pos4] = ((((c21 << 4) | ((c31 >> 2)))) & 255)
			_hx_local_65 = self
			_hx_local_66 = _hx_local_65.pos
			_hx_local_65.pos = (_hx_local_66 + len1)
			_hx_local_65.pos
			_this11 = self.cache
			_this11.append(_hx_bytes)
			return _hx_bytes
		elif (_g == 67):
			name3 = self.unserialize()
			cl1 = self.resolver.resolveClass(name3)
			if (cl1 is None):
				raise _HxException(("Class not found " + ("null" if name3 is None else name3)))
			o2 = Type.createEmptyInstance(cl1)
			_this12 = self.cache
			x1 = o2
			_this12.append(x1)
			Reflect.field(o2,"hxUnserialize")(self)
			def _hx_local_67():
				p18 = self.pos
				self.pos = (self.pos + 1)
				def _hx_local_69():
					def _hx_local_68():
						s21 = self.buf
						return (-1 if ((p18 >= len(s21))) else ord(s21[p18]))
					return _hx_local_68()
				return _hx_local_69()
			if (_hx_local_67() != 103):
				raise _HxException("Invalid custom data")
			return o2
		elif (_g == 65):
			name4 = self.unserialize()
			cl2 = self.resolver.resolveClass(name4)
			if (cl2 is None):
				raise _HxException(("Class not found " + ("null" if name4 is None else name4)))
			return cl2
		elif (_g == 66):
			name5 = self.unserialize()
			e2 = self.resolver.resolveEnum(name5)
			if (e2 is None):
				raise _HxException(("Enum not found " + ("null" if name5 is None else name5)))
			return e2
		else:
			pass
		_hx_local_70 = self
		_hx_local_71 = _hx_local_70.pos
		_hx_local_70.pos = (_hx_local_71 - 1)
		_hx_local_71
		def _hx_local_72():
			_this13 = self.buf
			index8 = self.pos
			return ("" if (((index8 < 0) or ((index8 >= len(_this13))))) else _this13[index8])
		raise _HxException(((("Invalid char " + HxOverrides.stringOrNull(_hx_local_72())) + " at position ") + Std.string(self.pos)))

	@staticmethod
	def initCodes():
		codes = list()
		_g1 = 0
		_g = len(haxe_Unserializer.BASE64)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			def _hx_local_0():
				s = haxe_Unserializer.BASE64
				return (-1 if ((i >= len(s))) else ord(s[i]))
			python_internal_ArrayImpl._set(codes, _hx_local_0(), i)
		return codes

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.buf = None
		_hx_o.pos = None
		_hx_o.length = None
		_hx_o.cache = None
		_hx_o.scache = None
		_hx_o.resolver = None
haxe_Unserializer._hx_class = haxe_Unserializer
_hx_classes["haxe.Unserializer"] = haxe_Unserializer


class haxe_ds_IntMap:
	_hx_class_name = "haxe.ds.IntMap"
	_hx_fields = ["h"]
	_hx_methods = ["set", "get", "keys"]
	_hx_interfaces = [haxe_IMap]

	def __init__(self):
		self.h = None
		self.h = dict()

	def set(self,key,value):
		self.h[key] = value

	def get(self,key):
		return self.h.get(key,None)

	def keys(self):
		this1 = None
		_this = self.h.keys()
		this1 = iter(_this)
		return python_HaxeIterator(this1)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.h = None
haxe_ds_IntMap._hx_class = haxe_ds_IntMap
_hx_classes["haxe.ds.IntMap"] = haxe_ds_IntMap


class haxe_ds_ObjectMap:
	_hx_class_name = "haxe.ds.ObjectMap"
	_hx_fields = ["h"]
	_hx_methods = ["set", "get", "keys"]
	_hx_interfaces = [haxe_IMap]

	def __init__(self):
		self.h = None
		self.h = dict()

	def set(self,key,value):
		self.h[key] = value

	def get(self,key):
		return self.h.get(key,None)

	def keys(self):
		this1 = None
		_this = self.h.keys()
		this1 = iter(_this)
		return python_HaxeIterator(this1)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.h = None
haxe_ds_ObjectMap._hx_class = haxe_ds_ObjectMap
_hx_classes["haxe.ds.ObjectMap"] = haxe_ds_ObjectMap


class haxe_format_JsonPrinter:
	_hx_class_name = "haxe.format.JsonPrinter"
	_hx_fields = ["buf", "replacer", "indent", "pretty", "nind"]
	_hx_methods = ["write", "fieldsString", "quote"]
	_hx_statics = ["print"]

	def __init__(self,replacer,space):
		self.buf = None
		self.replacer = None
		self.indent = None
		self.pretty = None
		self.nind = None
		self.replacer = replacer
		self.indent = space
		self.pretty = (space is not None)
		self.nind = 0
		self.buf = StringBuf()

	def write(self,k,v):
		if (self.replacer is not None):
			v = self.replacer(k,v)
		_g = Type.typeof(v)
		if ((_g.index) == 8):
			self.buf.b.write("\"???\"")
		elif ((_g.index) == 4):
			self.fieldsString(v,python_Boot.fields(v))
		elif ((_g.index) == 1):
			v1 = v
			self.buf.b.write(Std.string(v1))
		elif ((_g.index) == 2):
			v2 = None
			def _hx_local_0():
				f = v
				return (((f != Math.POSITIVE_INFINITY) and ((f != Math.NEGATIVE_INFINITY))) and (not python_lib_Math.isnan(f)))
			if _hx_local_0():
				v2 = v
			else:
				v2 = "null"
			self.buf.b.write(Std.string(v2))
		elif ((_g.index) == 5):
			self.buf.b.write("\"<fun>\"")
		elif ((_g.index) == 6):
			c = _g.params[0]
			if (c == str):
				self.quote(v)
			elif (c == list):
				v3 = v
				s = "".join(map(chr,[91]))
				self.buf.b.write(s)
				_hx_len = len(v3)
				last = (_hx_len - 1)
				_g1 = 0
				while (_g1 < _hx_len):
					i = _g1
					_g1 = (_g1 + 1)
					if (i > 0):
						s1 = "".join(map(chr,[44]))
						self.buf.b.write(s1)
					else:
						_hx_local_1 = self
						_hx_local_2 = _hx_local_1.nind
						_hx_local_1.nind = (_hx_local_2 + 1)
						_hx_local_2
					if self.pretty:
						s2 = "".join(map(chr,[10]))
						self.buf.b.write(s2)
					if self.pretty:
						v4 = StringTools.lpad("",self.indent,(self.nind * len(self.indent)))
						self.buf.b.write(Std.string(v4))
					self.write(i,(v3[i] if i >= 0 and i < len(v3) else None))
					if (i == last):
						_hx_local_3 = self
						_hx_local_4 = _hx_local_3.nind
						_hx_local_3.nind = (_hx_local_4 - 1)
						_hx_local_4
						if self.pretty:
							s3 = "".join(map(chr,[10]))
							self.buf.b.write(s3)
						if self.pretty:
							v5 = StringTools.lpad("",self.indent,(self.nind * len(self.indent)))
							self.buf.b.write(Std.string(v5))
				s4 = "".join(map(chr,[93]))
				self.buf.b.write(s4)
			elif (c == haxe_ds_StringMap):
				v6 = v
				o = _hx_AnonObject({})
				_hx_local_5 = v6.keys()
				while _hx_local_5.hasNext():
					k1 = _hx_local_5.next()
					value = v6.h.get(k1,None)
					setattr(o,(("_hx_" + k1) if (k1 in python_Boot.keywords) else (("_hx_" + k1) if (((((len(k1) > 2) and ((ord(k1[0]) == 95))) and ((ord(k1[1]) == 95))) and ((ord(k1[(len(k1) - 1)]) != 95)))) else k1)),value)
				self.fieldsString(o,python_Boot.fields(o))
			elif (c == Date):
				v7 = v
				self.quote(v7.toString())
			else:
				self.fieldsString(v,python_Boot.fields(v))
		elif ((_g.index) == 7):
			i1 = None
			e = v
			i1 = e.index
			v8 = i1
			self.buf.b.write(Std.string(v8))
		elif ((_g.index) == 3):
			v9 = v
			self.buf.b.write(Std.string(v9))
		elif ((_g.index) == 0):
			self.buf.b.write("null")
		else:
			pass

	def fieldsString(self,v,fields):
		s = "".join(map(chr,[123]))
		self.buf.b.write(s)
		_hx_len = len(fields)
		last = (_hx_len - 1)
		first = True
		_g = 0
		while (_g < _hx_len):
			i = _g
			_g = (_g + 1)
			f = (fields[i] if i >= 0 and i < len(fields) else None)
			value = Reflect.field(v,f)
			if Reflect.isFunction(value):
				continue
			if first:
				_hx_local_0 = self
				_hx_local_1 = _hx_local_0.nind
				_hx_local_0.nind = (_hx_local_1 + 1)
				_hx_local_1
				first = False
			else:
				s1 = "".join(map(chr,[44]))
				self.buf.b.write(s1)
			if self.pretty:
				s2 = "".join(map(chr,[10]))
				self.buf.b.write(s2)
			if self.pretty:
				v1 = StringTools.lpad("",self.indent,(self.nind * len(self.indent)))
				self.buf.b.write(Std.string(v1))
			self.quote(f)
			s3 = "".join(map(chr,[58]))
			self.buf.b.write(s3)
			if self.pretty:
				s4 = "".join(map(chr,[32]))
				self.buf.b.write(s4)
			self.write(f,value)
			if (i == last):
				_hx_local_2 = self
				_hx_local_3 = _hx_local_2.nind
				_hx_local_2.nind = (_hx_local_3 - 1)
				_hx_local_3
				if self.pretty:
					s5 = "".join(map(chr,[10]))
					self.buf.b.write(s5)
				if self.pretty:
					v2 = StringTools.lpad("",self.indent,(self.nind * len(self.indent)))
					self.buf.b.write(Std.string(v2))
		s6 = "".join(map(chr,[125]))
		self.buf.b.write(s6)

	def quote(self,s):
		s1 = "".join(map(chr,[34]))
		self.buf.b.write(s1)
		i = 0
		while True:
			c = None
			index = i
			i = (i + 1)
			if (index >= len(s)):
				c = -1
			else:
				c = ord(s[index])
			if (c == -1):
				break
			if (c == 34):
				self.buf.b.write("\\\"")
			elif (c == 92):
				self.buf.b.write("\\\\")
			elif (c == 10):
				self.buf.b.write("\\n")
			elif (c == 13):
				self.buf.b.write("\\r")
			elif (c == 9):
				self.buf.b.write("\\t")
			elif (c == 8):
				self.buf.b.write("\\b")
			elif (c == 12):
				self.buf.b.write("\\f")
			else:
				s2 = "".join(map(chr,[c]))
				self.buf.b.write(s2)
		s3 = "".join(map(chr,[34]))
		self.buf.b.write(s3)

	@staticmethod
	def print(o,replacer = None,space = None):
		printer = haxe_format_JsonPrinter(replacer, space)
		printer.write("",o)
		return printer.buf.b.getvalue()

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.buf = None
		_hx_o.replacer = None
		_hx_o.indent = None
		_hx_o.pretty = None
		_hx_o.nind = None
haxe_format_JsonPrinter._hx_class = haxe_format_JsonPrinter
_hx_classes["haxe.format.JsonPrinter"] = haxe_format_JsonPrinter


class haxe_io_Bytes:
	_hx_class_name = "haxe.io.Bytes"
	_hx_fields = ["length", "b"]
	_hx_methods = ["blit", "getString", "toString"]
	_hx_statics = ["alloc", "ofString", "ofData"]

	def __init__(self,length,b):
		self.length = None
		self.b = None
		self.length = length
		self.b = b

	def blit(self,pos,src,srcpos,_hx_len):
		if (((((pos < 0) or ((srcpos < 0))) or ((_hx_len < 0))) or (((pos + _hx_len) > self.length))) or (((srcpos + _hx_len) > src.length))):
			raise _HxException(haxe_io_Error.OutsideBounds)
		self.b[pos:pos+_hx_len] = src.b[srcpos:srcpos+_hx_len]

	def getString(self,pos,_hx_len):
		if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > self.length))):
			raise _HxException(haxe_io_Error.OutsideBounds)
		return self.b[pos:pos+_hx_len].decode('UTF-8','replace')

	def toString(self):
		return self.getString(0,self.length)

	@staticmethod
	def alloc(length):
		return haxe_io_Bytes(length, bytearray(length))

	@staticmethod
	def ofString(s):
		b = bytearray(s, "UTF-8")
		return haxe_io_Bytes(len(b), b)

	@staticmethod
	def ofData(b):
		return haxe_io_Bytes(len(b), b)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.length = None
		_hx_o.b = None
haxe_io_Bytes._hx_class = haxe_io_Bytes
_hx_classes["haxe.io.Bytes"] = haxe_io_Bytes


class haxe_io_BytesBuffer:
	_hx_class_name = "haxe.io.BytesBuffer"
	_hx_fields = ["b"]
	_hx_methods = ["getBytes"]

	def __init__(self):
		self.b = None
		self.b = list()

	def getBytes(self):
		buf = bytearray(self.b)
		_hx_bytes = haxe_io_Bytes(len(buf), buf)
		self.b = None
		return _hx_bytes

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.b = None
		_hx_o.length = None
haxe_io_BytesBuffer._hx_class = haxe_io_BytesBuffer
_hx_classes["haxe.io.BytesBuffer"] = haxe_io_BytesBuffer


class haxe_io_Input:
	_hx_class_name = "haxe.io.Input"
	_hx_methods = ["readByte", "readBytes", "readAll", "readLine"]

	def readByte(self):
		raise _HxException("Not implemented")

	def readBytes(self,s,pos,_hx_len):
		k = _hx_len
		b = s.b
		if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > s.length))):
			raise _HxException(haxe_io_Error.OutsideBounds)
		while (k > 0):
			b[pos] = self.readByte()
			pos = (pos + 1)
			k = (k - 1)
		return _hx_len

	def readAll(self,bufsize = None):
		if (bufsize is None):
			bufsize = 16384
		buf = haxe_io_Bytes.alloc(bufsize)
		total = haxe_io_BytesBuffer()
		try:
			while True:
				_hx_len = self.readBytes(buf,0,bufsize)
				if (_hx_len == 0):
					raise _HxException(haxe_io_Error.Blocked)
				if ((_hx_len < 0) or ((_hx_len > buf.length))):
					raise _HxException(haxe_io_Error.OutsideBounds)
				b1 = total.b
				b2 = buf.b
				_g1 = 0
				_g = _hx_len
				while (_g1 < _g):
					i = _g1
					_g1 = (_g1 + 1)
					_this = total.b
					_this.append(b2[i])
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			if isinstance(_hx_e1, haxe_io_Eof):
					pass
			else:
				raise _hx_e
		return total.getBytes()

	def readLine(self):
		buf_b = python_lib_io_StringIO()
		last = None
		s = None
		try:
			def _hx_local_0():
				nonlocal last
				last = self.readByte()
				return last
			while ((_hx_local_0()) != 10):
				s1 = "".join(map(chr,[last]))
				buf_b.write(s1)
			s = buf_b.getvalue()
			if (HxString.charCodeAt(s,(len(s) - 1)) == 13):
				s = HxString.substr(s,0,-1)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			if isinstance(_hx_e1, haxe_io_Eof):
				e = _hx_e1
				s = buf_b.getvalue()
				if (len(s) == 0):
					raise _HxException(e)
			else:
				raise _hx_e
		return s

	@staticmethod
	def _hx_empty_init(_hx_o):		pass
haxe_io_Input._hx_class = haxe_io_Input
_hx_classes["haxe.io.Input"] = haxe_io_Input


class haxe_io_Output:
	_hx_class_name = "haxe.io.Output"
	_hx_fields = ["bigEndian"]
	_hx_methods = ["writeByte", "writeBytes", "set_bigEndian", "write", "writeFullBytes", "writeString"]

	def writeByte(self,c):
		raise _HxException("Not implemented")

	def writeBytes(self,s,pos,_hx_len):
		k = _hx_len
		b = s.b
		if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > s.length))):
			raise _HxException(haxe_io_Error.OutsideBounds)
		while (k > 0):
			self.writeByte(b[pos])
			pos = (pos + 1)
			k = (k - 1)
		return _hx_len

	def set_bigEndian(self,b):
		self.bigEndian = b
		return b

	def write(self,s):
		l = s.length
		p = 0
		while (l > 0):
			k = self.writeBytes(s,p,l)
			if (k == 0):
				raise _HxException(haxe_io_Error.Blocked)
			p = (p + k)
			l = (l - k)

	def writeFullBytes(self,s,pos,_hx_len):
		while (_hx_len > 0):
			k = self.writeBytes(s,pos,_hx_len)
			pos = (pos + k)
			_hx_len = (_hx_len - k)

	def writeString(self,s):
		b = haxe_io_Bytes.ofString(s)
		self.writeFullBytes(b,0,b.length)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.bigEndian = None
haxe_io_Output._hx_class = haxe_io_Output
_hx_classes["haxe.io.Output"] = haxe_io_Output


class haxe_io_BytesOutput(haxe_io_Output):
	_hx_class_name = "haxe.io.BytesOutput"
	_hx_fields = ["b"]
	_hx_methods = ["writeByte", "writeBytes", "getBytes"]
	_hx_statics = []
	_hx_interfaces = []
	_hx_super = haxe_io_Output


	def __init__(self):
		self.b = None
		self.b = haxe_io_BytesBuffer()
		self.set_bigEndian(False)

	def writeByte(self,c):
		_this = self.b.b
		_this.append(c)

	def writeBytes(self,buf,pos,_hx_len):
		_this = self.b
		if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > buf.length))):
			raise _HxException(haxe_io_Error.OutsideBounds)
		b1 = _this.b
		b2 = buf.b
		_g1 = pos
		_g = (pos + _hx_len)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			_this1 = _this.b
			_this1.append(b2[i])
		return _hx_len

	def getBytes(self):
		return self.b.getBytes()

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.b = None
		_hx_o.length = None
haxe_io_BytesOutput._hx_class = haxe_io_BytesOutput
_hx_classes["haxe.io.BytesOutput"] = haxe_io_BytesOutput


class haxe_io_Eof:
	_hx_class_name = "haxe.io.Eof"
	_hx_methods = ["toString"]

	def __init__(self):
		pass

	def toString(self):
		return "Eof"

	@staticmethod
	def _hx_empty_init(_hx_o):		pass
haxe_io_Eof._hx_class = haxe_io_Eof
_hx_classes["haxe.io.Eof"] = haxe_io_Eof

class haxe_io_Error(Enum):
	_hx_class_name = "haxe.io.Error"
	_hx_constructs = ["Blocked", "Overflow", "OutsideBounds", "Custom"]

	@staticmethod
	def Custom(e):
		return haxe_io_Error("Custom", 3, [e])
haxe_io_Error.Blocked = haxe_io_Error("Blocked", 0, list())
haxe_io_Error.Overflow = haxe_io_Error("Overflow", 1, list())
haxe_io_Error.OutsideBounds = haxe_io_Error("OutsideBounds", 2, list())
haxe_io_Error._hx_class = haxe_io_Error
_hx_classes["haxe.io.Error"] = haxe_io_Error


class haxe_io_Path:
	_hx_class_name = "haxe.io.Path"
	_hx_fields = ["dir", "file", "ext", "backslash"]
	_hx_methods = ["toString"]
	_hx_statics = ["withoutExtension", "withoutDirectory", "directory", "join", "normalize", "addTrailingSlash"]

	def __init__(self,path):
		self.dir = None
		self.file = None
		self.ext = None
		self.backslash = None
		_hx_local_0 = len(path)
		if (_hx_local_0 == 1):
			if (path == "."):
				self.dir = path
				self.file = ""
				return
		elif (_hx_local_0 == 2):
			if (path == ".."):
				self.dir = path
				self.file = ""
				return
		else:
			pass
		c1 = path.rfind("/", 0, len(path))
		c2 = path.rfind("\\", 0, len(path))
		if (c1 < c2):
			self.dir = HxString.substr(path,0,c2)
			path = HxString.substr(path,(c2 + 1),None)
			self.backslash = True
		elif (c2 < c1):
			self.dir = HxString.substr(path,0,c1)
			path = HxString.substr(path,(c1 + 1),None)
		else:
			self.dir = None
		cp = path.rfind(".", 0, len(path))
		if (cp != -1):
			self.ext = HxString.substr(path,(cp + 1),None)
			self.file = HxString.substr(path,0,cp)
		else:
			self.ext = None
			self.file = path

	def toString(self):
		return ((HxOverrides.stringOrNull((("" if ((self.dir is None)) else (HxOverrides.stringOrNull(self.dir) + HxOverrides.stringOrNull((("\\" if (self.backslash) else "/"))))))) + HxOverrides.stringOrNull(self.file)) + HxOverrides.stringOrNull((("" if ((self.ext is None)) else ("." + HxOverrides.stringOrNull(self.ext))))))

	@staticmethod
	def withoutExtension(path):
		s = haxe_io_Path(path)
		s.ext = None
		return s.toString()

	@staticmethod
	def withoutDirectory(path):
		s = haxe_io_Path(path)
		s.dir = None
		return s.toString()

	@staticmethod
	def directory(path):
		s = haxe_io_Path(path)
		if (s.dir is None):
			return ""
		return s.dir

	@staticmethod
	def join(paths):
		def _hx_local_0(s):
			return ((s is not None) and ((s != "")))
		paths1 = list(filter(_hx_local_0,paths))
		if (len(paths1) == 0):
			return ""
		path = (paths1[0] if 0 < len(paths1) else None)
		_g1 = 1
		_g = len(paths1)
		while (_g1 < _g):
			i = _g1
			_g1 = (_g1 + 1)
			path = haxe_io_Path.addTrailingSlash(path)
			path = (("null" if path is None else path) + HxOverrides.stringOrNull((paths1[i] if i >= 0 and i < len(paths1) else None)))
		return haxe_io_Path.normalize(path)

	@staticmethod
	def normalize(path):
		slash = "/"
		_this = path.split("\\")
		path = "/".join([python_Boot.toString1(x1,'') for x1 in _this])
		if ((path is None) or ((path == slash))):
			return slash
		target = []
		_g = 0
		_g1 = None
		if (slash == ""):
			_g1 = list(path)
		else:
			_g1 = path.split(slash)
		while (_g < len(_g1)):
			token = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
			_g = (_g + 1)
			if (((token == "..") and ((len(target) > 0))) and ((python_internal_ArrayImpl._get(target, (len(target) - 1)) != ".."))):
				if (len(target) == 0):
					None
				else:
					target.pop()
			elif (token != "."):
				target.append(token)
		tmp = slash.join([python_Boot.toString1(x1,'') for x1 in target])
		regex = EReg("([^:])/+", "g")
		result = regex.replace(tmp,("$1" + ("null" if slash is None else slash)))
		acc_b = python_lib_io_StringIO()
		colon = False
		slashes = False
		_g11 = 0
		_g2 = len(tmp)
		while (_g11 < _g2):
			i = _g11
			_g11 = (_g11 + 1)
			_g21 = HxString.charCodeAt(tmp,i)
			i1 = _g21
			if (_g21 is not None):
				if (_g21 == 58):
					acc_b.write(":")
					colon = True
				elif (_g21 == 47):
					if (colon == False):
						slashes = True
					else:
						colon = False
						if slashes:
							acc_b.write("/")
							slashes = False
						x = "".join(map(chr,[i1]))
						acc_b.write(Std.string(x))
				else:
					colon = False
					if slashes:
						acc_b.write("/")
						slashes = False
					x1 = "".join(map(chr,[i1]))
					acc_b.write(Std.string(x1))
			else:
				colon = False
				if slashes:
					acc_b.write("/")
					slashes = False
				x1 = "".join(map(chr,[i1]))
				acc_b.write(Std.string(x1))
		result1 = acc_b.getvalue()
		return result1

	@staticmethod
	def addTrailingSlash(path):
		if (len(path) == 0):
			return "/"
		c1 = path.rfind("/", 0, len(path))
		c2 = path.rfind("\\", 0, len(path))
		if (c1 < c2):
			if (c2 != ((len(path) - 1))):
				return (("null" if path is None else path) + "\\")
			else:
				return path
		elif (c1 != ((len(path) - 1))):
			return (("null" if path is None else path) + "/")
		else:
			return path

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.dir = None
		_hx_o.file = None
		_hx_o.ext = None
		_hx_o.backslash = None
haxe_io_Path._hx_class = haxe_io_Path
_hx_classes["haxe.io.Path"] = haxe_io_Path


class haxe_xml__Fast_NodeAccess:
	_hx_class_name = "haxe.xml._Fast.NodeAccess"
	_hx_fields = ["__x"]
	_hx_methods = ["resolve"]

	def __init__(self,x):
		self._hx___x = None
		self._hx___x = x

	def resolve(self,name):
		x = self._hx___x.elementsNamed(name).next()
		if (x is None):
			xname = None
			if (self._hx___x.nodeType == Xml.Document):
				xname = "Document"
			else:
				_this = self._hx___x
				if (_this.nodeType != Xml.Element):
					raise _HxException(("Bad node type, expected Element but found " + Std.string(_this.nodeType)))
				xname = _this.nodeName
			raise _HxException(((("null" if xname is None else xname) + " is missing element ") + ("null" if name is None else name)))
		return haxe_xml_Fast(x)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o._hx___x = None
haxe_xml__Fast_NodeAccess._hx_class = haxe_xml__Fast_NodeAccess
_hx_classes["haxe.xml._Fast.NodeAccess"] = haxe_xml__Fast_NodeAccess


class haxe_xml__Fast_AttribAccess:
	_hx_class_name = "haxe.xml._Fast.AttribAccess"
	_hx_fields = ["__x"]
	_hx_methods = ["resolve"]

	def __init__(self,x):
		self._hx___x = None
		self._hx___x = x

	def resolve(self,name):
		if (self._hx___x.nodeType == Xml.Document):
			raise _HxException(("Cannot access document attribute " + ("null" if name is None else name)))
		v = self._hx___x.get(name)
		if (v is None):
			def _hx_local_0():
				_this = self._hx___x
				if (_this.nodeType != Xml.Element):
					raise _HxException(("Bad node type, expected Element but found " + Std.string(_this.nodeType)))
				return _this.nodeName
			raise _HxException(((HxOverrides.stringOrNull(_hx_local_0()) + " is missing attribute ") + ("null" if name is None else name)))
		return v

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o._hx___x = None
haxe_xml__Fast_AttribAccess._hx_class = haxe_xml__Fast_AttribAccess
_hx_classes["haxe.xml._Fast.AttribAccess"] = haxe_xml__Fast_AttribAccess


class haxe_xml__Fast_HasAttribAccess:
	_hx_class_name = "haxe.xml._Fast.HasAttribAccess"
	_hx_fields = ["__x"]
	_hx_methods = ["resolve"]

	def __init__(self,x):
		self._hx___x = None
		self._hx___x = x

	def resolve(self,name):
		if (self._hx___x.nodeType == Xml.Document):
			raise _HxException(("Cannot access document attribute " + ("null" if name is None else name)))
		return self._hx___x.exists(name)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o._hx___x = None
haxe_xml__Fast_HasAttribAccess._hx_class = haxe_xml__Fast_HasAttribAccess
_hx_classes["haxe.xml._Fast.HasAttribAccess"] = haxe_xml__Fast_HasAttribAccess


class haxe_xml__Fast_HasNodeAccess:
	_hx_class_name = "haxe.xml._Fast.HasNodeAccess"
	_hx_fields = ["__x"]
	_hx_methods = ["resolve"]

	def __init__(self,x):
		self._hx___x = None
		self._hx___x = x

	def resolve(self,name):
		return self._hx___x.elementsNamed(name).hasNext()

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o._hx___x = None
haxe_xml__Fast_HasNodeAccess._hx_class = haxe_xml__Fast_HasNodeAccess
_hx_classes["haxe.xml._Fast.HasNodeAccess"] = haxe_xml__Fast_HasNodeAccess


class haxe_xml__Fast_NodeListAccess:
	_hx_class_name = "haxe.xml._Fast.NodeListAccess"
	_hx_fields = ["__x"]

	def __init__(self,x):
		self._hx___x = None
		self._hx___x = x

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o._hx___x = None
haxe_xml__Fast_NodeListAccess._hx_class = haxe_xml__Fast_NodeListAccess
_hx_classes["haxe.xml._Fast.NodeListAccess"] = haxe_xml__Fast_NodeListAccess


class haxe_xml_Fast:
	_hx_class_name = "haxe.xml.Fast"
	_hx_fields = ["x", "node", "nodes", "att", "has", "hasNode"]
	_hx_methods = ["get_name", "get_innerData", "get_elements"]

	def __init__(self,x):
		self.x = None
		self.node = None
		self.nodes = None
		self.att = None
		self.has = None
		self.hasNode = None
		if ((x.nodeType != Xml.Document) and ((x.nodeType != Xml.Element))):
			raise _HxException(("Invalid nodeType " + Std.string(x.nodeType)))
		self.x = x
		self.node = haxe_xml__Fast_NodeAccess(x)
		self.nodes = haxe_xml__Fast_NodeListAccess(x)
		self.att = haxe_xml__Fast_AttribAccess(x)
		self.has = haxe_xml__Fast_HasAttribAccess(x)
		self.hasNode = haxe_xml__Fast_HasNodeAccess(x)

	def get_name(self):
		if (self.x.nodeType == Xml.Document):
			return "Document"
		else:
			_this = self.x
			if (_this.nodeType != Xml.Element):
				raise _HxException(("Bad node type, expected Element but found " + Std.string(_this.nodeType)))
			return _this.nodeName

	def get_innerData(self):
		it = None
		_this = self.x
		if ((_this.nodeType != Xml.Document) and ((_this.nodeType != Xml.Element))):
			raise _HxException(("Bad node type, expected Element or Document but found " + Std.string(_this.nodeType)))
		it = python_HaxeIterator(_this.children.__iter__())
		if (not it.hasNext()):
			raise _HxException((HxOverrides.stringOrNull(self.get_name()) + " does not have data"))
		v = it.next()
		n = it.next()
		if (n is not None):
			def _hx_local_0():
				if ((v.nodeType == Xml.Document) or ((v.nodeType == Xml.Element))):
					raise _HxException(("Bad node type, unexpected " + Std.string(v.nodeType)))
				return v.nodeValue
			if (((v.nodeType == Xml.PCData) and ((n.nodeType == Xml.CData))) and ((StringTools.trim(_hx_local_0()) == ""))):
				n2 = it.next()
				def _hx_local_1():
					if ((n2.nodeType == Xml.Document) or ((n2.nodeType == Xml.Element))):
						raise _HxException(("Bad node type, unexpected " + Std.string(n2.nodeType)))
					return n2.nodeValue
				if ((n2 is None) or ((((n2.nodeType == Xml.PCData) and ((StringTools.trim(_hx_local_1()) == ""))) and ((it.next() is None))))):
					if ((n.nodeType == Xml.Document) or ((n.nodeType == Xml.Element))):
						raise _HxException(("Bad node type, unexpected " + Std.string(n.nodeType)))
					return n.nodeValue
			raise _HxException((HxOverrides.stringOrNull(self.get_name()) + " does not only have data"))
		if ((v.nodeType != Xml.PCData) and ((v.nodeType != Xml.CData))):
			raise _HxException((HxOverrides.stringOrNull(self.get_name()) + " does not have data"))
		if ((v.nodeType == Xml.Document) or ((v.nodeType == Xml.Element))):
			raise _HxException(("Bad node type, unexpected " + Std.string(v.nodeType)))
		return v.nodeValue

	def get_elements(self):
		it = self.x.elements()
		def _hx_local_1():
			def _hx_local_0():
				x = it.next()
				if (x is None):
					return None
				return haxe_xml_Fast(x)
			return _hx_AnonObject({'hasNext': it.hasNext, 'next': _hx_local_0})
		return _hx_local_1()

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.x = None
		_hx_o.node = None
		_hx_o.nodes = None
		_hx_o.att = None
		_hx_o.has = None
		_hx_o.hasNode = None
haxe_xml_Fast._hx_class = haxe_xml_Fast
_hx_classes["haxe.xml.Fast"] = haxe_xml_Fast


class haxe_xml_Parser:
	_hx_class_name = "haxe.xml.Parser"
	_hx_statics = ["escapes", "parse", "doParse"]

	@staticmethod
	def parse(_hx_str,strict = False):
		if (strict is None):
			strict = False
		doc = Xml.createDocument()
		haxe_xml_Parser.doParse(_hx_str,strict,0,doc)
		return doc

	@staticmethod
	def doParse(_hx_str,strict,p = 0,parent = None):
		if (p is None):
			p = 0
		xml = None
		state = 1
		next = 1
		aname = None
		start = 0
		nsubs = 0
		nbrackets = 0
		c = None
		if (p >= len(_hx_str)):
			c = -1
		else:
			c = ord(_hx_str[p])
		buf = StringBuf()
		escapeNext = 1
		attrValQuote = -1
		while (not ((c == -1))):
			if (state == 0):
				if ((((c == 32) or ((c == 9))) or ((c == 13))) or ((c == 10))):
					pass
				else:
					state = next
					continue
			elif (state == 1):
				if (c == 60):
					state = 0
					next = 2
				else:
					start = p
					state = 13
					continue
			elif (state == 13):
				if (c == 60):
					_hx_len = (p - start)
					s = None
					if (_hx_len is None):
						s = HxString.substr(_hx_str,start,None)
					else:
						s = HxString.substr(_hx_str,start,_hx_len)
					buf.b.write(s)
					child = Xml.createPCData(buf.b.getvalue())
					buf = StringBuf()
					parent.addChild(child)
					nsubs = (nsubs + 1)
					state = 0
					next = 2
				elif (c == 38):
					len1 = (p - start)
					s1 = None
					if (len1 is None):
						s1 = HxString.substr(_hx_str,start,None)
					else:
						s1 = HxString.substr(_hx_str,start,len1)
					buf.b.write(s1)
					state = 18
					escapeNext = 13
					start = (p + 1)
			elif (state == 17):
				def _hx_local_1():
					index = (p + 1)
					return (-1 if ((index >= len(_hx_str))) else ord(_hx_str[index]))
				def _hx_local_2():
					index1 = (p + 2)
					return (-1 if ((index1 >= len(_hx_str))) else ord(_hx_str[index1]))
				if (((c == 93) and ((_hx_local_1() == 93))) and ((_hx_local_2() == 62))):
					child1 = Xml.createCData(HxString.substr(_hx_str,start,(p - start)))
					parent.addChild(child1)
					nsubs = (nsubs + 1)
					p = (p + 2)
					state = 1
			elif (state == 2):
				if (c == 33):
					def _hx_local_5():
						index2 = (p + 1)
						return (-1 if ((index2 >= len(_hx_str))) else ord(_hx_str[index2]))
					if (_hx_local_5() == 91):
						p = (p + 2)
						def _hx_local_7():
							_this = HxString.substr(_hx_str,p,6)
							return _this.upper()
						if (_hx_local_7() != "CDATA["):
							raise _HxException("Expected <![CDATA[")
						p = (p + 5)
						state = 17
						start = (p + 1)
					else:
						def _hx_local_9():
							index3 = (p + 1)
							return (-1 if ((index3 >= len(_hx_str))) else ord(_hx_str[index3]))
						def _hx_local_10():
							index4 = (p + 1)
							return (-1 if ((index4 >= len(_hx_str))) else ord(_hx_str[index4]))
						if ((_hx_local_9() == 68) or ((_hx_local_10() == 100))):
							def _hx_local_11():
								_this1 = HxString.substr(_hx_str,(p + 2),6)
								return _this1.upper()
							if (_hx_local_11() != "OCTYPE"):
								raise _HxException("Expected <!DOCTYPE")
							p = (p + 8)
							state = 16
							start = (p + 1)
						else:
							def _hx_local_13():
								index5 = (p + 1)
								return (-1 if ((index5 >= len(_hx_str))) else ord(_hx_str[index5]))
							def _hx_local_14():
								index6 = (p + 2)
								return (-1 if ((index6 >= len(_hx_str))) else ord(_hx_str[index6]))
							if ((_hx_local_13() != 45) or ((_hx_local_14() != 45))):
								raise _HxException("Expected <!--")
							else:
								p = (p + 2)
								state = 15
								start = (p + 1)
				elif (c == 63):
					state = 14
					start = p
				elif (c == 47):
					if (parent is None):
						raise _HxException("Expected node name")
					start = (p + 1)
					state = 0
					next = 10
				else:
					state = 3
					start = p
					continue
			elif (state == 3):
				if (not (((((((((c >= 97) and ((c <= 122))) or (((c >= 65) and ((c <= 90))))) or (((c >= 48) and ((c <= 57))))) or ((c == 58))) or ((c == 46))) or ((c == 95))) or ((c == 45))))):
					if (p == start):
						raise _HxException("Expected node name")
					xml = Xml.createElement(HxString.substr(_hx_str,start,(p - start)))
					parent.addChild(xml)
					nsubs = (nsubs + 1)
					state = 0
					next = 4
					continue
			elif (state == 4):
				if (c == 47):
					state = 11
				elif (c == 62):
					state = 9
				else:
					state = 5
					start = p
					continue
			elif (state == 5):
				if (not (((((((((c >= 97) and ((c <= 122))) or (((c >= 65) and ((c <= 90))))) or (((c >= 48) and ((c <= 57))))) or ((c == 58))) or ((c == 46))) or ((c == 95))) or ((c == 45))))):
					tmp = None
					if (start == p):
						raise _HxException("Expected attribute name")
					tmp = HxString.substr(_hx_str,start,(p - start))
					aname = tmp
					if xml.exists(aname):
						raise _HxException("Duplicate attribute")
					state = 0
					next = 6
					continue
			elif (state == 6):
				if (c == 61):
					state = 0
					next = 7
				else:
					raise _HxException("Expected =")
			elif (state == 7):
				if ((c == 39) or ((c == 34))):
					buf = StringBuf()
					state = 8
					start = (p + 1)
					attrValQuote = c
				else:
					raise _HxException("Expected \"")
			elif (state == 8):
				if (c == 38):
					len2 = (p - start)
					s2 = None
					if (len2 is None):
						s2 = HxString.substr(_hx_str,start,None)
					else:
						s2 = HxString.substr(_hx_str,start,len2)
					buf.b.write(s2)
					state = 18
					escapeNext = 8
					start = (p + 1)
				elif (c == 62):
					if strict:
						raise _HxException((("Invalid unescaped " + HxOverrides.stringOrNull("".join(map(chr,[c])))) + " in attribute value"))
					elif (c == attrValQuote):
						len3 = (p - start)
						s3 = None
						if (len3 is None):
							s3 = HxString.substr(_hx_str,start,None)
						else:
							s3 = HxString.substr(_hx_str,start,len3)
						buf.b.write(s3)
						val = buf.b.getvalue()
						buf = StringBuf()
						xml.set(aname,val)
						state = 0
						next = 4
				elif (c == 60):
					if strict:
						raise _HxException((("Invalid unescaped " + HxOverrides.stringOrNull("".join(map(chr,[c])))) + " in attribute value"))
					elif (c == attrValQuote):
						len4 = (p - start)
						s4 = None
						if (len4 is None):
							s4 = HxString.substr(_hx_str,start,None)
						else:
							s4 = HxString.substr(_hx_str,start,len4)
						buf.b.write(s4)
						val1 = buf.b.getvalue()
						buf = StringBuf()
						xml.set(aname,val1)
						state = 0
						next = 4
				elif (c == attrValQuote):
					len5 = (p - start)
					s5 = None
					if (len5 is None):
						s5 = HxString.substr(_hx_str,start,None)
					else:
						s5 = HxString.substr(_hx_str,start,len5)
					buf.b.write(s5)
					val2 = buf.b.getvalue()
					buf = StringBuf()
					xml.set(aname,val2)
					state = 0
					next = 4
			elif (state == 9):
				p = haxe_xml_Parser.doParse(_hx_str,strict,p,xml)
				start = p
				state = 1
			elif (state == 11):
				if (c == 62):
					state = 1
				else:
					raise _HxException("Expected >")
			elif (state == 12):
				if (c == 62):
					if (nsubs == 0):
						parent.addChild(Xml.createPCData(""))
					return p
				else:
					raise _HxException("Expected >")
			elif (state == 10):
				if (not (((((((((c >= 97) and ((c <= 122))) or (((c >= 65) and ((c <= 90))))) or (((c >= 48) and ((c <= 57))))) or ((c == 58))) or ((c == 46))) or ((c == 95))) or ((c == 45))))):
					if (start == p):
						raise _HxException("Expected node name")
					v = HxString.substr(_hx_str,start,(p - start))
					def _hx_local_17():
						if (parent.nodeType != Xml.Element):
							raise _HxException(("Bad node type, expected Element but found " + Std.string(parent.nodeType)))
						return parent.nodeName
					if (v != _hx_local_17()):
						def _hx_local_18():
							if (parent.nodeType != Xml.Element):
								raise _HxException(("Bad node type, expected Element but found " + Std.string(parent.nodeType)))
							return parent.nodeName
						raise _HxException((("Expected </" + HxOverrides.stringOrNull(_hx_local_18())) + ">"))
					state = 0
					next = 12
					continue
			elif (state == 15):
				def _hx_local_19():
					index7 = (p + 1)
					return (-1 if ((index7 >= len(_hx_str))) else ord(_hx_str[index7]))
				def _hx_local_20():
					index8 = (p + 2)
					return (-1 if ((index8 >= len(_hx_str))) else ord(_hx_str[index8]))
				if (((c == 45) and ((_hx_local_19() == 45))) and ((_hx_local_20() == 62))):
					xml1 = Xml.createComment(HxString.substr(_hx_str,start,(p - start)))
					parent.addChild(xml1)
					nsubs = (nsubs + 1)
					p = (p + 2)
					state = 1
			elif (state == 16):
				if (c == 91):
					nbrackets = (nbrackets + 1)
				elif (c == 93):
					nbrackets = (nbrackets - 1)
				elif ((c == 62) and ((nbrackets == 0))):
					xml2 = Xml.createDocType(HxString.substr(_hx_str,start,(p - start)))
					parent.addChild(xml2)
					nsubs = (nsubs + 1)
					state = 1
			elif (state == 14):
				def _hx_local_26():
					index9 = (p + 1)
					return (-1 if ((index9 >= len(_hx_str))) else ord(_hx_str[index9]))
				if ((c == 63) and ((_hx_local_26() == 62))):
					p = (p + 1)
					str1 = HxString.substr(_hx_str,(start + 1),((p - start) - 2))
					xml3 = Xml.createProcessingInstruction(str1)
					parent.addChild(xml3)
					nsubs = (nsubs + 1)
					state = 1
			elif (state == 18):
				if (c == 59):
					s6 = HxString.substr(_hx_str,start,(p - start))
					if (((-1 if ((0 >= len(s6))) else ord(s6[0]))) == 35):
						c1 = None
						if (((-1 if ((1 >= len(s6))) else ord(s6[1]))) == 120):
							c1 = Std.parseInt(("0" + HxOverrides.stringOrNull(HxString.substr(s6,1,(len(s6) - 1)))))
						else:
							c1 = Std.parseInt(HxString.substr(s6,1,(len(s6) - 1)))
						s7 = "".join(map(chr,[c1]))
						buf.b.write(s7)
					elif (not s6 in haxe_xml_Parser.escapes.h):
						if strict:
							raise _HxException(("Undefined entity: " + ("null" if s6 is None else s6)))
						buf.b.write(Std.string((("&" + ("null" if s6 is None else s6)) + ";")))
					else:
						x = haxe_xml_Parser.escapes.h.get(s6,None)
						buf.b.write(Std.string(x))
					start = (p + 1)
					state = escapeNext
				elif ((not (((((((((c >= 97) and ((c <= 122))) or (((c >= 65) and ((c <= 90))))) or (((c >= 48) and ((c <= 57))))) or ((c == 58))) or ((c == 46))) or ((c == 95))) or ((c == 45))))) and ((c != 35))):
					if strict:
						raise _HxException(("Invalid character in entity: " + HxOverrides.stringOrNull("".join(map(chr,[c])))))
					s8 = "".join(map(chr,[38]))
					buf.b.write(s8)
					len6 = (p - start)
					s9 = None
					if (len6 is None):
						s9 = HxString.substr(_hx_str,start,None)
					else:
						s9 = HxString.substr(_hx_str,start,len6)
					buf.b.write(s9)
					p = (p - 1)
					start = (p + 1)
					state = escapeNext
			else:
				pass
			p = (p + 1)
			index10 = p
			if (index10 >= len(_hx_str)):
				c = -1
			else:
				c = ord(_hx_str[index10])
		if (state == 1):
			start = p
			state = 13
		if (state == 13):
			if ((p != start) or ((nsubs == 0))):
				len7 = (p - start)
				s10 = None
				if (len7 is None):
					s10 = HxString.substr(_hx_str,start,None)
				else:
					s10 = HxString.substr(_hx_str,start,len7)
				buf.b.write(s10)
				xml4 = Xml.createPCData(buf.b.getvalue())
				parent.addChild(xml4)
				nsubs = (nsubs + 1)
			return p
		if (((not strict) and ((state == 18))) and ((escapeNext == 13))):
			s11 = "".join(map(chr,[38]))
			buf.b.write(s11)
			len8 = (p - start)
			s12 = None
			if (len8 is None):
				s12 = HxString.substr(_hx_str,start,None)
			else:
				s12 = HxString.substr(_hx_str,start,len8)
			buf.b.write(s12)
			xml5 = Xml.createPCData(buf.b.getvalue())
			parent.addChild(xml5)
			nsubs = (nsubs + 1)
			return p
		raise _HxException("Unexpected end")
haxe_xml_Parser._hx_class = haxe_xml_Parser
_hx_classes["haxe.xml.Parser"] = haxe_xml_Parser


class python_Boot:
	_hx_class_name = "python.Boot"
	_hx_statics = ["keywords", "_add_dynamic", "toString1", "fields", "simpleField", "field", "getInstanceFields", "getSuperClass", "getClassFields", "prefixLength", "unhandleKeywords"]

	@staticmethod
	def _add_dynamic(a,b):
		if (isinstance(a,str) and isinstance(b,str)):
			return (a + b)
		if (isinstance(a,str) or isinstance(b,str)):
			return (python_Boot.toString1(a,"") + python_Boot.toString1(b,""))
		return (a + b)

	@staticmethod
	def toString1(o,s):
		if (o is None):
			return "null"
		if isinstance(o,str):
			return o
		if (s is None):
			s = ""
		if (len(s) >= 5):
			return "<...>"
		if isinstance(o,bool):
			if o:
				return "true"
			else:
				return "false"
		if isinstance(o,int):
			return str(o)
		if isinstance(o,float):
			try:
				if (o == int(o)):
					def _hx_local_1():
						def _hx_local_0():
							v = o
							return Math.floor((v + 0.5))
						return str(_hx_local_0())
					return _hx_local_1()
				else:
					return str(o)
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				e = _hx_e1
				return str(o)
		if isinstance(o,list):
			o1 = o
			l = len(o1)
			st = "["
			s = (("null" if s is None else s) + "\t")
			_g = 0
			while (_g < l):
				i = _g
				_g = (_g + 1)
				prefix = ""
				if (i > 0):
					prefix = ","
				st = (("null" if st is None else st) + HxOverrides.stringOrNull(((("null" if prefix is None else prefix) + HxOverrides.stringOrNull(python_Boot.toString1((o1[i] if i >= 0 and i < len(o1) else None),s))))))
			st = (("null" if st is None else st) + "]")
			return st
		try:
			if hasattr(o,"toString"):
				return o.toString()
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			pass
		if (python_lib_Inspect.isfunction(o) or python_lib_Inspect.ismethod(o)):
			return "<function>"
		if hasattr(o,"__class__"):
			if isinstance(o,_hx_AnonObject):
				toStr = None
				try:
					fields = python_Boot.fields(o)
					fieldsStr = None
					_g1 = []
					_g11 = 0
					while (_g11 < len(fields)):
						f = (fields[_g11] if _g11 >= 0 and _g11 < len(fields) else None)
						_g11 = (_g11 + 1)
						x = ((("" + ("null" if f is None else f)) + " : ") + HxOverrides.stringOrNull(python_Boot.toString1(python_Boot.simpleField(o,f),(("null" if s is None else s) + "\t"))))
						_g1.append(x)
					fieldsStr = _g1
					toStr = (("{ " + HxOverrides.stringOrNull(", ".join([x1 for x1 in fieldsStr]))) + " }")
				except Exception as _hx_e:
					_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
					e2 = _hx_e1
					return "{ ... }"
				if (toStr is None):
					return "{ ... }"
				else:
					return toStr
			if isinstance(o,Enum):
				o2 = o
				l1 = len(o2.params)
				hasParams = (l1 > 0)
				if hasParams:
					paramsStr = ""
					_g2 = 0
					while (_g2 < l1):
						i1 = _g2
						_g2 = (_g2 + 1)
						prefix1 = ""
						if (i1 > 0):
							prefix1 = ","
						paramsStr = (("null" if paramsStr is None else paramsStr) + HxOverrides.stringOrNull(((("null" if prefix1 is None else prefix1) + HxOverrides.stringOrNull(python_Boot.toString1((o2.params[i1] if i1 >= 0 and i1 < len(o2.params) else None),s))))))
					return (((HxOverrides.stringOrNull(o2.tag) + "(") + ("null" if paramsStr is None else paramsStr)) + ")")
				else:
					return o2.tag
			if hasattr(o,"_hx_class_name"):
				if (o.__class__.__name__ != "type"):
					fields1 = python_Boot.getInstanceFields(o)
					fieldsStr1 = None
					_g3 = []
					_g12 = 0
					while (_g12 < len(fields1)):
						f1 = (fields1[_g12] if _g12 >= 0 and _g12 < len(fields1) else None)
						_g12 = (_g12 + 1)
						x1 = ((("" + ("null" if f1 is None else f1)) + " : ") + HxOverrides.stringOrNull(python_Boot.toString1(python_Boot.simpleField(o,f1),(("null" if s is None else s) + "\t"))))
						_g3.append(x1)
					fieldsStr1 = _g3
					toStr1 = (((HxOverrides.stringOrNull(o._hx_class_name) + "( ") + HxOverrides.stringOrNull(", ".join([x1 for x1 in fieldsStr1]))) + " )")
					return toStr1
				else:
					fields2 = python_Boot.getClassFields(o)
					fieldsStr2 = None
					_g4 = []
					_g13 = 0
					while (_g13 < len(fields2)):
						f2 = (fields2[_g13] if _g13 >= 0 and _g13 < len(fields2) else None)
						_g13 = (_g13 + 1)
						x2 = ((("" + ("null" if f2 is None else f2)) + " : ") + HxOverrides.stringOrNull(python_Boot.toString1(python_Boot.simpleField(o,f2),(("null" if s is None else s) + "\t"))))
						_g4.append(x2)
					fieldsStr2 = _g4
					toStr2 = (((("#" + HxOverrides.stringOrNull(o._hx_class_name)) + "( ") + HxOverrides.stringOrNull(", ".join([x1 for x1 in fieldsStr2]))) + " )")
					return toStr2
			if (o == str):
				return "#String"
			if (o == list):
				return "#Array"
			if callable(o):
				return "function"
			try:
				if hasattr(o,"__repr__"):
					return o.__repr__()
			except Exception as _hx_e:
				_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
				pass
			if hasattr(o,"__str__"):
				return o.__str__([])
			if hasattr(o,"__name__"):
				return o.__name__
			return "???"
		else:
			return str(o)

	@staticmethod
	def fields(o):
		a = []
		if (o is not None):
			if hasattr(o,"_hx_fields"):
				fields = o._hx_fields
				return list(fields)
			if isinstance(o,_hx_AnonObject):
				d = o.__dict__
				keys = d.keys()
				handler = python_Boot.unhandleKeywords
				for k in keys:
					a.append(handler(k))
			elif hasattr(o,"__dict__"):
				a1 = []
				d1 = o.__dict__
				keys1 = d1.keys()
				for k in keys1:
					a.append(k)
		return a

	@staticmethod
	def simpleField(o,field):
		if (field is None):
			return None
		field1 = None
		if field in python_Boot.keywords:
			field1 = ("_hx_" + field)
		elif ((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95))):
			field1 = ("_hx_" + field)
		else:
			field1 = field
		if hasattr(o,field1):
			return getattr(o,field1)
		else:
			return None

	@staticmethod
	def field(o,field):
		if (field is None):
			return None
		_hx_local_0 = len(field)
		if (_hx_local_0 == 10):
			if (field == "charCodeAt"):
				if isinstance(o,str):
					s4 = o
					def _hx_local_1(a11):
						return HxString.charCodeAt(s4,a11)
					return _hx_local_1
		elif (_hx_local_0 == 11):
			if (field == "toLowerCase"):
				if isinstance(o,str):
					s1 = o
					def _hx_local_2():
						return HxString.toLowerCase(s1)
					return _hx_local_2
			elif (field == "toUpperCase"):
				if isinstance(o,str):
					s2 = o
					def _hx_local_3():
						return HxString.toUpperCase(s2)
					return _hx_local_3
			elif (field == "lastIndexOf"):
				if isinstance(o,str):
					s6 = o
					def _hx_local_4(a13):
						return HxString.lastIndexOf(s6,a13)
					return _hx_local_4
				elif isinstance(o,list):
					a2 = o
					def _hx_local_5(x2):
						return python_internal_ArrayImpl.lastIndexOf(a2,x2)
					return _hx_local_5
		elif (_hx_local_0 == 9):
			if (field == "substring"):
				if isinstance(o,str):
					s9 = o
					def _hx_local_6(a15):
						return HxString.substring(s9,a15)
					return _hx_local_6
		elif (_hx_local_0 == 5):
			if (field == "split"):
				if isinstance(o,str):
					s7 = o
					def _hx_local_7(d):
						return HxString.split(s7,d)
					return _hx_local_7
			elif (field == "shift"):
				if isinstance(o,list):
					x14 = o
					def _hx_local_8():
						return python_internal_ArrayImpl.shift(x14)
					return _hx_local_8
			elif (field == "slice"):
				if isinstance(o,list):
					x15 = o
					def _hx_local_9(a18):
						return python_internal_ArrayImpl.slice(x15,a18)
					return _hx_local_9
		elif (_hx_local_0 == 4):
			if (field == "copy"):
				if isinstance(o,list):
					def _hx_local_10():
						x6 = o
						return list(x6)
					return _hx_local_10
			elif (field == "join"):
				if isinstance(o,list):
					def _hx_local_11(sep):
						x9 = o
						return sep.join([python_Boot.toString1(x1,'') for x1 in x9])
					return _hx_local_11
			elif (field == "push"):
				if isinstance(o,list):
					x11 = o
					def _hx_local_12(e):
						return python_internal_ArrayImpl.push(x11,e)
					return _hx_local_12
			elif (field == "sort"):
				if isinstance(o,list):
					x16 = o
					def _hx_local_13(f2):
						python_internal_ArrayImpl.sort(x16,f2)
					return _hx_local_13
		elif (_hx_local_0 == 7):
			if (field == "indexOf"):
				if isinstance(o,str):
					s5 = o
					def _hx_local_14(a12):
						return HxString.indexOf(s5,a12)
					return _hx_local_14
				elif isinstance(o,list):
					a = o
					def _hx_local_15(x1):
						return python_internal_ArrayImpl.indexOf(a,x1)
					return _hx_local_15
			elif (field == "unshift"):
				if isinstance(o,list):
					x12 = o
					def _hx_local_16(e1):
						python_internal_ArrayImpl.unshift(x12,e1)
					return _hx_local_16
			elif (field == "reverse"):
				if isinstance(o,list):
					a4 = o
					def _hx_local_17():
						python_internal_ArrayImpl.reverse(a4)
					return _hx_local_17
		elif (_hx_local_0 == 3):
			if (field == "map"):
				if isinstance(o,list):
					x4 = o
					def _hx_local_18(f):
						return python_internal_ArrayImpl.map(x4,f)
					return _hx_local_18
			elif (field == "pop"):
				if isinstance(o,list):
					x10 = o
					def _hx_local_19():
						return python_internal_ArrayImpl.pop(x10)
					return _hx_local_19
		elif (_hx_local_0 == 8):
			if (field == "toString"):
				if isinstance(o,str):
					s10 = o
					def _hx_local_20():
						return HxString.toString(s10)
					return _hx_local_20
				elif isinstance(o,list):
					x3 = o
					def _hx_local_21():
						return python_internal_ArrayImpl.toString(x3)
					return _hx_local_21
			elif (field == "iterator"):
				if isinstance(o,list):
					x7 = o
					def _hx_local_22():
						return python_internal_ArrayImpl.iterator(x7)
					return _hx_local_22
		elif (_hx_local_0 == 6):
			if (field == "length"):
				if isinstance(o,str):
					s = o
					return len(s)
				elif isinstance(o,list):
					x = o
					return len(x)
			elif (field == "charAt"):
				if isinstance(o,str):
					s3 = o
					def _hx_local_23(a1):
						return HxString.charAt(s3,a1)
					return _hx_local_23
			elif (field == "substr"):
				if isinstance(o,str):
					s8 = o
					def _hx_local_24(a14):
						return HxString.substr(s8,a14)
					return _hx_local_24
			elif (field == "filter"):
				if isinstance(o,list):
					x5 = o
					def _hx_local_25(f1):
						return python_internal_ArrayImpl.filter(x5,f1)
					return _hx_local_25
			elif (field == "concat"):
				if isinstance(o,list):
					a16 = o
					def _hx_local_26(a21):
						return python_internal_ArrayImpl.concat(a16,a21)
					return _hx_local_26
			elif (field == "insert"):
				if isinstance(o,list):
					a3 = o
					def _hx_local_27(a17,x8):
						python_internal_ArrayImpl.insert(a3,a17,x8)
					return _hx_local_27
			elif (field == "remove"):
				if isinstance(o,list):
					x13 = o
					def _hx_local_28(e2):
						return python_internal_ArrayImpl.remove(x13,e2)
					return _hx_local_28
			elif (field == "splice"):
				if isinstance(o,list):
					x17 = o
					def _hx_local_29(a19,a22):
						return python_internal_ArrayImpl.splice(x17,a19,a22)
					return _hx_local_29
		else:
			pass
		field1 = None
		if field in python_Boot.keywords:
			field1 = ("_hx_" + field)
		elif ((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95))):
			field1 = ("_hx_" + field)
		else:
			field1 = field
		if hasattr(o,field1):
			return getattr(o,field1)
		else:
			return None

	@staticmethod
	def getInstanceFields(c):
		f = None
		if hasattr(c,"_hx_fields"):
			f = c._hx_fields
		else:
			f = []
		if hasattr(c,"_hx_methods"):
			a = c._hx_methods
			f = (f + a)
		sc = python_Boot.getSuperClass(c)
		if (sc is None):
			return f
		else:
			scArr = python_Boot.getInstanceFields(sc)
			scMap = set(scArr)
			res = []
			_g = 0
			while (_g < len(f)):
				f1 = (f[_g] if _g >= 0 and _g < len(f) else None)
				_g = (_g + 1)
				if (not f1 in scMap):
					scArr.append(f1)
			return scArr

	@staticmethod
	def getSuperClass(c):
		if (c is None):
			return None
		try:
			if hasattr(c,"_hx_super"):
				return c._hx_super
			return None
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			pass
		return None

	@staticmethod
	def getClassFields(c):
		if hasattr(c,"_hx_statics"):
			x = c._hx_statics
			return list(x)
		else:
			return []

	@staticmethod
	def unhandleKeywords(name):
		if (HxString.substr(name,0,python_Boot.prefixLength) == "_hx_"):
			real = HxString.substr(name,python_Boot.prefixLength,None)
			if real in python_Boot.keywords:
				return real
		return name
python_Boot._hx_class = python_Boot
_hx_classes["python.Boot"] = python_Boot


class python__KwArgs_KwArgs_Impl_:
	_hx_class_name = "python._KwArgs.KwArgs_Impl_"
	_hx_statics = ["fromT"]

	@staticmethod
	def fromT(d):
		d1 = python_Lib.anonAsDict(d)
		return d1
python__KwArgs_KwArgs_Impl_._hx_class = python__KwArgs_KwArgs_Impl_
_hx_classes["python._KwArgs.KwArgs_Impl_"] = python__KwArgs_KwArgs_Impl_


class python_Lib:
	_hx_class_name = "python.Lib"
	_hx_statics = ["print", "println", "dictToAnon", "anonToDict", "anonAsDict", "dictAsAnon"]

	@staticmethod
	def print(v):
		_hx_str = Std.string(v)
		python_lib_Sys.stdout.buffer.write(_hx_str.encode("utf-8", "strict"))
		python_lib_Sys.stdout.flush()

	@staticmethod
	def println(v):
		_hx_str = Std.string(v)
		python_lib_Sys.stdout.buffer.write((("" + ("null" if _hx_str is None else _hx_str)) + "\n").encode("utf-8", "strict"))
		python_lib_Sys.stdout.flush()

	@staticmethod
	def dictToAnon(v):
		return _hx_AnonObject(v.copy())

	@staticmethod
	def anonToDict(o):
		if isinstance(o,_hx_AnonObject):
			return o.__dict__.copy()
		else:
			return None

	@staticmethod
	def anonAsDict(o):
		if isinstance(o,_hx_AnonObject):
			return o.__dict__
		else:
			return None

	@staticmethod
	def dictAsAnon(d):
		return _hx_AnonObject(d)
python_Lib._hx_class = python_Lib
_hx_classes["python.Lib"] = python_Lib


class python_internal_ArrayImpl:
	_hx_class_name = "python.internal.ArrayImpl"
	_hx_statics = ["concat", "iterator", "indexOf", "lastIndexOf", "toString", "pop", "push", "unshift", "remove", "shift", "slice", "sort", "splice", "map", "filter", "insert", "reverse", "_get", "_set"]

	@staticmethod
	def concat(a1,a2):
		return (a1 + a2)

	@staticmethod
	def iterator(x):
		return python_HaxeIterator(x.__iter__())

	@staticmethod
	def indexOf(a,x,fromIndex = None):
		_hx_len = len(a)
		l = None
		if (fromIndex is None):
			l = 0
		elif (fromIndex < 0):
			l = (_hx_len + fromIndex)
		else:
			l = fromIndex
		if (l < 0):
			l = 0
		_g = l
		while (_g < _hx_len):
			i = _g
			_g = (_g + 1)
			if (a[i] == x):
				return i
		return -1

	@staticmethod
	def lastIndexOf(a,x,fromIndex = None):
		_hx_len = len(a)
		l = None
		if (fromIndex is None):
			l = _hx_len
		elif (fromIndex < 0):
			l = ((_hx_len + fromIndex) + 1)
		else:
			l = (fromIndex + 1)
		if (l > _hx_len):
			l = _hx_len
		def _hx_local_1():
			nonlocal l
			l = (l - 1)
			return l
		while (_hx_local_1() > -1):
			if (a[l] == x):
				return l
		return -1

	@staticmethod
	def toString(x):
		return (("[" + HxOverrides.stringOrNull(",".join([python_Boot.toString1(x1,'') for x1 in x]))) + "]")

	@staticmethod
	def pop(x):
		if (len(x) == 0):
			return None
		else:
			return x.pop()

	@staticmethod
	def push(x,e):
		x.append(e)
		return len(x)

	@staticmethod
	def unshift(x,e):
		x.insert(0, e)

	@staticmethod
	def remove(x,e):
		try:
			x.remove(e)
			return True
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			e1 = _hx_e1
			return False

	@staticmethod
	def shift(x):
		if (len(x) == 0):
			return None
		return x.pop(0)

	@staticmethod
	def slice(x,pos,end = None):
		return x[pos:end]

	@staticmethod
	def sort(x,f):
		x.sort(key= python_lib_Functools.cmp_to_key(f))

	@staticmethod
	def splice(x,pos,_hx_len):
		if (pos < 0):
			pos = (len(x) + pos)
		if (pos < 0):
			pos = 0
		res = x[pos:(pos + _hx_len)]
		del x[pos:(pos + _hx_len)]
		return res

	@staticmethod
	def map(x,f):
		return list(map(f,x))

	@staticmethod
	def filter(x,f):
		return list(filter(f,x))

	@staticmethod
	def insert(a,pos,x):
		a.insert(pos, x)

	@staticmethod
	def reverse(a):
		a.reverse()

	@staticmethod
	def _get(x,idx):
		if ((idx > -1) and ((idx < len(x)))):
			return x[idx]
		else:
			return None

	@staticmethod
	def _set(x,idx,v):
		l = len(x)
		while (l < idx):
			x.append(None)
			l = (l + 1)
		if (l == idx):
			x.append(v)
		else:
			x[idx] = v
		return v
python_internal_ArrayImpl._hx_class = python_internal_ArrayImpl
_hx_classes["python.internal.ArrayImpl"] = python_internal_ArrayImpl


class _HxException(Exception):
	_hx_class_name = "_HxException"
	_hx_fields = ["val"]
	_hx_methods = []
	_hx_statics = []
	_hx_interfaces = []
	_hx_super = Exception


	def __init__(self,val):
		self.val = None
		message = str(val)
		super().__init__(message)
		self.val = val

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.val = None
_HxException._hx_class = _HxException
_hx_classes["_HxException"] = _HxException


class HxOverrides:
	_hx_class_name = "HxOverrides"
	_hx_statics = ["iterator", "eq", "stringOrNull", "modf", "mod", "arrayGet", "mapKwArgs"]

	@staticmethod
	def iterator(x):
		if isinstance(x,list):
			return python_HaxeIterator(x.__iter__())
		return x.iterator()

	@staticmethod
	def eq(a,b):
		if (isinstance(a,list) or isinstance(b,list)):
			return a is b
		return (a == b)

	@staticmethod
	def stringOrNull(s):
		if (s is None):
			return "null"
		else:
			return s

	@staticmethod
	def modf(a,b):
		return float('nan') if (b == 0.0) else a % b if a >= 0 else -(-a % b)

	@staticmethod
	def mod(a,b):
		return a % b if a >= 0 else -(-a % b)

	@staticmethod
	def arrayGet(a,i):
		if isinstance(a,list):
			x = a
			if ((i > -1) and ((i < len(x)))):
				return x[i]
			else:
				return None
		else:
			return a[i]

	@staticmethod
	def mapKwArgs(a,v):
		a1 = python_Lib.dictAsAnon(python_Lib.anonToDict(a))
		def _hx_local_0():
			_this = v.keys()
			def _hx_local_2():
				def _hx_local_1():
					this1 = iter(_this)
					return python_HaxeIterator(this1)
				return _hx_local_1()
			return _hx_local_2()
		_hx_local_3 = _hx_local_0()
		while _hx_local_3.hasNext():
			k = _hx_local_3.next()
			val = v.get(k)
			if hasattr(a1,k):
				x = getattr(a1,k)
				setattr(a1,val,x)
				delattr(a1,k)
		return a1
HxOverrides._hx_class = HxOverrides
_hx_classes["HxOverrides"] = HxOverrides


class HxString:
	_hx_class_name = "HxString"
	_hx_statics = ["split", "charCodeAt", "charAt", "lastIndexOf", "toUpperCase", "toLowerCase", "indexOf", "toString", "substring", "substr"]

	@staticmethod
	def split(s,d):
		if (d == ""):
			return list(s)
		else:
			return s.split(d)

	@staticmethod
	def charCodeAt(s,index):
		if ((((s is None) or ((len(s) == 0))) or ((index < 0))) or ((index >= len(s)))):
			return None
		else:
			return ord(s[index])

	@staticmethod
	def charAt(s,index):
		if ((index < 0) or ((index >= len(s)))):
			return ""
		else:
			return s[index]

	@staticmethod
	def lastIndexOf(s,_hx_str,startIndex = None):
		if (startIndex is None):
			return s.rfind(_hx_str, 0, len(s))
		else:
			i = s.rfind(_hx_str, 0, (startIndex + 1))
			startLeft = None
			if (i == -1):
				startLeft = max(0,((startIndex + 1) - len(_hx_str)))
			else:
				startLeft = (i + 1)
			check = s.find(_hx_str, startLeft, len(s))
			if ((check > i) and ((check <= startIndex))):
				return check
			else:
				return i

	@staticmethod
	def toUpperCase(s):
		return s.upper()

	@staticmethod
	def toLowerCase(s):
		return s.lower()

	@staticmethod
	def indexOf(s,_hx_str,startIndex = None):
		if (startIndex is None):
			return s.find(_hx_str)
		else:
			return s.find(_hx_str, startIndex)

	@staticmethod
	def toString(s):
		return s

	@staticmethod
	def substring(s,startIndex,endIndex = None):
		if (startIndex < 0):
			startIndex = 0
		if (endIndex is None):
			return s[startIndex:]
		else:
			if (endIndex < 0):
				endIndex = 0
			if (endIndex < startIndex):
				return s[endIndex:startIndex]
			else:
				return s[startIndex:endIndex]

	@staticmethod
	def substr(s,startIndex,_hx_len = None):
		if (_hx_len is None):
			return s[startIndex:]
		else:
			if (_hx_len == 0):
				return ""
			return s[startIndex:(startIndex + _hx_len)]
HxString._hx_class = HxString
_hx_classes["HxString"] = HxString


class python_io_NativeInput(haxe_io_Input):
	_hx_class_name = "python.io.NativeInput"
	_hx_fields = ["stream", "wasEof"]
	_hx_methods = ["get_canSeek", "close", "tell", "throwEof", "readinto", "seek", "readBytes"]
	_hx_statics = []
	_hx_interfaces = []
	_hx_super = haxe_io_Input


	def __init__(self,s):
		self.stream = None
		self.wasEof = None
		self.stream = s
		self.wasEof = False
		if (not self.stream.readable()):
			raise _HxException("Write-only stream")

	def get_canSeek(self):
		return self.stream.seekable()

	def close(self):
		self.stream.close()

	def tell(self):
		return self.stream.tell()

	def throwEof(self):
		self.wasEof = True
		raise _HxException(haxe_io_Eof())

	def readinto(self,b):
		raise _HxException("abstract method, should be overriden")

	def seek(self,p,mode):
		raise _HxException("abstract method, should be overriden")

	def readBytes(self,s,pos,_hx_len):
		if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > s.length))):
			raise _HxException(haxe_io_Error.OutsideBounds)
		if self.get_canSeek():
			self.seek(pos,sys_io_FileSeek.SeekBegin)
		elif (pos > 0):
			raise _HxException((("Cannot call readBytes for pos > 0 (" + Std.string(pos)) + ") on not seekable stream"))
		ba = bytearray(_hx_len)
		ret = self.readinto(ba)
		s.blit(pos,haxe_io_Bytes.ofData(ba),0,_hx_len)
		if (ret == 0):
			self.throwEof()
		return ret

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.stream = None
		_hx_o.wasEof = None
python_io_NativeInput._hx_class = python_io_NativeInput
_hx_classes["python.io.NativeInput"] = python_io_NativeInput


class python_io_IInput:
	_hx_class_name = "python.io.IInput"
	_hx_methods = ["readByte", "readBytes", "close", "readAll", "readLine"]
python_io_IInput._hx_class = python_io_IInput
_hx_classes["python.io.IInput"] = python_io_IInput


class python_io_NativeBytesInput(python_io_NativeInput):
	_hx_class_name = "python.io.NativeBytesInput"
	_hx_fields = []
	_hx_methods = ["readByte", "seek", "readinto"]
	_hx_statics = []
	_hx_interfaces = [python_io_IInput]
	_hx_super = python_io_NativeInput


	def __init__(self,stream):
		super().__init__(stream)

	def readByte(self):
		ret = self.stream.read(1)
		if (len(ret) == 0):
			self.throwEof()
		return ret[0]

	def seek(self,p,pos):
		self.wasEof = False
		python_io_IoTools.seekInBinaryMode(self.stream,p,pos)
		return

	def readinto(self,b):
		return self.stream.readinto(b)

	@staticmethod
	def _hx_empty_init(_hx_o):		pass
python_io_NativeBytesInput._hx_class = python_io_NativeBytesInput
_hx_classes["python.io.NativeBytesInput"] = python_io_NativeBytesInput


class python_io_IFileInput:
	_hx_class_name = "python.io.IFileInput"
	_hx_interfaces = [python_io_IInput]
python_io_IFileInput._hx_class = python_io_IFileInput
_hx_classes["python.io.IFileInput"] = python_io_IFileInput


class python_io_FileBytesInput(python_io_NativeBytesInput):
	_hx_class_name = "python.io.FileBytesInput"
	_hx_fields = []
	_hx_methods = []
	_hx_statics = []
	_hx_interfaces = [python_io_IFileInput]
	_hx_super = python_io_NativeBytesInput


	def __init__(self,stream):
		super().__init__(stream)
python_io_FileBytesInput._hx_class = python_io_FileBytesInput
_hx_classes["python.io.FileBytesInput"] = python_io_FileBytesInput


class python_io_NativeOutput(haxe_io_Output):
	_hx_class_name = "python.io.NativeOutput"
	_hx_fields = ["stream"]
	_hx_methods = ["close"]
	_hx_statics = []
	_hx_interfaces = []
	_hx_super = haxe_io_Output


	def __init__(self,stream):
		self.stream = None
		self.stream = stream
		if (not stream.writable()):
			raise _HxException("Read only stream")

	def close(self):
		self.stream.close()

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.stream = None
python_io_NativeOutput._hx_class = python_io_NativeOutput
_hx_classes["python.io.NativeOutput"] = python_io_NativeOutput


class python_io_NativeBytesOutput(python_io_NativeOutput):
	_hx_class_name = "python.io.NativeBytesOutput"
	_hx_fields = []
	_hx_methods = ["writeByte"]
	_hx_statics = []
	_hx_interfaces = []
	_hx_super = python_io_NativeOutput


	def __init__(self,stream):
		super().__init__(stream)

	def writeByte(self,c):
		self.stream.write(bytearray([c]))

	@staticmethod
	def _hx_empty_init(_hx_o):		pass
python_io_NativeBytesOutput._hx_class = python_io_NativeBytesOutput
_hx_classes["python.io.NativeBytesOutput"] = python_io_NativeBytesOutput


class python_io_IOutput:
	_hx_class_name = "python.io.IOutput"
	_hx_methods = ["set_bigEndian", "writeByte", "writeBytes", "close", "write", "writeFullBytes", "writeString"]
python_io_IOutput._hx_class = python_io_IOutput
_hx_classes["python.io.IOutput"] = python_io_IOutput


class python_io_IFileOutput:
	_hx_class_name = "python.io.IFileOutput"
	_hx_interfaces = [python_io_IOutput]
python_io_IFileOutput._hx_class = python_io_IFileOutput
_hx_classes["python.io.IFileOutput"] = python_io_IFileOutput


class python_io_FileBytesOutput(python_io_NativeBytesOutput):
	_hx_class_name = "python.io.FileBytesOutput"
	_hx_fields = []
	_hx_methods = []
	_hx_statics = []
	_hx_interfaces = [python_io_IFileOutput]
	_hx_super = python_io_NativeBytesOutput


	def __init__(self,stream):
		super().__init__(stream)
python_io_FileBytesOutput._hx_class = python_io_FileBytesOutput
_hx_classes["python.io.FileBytesOutput"] = python_io_FileBytesOutput


class python_io_NativeTextInput(python_io_NativeInput):
	_hx_class_name = "python.io.NativeTextInput"
	_hx_fields = []
	_hx_methods = ["readByte", "seek", "readinto"]
	_hx_statics = []
	_hx_interfaces = [python_io_IInput]
	_hx_super = python_io_NativeInput


	def __init__(self,stream):
		super().__init__(stream)

	def readByte(self):
		ret = self.stream.read(1)
		if (len(ret) == 0):
			self.throwEof()
		return HxString.charCodeAt(ret,0)

	def seek(self,p,pos):
		self.wasEof = False
		python_io_IoTools.seekInTextMode(self.stream,self.tell,p,pos)

	def readinto(self,b):
		return self.stream.buffer.readinto(b)

	@staticmethod
	def _hx_empty_init(_hx_o):		pass
python_io_NativeTextInput._hx_class = python_io_NativeTextInput
_hx_classes["python.io.NativeTextInput"] = python_io_NativeTextInput


class python_io_FileTextInput(python_io_NativeTextInput):
	_hx_class_name = "python.io.FileTextInput"
	_hx_fields = []
	_hx_methods = []
	_hx_statics = []
	_hx_interfaces = [python_io_IFileInput]
	_hx_super = python_io_NativeTextInput


	def __init__(self,stream):
		super().__init__(stream)
python_io_FileTextInput._hx_class = python_io_FileTextInput
_hx_classes["python.io.FileTextInput"] = python_io_FileTextInput


class python_io_NativeTextOutput(python_io_NativeOutput):
	_hx_class_name = "python.io.NativeTextOutput"
	_hx_fields = []
	_hx_methods = ["writeByte"]
	_hx_statics = []
	_hx_interfaces = []
	_hx_super = python_io_NativeOutput


	def __init__(self,stream):
		super().__init__(stream)
		if (not stream.writable()):
			raise _HxException("Read only stream")

	def writeByte(self,c):
		self.stream.write("".join(map(chr,[c])))

	@staticmethod
	def _hx_empty_init(_hx_o):		pass
python_io_NativeTextOutput._hx_class = python_io_NativeTextOutput
_hx_classes["python.io.NativeTextOutput"] = python_io_NativeTextOutput


class python_io_FileTextOutput(python_io_NativeTextOutput):
	_hx_class_name = "python.io.FileTextOutput"
	_hx_fields = []
	_hx_methods = []
	_hx_statics = []
	_hx_interfaces = [python_io_IFileOutput]
	_hx_super = python_io_NativeTextOutput


	def __init__(self,stream):
		super().__init__(stream)
python_io_FileTextOutput._hx_class = python_io_FileTextOutput
_hx_classes["python.io.FileTextOutput"] = python_io_FileTextOutput


class python_io_IoTools:
	_hx_class_name = "python.io.IoTools"
	_hx_statics = ["createFileInputFromText", "createFileInputFromBytes", "createFileOutputFromText", "createFileOutputFromBytes", "seekInTextMode", "seekInBinaryMode"]

	@staticmethod
	def createFileInputFromText(t):
		return sys_io_FileInput(python_io_FileTextInput(t))

	@staticmethod
	def createFileInputFromBytes(t):
		return sys_io_FileInput(python_io_FileBytesInput(t))

	@staticmethod
	def createFileOutputFromText(t):
		return sys_io_FileOutput(python_io_FileTextOutput(t))

	@staticmethod
	def createFileOutputFromBytes(t):
		return sys_io_FileOutput(python_io_FileBytesOutput(t))

	@staticmethod
	def seekInTextMode(stream,tell,p,pos):
		pos1 = None
		if ((pos.index) == 0):
			pos1 = 0
		elif ((pos.index) == 1):
			p = (tell() + p)
			pos1 = 0
		elif ((pos.index) == 2):
			stream.seek(0,2)
			p = (tell() + p)
			pos1 = 0
		else:
			pass
		stream.seek(p,pos1)

	@staticmethod
	def seekInBinaryMode(stream,p,pos):
		pos1 = None
		if ((pos.index) == 0):
			pos1 = 0
		elif ((pos.index) == 1):
			pos1 = 1
		elif ((pos.index) == 2):
			pos1 = 2
		else:
			pass
		stream.seek(p,pos1)
python_io_IoTools._hx_class = python_io_IoTools
_hx_classes["python.io.IoTools"] = python_io_IoTools


class sys_FileSystem:
	_hx_class_name = "sys.FileSystem"
	_hx_statics = ["exists", "fullPath", "isDirectory", "createDirectory", "deleteFile", "readDirectory"]

	@staticmethod
	def exists(path):
		return python_lib_os_Path.exists(path)

	@staticmethod
	def fullPath(relPath):
		return python_lib_os_Path.realpath(relPath)

	@staticmethod
	def isDirectory(path):
		return python_lib_os_Path.isdir(path)

	@staticmethod
	def createDirectory(path):
		python_lib_Os.makedirs(path,511,True)

	@staticmethod
	def deleteFile(path):
		python_lib_Os.remove(path)

	@staticmethod
	def readDirectory(path):
		return python_lib_Os.listdir(path)
sys_FileSystem._hx_class = sys_FileSystem
_hx_classes["sys.FileSystem"] = sys_FileSystem


class sys_io_File:
	_hx_class_name = "sys.io.File"
	_hx_statics = ["getContent", "getBytes", "read", "write", "copy"]

	@staticmethod
	def getContent(path):
		f = python_lib_Builtins.open(path,"r",-1,"utf-8",None,"")
		content = f.read(-1)
		f.close()
		return content

	@staticmethod
	def getBytes(path):
		f = python_lib_Builtins.open(path,"rb",-1)
		size = f.read(-1)
		b = haxe_io_Bytes.ofData(size)
		f.close()
		return b

	@staticmethod
	def read(path,binary = True):
		if (binary is None):
			binary = True
		mode = None
		if binary:
			mode = "rb"
		else:
			mode = "r"
		f = python_lib_Builtins.open(path,mode,-1,None,None,(None if binary else ""))
		if binary:
			return python_io_IoTools.createFileInputFromBytes(f)
		else:
			return python_io_IoTools.createFileInputFromText(f)

	@staticmethod
	def write(path,binary = True):
		if (binary is None):
			binary = True
		mode = None
		if binary:
			mode = "wb"
		else:
			mode = "w"
		f = python_lib_Builtins.open(path,mode,-1,None,None,(None if binary else ""))
		if binary:
			return python_io_IoTools.createFileOutputFromBytes(f)
		else:
			return python_io_IoTools.createFileOutputFromText(f)

	@staticmethod
	def copy(srcPath,dstPath):
		python_lib_Shutil.copy(srcPath,dstPath)
		return
sys_io_File._hx_class = sys_io_File
_hx_classes["sys.io.File"] = sys_io_File


class sys_io_FileInput(haxe_io_Input):
	_hx_class_name = "sys.io.FileInput"
	_hx_fields = ["impl"]
	_hx_methods = ["readByte", "readBytes", "close", "readAll", "readLine"]
	_hx_statics = []
	_hx_interfaces = []
	_hx_super = haxe_io_Input


	def __init__(self,impl):
		self.impl = None
		self.impl = impl

	def readByte(self):
		return self.impl.readByte()

	def readBytes(self,s,pos,_hx_len):
		return self.impl.readBytes(s,pos,_hx_len)

	def close(self):
		self.impl.close()

	def readAll(self,bufsize = None):
		return self.impl.readAll(bufsize)

	def readLine(self):
		return self.impl.readLine()

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.impl = None
sys_io_FileInput._hx_class = sys_io_FileInput
_hx_classes["sys.io.FileInput"] = sys_io_FileInput


class sys_io_FileOutput(haxe_io_Output):
	_hx_class_name = "sys.io.FileOutput"
	_hx_fields = ["impl"]
	_hx_methods = ["set_bigEndian", "writeByte", "writeBytes", "close", "write", "writeFullBytes", "writeString"]
	_hx_statics = []
	_hx_interfaces = []
	_hx_super = haxe_io_Output


	def __init__(self,impl):
		self.impl = None
		self.impl = impl

	def set_bigEndian(self,b):
		return self.impl.set_bigEndian(b)

	def writeByte(self,c):
		self.impl.writeByte(c)

	def writeBytes(self,s,pos,_hx_len):
		return self.impl.writeBytes(s,pos,_hx_len)

	def close(self):
		self.impl.close()

	def write(self,s):
		self.impl.write(s)

	def writeFullBytes(self,s,pos,_hx_len):
		self.impl.writeFullBytes(s,pos,_hx_len)

	def writeString(self,s):
		self.impl.writeString(s)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.impl = None
sys_io_FileOutput._hx_class = sys_io_FileOutput
_hx_classes["sys.io.FileOutput"] = sys_io_FileOutput

class sys_io_FileSeek(Enum):
	_hx_class_name = "sys.io.FileSeek"
	_hx_constructs = ["SeekBegin", "SeekCur", "SeekEnd"]
sys_io_FileSeek.SeekBegin = sys_io_FileSeek("SeekBegin", 0, list())
sys_io_FileSeek.SeekCur = sys_io_FileSeek("SeekCur", 1, list())
sys_io_FileSeek.SeekEnd = sys_io_FileSeek("SeekEnd", 2, list())
sys_io_FileSeek._hx_class = sys_io_FileSeek
_hx_classes["sys.io.FileSeek"] = sys_io_FileSeek


class sys_io_Process:
	_hx_class_name = "sys.io.Process"
	_hx_fields = ["stdout", "stderr", "stdin", "p"]
	_hx_methods = ["exitCode", "close", "kill"]

	def __init__(self,cmd,args):
		self.stdout = None
		self.stderr = None
		self.stdin = None
		self.p = None
		args1 = ([cmd] + args)
		o = _hx_AnonObject({'stdin': python_lib_Subprocess.PIPE, 'stdout': python_lib_Subprocess.PIPE, 'stderr': python_lib_Subprocess.PIPE})
		if hasattr(o,(("_hx_" + "bufsize") if ("bufsize" in python_Boot.keywords) else (("_hx_" + "bufsize") if (((((len("bufsize") > 2) and ((ord("bufsize"[0]) == 95))) and ((ord("bufsize"[1]) == 95))) and ((ord("bufsize"[(len("bufsize") - 1)]) != 95)))) else "bufsize"))):
			Reflect.setField(o,"bufsize",Reflect.field(o,"bufsize"))
		else:
			Reflect.setField(o,"bufsize",0)
		if hasattr(o,(("_hx_" + "executable") if ("executable" in python_Boot.keywords) else (("_hx_" + "executable") if (((((len("executable") > 2) and ((ord("executable"[0]) == 95))) and ((ord("executable"[1]) == 95))) and ((ord("executable"[(len("executable") - 1)]) != 95)))) else "executable"))):
			Reflect.setField(o,"executable",Reflect.field(o,"executable"))
		else:
			Reflect.setField(o,"executable",None)
		if hasattr(o,(("_hx_" + "stdin") if ("stdin" in python_Boot.keywords) else (("_hx_" + "stdin") if (((((len("stdin") > 2) and ((ord("stdin"[0]) == 95))) and ((ord("stdin"[1]) == 95))) and ((ord("stdin"[(len("stdin") - 1)]) != 95)))) else "stdin"))):
			Reflect.setField(o,"stdin",Reflect.field(o,"stdin"))
		else:
			Reflect.setField(o,"stdin",None)
		if hasattr(o,(("_hx_" + "stdout") if ("stdout" in python_Boot.keywords) else (("_hx_" + "stdout") if (((((len("stdout") > 2) and ((ord("stdout"[0]) == 95))) and ((ord("stdout"[1]) == 95))) and ((ord("stdout"[(len("stdout") - 1)]) != 95)))) else "stdout"))):
			Reflect.setField(o,"stdout",Reflect.field(o,"stdout"))
		else:
			Reflect.setField(o,"stdout",None)
		if hasattr(o,(("_hx_" + "stderr") if ("stderr" in python_Boot.keywords) else (("_hx_" + "stderr") if (((((len("stderr") > 2) and ((ord("stderr"[0]) == 95))) and ((ord("stderr"[1]) == 95))) and ((ord("stderr"[(len("stderr") - 1)]) != 95)))) else "stderr"))):
			Reflect.setField(o,"stderr",Reflect.field(o,"stderr"))
		else:
			Reflect.setField(o,"stderr",None)
		if hasattr(o,(("_hx_" + "preexec_fn") if ("preexec_fn" in python_Boot.keywords) else (("_hx_" + "preexec_fn") if (((((len("preexec_fn") > 2) and ((ord("preexec_fn"[0]) == 95))) and ((ord("preexec_fn"[1]) == 95))) and ((ord("preexec_fn"[(len("preexec_fn") - 1)]) != 95)))) else "preexec_fn"))):
			Reflect.setField(o,"preexec_fn",Reflect.field(o,"preexec_fn"))
		else:
			Reflect.setField(o,"preexec_fn",None)
		if hasattr(o,(("_hx_" + "close_fds") if ("close_fds" in python_Boot.keywords) else (("_hx_" + "close_fds") if (((((len("close_fds") > 2) and ((ord("close_fds"[0]) == 95))) and ((ord("close_fds"[1]) == 95))) and ((ord("close_fds"[(len("close_fds") - 1)]) != 95)))) else "close_fds"))):
			Reflect.setField(o,"close_fds",Reflect.field(o,"close_fds"))
		else:
			Reflect.setField(o,"close_fds",None)
		if hasattr(o,(("_hx_" + "shell") if ("shell" in python_Boot.keywords) else (("_hx_" + "shell") if (((((len("shell") > 2) and ((ord("shell"[0]) == 95))) and ((ord("shell"[1]) == 95))) and ((ord("shell"[(len("shell") - 1)]) != 95)))) else "shell"))):
			Reflect.setField(o,"shell",Reflect.field(o,"shell"))
		else:
			Reflect.setField(o,"shell",None)
		if hasattr(o,(("_hx_" + "cwd") if ("cwd" in python_Boot.keywords) else (("_hx_" + "cwd") if (((((len("cwd") > 2) and ((ord("cwd"[0]) == 95))) and ((ord("cwd"[1]) == 95))) and ((ord("cwd"[(len("cwd") - 1)]) != 95)))) else "cwd"))):
			Reflect.setField(o,"cwd",Reflect.field(o,"cwd"))
		else:
			Reflect.setField(o,"cwd",None)
		if hasattr(o,(("_hx_" + "env") if ("env" in python_Boot.keywords) else (("_hx_" + "env") if (((((len("env") > 2) and ((ord("env"[0]) == 95))) and ((ord("env"[1]) == 95))) and ((ord("env"[(len("env") - 1)]) != 95)))) else "env"))):
			Reflect.setField(o,"env",Reflect.field(o,"env"))
		else:
			Reflect.setField(o,"env",None)
		if hasattr(o,(("_hx_" + "universal_newlines") if ("universal_newlines" in python_Boot.keywords) else (("_hx_" + "universal_newlines") if (((((len("universal_newlines") > 2) and ((ord("universal_newlines"[0]) == 95))) and ((ord("universal_newlines"[1]) == 95))) and ((ord("universal_newlines"[(len("universal_newlines") - 1)]) != 95)))) else "universal_newlines"))):
			Reflect.setField(o,"universal_newlines",Reflect.field(o,"universal_newlines"))
		else:
			Reflect.setField(o,"universal_newlines",None)
		if hasattr(o,(("_hx_" + "startupinfo") if ("startupinfo" in python_Boot.keywords) else (("_hx_" + "startupinfo") if (((((len("startupinfo") > 2) and ((ord("startupinfo"[0]) == 95))) and ((ord("startupinfo"[1]) == 95))) and ((ord("startupinfo"[(len("startupinfo") - 1)]) != 95)))) else "startupinfo"))):
			Reflect.setField(o,"startupinfo",Reflect.field(o,"startupinfo"))
		else:
			Reflect.setField(o,"startupinfo",None)
		if hasattr(o,(("_hx_" + "creationflags") if ("creationflags" in python_Boot.keywords) else (("_hx_" + "creationflags") if (((((len("creationflags") > 2) and ((ord("creationflags"[0]) == 95))) and ((ord("creationflags"[1]) == 95))) and ((ord("creationflags"[(len("creationflags") - 1)]) != 95)))) else "creationflags"))):
			Reflect.setField(o,"creationflags",Reflect.field(o,"creationflags"))
		else:
			Reflect.setField(o,"creationflags",0)
		if (Sys.systemName() == "Windows"):
			self.p = python_lib_subprocess_Popen(args1, Reflect.field(o,"bufsize"), Reflect.field(o,"executable"), Reflect.field(o,"stdin"), Reflect.field(o,"stdout"), Reflect.field(o,"stderr"), Reflect.field(o,"preexec_fn"), Reflect.field(o,"close_fds"), Reflect.field(o,"shell"), Reflect.field(o,"cwd"), Reflect.field(o,"env"), Reflect.field(o,"universal_newlines"), Reflect.field(o,"startupinfo"), Reflect.field(o,"creationflags"))
		else:
			self.p = python_lib_subprocess_Popen(args1, Reflect.field(o,"bufsize"), Reflect.field(o,"executable"), Reflect.field(o,"stdin"), Reflect.field(o,"stdout"), Reflect.field(o,"stderr"), Reflect.field(o,"preexec_fn"), Reflect.field(o,"close_fds"), Reflect.field(o,"shell"), Reflect.field(o,"cwd"), Reflect.field(o,"env"), Reflect.field(o,"universal_newlines"), Reflect.field(o,"startupinfo"))
		self.stdout = python_io_IoTools.createFileInputFromText(python_lib_io_TextIOWrapper(python_lib_io_BufferedReader(self.p.stdout)))
		self.stderr = python_io_IoTools.createFileInputFromText(python_lib_io_TextIOWrapper(python_lib_io_BufferedReader(self.p.stderr)))
		self.stdin = python_io_IoTools.createFileOutputFromText(python_lib_io_TextIOWrapper(python_lib_io_BufferedWriter(self.p.stdin)))

	def exitCode(self):
		return self.p.wait()

	def close(self):
		self.p.terminate()

	def kill(self):
		self.p.kill()

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.stdout = None
		_hx_o.stderr = None
		_hx_o.stdin = None
		_hx_o.p = None
sys_io_Process._hx_class = sys_io_Process
_hx_classes["sys.io.Process"] = sys_io_Process


class sys_net_Host:
	_hx_class_name = "sys.net.Host"
	_hx_fields = ["name"]
	_hx_methods = ["toString"]

	def toString(self):
		return self.name

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o.name = None
sys_net_Host._hx_class = sys_net_Host
_hx_classes["sys.net.Host"] = sys_net_Host


class sys_net__Socket_SocketInput(haxe_io_Input):
	_hx_class_name = "sys.net._Socket.SocketInput"
	_hx_fields = ["__s"]
	_hx_methods = ["readByte", "readBytes"]
	_hx_statics = []
	_hx_interfaces = []
	_hx_super = haxe_io_Input


	def __init__(self,s):
		self._hx___s = None
		self._hx___s = s

	def readByte(self):
		r = None
		try:
			r = self._hx___s.recv(1,0)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			if isinstance(_hx_e1, BlockingIOError):
				e = _hx_e1
				raise _HxException(haxe_io_Error.Blocked)
			else:
				raise _hx_e
		if (len(r) == 0):
			raise _HxException(haxe_io_Eof())
		return r[0]

	def readBytes(self,buf,pos,_hx_len):
		r = None
		data = buf.b
		try:
			r = self._hx___s.recv(_hx_len,0)
			_g1 = pos
			_g = (pos + len(r))
			while (_g1 < _g):
				i = _g1
				_g1 = (_g1 + 1)
				data.__setitem__(i,r[(i - pos)])
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			if isinstance(_hx_e1, BlockingIOError):
				e = _hx_e1
				raise _HxException(haxe_io_Error.Blocked)
			else:
				raise _hx_e
		if (len(r) == 0):
			raise _HxException(haxe_io_Eof())
		return len(r)

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o._hx___s = None
sys_net__Socket_SocketInput._hx_class = sys_net__Socket_SocketInput
_hx_classes["sys.net._Socket.SocketInput"] = sys_net__Socket_SocketInput


class sys_net__Socket_SocketOutput(haxe_io_Output):
	_hx_class_name = "sys.net._Socket.SocketOutput"
	_hx_fields = ["__s"]
	_hx_methods = ["writeByte", "writeBytes"]
	_hx_statics = []
	_hx_interfaces = []
	_hx_super = haxe_io_Output


	def __init__(self,s):
		self._hx___s = None
		self._hx___s = s

	def writeByte(self,c):
		try:
			self._hx___s.send(bytes([c]),0)
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			if isinstance(_hx_e1, BlockingIOError):
				e = _hx_e1
				raise _HxException(haxe_io_Error.Blocked)
			else:
				raise _hx_e

	def writeBytes(self,buf,pos,_hx_len):
		try:
			data = buf.b
			payload = data[pos:pos+len]
			r = self._hx___s.send(payload,0)
			return r
		except Exception as _hx_e:
			_hx_e1 = _hx_e.val if isinstance(_hx_e, _HxException) else _hx_e
			if isinstance(_hx_e1, BlockingIOError):
				e = _hx_e1
				raise _HxException(haxe_io_Error.Blocked)
			else:
				raise _hx_e

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o._hx___s = None
sys_net__Socket_SocketOutput._hx_class = sys_net__Socket_SocketOutput
_hx_classes["sys.net._Socket.SocketOutput"] = sys_net__Socket_SocketOutput


class sys_net_Socket:
	_hx_class_name = "sys.net.Socket"
	_hx_fields = ["__s", "input", "output"]
	_hx_methods = ["__init", "close", "write", "connect", "shutdown", "setTimeout", "fileno"]

	def _hx___init(self):
		self._hx___s = python_lib_net_Socket()
		self.input = sys_net__Socket_SocketInput(self._hx___s)
		self.output = sys_net__Socket_SocketOutput(self._hx___s)

	def close(self):
		self._hx___s.close()

	def write(self,content):
		self.output.writeString(content)

	def connect(self,host,port):
		self._hx___init()
		host_str = host.toString()
		self._hx___s.connect((host_str,port))

	def shutdown(self,read,write):
		self._hx___s.shutdown((python_lib_net_Socket.SHUT_RDWR if ((read and write)) else (python_lib_net_Socket.SHUT_RD if read else python_lib_net_Socket.SHUT_WR)))

	def setTimeout(self,timeout):
		self._hx___s.settimeout(timeout)

	def fileno(self):
		return self._hx___s.fileno()

	@staticmethod
	def _hx_empty_init(_hx_o):
		_hx_o._hx___s = None
		_hx_o.input = None
		_hx_o.output = None
sys_net_Socket._hx_class = sys_net_Socket
_hx_classes["sys.net.Socket"] = sys_net_Socket

Math.NEGATIVE_INFINITY = float("-inf")
Math.POSITIVE_INFINITY = float("inf")
Math.NaN = float("nan")
Math.PI = python_lib_Math.pi

Date.EPOCH_LOCAL = python_lib_datetime_Datetime.fromtimestamp(0)
def _hx_init_Sys_environ():
	def _hx_local_0():
		Sys.environ = haxe_ds_StringMap()
		env = python_lib_Os.environ
		def _hx_local_1():
			_this = env.keys()
			def _hx_local_3():
				def _hx_local_2():
					this1 = iter(_this)
					return python_HaxeIterator(this1)
				return _hx_local_2()
			return _hx_local_3()
		_hx_local_4 = _hx_local_1()
		while _hx_local_4.hasNext():
			key = _hx_local_4.next()
			value = env.get(key,None)
			Sys.environ.h[key] = value
		return Sys.environ
	return _hx_local_0()
Sys.environ = _hx_init_Sys_environ()
Xml.Element = 0
Xml.PCData = 1
Xml.CData = 2
Xml.Comment = 3
Xml.DocType = 4
Xml.ProcessingInstruction = 5
Xml.Document = 6
duell_Duell.VERSION = "1.0.1"
duell_commands_BuildCommand.HOURS_TO_REQUEST_UPDATE = 8
duell_commands_RepoConfigCommand.defaultRepoListURL = "git@github.com:gameduell/duell-repository-list.git"
duell_commands_ToolSetupCommand.haxeURL = "http://haxe.org/"
duell_commands_ToolSetupCommand.defaultRepoListURL = "git@github.com:gameduell/duell-repository-list.git"
duell_defines_DuellDefines.USER_CONFIG_FILENAME = "duell_user.xml"
duell_defines_DuellDefines.PROJECT_CONFIG_FILENAME = "duell_project.xml"
duell_defines_DuellDefines.LIB_CONFIG_FILENAME = "duell_library.xml"
duell_defines_DuellDefines.PLATFORM_CONFIG_FILENAME = "duell_platform.xml"
duell_defines_DuellDefines.DEFAULT_HXCPP_VERSION = "3.2.193"
duell_defines_DuellDefines.HAXE_VERSION = "3.2.0"
duell_defines_DuellDefines.ALLOWED_HAXE_VERSIONS = "3.2.0,3.2.1"
duell_defines_DuellDefines.DUELL_API_LEVEL = 413
duell_helpers_ConnectionHelper.TIMEOUT = 3
duell_helpers_ConnectionHelper.online = True
duell_helpers_ConnectionHelper.initialized = False
duell_helpers_DuellLibHelper.caches = _hx_AnonObject({'existsCache': [], 'haxelibPathOutputCache': haxe_ds_StringMap(), 'pathCache': haxe_ds_StringMap()})
duell_helpers_DuellLibListHelper.DEPENDENCY_LIST_FILENAME = "duell_dependencies.json"
duell_helpers_DuellLibListHelper.repoListCache = None
duell_helpers_FileHelper.binaryExtensions = ["jpg", "jpeg", "png", "exe", "gif", "ini", "zip", "tar", "gz", "fla", "swf"]
duell_helpers_FileHelper.textExtensions = ["xml", "java", "hx", "hxml", "html", "ini", "gpe", "pch", "pbxproj", "plist", "json", "cpp", "mm", "properties", "hxproj", "nmml", "lime"]
duell_helpers_LogHelper.colorCodes = EReg("\\x1b\\[[^m]+m", "g")
duell_helpers_LogHelper.colorSupported = None
duell_helpers_LogHelper.sentWarnings = haxe_ds_StringMap()
duell_helpers_LogHelper.RED = "\x1B[31;1m"
duell_helpers_LogHelper.YELLOW = "\x1B[33;1m"
duell_helpers_LogHelper.DARK_GREEN = "\x1B[2m"
duell_helpers_LogHelper.NORMAL = "\x1B[0m"
duell_helpers_LogHelper.BOLD = "\x1B[1m"
duell_helpers_LogHelper.UNDERLINE = "\x1B[4m"
duell_helpers_SchemaHelper.DUELL_NS = "duell"
duell_helpers_SchemaHelper.SCHEMA_FILE = "schema.xsd"
duell_helpers_SchemaHelper.SCHEMA_FOLDER = "schema"
duell_helpers_SchemaHelper.TEMPLATED_SCHEMA_FILE = "duell_schema.xsd"
duell_helpers_SchemaHelper.COMMON_SCHEMA_FILE = "https://raw.githubusercontent.com/gameduell/duell/master/schema/common_schema.xsd"
duell_helpers_StringHelper.seedNumber = 0
duell_helpers_StringHelper.usedFlatNames = haxe_ds_StringMap()
duell_helpers_StringHelper.uuidChars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
duell_helpers_Template.splitter = EReg("(::[A-Za-z0-9_ ()&|!+=/><*.\"-]+::|\\$\\$([A-Za-z0-9_-]+)\\()", "")
duell_helpers_Template.expr_splitter = EReg("(\\(|\\)|[ \r\n\t]*\"[^\"]*\"[ \r\n\t]*|[!+=/><*.&|-]+)", "")
duell_helpers_Template.expr_trim = EReg("^[ ]*([^ ]+)[ ]*$", "")
duell_helpers_Template.expr_int = EReg("^[0-9]+$", "")
duell_helpers_Template.expr_float = EReg("^([+-]?)(?=\\d|,\\d)\\d*(,\\d*)?([Ee]([+-]?\\d+))?$", "")
duell_helpers_Template.globals = _hx_AnonObject({})
duell_objects_Arguments.PLUGIN_XML_FILE = "plugin.xml"
duell_objects_Arguments.CONFIG_XML_FILE = "config.xml"
duell_objects_Arguments.generalArgumentSpecs = haxe_ds_StringMap()
duell_objects_Arguments.commandSpecs = haxe_ds_StringMap()
duell_objects_Arguments.selectedCommand = None
duell_objects_Arguments.plugin = None
duell_objects_Arguments.pluginDocumentation = None
duell_objects_Arguments.pluginArgumentSpecs = None
duell_objects_Arguments.pluginConfigurationDocumentation = None
duell_objects_Arguments.generalDocumentation = None
duell_objects_Arguments.pluginAcceptsAnyArgument = False
duell_objects_Arguments.defines = haxe_ds_StringMap()
duell_objects_DuellLib.duellLibCache = haxe_ds_StringMap()
duell_objects_Haxelib.haxelibCache = haxe_ds_StringMap()
duell_objects_SemVer.parse = EReg("^([0-9|\\*]+)\\.([0-9|\\*]+)\\.([0-9|\\*]+)(\\-rc)?(\\+)?$", "")
duell_objects_SemVer.START_OFFSET = 10000000
duell_objects_SemVer.OFFSET_REDUCTION = 100
duell_versioning_locking_LockedVersionsHelper.DEFAULT_FOLDER = "versions"
duell_versioning_locking_LockedVersionsHelper.DEFAULT_FILE = "log.xml"
duell_versioning_locking_LockedVersionsHelper.versionMap = haxe_ds_StringMap()
duell_versioning_locking_LockedVersions.NUMBER_MAX_TRACKED_VERSIONS = 5
haxe_Serializer.USE_CACHE = False
haxe_Serializer.USE_ENUM_INDEX = False
haxe_Serializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:"
haxe_Unserializer.DEFAULT_RESOLVER = Type
haxe_Unserializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:"
haxe_Unserializer.CODES = None
def _hx_init_haxe_xml_Parser_escapes():
	def _hx_local_0():
		h = haxe_ds_StringMap()
		h.h["lt"] = "<"
		h.h["gt"] = ">"
		h.h["amp"] = "&"
		h.h["quot"] = "\""
		h.h["apos"] = "'"
		return h
	return _hx_local_0()
haxe_xml_Parser.escapes = _hx_init_haxe_xml_Parser_escapes()
python_Boot.keywords = set(["and", "del", "from", "not", "with", "as", "elif", "global", "or", "yield", "assert", "else", "if", "pass", "None", "break", "except", "import", "raise", "True", "class", "exec", "in", "return", "False", "continue", "finally", "is", "try", "def", "for", "lambda", "while"])
python_Boot.prefixLength = len("_hx_")

duell_Duell.main()