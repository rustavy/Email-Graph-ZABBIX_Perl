#!/usr/bin/perl

use strict;
use warnings;
use MIME::Lite;
use WWW::Mechanize; 
use HTTP::Cookies;
use Encode;
use POSIX;

## Dados do Zabbix ##############################################################################################################
my $server_ip = 'http://127.0.0.1/zabbix'; # URL de acesso ao FRONT com "http://"                                               #
my $usuario   = 'Admin';                                                                                                        #
my $senha     = 'zabbix';                                                                                                       #
#################################################################################################################################

## Configuracao do Grafico ######################################################################################################
my $periodo = 3600; # 1 hora em segundos                                                                                        #
my $width   = 600;  # Largura                                                                                                   #
my $height  = 100;  # Altura                                                                                                    #
my $stime   = strftime("%Y%m%d%H%M%S", localtime( time-3600 )); # Hora inicial do grafico [time-3600 = 1 hora atras]            #
#################################################################################################################################

## Separando ItemID / Corpo do Email ############################################################################################
my ($itemid, $email_corpo) = split /\#/, $ARGV[2], 2;                                                                           #
#################################################################################################################################

#################################################################################################################################
my $graph = "/tmp/$itemid.png";                                                                                                 #
                                                                                                                                #
                                                                                                                                #
my $mech = WWW::Mechanize->new();                                                                                               #
$mech->cookie_jar(HTTP::Cookies->new());                                                                                        #
$mech->get("$server_ip/index.php?login=1");                                                                                     #
$mech->field(name => $usuario);                                                                                                 #
$mech->field(password => $senha);                                                                                               #
$mech->click();                                                                                                                 #
#$mech->content->as_string;                                                                                                     #
                                                                                                                                #
my $png = $mech->get("$server_ip/chart.php?period=$periodo&itemids%5B0%5D=$itemid&stime=$stime&width=$width&height=$height");   #
                                                                                                                                #
open my $image, '>', $graph or die $!;                                                                                          #
$image->print($png->decoded_content);                                                                                           #
$image->close;                                                                                                                  #
#################################################################################################################################

## Bom dia, boa tarde ou boa noite ##############################################################################################
my $hora = strftime '%H', localtime;                                                                                            #
my $saudacao;                                                                                                                   #
if ($hora < "12")                                                                                                               #
{                                                                                                                               #
        $saudacao = "Bom dia"; #Good Morning                                                                                    #
}                                                                                                                               #
elsif ($hora >= "18")                                                                                                           #
{                                                                                                                               #
        $saudacao = "Boa noite"; #Good Night                                                                                    #
}                                                                                                                               #
else                                                                                                                            #
{                                                                                                                               #
        $saudacao = "Boa tarde"; #Good Afternoon                                                                                #
}                                                                                                                               #
#################################################################################################################################



## Decodificando o Assunto do Email como UTF-8
utf8::decode($ARGV[1]);


## Envio do email
my $msg = MIME::Lite->new(
                 From    => 'ZABBIX <noc@monitoramento.com>',
                 To      => $ARGV[0],
                 Subject => encode('MIME-Header',$ARGV[1]),
                 Type    => 'multipart/related'
                 );
    $msg->attach(Type    => 'text/html',
                 Data    => qq{<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
                            <body>
                            <p>$saudacao,</p>
                            <p>$email_corpo</p>
                            <p> <img src="cid:grafico.png"></p>
                            </body>}
                 );
    $msg->attach(Type    => 'AUTO',
                 Id      => 'grafico.png',
                 Path    => $graph,
                 );


    $msg->send();

## Excluindo o arquivo (Grafico)
   unlink ("$graph");

exit;
