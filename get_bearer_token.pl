#!/usr/bin/env perl
use strict;
use warnings;
use LWP::UserAgent;
use URI::Escape;
use MIME::Base64;
use JSON;

my $consumer_key = '';
my $consumer_secret = '';

my $ua = LWP::UserAgent->new;
$ua->default_header('Authorization' => "Basic ".encode_base64(uri_escape($consumer_key).":".uri_escape($consumer_secret)));
$ua->default_header('Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8');

my $url = 'https://api.twitter.com/oauth2/token';
my $res = $ua->post($url, ['grant_type' => 'client_credentials']);

if ($res->is_success) {
    my $obj = JSON::from_json($res->content);
    print $obj->{access_token}."\n";
} else {
    print $res->as_string."\n";
}


