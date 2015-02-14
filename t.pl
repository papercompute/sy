use strict;
use warnings;

my %prec = (
    '^' => 4,
    '*' => 3,
    '/' => 3,
    ':' => 3,
    '+' => 2,
    '-' => 2,
    '(' => 1
);
 
my %assoc = (
    '^' => 'right',
    '*' => 'left',
    '/' => 'left',
    ':' => 'left',
    '+' => 'left',
    '-' => 'left'
);

my $function = "-2*((324,456+896,942.31/92.54)*1)/-2*23.34+(-3*63453.223)";
$function =~ s/[,]//g;
#my $function = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3";
my @tokens = split(/(\(|\)|\*|\+|\^|\/|\:|\-)/, $function);
print "tokens:@tokens","length",scalar(@tokens),"\n";

my @tokens2=();
my @tokens3=();
#my @tokens = split(/(?=[()*|,])|(?<=[ ()*,])(?! )/, $function);
print "$function\n";
my $prevt="";

#for (my $i = 0; $i < @tokens; $i++) {
# if(length($_)>0){  
#  my $ss=trim($tokens[$i]);
#  if(length($ss)>0){
#   push @tokens2,$ss;
#  }
# }
#}

my $min=0;
my $i=0;
foreach(@tokens){
if(length($_)>0){  
  my $ss=trim($_);
  if(length($ss)>0){
   print $ss,"\n";
   if($ss eq '-' && ((@tokens2[-1]=~ /\+|\*|\:|\/|\-|\(/) || ($i eq 0)) ){
    #print "Boom::::@tokens2[-1]\n";
    $min=1;
   }
   else{
    if($min eq 1){$ss='-'.$ss;}
    push @tokens2,$ss;
    $i++;
    $min=0;
   }
  } 
 }
}

print "tokens2:@tokens2","length",scalar(@tokens2),"\n";
#die("a");


#local $, = " ";
my @rpn=shunting_yard(\@tokens2);
print "rpn=@rpn\n";
my $sum=calc(\@rpn);
print "s=$sum\n";


 
sub shunting_yard {
#    my @inp = split ' ', $_[0];
#    my @inp = $_[0];
    my ($inp_ref) = @_;
    my @inp=@$inp_ref;
    print "inp=@inp\n";

    my @ops;
    my @res; 
 
    while (@inp) {
        my $token = trim(shift @inp)  ;
        if(length($token)<=0){last;}
        if    ( $token =~ /\d+/ ) { push @res,$token }
        elsif ( $token eq '(' )  { push @ops,$token }
        elsif ( $token eq ')' ) {
            while ( @ops and "(" ne ( my $x = pop @ops ) ) { push @res,$x }
        } else {
            my $newprec = $prec{$token};
            while (@ops) {
                my $oldprec = $prec{ $ops[-1] };
                last if $newprec > $oldprec;
                last if $newprec == $oldprec and $assoc{$token} eq 'right';
                push(@res,pop @ops);
            }
            push @ops,$token;
        }
      print ">$token", "|", "@res", "|" ,"@ops","\n";
    }
#    push(@res,pop @ops) while @ops;
    while (@ops){push(@res,pop @ops);};
    @res;
}

sub test_count{
  my $sr=@_;
  $i=0;
  # ((dsdfsf()ssd)sdfs)
  foreach(@$sr){
    if($_ eq '('){$i++;}
    elsif($_ eq ')'){$i--;}  
  }
  $i;
}
 
sub calc
{
    my ($rpn_ref) = @_;
    my @rpn=@$rpn_ref;
    print "rpn=@rpn\n";
    my @stack;
    foreach(@rpn){
     my $token=$_;
     print "$_ | @stack\n";
     if($token =~ /\d+/ )   {push @stack, $token}
     elsif ( $token eq '*' ){push @stack, ( (pop @stack) * (pop @stack)) }
     elsif ( $token eq '/' ){my $f=pop @stack;my $s=pop @stack; push @stack, ($s / $f); }
     elsif ( $token eq ':' ){my $f=pop @stack;my $s=pop @stack; push @stack, ($s / $f); }
     elsif ( $token eq '+' ){push @stack, ( (pop @stack) + (pop @stack)) }
     elsif ( $token eq '^' ){ my $f=pop @stack;my $s=pop @stack; push @stack, ($s ** $f); }
     elsif ( $token eq '-' ){ my $f=pop @stack;my $s=pop @stack; push @stack, ($s - $f); }
    }
    $stack[0];
}

sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s };
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s };
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

