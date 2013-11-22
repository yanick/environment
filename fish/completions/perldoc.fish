function __perldoc_complete_fish

perl -e'
use strict;

use File::Spec::Functions qw( catfile );
use List::AllUtils qw/ uniq apply /;
use Path::Tiny;
use Path::Iterator::Rule;

sub get_package_suggestions {
	my ( $pkg ) = @_;

	my @dirs = split /::|:\z/, $pkg, -1;
    my $file = pop @dirs;
    my $dirs = join "/", @dirs;

    my @prospects;

    for my $root ( @INC ) {
        my $path = path( $root, @dirs );

        next unless -d $path;

        push @prospects, map {
            substr $_, length($root);
        } 
        map {
            -f $_ ? $_ : Path::Iterator::Rule->new->perl_file->all($_)
        } grep { not index $_->basename, $file } $path->children;
    }


    for ( @prospects ) {
        -d $_ ? s/$/::/ : s/\.p(?:m|od)$//;
        s#^/##;
        s#/#::#g;
    }

    return uniq @prospects;
}

sub get_function_suggestions {
	my ( $func ) = @_;

	my $perlfunc;
	INCPATH: for ( @INC, undef ) {
		return if not defined;
		for my $dir ( qw( pods pod ) ) {
			$perlfunc = catfile $_, $dir, "perlfunc.pod";
			last INCPATH if -r $perlfunc;
		}
	}

	open my $fh, "<", $perlfunc or return;

	my @suggestion;
	my $nest_level = -1;
	while ( <$fh> ) {
		next if 1 .. /^=head2 Alphabetical Listing of Perl Functions$/;
		++$nest_level if /^=over/;
		--$nest_level if /^=back/;
		next if $nest_level;
		push @suggestion, /^=item (-?\w+)/;
	}

	my $func_rx = qr/\A${\quotemeta $func}/;

	return grep { /$func_rx/ } @suggestion;
}

my @arg = split " ", shift @ARGV;
my $word = pop @arg;

print qq{$_\n} for ( @arg and @arg[-1] eq q{-f} )
	? get_function_suggestions( $word )
	: get_package_suggestions( $word );


' (commandline)

end

complete -c perldoc -a '(__perldoc_complete_fish)'

complete -c perldoc -s h -d "help"
complete -c perldoc -s V -d 'Report version'
complete -c perldoc -s r -d 'Recursive search'
complete -c perldoc -s i -d 'Ignore case'
complete -c perldoc -s t -d 'Display pod using pod2text instead of Pod::Man and groff'
complete -c perldoc -s u -d 'Display unformatted pod text'
complete -c perldoc -s m -d "Display module's file in its entirety"
complete -c perldoc -s n -d 'Specify replacement for groff'
complete -c perldoc -s l -d "Display the module's file name"
complete -c perldoc -s F -d 'Arguments are file names, not modules'
complete -c perldoc -s D -d "Verbosely describe what's going on"
complete -c perldoc -s T -d 'Send output to STDOUT without any pager'
complete -c perldoc -s d -d 'output_filename_to_send_to'
complete -c perldoc -s o -d 'output_format_name'
complete -c perldoc -s M -d 'FormatterModuleNameToUse'
complete -c perldoc -s w -d 'formatter_option:option_value'
complete -c perldoc -s L -d 'Choose doc translation'
complete -c perldoc -s X -d 'Use index if present'
complete -c perldoc -s q -d 'Search the text of questions in perlfaq'
complete -c perldoc -s f -d 'Search Perl built-in functions'
complete -c perldoc -s v -d 'Search predefined Perl variables'

