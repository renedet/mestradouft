#library(multilevel)
library(ggplot2)
library(plyr)
library(colorspace)
library(wesanderson)
library(qcc)

infosites = read.csv('/home/renedet/Documentos/2018/a11y/infosites.csv')

#summary(dados)

plotgraf = function(perg,col1,col2,titulo){
  
  perg = data.frame(count(perg, c(col1,col2)))
  
  ggplot(perg,
         aes(perg[1],perg[2],size = freq,label = ''))+
    #geom_point(size=blogs$pageview/1000,colour = alpha('blue',0.2))+
    geom_point(colour = alpha('red',0.2))+
    #geom_smooth(method = "lm")+
    #geom_quantile()+
    #scale_size('Visualiza??o \nde p?ginas',range = c(5,25))+
    scale_size('Legenda',range = c(5,15))+
    geom_text(size=3)+
    #labs(title = 'Rede Colaborativa de Aprendizado', y='Publica??es',x='Tempo em atividade (Anos)')+
    labs(title = titulo, x=col1, y=col2)+
    coord_cartesian(xlim=c(0,6),ylim=c(0,6))+
    scale_x_discrete(limit = c(0,1,2,3,4,5,6))+
    scale_y_discrete(limit = c(0,1,2,3,4,5,6))
}

#teste = rwg(dados$entendimento_conteudo,dados$necessidade_aprendizagem)
#teste
#summary(teste)

#plotgraf(infosites,'rea_contribuiu','entendimento_conteudo','Contribui??o e entendimento - REA')

## grafico de barras freq servidor/tecnologia
#ggplot(infosites,aes(server))+geom_bar()


####################################################################################
## grafico de pizza freq servidor/tecnologia
####################################################################################
is = data.frame(count(infosites, c('server')))
slices = is$freq
pct = round(slices/sum(slices)*100,digits=2)

lbls = is$server

lbls = paste(lbls, '-')
lbls = paste(lbls, pct)
lbls = paste(lbls, "%")

#pie(pct, labels = lbls, main="Abordagem 1",init.angle = 220, radius = 1)
#pie(pct, labels = lbls, col = wes.palette(n=3, name="GrandBudapest"))rainbow_hcl(4), main="Tecnologia utilizada pelos sites", init.angle = 0, radius = 0.8)
#pie(pct, labels = lbls, col = wes_palette(n=4, name="GrandBudapest2"), main="Tecnologia utilizada pelos sites", init.angle = 0, radius = 0.8)
pie(pct, labels = lbls, col = wes_palette(n=4, name="Royal1"), main="Servidor Web utilizado pelos sites", init.angle = 0, radius = 0.8)


####################################################################################
## grafico de pizza freq tipo site
####################################################################################
sites = read.csv('/home/renedet/Documentos/2018/a11y/sites.csv')

is = data.frame(count(sites, c('tipo')))
slices = is$freq
pct = round(slices/sum(slices)*100,digits=2)

lbls = is$tipo

lbls = paste(lbls, '-')
lbls = paste(lbls, slices)
#lbls = paste(lbls, pct)
#lbls = paste(lbls, "%")

#pie(pct, labels = lbls, main="Abordagem 1",init.angle = 220, radius = 1)
# http://www.sthda.com/english/wiki/colors-in-r
pie(pct, labels = lbls, col = c(wes_palette(n=4, name="GrandBudapest2"),wes_palette(n=4, name="GrandBudapest1")), main="Sites do Judiciário por Classificação", init.angle = -80, radius = 0.8)


####################################################################################
## ranking sites X erros (total)
####################################################################################
#plotgraf(wcag,'erro','nome_site','')

#wcag = data.frame(x=wcag$nome_site, y=wcag$erro, freq=wcag$total, group=wcag$rank)

wcag = read.csv('/home/renedet/Documentos/2018/a11y/wcag2_freq.csv')

ggplot(wcag,
       aes(erro,ordem,size = total,label = ''))+
  #geom_point(size=blogs$pageview/1000,colour = alpha('blue',0.2))+
  geom_point(colour = alpha('red',0.2))+
  #geom_smooth(method = "lm")+
  #geom_quantile()+
  #scale_size('Visualiza??o \nde p?ginas',range = c(5,25))+
  #scale_size('Legenda',range = c(5,15))+
  geom_text(size=3)+
  labs(title = 'titulo', x='col1', y='col2')
  #coord_cartesian(xlim=c(0,6),ylim=c(0,6))+
  #scale_x_discrete(limit = c(0,1,2,3,4,5,6))+
  #scale_y_discrete(limit = c(0,1,2,3,4,5,6))


