#!/usr/bin/env python
# -*- coding: utf-8 -*-
PYTHONHTTPSVERIFY=0 

from subprocess import call
import urllib2
import ssl

import csv
import sys
import datetime

from StringIO import StringIO
import gzip

import socket

#socket.setdefaulttimeout(60000)

def baixarhtml(site):
    hdr = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
       'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
       'Accept-Encoding': 'gzip, deflate, br',
       'Pragma': 'no-cache',
       'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
       'Accept-Encoding': 'none',
       'Cache-Control':'no-cache',
       'Accept-Language': 'en-US,en;q=0.8',
       'Upgrade-Insecure-Requests':'1',
       'Cookie':'has_js=1; _ga=GA1.3.871941444.1524768063; _gid=GA1.3.1313631930.1524768063',
       'Connection': 'keep-alive'}
    #hdr = {'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'}
    context = ssl._create_unverified_context()
    req = urllib2.Request(site, headers=hdr)
    try:
        response = urllib2.urlopen(req, context=context)
        #response = urllib2.urlopen(site,context=context)
        
        if response.code == 200:
            #print response.info()
            if response.info().get('Content-Encoding') == 'gzip':
                buf = StringIO(response.read())
                f = gzip.GzipFile(fileobj=buf)
                html = f.read()
            else:
                html = response.read()
            #Server
            #print 'Servidor:',response.info().get('Server')
            #print 'Tamanho:',response.info().get('Content-Length'),len(html)
            nome=site[site.index('.')+1:site.index('.')+1+site[site.index('.')+1:].index('.')]
            with open('sites/'+nome+'.html','w') as f:
                f.write(html)
            
            infosite = []
            infosite.append(nome)
            infosite.append(response.info().get('Server'))
            infosite.append(len(html))
            data = datetime.datetime.now()
            infosite.append("'"+data.strftime('%Y-%m-%d %H:%M:%S')+"'")
            infosite.append(response.info().get('Date'))
            with open('infosites.csv', 'a+') as f:
                writer = csv.writer(f)
                writer.writerows([infosite])
            
            return 1
        print 'ERRO',response.code
        return 0
    except urllib2.HTTPError, e:
        print 'ERRO'
        print e.fp.read()
    except urllib2.URLError, e:
        print 'ERRO'
        print e.reason
    return 0


def processar(tipo,site):
	#print site+' '+site[site.index('.')+1:site.index('.')+1+site[site.index('.')+1:].index('.')]+' '+tipo
	call(['./acessibilidade2.sh', site+' '+site[site.index('.')+1:site.index('.')+1+site[site.index('.')+1:].index('.')]+' '+tipo])

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

with open('./sites.csv', 'r') as csvfile2:
	dados = csv.DictReader(csvfile2)
	sites = list(dados)

for site in sites:
    print '- - - - - - - - - - - - - - - - - - - - - - - - - - - - '
    print 'BAIXANDO', site['url']
    print '- - - - - - - - - - - - - - - - - - - - - - - - - - - - '
    baixarhtml(site['url'])
    print

for site in sites:
    print '- - - - - - - - - - - - - - - - - - - - - - - - - - - - '
    print 'VERIFICANDO ACESSIBILIDADE', site['url']
    print '- - - - - - - - - - - - - - - - - - - - - - - - - - - - '
    processar(site['tipo'],site['url'])
    print
