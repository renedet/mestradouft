#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
 Desenvolvido por Renê Dettenborn
 Data 01/06/2018
 Conversao de dados wcag2_erros.csv
 frequecia dos erros
"""

import csv

erros = ['1.1.1','1.3.1','1.4.3','1.4.6','2.2.1','2.2.2','2.4.1','2.4.2','2.4.8','3.1.1','3.1.2','3.1.6','3.2.2','4.1.1','4.1.2']

result = 'nome_site,rank,erro,total\n'

pontaux = open('wcag2_freq.csv', 'a+')
pontaux.write(result)

with open('wcag2_erros.csv', 'r') as csvfile2:
	dados = csv.DictReader(csvfile2)
	dados = list(dados)
	#print dados
	for dado in dados:
		aux=''
		for erro in erros:
			#print dado['nome_site'],dado[erro],dado[erro]
			#print type(dado[erro])
			if int(dado[erro])>0:
				#aux.append(dado['nome_site'],erro,dado[erro])
				aux=dado['nome_site']+','+dado['rank']+',"'+erro+'",'+dado[erro]
				pontaux.write(aux+'\n')

pontaux.close()

