#!/usr/bin/env perl
use strict;
use warnings;
use URI::Escape;
use LWP::UserAgent;
use JSON;
use Getopt::Long;
use Time::Local;
use POSIX qw(strftime);
use Encode;
use utf8;
use open ":utf8";
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

$| = 1;

my $bearer_token = 'AAAAAAAAAA...';

$ENV{'TZ'} = "JST-9";
my %m2i = do {
    my $i = 0;
    map {$_ => $i++} ('Jan','Feb','Mar','Apr','May','Jun',
		      'Jul','Aug','Sep','Oct','Nov','Dec');
};

my $q;
my $pages = 32;
my $count = 100;
my $datadump = 0;
GetOptions(
    'q=s' => \$q,
    'pages=s' => \$pages,
    'count=s' => \$count,
    'dump' => \$datadump,
    );

$q = Encode::decode_utf8($q) if not utf8::is_utf8($q);

my $ua = LWP::UserAgent->new;
$ua->default_header('Authorization' => "Bearer $bearer_token");

my $rt = search({q => uri_escape_utf8($q), count => $count});
if ($datadump) {
    use Data::Dumper;
    print Dumper($rt),"\n";
    exit;
}
exit unless @{$rt->{statuses}};
output($rt->{statuses});
exit if $pages <= 1;
exit if @{$rt->{statuses}} < $count;

for (my $i = 2; $i <= $pages; $i++) {
    #warn "page $i";
    my $last_id = $rt->{statuses}[-1]{id};
    sleep 1;
    $rt = search({q => $q, count => $count, max_id => $last_id-1});
    exit unless @{$rt->{statuses}};
    output($rt->{statuses});
}

sub search {
    my ($r) = @_;
    my $ps = join("&", map {"$_=$r->{$_}"} keys %$r);
    my $url = "https://api.twitter.com/1.1/search/tweets.json?".$ps;
    my $res = $ua->get($url);
    return unless $res->is_success;
    my $obj = JSON::from_json($res->content);
    return $obj;
}

sub output {
    my ($t_r) = @_;
    foreach my $t (@$t_r) {
	my $ymdhms = do {
	    $t->{created_at} =~ /([A-Z][a-z]{2}) (\d+) (\d+):(\d+):(\d+) .\d+ (\d+)$/;
	    my $utm = timegm($5, $4, $3, $2, $m2i{$1}, $6);
	    strftime("%Y-%m-%d %H:%M:%S", localtime($utm));
	};
	my $s = join("\t", $t->{user}{screen_name}, $ymdhms, $t->{text});
	$s =~ s/\n/\\n/g;
	print "$s\n";
    }
}

