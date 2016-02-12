use strict;
use warnings;
my %pos;

##read annotation file##
my $gene = "AT2G42830";

open(FILE,"tair10.all.gene.anno.final.v2") or die;
$/ = "\n>";
while(<FILE>){
    chomp;
    s/>//g;
    s/^(.*)\n//;
    my $name = $1;
    my $gene_name = $1;
    $gene_name =~ s/\..*//;
    if($gene_name eq $gene){
        my @line = split(/\n/,$_);
        foreach(@line){
            my @position = split(/\t/,$_);
            for(my $i=$position[2];$i<=$position[3];$i++){
                if(exists $pos{"$position[0]\t$i"}){
                    $pos{"$position[0]\t$i"} =  $pos{"$position[0]\t$i"}.";$name";
                }
                else{
                     $pos{"$position[0]\t$i"} = $name;
                 }
             }
         }
     }
}
close FILE;

open(FILE,$ARGV[0]) or die;
$/="\n";
open(OUT,">$ARGV[0]\.$gene\.overlap.fas") or die;
open(OUT1,">$ARGV[0]\.$gene\.1.uniq.fas") or die;
open(OUT2,">$ARGV[0]\.$gene\.2.uniq.fas") or die;

while(<FILE>){
    chomp;
    next if(/\@/);
    my @line = split(/\t/,$_);
    if(exists $pos{"Chr$line[2]\t$line[3]"}){
    my $anno = $pos{"Chr$line[2]\t$line[3]"};
    my @num = split(/;/,$anno);
    if(scalar(@num)>1){
        print OUT ">$line[0]\n$line[9]\n";
    }
    else{
        if($anno eq "$gene\.1"){
            print OUT1 ">$line[0]\n$line[9]\n";
        }
        else{
            print OUT2 ">$line[0]\n$line[9]\n";
        }
    }
}
}





    
