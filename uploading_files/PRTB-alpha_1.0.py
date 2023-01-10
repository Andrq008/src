#!/bin/python3.8
# -*- coding: utf-8 -*-
import shutil
import os
import glob
# pip install hazm  --  zipfile
# apt install liblzma-dev -- for compression
import zipfile
from datetime import datetime
from os.path import basename
cur_date = datetime.now().date()
d = dict(	Ираэросервис_ООО="ftp://specit:13508@192.168.0.54:2100/test2/", 
			Региональный_центр_бронирования='ftp://specit:13508@192.168.0.54:2100',
			Регион24="ftp://specit:13508@192.168.0.54:2100")
for i in glob.glob("/mnt/c/Users/seligenenko/port/*.xml"):
	print(i)
	for q in d:
		with open(i) as f:
			if q.replace("_", " ") in f.read():
				print(i + ' ' + q.replace("_", " ") + ' -- ' + d[q])
				os.system("echo put %s | lftp %s" % (i,d[q]))
				if q in os.listdir('/mnt/c/Users/seligenenko/port/'):
					if "%s.zip" % cur_date in os.listdir('/mnt/c/Users/seligenenko/port/%s/' % q):
						with zipfile.ZipFile('/mnt/c/Users/seligenenko/port/%s/%s.zip' % (q,cur_date), 'a', compression=zipfile.ZIP_LZMA) as myzip:
							myzip.write(i, basename(i))
					else:
						with zipfile.ZipFile('/mnt/c/Users/seligenenko/port/%s/%s.zip' % (q,cur_date), 'w', compression=zipfile.ZIP_LZMA) as myzip:
							myzip.write(i, basename(i))
					break
				else:
					os.makedirs("/mnt/c/Users/seligenenko/port/%s" % q)
					if "%s.zip" % cur_date in os.listdir('/mnt/c/Users/seligenenko/port/%s/' % q):
						with zipfile.ZipFile('/mnt/c/Users/seligenenko/port/%s/%s.zip' % (q,cur_date), 'a', compression=zipfile.ZIP_LZMA) as myzip:
							myzip.write(i, basename(i))
					else:
						with zipfile.ZipFile('/mnt/c/Users/seligenenko/port/%s/%s.zip' % (q,cur_date), 'w', compression=zipfile.ZIP_LZMA) as myzip:
							myzip.write(i, basename(i))
					break	
	shutil.move(i, '/mnt/c/Users/seligenenko/port/eee/')
