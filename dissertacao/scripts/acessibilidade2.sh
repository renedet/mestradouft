#!/bin/bash

# Script para gerar relatórios de acessibilidade WCAG
# com o software pa11y https://github.com/pa11y/pa11y

# cd /d E:\

#set site=%1
#set tempo=60000

#echo Iniciando o teste $site

#set texto=%site:~11,4%

#echo $texto

site=$1
tempo=120000

#echo "Iniciando o teste $site"

#texto=${site:11:4}

#echo $site
url=${site% *}
tipo=${site##* }
texto=${url##* }
url=${url% *}

#ignore=' -i warning;notice'
ignore=''

#echo $url
#echo $texto
#echo $tipo

#pwd
#echo "pa11y -s WCAG2A -r csv -i warning;notice -t $tempo -d $site > $texto_WCAG2A.csv | pa11y -s WCAG2AA -r csv -i warning;notice -t $tempo -d $site > $texto_WCAG2AA.csv | pa11y -s WCAG2AAA -r csv -i warning;notice -t $tempo $site > $texto_WCAG2AAA.csv"
#pa11y -s WCAG2A -r csv -i 'warning;notice' -t $tempo -d $site > $texto_WCAG2A.csv | pa11y -s WCAG2AA -r csv -i 'warning;notice' -t $tempo -d $site > $texto_WCAG2AA.csv | pa11y -s WCAG2AAA -r csv -i 'warning;notice' -t $tempo $site > $texto_WCAG2AAA.csv
#pa11y -s WCAG2A -r csv -i 'warning;notice' -t $tempo -d $site > ${texto}_WCAG2A.csv

# ok
echo $texto
#pa11y -s WCAG2A -r csv -i 'warning;notice' -t $tempo -w 2000 -d $url > ${texto}_WCAG2A.csv | pa11y -s WCAG2AA -r csv -i 'warning;notice' -t $tempo -w 3000 -d $url > ${texto}_WCAG2AA.csv | pa11y -s WCAG2AAA -r csv -i 'warning;notice' -t $tempo -w 4000 $url > ${texto}_WCAG2AAA.csv
pa11y -s WCAG2A -r csv${ignore} -t $tempo -d ./sites/${texto}.html > ./wcag/${texto}_WCAG2A.csv | pa11y -s WCAG2AA -r csv${ignore} -t $tempo -d ./sites/${texto}.html > ./wcag/${texto}_WCAG2AA.csv | pa11y -s WCAG2AAA -r csv${ignore} -t $tempo -d ./sites/${texto}.html > ./wcag/${texto}_WCAG2AAA.csv

#echo $?
./limpar2.py $url $tipo

