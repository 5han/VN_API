#!/usr/bin/perl
use strict;
use warnings;
print "api.pl!\n";

my $inputfile = "slice.conf";

# ハッシュの作成
# my %hash;

# inputfileの読み込み
open(IN, $inputfile) or die ("ERROR: no inputfile!");
while(my $line = <IN>) {
  # 改行を削除
  chomp $line;
  # 正規表現にマッチするかチェックする
  if(! $line =~ /slice([0-9]){(.*)}/) {
    # マッチしなければプログラムを終了する 
    exit(0);
  }
}
close(IN);


my $command = "/bin/cat slice.conf |";
# 外部コマンドの実行 
open(IN, $command);
print "you did this command: " . $command . "\n";
while(my $line = <IN>) {
  print $line;
}
close(IN);

# my $outputfile = "slice1.conf";
# outputfileへの書き込み
# open(OUT, ">", $outputfile) or die ("ERROR");
# my $s = "class VN\n"
# $s .= "  def_delegator :@vn, :each, :each_vn\n"
# $s .= "  def initialize()
# print 
# print OUT $string;
# close(OUT);
