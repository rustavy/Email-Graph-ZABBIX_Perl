#!/usr/bin/perl

# Envio de gráfico por email através do ZABBIX (Send zabbix alerts graph mail)
#
# 
# Copyright (C) <2016>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Contacts:
# Eracydes Carvalho (Sansão Simonton) - NOC Analyst - sansaoipb@gmail.com
# Thiago Paz - NOC Analyst - thiagopaz1986@gmail.com

use strict;
use warnings;
use MIME::Lite;
use Data::Dumper;
use HTTP::Cookies;
use WWW::Mechanize; 
use JSON::RPC::Client;
use Encode;
use POSIX;

## Dados do Zabbix ##############################################################################################################
my $server_ip  = 'http://127.0.0.1/zabbix'; # URL de acesso ao FRONT com "http://"
my $user       = 'Admin';
my $password   = 'zabbix';
my $client     = new JSON::RPC::Client;
my ($json, $response, $authID);
#################################################################################################################################

## Configuracao do Grafico ######################################################################################################
my $color   = '00C800'; # Cor do grafico em Hex. (sem tralha)
my $period  = 3600; # 1 hora em segundos
my $height  = 200;  # Altura
my $width   = 900;  # Largura
my $stime   = strftime("%Y%m%d%H%M%S", localtime( time-3600 )); # Hora inicial do grafico [time-3600 = 1 hora atras]
#################################################################################################################################

## Configuracao do Grafico ######################################################################################################
my $itemid     = '23316';
my $subject    = 'ALARME';
my $itemname   = 'MEMORIA DISPONIVEL';
my $body_mail  = 'Teste de envio';
#################################################################################################################################
unless ($itemid){
                print "<<< Item inválido ou USER do front sem permissão de leitura no host >>>\n";
                exit;
}

my $graph = "/tmp/$itemid.png";

my $mech = WWW::Mechanize->new();
$mech->cookie_jar(HTTP::Cookies->new());
$mech->get("$server_ip/index.php?login=1");
$mech->field(name => $user);
$mech->field(password => $password);
$mech->click();

my $png = $mech->get("$server_ip/chart3.php?name=$itemname&period=$period&width=$width&height=$height&stime=$stime&items[0][itemid]=$itemid&items[0][drawtype]=5&items[0][color]=$color");

open my $image, '>', $graph or die $!;
$image->print($png->decoded_content);
$image->close;
#################################################################################################################################

## Bom dia, boa tarde ou boa noite ##############################################################################################
my $hour = strftime '%H', localtime;
my $salutation;
if ($hour < "12")
{  
	$salutation = "Bom dia"; #Good Morning
}  
elsif ($hour >= "18")
{
	$salutation = "Boa noite"; #Good Night
}
else
{
	$salutation = "Boa tarde"; #Good Afternoon
}
#################################################################################################################################

utf8::decode($subject);

if ((&tipo == 0) || (&tipo == 3)) {

	my $msg = MIME::Lite->new(
					From    => 'ZABBIX <noc@monitoramento.com>',
					To      => $ARGV[0],
					Subject => encode('MIME-Header',$subject),
					Type    => 'multipart/related'
	);
	$msg->attach(
			Type => 'text/html',
			Data => qq{<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
			<body>
			<p>$salutation,</p>
			<p>$body_mail</p>
			<p><img src="cid:grafico.png"></p>
			</body>}
	);
	$msg->attach(
			Type => 'AUTO',
			Id   => 'grafico.png',
			Path => $graph,
	);
	$msg->send();
}
else {
	my $msg = MIME::Lite->new(
					From    => 'ZABBIX <noc@monitoramento.com>',
					To      => $ARGV[0],
					Subject => encode('MIME-Header',$subject),
					Type    => 'multipart/related'
);
	$msg->attach(
			Type => 'text/html',
			Data => qq{<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
			<body>
			<p>$salutation,</p>
			<p>$body_mail</p>
			</body>}
	);
	$msg->send();
}

unlink ("$graph");

sub tipo {
	$json = {
		jsonrpc => '2.0',
		method  => 'user.login',
		params  => {
			user  => $user  ,
			password => $password
     		},
   		id => 1
  	};

	$response = $client->call("$server_ip/api_jsonrpc.php", $json);
	#print Dumper ($response);
	unless ($response){
    print "<<< URL declarada para o front errada >>>\n";
    exit;
    }
        unless ($response->content->{'result'}){
        print "<<< Usuário ou senha inválido >>>\n";
        exit;
        }	
		
	$authID = $response->content->{'result'};
	$itemid =~ s/^\s+//;

	$json = {
		jsonrpc => '2.0',
	   	method  => 'item.get',
		params  => {
			output => ['value_type'],
			itemids => $itemid
     		},
   		auth => $authID,
		id => 2
  	};
	$response = $client->call("$server_ip/api_jsonrpc.php", $json);
	#print Dumper ($response);
	
        my $itemtype;
        foreach my $get_itemtype (@{$response->content->{result}}) {
                $itemtype = $get_itemtype->{value_type}
        }
        unless (defined $itemtype){
                print "<<< Item inválido ou USER do front sem permissão de leitura no host >>>\n";
                exit;
        }

        return $itemtype;
}

exit;
