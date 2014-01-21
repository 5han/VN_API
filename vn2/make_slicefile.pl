#!/usr/bin/perl
use strict;
use warnings;
use utf8;

if(@ARGV < 2){
    print "error\n";
}
if($ARGV[0] eq "make"){
    &make_topology;
}elsif($ARGV[0] eq "add_slice"){
    &add_slice;
}elsif($ARGV[0] eq "add_host"){
    &add_host;
}elsif($ARGV[0] eq "del_slice"){
    &del_slice;
}elsif($ARGV[0] eq "del_host"){
    &del_host;
}else{
    print "error";
    exit(0);
}

sub make_topology{
    my $width = $ARGV[1];
    my $height = $ARGV[2];
    my $sliceunit = $ARGV[3];
    my $size = $width*$height;
    my $slice_file = "test_slice.conf";
    my @mac = ("0")x12;
    my $current = 0;
    my $i;
    my $j;

    open my $fh, '>', $slice_file or die "error";
    for($i = 0; $i < $size; $i++){
	my $slicenum = $i/$sliceunit;
	if($i % $sliceunit == 0){
	    print $fh "slice".$slicenum."{";
	}
	for($j = 11; $j>=0; $j--){
	    printf $fh "%x",$mac[$j];
	    if(($j%2==0) && ($j != 0)){
		print $fh ":";
	    }
	}
	if($i%$sliceunit == $sliceunit-1 || $i == $size -1){
	    print $fh "}\n";
	}else{
	    print $fh ",";
	}
	$mac[0]++;
	while($mac[$current] == 16){
	    $mac[$current] = 0;
	    $current++;
	    $mac[$current]++;
	}
	$current = 0;
    }
    close($fh);
}

sub add_host{
    my $slice_file = "test_slice.conf";
    my $result_file = "result.conf";
    my $i;
    open my $fh, '<', $slice_file or die "error";
    open my $fh2,'>',$result_file or die "error";

    while(my $line = <$fh>){
	my $tmp = $line;
	chomp $line;
	$line =~ s/slice//g;
	my @factor = split("{",$line);
	if($factor[0] eq $ARGV[1]){
	    print $fh2 "slice".$factor[0]."{";
	    my $count = @ARGV;
	    my $mac = &convert_mac($count,$ARGV[2]);
	    print $fh2 $mac.$factor[1]."\n";
	}else{
	    print $fh2 $tmp;
	}
    }
    close($fh);
    close($fh2);
    system("mv result.conf test_slice.conf");
}

sub add_slice{
    my $slice_file = "test_slice.conf";
    my $result_file = "result.conf";
    my $i;
    open my $fh, '<', $slice_file or die "error";
    open my $fh2,'>',$result_file or die "error";

    while(my $line = <$fh>){
	print $fh2 $line;
	my $tmp = $line;
	chomp $line;
	$line =~ s/slice//g;
	my @factor = split("{",$line);
	if($factor[0] eq $ARGV[1]){
	    print "already exist\n";
	    exit(1);
	}
    }
    print $fh2 "slice".$ARGV[1]."{}\n";
    close($fh);
    close($fh2);
    system("mv result.conf test_slice.conf");
}

sub del_host{
    my $slice_file = "test_slice.conf";
    my $result_file = "result.conf";
    my $i;
    my $j;
    open my $fh, '<', $slice_file or die "error";
    open my $fh2,'>',$result_file or die "error";

    while(my $line = <$fh>){
	my $tmp = $line;
	chomp $line;
	$line =~ s/slice//g;
	my @factor = split("{",$line);
	if($factor[0] eq $ARGV[1]){
	    print $fh2 "slice".$factor[0]."{";
	    my $count = @ARGV;
	    my $mac = &convert_mac($count,$ARGV[2]);
	    my @macs = split(",",$mac);
	    my $countA = @macs;
	    my @address = split("[,}]",$factor[1]);
	    my $countB = @address;
	    for($i = 0; $i < $countB; $i++){
		for($j=0; $j < $countA; $j++){
		    if($macs[$j] eq $address[$i]){
			last;
		    }
		}
		if($j == $countA){
		    print $fh2 $address[$i];
		    if($i != $countB -1){
			print ",";
		    }
		}
	    }
	    print $fh2 "}\n";
	}else{
	    print $fh2 $tmp;
	}
    }
    close($fh);
    close($fh2);
    system("mv result.conf test_slice.conf");
}

sub del_slice{
    my $slice_file = "test_slice.conf";
    my $result_file = "result.conf";
    my $i;
    open my $fh, '<', $slice_file or die "error";
    open my $fh2,'>',$result_file or die "error";

    while(my $line = <$fh>){
	my $tmp = $line;
	chomp $line;
	$line =~ s/slice//g;
	my @factor = split("{",$line);
	if($factor[0] eq $ARGV[1]){
	}else{
	    print $fh2 $tmp;
	}
    }
    close($fh);
    close($fh2);
    system("mv result.conf test_slice.conf");
}

sub convert_mac{
    my $y = $_[0];
    my $x = 0;
    my $i = 0;
    my $j = 0;
    my $result = "";

    for($i = 2; $i < $y; $i++){
	my $x = $ARGV[$i];
	$x =~ s/host//g;
	$x--;
	my @mac = ("0")x12;
	$mac[0] = $x;
	while($mac[$j] > 16){
	    while($mac[$j] > 16){
		$mac[$j+1]++;
		$mac[$j] -= 16;
	    }
	    $j++;
	}
	
	for($j = 11; $j>=0; $j--){
	    my $tmp = sprintf("%x",$mac[$j]);
	    $result = $result.$tmp;
	    if(($j%2==0) && ($j != 0)){
		$result = $result.":";
	    }
	}
	$result = $result.",";
    }
    return $result;
}
