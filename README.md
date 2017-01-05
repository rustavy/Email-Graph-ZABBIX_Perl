# Email-Graph-ZABBIX
Em caso de dúvida, sugestão ou dificuldade junte-se a nós no <b>Grupo do Telegram</b> <class="noteimportant"><a href="https://telegram.me/email_telegram" class="wikilink2" title="Ingressar no Grupo" rel="nofollow">Gráfico no Email e Telegram</a>.

Envio de alarmes no ZABBIX por Email com gráficos.<br>

O "How to" foi testado no ZABBIX 2.4, 3.0 e no 3.2 no Debian/Ubuntu e CentOS 6.x e 7, caso não utilize estas distros procure os pacotes descritos para sua necessidade.


#Requisitos:

<b>1 – </b>Ter o POSTFIX instalado e configurado, caso não tenha, <class="noteimportant"><a href="https://github.com/sansaoipb/Email_Gmail_ZABBIX" class="wikilink2" title="Instalar POSTFIX" rel="nofollow">Clique aqui</a>.

<b>2 – </b> Baixar os módulos <code>MIME::Lite</code>, <code>WWW::Mechanize</code> e <code>JSON::RPC::Client</code>.
<br>
Ex:<br>

<!--<blockquote> <p> Debian/Ubuntu</p> </blockquote>
<pre>$ sudo apt-get install libmime-lite-perl <br></pre>

<blockquote> <p>CentOS 6.x e 7</p> </blockquote>
<pre>yum install perl-MIME-Lite </pre>-->


<blockquote> <p> Debian/Ubuntu / CentOS 6.x e 7</p> </blockquote>
<b>2.1 </b><pre>$ sudo cpan</pre>
<b>2.2 </b><pre> cpan[1]> install MIME::Lite WWW::Mechanize JSON::RPC::Client</pre>
<b>2.3 </b><pre> Depois “exit” para sair. </pre>


<!--<blockquote> <p> Debian/Ubuntu</p> </blockquote>
<pre>$ sudo apt-get install libmime-lite-perl libwww-mechanize-perl libjson-rpc-perl<br></pre>
<blockquote> <p>CentOS 6.x e 7</p> </blockquote>
<pre>yum install perl-WWW-Mechanize perl-MIME-Lite perl-JSON-RPC</pre> -->

<b>3 – </b> Localize a pasta de script do ZABBIX, dependendo da forma que você o instalou (compilando ou por pacote) estará em <code>“/usr/local/share/zabbix/alertscripts/”</code>  ou <code>“/usr/lib/zabbix/alertscripts/”</code>, e faça o download do script <code>“email.pl“</code> através do comando:
<br>

<pre>wget https://raw.githubusercontent.com/sansaoipb/Email-Graph-ZABBIX/master/email-teste.pl ; wget https://raw.githubusercontent.com/sansaoipb/Email-Graph-ZABBIX/master/email.pl</pre>

Caso queira mudar a pasta padrão, edite a linha <code>“AlertScriptsPath=”</code> no <code>“zabbix_server.conf”</code> e aponte para uma de sua preferência.
<br>

<b>OBS:</b><br>
Dê permissão de execução nos arquivos <code>“email.pl“</code> e <code>email-teste.pl</code>, para isso entre na pasta onde o script está, execute a linha abaixo:<br>

<pre>sudo chmod +x email*</pre>

#Edite os parâmetros:

<ul class="task-list">
<li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" checked="checked" disabled="disabled"><font><font class=""> “my $server_ip” = 'http://127.0.0.1/zabbix' - URL de acesso ao FRONT com "http://" </font></font></li>
<li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" checked="checked" disabled="disabled"><font><font class=""> “my $usuario”   = 'Admin';</font></font></li>
<li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" checked="checked" disabled="disabled"><font><font class=""> “my $senha”     = 'zabbix';</font></font></li>
</ul>

<b>OBS:</b><br>
O usuário que você declarar no campo <i>“my $usuario”</i> precisa ter permissão de no mínimo leitura no ambiente.<br><br>

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Comando para teste</h3>

Script para realização do teste:<br>
<b>Script, Email.</b><br>
Ex:<br>
<pre>./email-teste.pl SeuEmail@Provedor.com </pre>