####################################################################################
# Soma dos erros Wcag2 cometidos pelos sites
####################################################################################
freqerro1 = aggregate(total ~ erro, data=wcag,sum)

ggplot(freqerro1,
       aes(erro,total,size = total,label = ''))+
  #geom_point(size=blogs$pageview/1000,colour = alpha('blue',0.2))+
  #geom_point(colour = alpha('red',0.2))+
  geom_bar(stat="identity", width=0.5)+
  #geom_smooth(method = "lm")+
  #geom_quantile()+
  #scale_size('Visualiza??o \nde p?ginas',range = c(5,25))+
  #scale_size('Legenda',range = c(5,15))+
  geom_text(size=3)+
  labs(title = 'Soma dos erros comentidos pelos sites analisados', x='Erros WCAG2.0', y='Total')
#coord_cartesian(xlim=c(0,6),ylim=c(0,6))+
#scale_x_discrete(limit = c(0,1,2,3,4,5,6))+
#scale_y_discrete(limit = c(0,1,2,3,4,5,6))

####################################################################################
# Pareto: Soma dos erros Wcag2 cometidos pelos sites
####################################################################################

pfreqerro1 = freqerro1$total
names(pfreqerro1) = freqerro1$erro

pareto.chart(pfreqerro1, xlab = "Critéios de Sucesso", ylab = "Erros (Total)", ylab2 = "Porcentagem Acumulativa", main="Critérios de Sucesso WCAG 2.0 violados pelos sites")

####################################################################################
# Ocorr?ncias
####################################################################################
freqerro2 = count(wcag$erro)

ggplot(freqerro2,
       aes(x,freq,size = freq,label = ''))+
  #geom_point(size=blogs$pageview/1000,colour = alpha('blue',0.2))+
  #geom_point(colour = alpha('red',0.2))+
  geom_bar(stat="identity", width=0.5)+
  #geom_smooth(method = "lm")+
  #geom_quantile()+
  #scale_size('Visualiza??o \nde p?ginas',range = c(5,25))+
  #scale_size('Legenda',range = c(5,15))+
  geom_text(size=3)+
  labs(title = 'Erros frequente nos sites analisados', x='Erro WCAG2.0', y='Total')


####################################################################################
# Pareto: Ocorrencias
####################################################################################

pfreqerro2 = freqerro2$freq
names(pfreqerro2) = freqerro2$x

pareto.chart(pfreqerro2, xlab = "Critéios de Sucesso", ylab = "Erros (Total)", ylab2 = "Porcentagem Acumulativa", main="Ocorrências dos Critérios de Sucesso WCAG 2.0 violados pelos sites")

####################################################################################
# Quantidade de sites que cometeram erros X Erros cometidos + (Total erros: tamanho da bola)
####################################################################################

# total erros
freqerro1

# total sites cometeram erros
freqerro2

aux = cbind(freqerro1,freqerro2[2])

ggplot(aux,
       aes(erro,freq,size = total,label = ''))+
  geom_point(colour = alpha('red',0.2))+
  # https://ggplot2.tidyverse.org/reference/scale_size.html
  scale_size('Total de erros', range = c(3, 15))+
  geom_text(size=3)+
  labs(title = 'Sites e Erros cometidos', x='Erros WCAG', y='Total sites')


####################################################################################
# infosites (tamanho_Kbites) X wcag2_erros (total_erros)
####################################################################################
infosites = read.csv('/home/renedet/Documentos/2018/a11y/infosites.csv')
wcag2_erros = read.csv('/home/renedet/Documentos/2018/a11y/wcag2_erros.csv')

library(sqldf)

aux = sqldf('SELECT wcag2_erros.nome_site,tamanho_Kbytes, total_erros
      FROM infosites, wcag2_erros
      WHERE wcag2_erros.nome_site = infosites.nome_site')

ggplot(aux,
       aes(tamanho_Kbytes,total_erros,label = nome_site))+
  #geom_point(size=blogs$pageview/1000,colour = alpha('blue',0.2))+
  geom_point(colour = alpha('red',0.2))+
  
  geom_density2d()+
  #geom_smooth(method = "lm")+
  #geom_quantile()+
  #scale_size('Visualiza??o \nde p?ginas',range = c(5,25))+
  #scale_size('Legenda',range = c(5,15))+
  geom_text(size=5)+
  labs(title = 'Erros X Tamanho do HTML (Kbytes)', x='Tamanho do HTML (Kbytes)', y='Erros')
