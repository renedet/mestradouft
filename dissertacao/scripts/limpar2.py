#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
 Desenvolvido por Renê Dettenborn
 Data 31/05/2017
 Analise dos dados output.csv
 Níveis WCAG2A, WCAG2AA, WCAG2AAA
"""

import csv
import sys
import datetime

site = sys.argv[1]
tipo = sys.argv[2]

regras = ['1_1_1','1_2_1','1_2_2','1_2_3','1_2_4','1_2_5','1_2_6','1_2_7','1_2_8','1_2_9','1_3_1','1_3_2','1_3_3','1_4_1','1_4_2','1_4_3','1_4_4','1_4_5','1_4_6','1_4_7','1_4_8','1_4_9','2_1_1','2_1_2','2_1_3','2_2_1','2_2_2','2_2_3','2_2_4','2_2_5','2_3_1','2_3_2','2_4_1','2_4_2','2_4_3','2_4_4','2_4_5','2_4_6','2_4_7','2_4_8','2_4_9','2_4_10','3_1_1','3_1_2','3_1_3','3_1_4','3_1_5','3_1_6','3_2_1','3_2_2','3_2_3','3_2_4','3_2_5','3_3_1','3_3_2','3_3_3','3_3_4','3_3_5','3_3_6','4_1_1','4_1_2']

# todos os erros
#regras_erros = ['1_1_1','1_3_1','1_3_2','1_4_3','1_4_6','2_2_1','2_2_2','2_4_1','2_4_2','2_4_8','3_1_1','3_1_2','3_1_6','3_2_2','4_1_1','4_1_2']

# regras do 1A
regras_comuns = ['1_1_1','1_3_1','2_2_1','2_2_2','2_4_1','2_4_2','3_1_1','3_2_2','4_1_1','4_1_2']

regras_3A = ['1_3_1','1_4_6','2_4_8','3_1_2','3_1_6']
regras_2A = ['1_4_3','3_1_2']

#regras_1A = [] # 1A não tem regras exclusivas

contador = []

erros = []

arquivos = ['_WCAG2A.csv','_WCAG2AA.csv','_WCAG2AAA.csv']

# contar no *_WCAG2A.csv o total de regras_comuns
# contar no *_WCAG2AA.csv o total de regras_2A
# contar no *_WCAG2AAA.csv o total de regras_3A

nomesite = site[site.index('.')+1:site.index('.')+1+site[site.index('.')+1:].index('.')]

aux = []

count_file = 0

count_rc = 0
count_2A = 0
count_3A = 0

for arquivo in arquivos:
    with open('./wcag/'+nomesite+arquivo, 'r') as csvfile2:
        dados = csv.DictReader(csvfile2)
        dados = list(dados)
        #print len(dados)
        #erros = erros + dados
        
        print '- - - - - - - - - - - - - - - - - - - - - - - - - - - - '
        print nomesite+arquivo
        
        if count_file == 0:
            for dado in dados:
                for rc in regras_comuns:
                    if dado['code'].find(rc)>=0:
                        count_rc+=1
                        aux.append(dado['code'][31:36])
                        #print rc, dado['code']
                        
            print 'regras comuns:', count_rc
        
        if count_file == 1:
            for dado in dados:
                for rc in regras_2A:
                    if dado['code'].find(rc)>=0:
                        count_2A+=1
                        aux.append(dado['code'][32:37])
                        #print rc, dado['code']
                    
            print 'regras 2A:', count_2A
        
        if count_file == 2:
            for dado in dados:
                for rc in regras_3A:
                    if dado['code'].find(rc)>=0:
                        count_3A+=1
                        aux.append(dado['code'][33:38])
                        #print rc, dado['code']
                        
            print 'regras 3A:', count_3A
        count_file+=1

print aux

#quit()


#for erro in erros:
    #if erro['code'].find('WCAG2A.')==0:
        #aux.append(erro['code'][31:36])
    #if erro['code'].find('WCAG2AA.')==0:
        #aux.append(erro['code'][32:37])
    #if erro['code'].find('WCAG2AAA.')==0:
        #aux.append(erro['code'][33:38])

contador.append("'"+tipo+"'")
contador.append("'"+site+"'")
#'2018-03-12 00:00:00'
data = datetime.datetime.now()
contador.append("'"+data.strftime('%Y-%m-%d %H:%M:%S')+"'")
for regra in regras:
    contador.append(aux.count(regra))

# total de erros A, AA e AAA
print count_rc,count_2A,count_3A
contador.append(count_rc)
contador.append(count_rc+count_2A)
contador.append(count_rc+count_3A)

print contador

with open('wcag2_limpar2.csv', 'a+') as f:
    writer = csv.writer(f)
    writer.writerows([contador])

