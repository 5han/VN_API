#!/usr/bin/perl
use strict;
use warnings;

my $inputfile = "test_slice.conf";

# ハッシュの作成
# my %hash;

# inputfileの読み込み
open(DATAFILE, $inputfile) or die ("ERROR: no inputfile!");
while(my $line = <DATAFILE>) {
  # 改行を削除
  chomp $line;
  # 正規表現にマッチするかチェックする
  if(! $line =~ /slice([0-9]){(.*)}/) {
    # マッチしなければプログラムを終了する 
    exit(0);
  }
}
close(DATAFILE);


# 外部コマンドの実行 
my $command0 = "sudo trema run ./routing-switch.rb -c test_topology.conf |";
print "command: " . $command0 . "\n";
open(IN, $command0);
while(my $line0 = <IN>) {
  print $line0;
}
close(IN);

my $command1 = "sudo trema killall |";
print "command: " . $command1 . "\n";
open(IN, $command1);
while(my $line1 = <IN>) {
  print $line1;
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
