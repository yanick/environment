#!/usr/bin/env perl

# source: http://fsck.com/~jesse/extract
# see also http://www.bofh.org.uk/2006/09/21/crossing-the-rubicon-again
# to use:
#   map ,rf <Esc>:'<,'>! ~/work/environment/bin/extract<CR>

use warnings;
use strict;
use IO::All;

my $code =join('',<STDIN>);

print extract_method($code);

sub extract_method {
    my $code = shift;
    write_file($code);
    my $err  = 1;
    my @args = ();
    while ($err) {
        $err = 0;
        open( my $perl, "-|", 'perl -C /tmp/code.txt 2>&1' )
            || die $@;
        while ( my $item = <$perl> ) {
            if ( $item
                =~ /Global symbol "(.*)" requires explicit package name/ )
            {
                $err = 1;
                push @args, $1 unless (grep {$1 eq $_} @args);
            }
        }
        write_file($code, @args);
    }
    return codegen($code,'final',@args);
}

sub write_file {
    my $code = shift;
    my @args = (@_);
    codegen($code, 'test', @args) > io('/tmp/code.txt');

}

sub codegen {
    my $code = shift;
    my $mode = shift;
    my @args = (@_);

    my $selforthis_signature = qr/^(\$self|\$this)$/;
    my ($class_obj) = grep { $_ =~ /$selforthis_signature/ } @args;
    my @params = grep { $_ !~ /$selforthis_signature/ } @args;
    my $method_body = generate_signature( $class_obj, \@params, $code );
    my $subname = 'mysub_' . int( rand(1000) );
    my $invocation;
    if ($class_obj) {
        $invocation = $class_obj . "->" . $subname;
    } else {
        $invocation = $subname;
    }
    my $ret = "$invocation("
        . join( ',', map { $_ =~ /^(\%|\@)/ ? '\\' . $_ : $_ } @params )
        . ");\n";
    $ret .= "sub $subname { \n"
        . ( $mode eq 'test' ? "use strict;\n" : '' )
        . $method_body . "\n}";
    return $ret;
}

sub generate_signature { 
   my $class_obj = shift;
   my @params = @{(shift)};
   my $code = shift;

    my $ret  = join(
        "\n",
        ( $class_obj ? '  my '.$class_obj." = shift;" :""),
        map {
            my $var = $_;
            if ( $var =~ /^(\%|\@)(.*)$/) {
                my $sigil = $1;
                my $name =  $2;
                "   my ".$var." = ".$sigil."{(shift)};";
            } else {
            "   my $var = shift;";
            }
            }  @params
        )
        . "\n\n"
        . $code;
    return $ret;
}
