use strict;
use warnings;
package Finance::Oanda::v20;

use Moose;
use LWP::UserAgent;
use JSON qw( decode_json );

has 'account_id' => (
    is  => 'rw',
    isa => 'Str',
    required => 1,
);

has 'auth_token' => (
    is  => 'ro',
    isa => 'Str',
    required => 1,
);

has '_ua' => (
    is => 'ro',
    default => sub { LWP::UserAgent->new() },
);

has '_api_endpoint' => (
    is => 'ro',
    isa => 'URI',
    default => sub { URI->new("https://api-fxtrade.oanda.com/v3/") },
);


sub _send_request {
    my $self = shift;

    my $req = HTTP::Request->new( @_ );
    $req->header( 'Authorization' => 'Bearer ' . $self->auth_token );

    return $self->_ua->request($req);
}

sub getAsk {
    my ($self, $symbol) = @_;

    my $url = $self->_api_endpoint->as_string() . "/accounts/" . $self->account_id . "/pricing?instruments=" . $symbol;
    my $response = $self->_send_request(GET => $url);
    my $response_object = decode_json( $response->decoded_content);

    return $response_object->{prices}->[0]->{closeoutAsk};

}

sub getBid {
    my ($self, $symbol) = @_;

    my $url = $self->_api_endpoint->as_string() . "/accounts/" . $self->account_id . "/pricing?instruments=" . $symbol;
    my $response = $self->_send_request(GET => $url);
    my $response_object = decode_json( $response->decoded_content);

    return $response_object->{prices}->[0]->{closeoutBid};
}

sub openMarket {
    my ($self, $direction, $amount) = @_;

    my %order = (
        type => 'MARKET',
        instrument => $symbol,
        units => $amount * ($direction eq 'long' ? 1 : -1),
}

sub closeMarket {
    my ($self, $tradeID, $amount) = @_;
}

sub getTrades {
    my ($self) = @_;

}

sub getBalance {
}

sub getMinTradeSize {
    return 1;
}

1;