<b>OBS:</b><br>
Caso tenha trocado o template do "Zabbix server", será necessário alterar o campo "my $itemid" (na linha 51) para um itemid válido do seu ambiente.<br>
<!-- <b>1 – </b>”123456” é um número fictício para exemplificar, busque uma ID válida em seu ambiente para realização do teste;<br>
<b>2 – </b>"00C800" é o verde "padrão" do zabbix em Hexadecimal;<br>
<b>3 – </b>"3600" é o período de 1h do gráfico em segundos.<br><br> -->

#Configurando o envio:

Com o script adicionado no local indicado acima, precisamos realizar algumas configurações no Front do ZABBIX, no <i>"Tipo de Mídia"</i>, (em Administração  > Tipo de Mídia) e a <i>"Ação"</i> (em Configuração  > Ações).

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Tipo de Mídia</h3>

<blockquote> <p>Zabbix 2.4</p> </blockquote>
<img src="https://lh3.googleusercontent.com/-VShKQbvb-sI/VugV_Csop6I/AAAAAAAAHjA/pNAv2REt5h0RyuPqqDCSME-q9HS0cde5wCCo/s435-Ic42/Type.JPG"/><br><br>

<blockquote> <p>Zabbix 3.0</p> </blockquote>
<img src="https://lh3.googleusercontent.com/-fYsqsGPi_Ts/VwucDEi496I/AAAAAAAAIV8/PppgsqA6VlkJXdAgTTbZiS92FMOjCunWQCCo/s512-Ic42/Type_3.0.JPG"/><br><br>

<b>OBS:</b><br>
Na versão 3.0, é obrigatório a utilização das macros <code>{ALERT.SENDTO}</code>, <code>{ALERT.SUBJECT}</code> e <code>{ALERT.MESSAGE}</code>, em caso de dúvidas, leia a Documentação 
<class="noteimportant"><a href="https://www.zabbix.com/documentation/3.0/manual/config/notifications/media/script" class="wikilink2" title="Documentação Oficial" rel="nofollow">Aqui</a>.<br><br>

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Configurando o usuário</h3>

<img src="https://lh3.googleusercontent.com/-xyTMzbhq6Qk/VwuL3xQdSCI/AAAAAAAAIVk/MfcoKVOHv4o5nLGQ_AQTe1VXZyE5lcYagCCo/s428-Ic42/Media.JPG"/><br>

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Criando a Ação:</h3>

A “<i>Mensagem Padrão</i>” na aba <b>“<u>Ação</u>”</b> está sendo executada no formato “HTML”, então você pode realizar a formatação que desejar, somente com uma “exigência”, a primeira linha deve permanecer com as macros/variáveis abaixo ilustradas (<i>as macros/variáveis <b>entre as "#" </b></i>), podendo editar da segunda linha em diante. 

Exemplificando sobre o HTML, abaixo começou com um parágrafo, e o {HOST.HOST} coloquei em negrito.
<br>
<br>

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Imagem da Mensagem na Ação:</h3>

<img src="https://lh3.googleusercontent.com/QCNQDSbKSeU57eG23mqWAR4q_jpNhXzKE6uGeqLUNTdiXukdV2tZfOHli3C8DGDx0s25byXQoXkgYA"/><br><br>

<blockquote> Modelo Mensagem Padrão</blockquote>
<pre>
{ITEM.NAME}#{EVENT.ID}#{ITEM.ID}#00C800#3600#

Foi detectado um evento no equipamento <b>{HOST.HOST}</b>.</pre>

<b>OBS:</b><br>
<i><b>”00C800”</b></i> é a cor da linha (verde) em Hex. sem tralha, e <i><b>”3600”</b></i> é o período do gráfico (1h) em segundo.

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Resultado:</h3>

<img src="https://lh3.googleusercontent.com/-LFv2lVH0kkY/V3a0YZHS21I/AAAAAAAAI3o/pUhHpJ6BToc9_xhbvlOQhwrOYPClTJjkQCCo/s707/EmailResult.JPG"/>
<br>
<br>

#Conclusão

1 – Este script é para agilizar a análise e ficar visualmente mais agradável o recebimento dos alarmes.<br><br>
2 – O script realiza uma consulta API mais ampla, detecta automaticamente se o item é de caracter/log/texto, e não envia o gráfico "sem dados" somente o texto, ele dá "ack" no evento e informa quem foi notificado naquela ação.

<!--2 - Caso você monitore itens de log, e queira receber invés do gráfico vazio "sem dados", receber somente o texto descrito na "Mensagem Padrão", basta iniciar o nome do item com log, pode ser em caixa alta ou não. -->

