#!/usr/bin/perl
use strict;
use warnings;
use utf8;

my ($slice_file, $conf_file);

if(@ARGV == 2){
  $conf_file = $ARGV[0];
  $slice_file = $ARGV[1];
}
if(@ARGV == 3){
  my $tate = $ARGV[0];
  my $yoko = $ARGV[1];
  my $slice_unit = $ARGV[2];
  my $com1 = "./make_topology " . $tate . " " . $yoko;
  print $com1 . "\n";
  system($com1) || die ("ERROR: cannot do ./make_topology");
  my $com2 = "./make_slicefile " . $tate . " " . $yoko . " " . $slice_unit;
  print $com2 . "\n";
  system($com2) || die ("ERROR: cannot do ./make_slicefile");

  $conf_file = "test_topology.conf";
  $slice_file = "test_slice.conf";
}
if(@ARGV == 0){
  print "usage: perl api.pl <topology_file> <slice_file>\n";
  print "usage: perl api.pl <height_nodenum> <width_nodenum> <slice_unitnum>\n";
  exit(0);
}

  # slicefileの読み込み
  open(DATAFILE, $slice_file) or die ("ERROR: no input_file!");
  while(my $line = <DATAFILE>) {
    # 改行を削除
    chomp $line;
    # 正規表現にマッチするかチェックする
    if(! $line =~ /slice([0-9]){[0-9](.*)}/) {
      # マッチしなければプログラムを終了する 
      print "slice_file is wrong.\n";
      print $line . "\n";
      exit(0);
    }
  }
  close(DATAFILE);

  # slice.rbの作成
  open(INITFILE, "slice_init.pl") or die ("ERROR: no slice_init!");
  open(RUBYFILE, ">slice.rb") or die ("ERROR: cannot open slice.rb!");
  while(my $line1 = <INITFILE>) {
    if($line1 =~ /.*test_slice\.conf.*/) {
      print RUBYFILE "    \@input_file = \"" . $slice_file . "\"\n" ;
    }
    else {
      print RUBYFILE $line1;
    }
  }

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


# my $outputfile = "slice1.conf";
# outputfileへの書き込み
# open(OUT, ">", $outputfile) or die ("ERROR");
# my $s = "class VN\n"
# $s .= "  def_delegator :@vn, :each, :each_vn\n"
# $s .= "  def initialize()
# print 
# print OUT $string;
# close(OUT);

