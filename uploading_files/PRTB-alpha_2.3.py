#!/bin/python3.8
# -*- coding: utf-8 -*-
import shutil, glob, zipfile
# pip install hazm  --  zipfile
# apt install liblzma-dev -- for compression
from datetime import datetime
from pathlib import Path
from subprocess import call

cur_date = datetime.now().date()

d = dict(   Ираэросервис_ООО="ftp://specit:13508@192.168.0.54:21/test2/", 
            Региональный_центр_бронирования='ftp://specit:13508@192.168.0.54:21',
            Регион24="ftp://specit:13508@192.168.0.54:21")
			
for i in glob.glob("/mnt/c/Users/seligenenko/port/*.xml"):
    for q in d:
        with open(i, 'r', encoding='utf-8') as f:
            if q.replace('_',' ') in f.read():
                print(i + ' ' + q.replace("_", " ") + ' -- ' + d[q])
                call("echo put %s | lftp %s" % (i,d[q]), shell=True)
                if not Path('/mnt/c/Users/seligenenko/port/%s' % q).is_dir():
                    Path("/mnt/c/Users/seligenenko/port/%s" % q).mkdir()
                if not Path('/mnt/c/Users/seligenenko/port/%s/%s.zip' % (q, cur_date)).is_file():
                    with zipfile.ZipFile('/mnt/c/Users/seligenenko/port/%s/%s.zip' % (q,cur_date), 'w', compression=zipfile.ZIP_LZMA) as myzip:
                        myzip.write(i, Path(i).name)
                    break
                with zipfile.ZipFile('/mnt/c/Users/seligenenko/port/%s/%s.zip' % (q,cur_date), 'a', compression=zipfile.ZIP_LZMA) as myzip:
                    myzip.write(i, Path(i).name)
                break
    with zipfile.ZipFile('/mnt/c/Users/seligenenko/port/%s.zip' % cur_date, 'a', compression=zipfile.ZIP_LZMA) as myzip:
        myzip.write(i, Path(i).name)
    shutil.move(i, '/mnt/c/Users/seligenenko/port/eee/')
