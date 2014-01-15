#!/usr/bin/perl
use strict;
use warnings;
use utf8;

my ($slice_file, $conf_file);

if(@ARGV == 2){
  my $conf_file = $ARGV[0];
  my $slice_file = $ARGV[1];

  # slicefileの読み込み
  open(DATAFILE, $slice_file) or die ("ERROR: no input_file!");
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
  $SIG{PIPE} = 'IGNORE';
  my $command0 = "sudo trema run ./routing-switch.rb -c " . $conf_file . " |";
  print "command: " . $command0 . "\n";
  open(IN, $command0) || die "can't fork: $!";
  while(<IN>) {
    print;
  }
  close(IN) || die "command end!";

  my $command1 = "sudo trema killall";
  system($command1);


}else{
  print "usage: perl api.pl <conf_file> <slice_file>\n"
}
# my $outputfile = "slice1.conf";
# outputfileへの書き込み
# open(OUT, ">", $outputfile) or die ("ERROR");
# my $s = "class VN\n"
# $s .= "  def_delegator :@vn, :each, :each_vn\n"
# $s .= "  def initialize()
# print 
# print OUT $string;
# close(OUT);

