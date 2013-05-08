#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Unicode::Japanese;
use Encode qw/encode decode/;

my $u = Unicode::Japanese->new();
my $t;
my $setenc;

open INIIN, ("< "."./set.ini");
$t = <INIIN>;
$setenc = $u->getcode($t);
if ($setenc eq "euc") {
	$setenc = "utf8";
}
my $title = decode($setenc, $t);

$t = <INIIN>;
$setenc = $u->getcode($t);
if ($setenc eq "euc") {
	$setenc = "utf8";
}
my @date  = split(/[ \r\n]/, decode($setenc, $t));
$t = <INIIN>;
$setenc = $u->getcode($t);
if ($setenc eq "euc") {
	$setenc = "utf8";
}
my $prod  = decode($setenc, $t);

print '\documentclass[b5j,11pt,twoside,openany]{tbook}'."\n";
print '\usepackage{paz}'."\n";
print '\def\bookname{'.encode("utf8", $title)."}\n";
print '\def\mydate{'.encode("utf8", "$date[0]年$date[1]月$date[2]日")."}\n";
print '\def\produce{'.encode("utf8", $prod)."}\n";

my (@no, @th, @po, @af, $ma);
$ma = "";

while (<INIIN>) {
	if (/^no(v(el?)?)?\{/) {
		$no[$#no + 1] = $_;
	} elsif (/^ths?\{/) {
		$th[$#th + 1] = $_;
	} elsif (/^po(e(t(ry?)?)?)?\{/) {
		$po[$#po + 1] = $_;
	} elsif (/^af(t(er?)?)?\{/) {
		$af[$#af + 1] = $_;
	} elsif (/ma(s(t(er?)?)?)?\{/) {
		$ma = $_;
	} else {
		print encode("utf8","%error:".$_);
	}
}
close INIIN;

print '\begin{document}'."\n";

#mokuji
print '\begin{mokuji}'."\n";
if ($#th >= 0) {
	print encode("utf8", '\subsection*{三題噺}'."\n");
	foreach(@th) {
		my @s = split /[\{\}]+/;
		print "\\contents{$s[1]}{$s[2]}{$s[6]}\n";
	}
}
if ($#no >= 0) {
	print encode("utf8", '\subsection*{小説}'."\n");
	foreach(@no) {
		my @s = split /[\{\}]+/;
		print "\\contents{$s[1]}{$s[2]}{$s[3]}\n";
	}
}
if ($#po >= 0) {
	print encode("utf8", '\subsection*{詩}'."\n");
	foreach(@po) {
		my @s = split /[\{\}]+/;
		print "\\contents{$s[1]}{$s[2]}{$s[3]}\n";
	}
}
print '\hbox{}\par'."\n";
print '\hbox{}\par'."\n";
print encode("utf8", '\contents{後書き}{}{sec:after}'."\n");
print '\end{mokuji}'."\n";

#three themes novels
foreach (@th) {
	my @s = split /[\{\}]+/;
	print '\begin{THS}{'.$s[1].'}{'.$s[2].'}{'.$s[3].'}{'.$s[4].'}{'.$s[5].'}{'.$s[6].'}'."\n";
	open TXT, ("< ".$s[6]);
	while (<TXT>) {
		$_ = decode($u->getcode($_), $_);
		s/([^\r\n]*)/$1/;
		#テキストの整形と出力
		if (/^\s*$/) {
			#空行処理
			print '\hbox{}';
		} elsif (/^[「『　]/) {
			print '\noindent'."\n";
		}
		s/((\\――)*)(――)/$1\\$3/g;
		s/([？！])　/$1/g;
		print(encode("UTF-8", $_));
		print '\par'."\n";
	}
	print '\end{THS}'."\n";
}

#novels
foreach (@no) {
	my @s = split /[\{\}]+/;
	print '\begin{novel}{'.$s[1].'}{'.$s[2].'}{'.$s[3].'}'."\n";
	open TXT, ("< ".$s[3]);
	while (<TXT>) {
		$_ = decode($u->getcode($_), $_);
		s/([^\r\n]*)/$1/;
		#テキストの整形と出力
		if (/^\s*$/) {
			#空行処理
			print '\hbox{}';
		} elsif (/^[「『　]/) {
			print '\noindent'."\n";
		}
		s/((\\――)*)(――)/$1\\$3/g;
		s/([？！])　/$1/g;
		print(encode("UTF-8", $_));
		print '\par'."\n";
	}
	close TXT;
	print '\end{novel}'."\n";
}

#poetry
foreach (@po) {
	my @s = split /[\{\}]+/;
	print '\begin{poetry}{'.$s[1].'}{'.$s[2].'}{'.$s[3].'}'."\n";
	open TXT, ("< ".$s[3]);
	while (<TXT>) {
		$_ = decode($u->getcode($_), $_);
		s/([^\r\n]*)/$1/;
		#テキストの整形と出力
		if (/^\s*$/) {
			#空行処理
			print '\hbox{}';
		} elsif (/^[「『　]/) {
			print '\noindent'."\n";
		}
		s/((\\――)*)(――)/$1\\$3/g;
		s/([？！])　/$1/g;
		print(encode("UTF-8", $_));
		print '\par'."\n";
	}
	close TXT;
	print '\end{poetry}'."\n";
}

#afterwords
print '\begin{afterwords}'."\n";
foreach (@af) {
	my @s = split /[\{\}]+/;
	print '\begin{after}{'.$s[1].'}'."\n";
	open TXT, ("< ".$s[2]);
	$_ = <TXT>;
	$_ = decode($u->getcode($_), $_);
	s/([^\r\n]*)/$1/;
	#テキストの整形と出力
	if (/^\s*$/) {
		#空行処理
		print '\hbox{}';
	} elsif (/^[「『　]/) {
		print '\noindent'."\n";
	}
	s/((\\――)*)(――)/$1\\$3/g;
	s/([？！])　/$1/g;
	print(encode("UTF-8", $_));
	while (<TXT>) {
		print '\par'."\n";
		$_ = decode($u->getcode($_), $_);
		s/([^\r\n]*)/$1/;
		#テキストの整形と出力
		if (/^\s*$/) {
			#空行処理
			print '\hbox{}';
		} elsif (/^[「『　]/) {
			print '\noindent'."\n";
		}
		s/((\\――)*)(――)/$1\\$3/g;
		s/([？！])　/$1/g;
		print(encode("UTF-8", $_));
	}
	close TXT;
	print '\end{after}'."\n";
}

unless ($ma eq "") {
	my @ss = split(/[\{\}]+/, $ma);
	print '\begin{master}{'.$ss[1].'}'."\n";
	open TXT, ("< ".$ss[2]);
	while (<TXT>) {
		s/([^\r\n]*)/$1/;
		$_ = decode($u->getcode($_), $_);
		#テキストの整形と出力
		if (/^\s*$/) {
			#空行処理
			print '\hbox{}';
		} elsif (/^[「『　]/) {
			print '\noindent'."\n";
		}
		s/((\\――)*)(――)/$1\\$3/g;
		s/([？！])　/$1/g;
		print(encode("UTF-8", $_));
		print '\par'."\n";
	}
	close TXT;
	print '\end{master}'."\n";
}

print '\end{afterwords}'."\n";
print '\okuduke{\produce}'."\n";


print '\end{document}'."\n";
