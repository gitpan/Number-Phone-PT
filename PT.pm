package Number::Phone::PT;

use 5.008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	is_valid is_residential is_mobile is_personal area_of
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	is_valid is_residential is_mobile is_personal area_of
);

our $VERSION = '0.01';

=head1 NAME

Number::Phone::PT - Validate Portuguese phone numbers

=head1 SYNOPSIS

  use Number::Phone::PT;

  print "$number is valid" if is_valid($number);

  print "$number belongs to a home" if is_residential($number);

  print "$number is a celular phone" if is_mobile($number);

  print "$number belongs to someone" if is_personal($number);
  # same thing as ( is_residential($number) or is_mobile($number) )

  print "$number is from " . area_of($number) if is_residential($number);

=cut

my %indicativos;

BEGIN {
  %indicativos = (
    21  => 'lisboa',
    22  => 'porto',
    231 => 'mealhada',
    232 => 'mangualde,tondela,viseu',
    233 => 'figueira da foz',
    234 => 'aveiro,águeda',
    236 => 'pombal',
    239 => 'coimbra,condeixa,penacova',
    242 => 'santarém',
    243 => 'santarém',
    244 => 'marinha grande,leiria',
    245 => 'portalegre',
    249 => 'tomar,torres novas',
    251 => 'valença',
    252 => 'famalicão,póvoa do varzim,santo tirso,trofa',
    253 => 'braga,fafe,guimarães,barcelos',
    254 => 'régua',
    255 => 'amarante,felgueiras,penafiel',
    256 => 'ovar,são joão da madeira',
    258 => 'viana do castelo',
    259 => 'vila real',
    261 => 'mafra,torres vedras,lourinhã',
    263 => 'caldas da raínha,peniche',
    265 => 'setúbal',
    266 => 'évora',
    268 => 'estremoz',
    269 => 'santiago do cacém',
    271 => 'guarda',
    272 => 'castelo branco',
    273 => 'bragança',
    274 => 'sertã',
    275 => 'covilhã',
    276 => 'chaves',
    277 => 'castelo branco',
    278 => 'mirandela',
    279 => 'moncorvo',
    281 => 'tavira',
    282 => 'lagos,portimão',
    283 => 'beja',
    284 => 'beja',
    285 => 'beja',
    286 => 'beja',
    289 => 'faro,quarteira',
    291 => 'funchal',
    292 => 'horta,madalena,santa cruz das flores',
    295 => 'angra do heroísmo',
    296 => 'ponta delgada',

    91  => 'rede móvel 91 (Vodafone / Yorn)',
    93  => 'rede móvel 93 (Optimus)',
    96  => 'rede móvel 96 (TMN)',

    707 => 'número único',
    760 => 'número único',
    800 => 'número grátis',
    808 => 'chamada local',
  );
}

sub is_valid {
  $_ = shift || return 0;
  unless (/^\d{9}$/) { return 0 }

  for my $ind (keys %indicativos) {
    /^$ind/ && return 1;
  }

  return 0
}

sub is_personal {
  is_mobile(@_) or is_residential(@_);
}

sub is_mobile {
  is_valid(@_) || return 0;
  $_ = shift || return 0;
  for my $ind (grep /^9/, keys %indicativos) {
    /^$ind/ && return 1;
  }
  return 0
}

sub is_residential {
  is_valid(@_) || return 0;
  $_ = shift || return 0;
  for my $ind (grep /^2/, keys %indicativos) {
    /^$ind/ && return 1;
  }
  return 0
}

sub area_of {
  is_valid(@_) || return 0;
  $_ = shift || return 0;
  for my $ind (grep /^2/, keys %indicativos) {
    /^$ind/ && return $indicativos{$ind};
  }
  return 0;
}

1;
__END__

=head1 DESCRIPTION

Validates Portuguese phone numbers. Does not check whether they exist or not;
it just validates to see if they are well written.

Special numbers (as the emergency number 112, for instance), are currently not
comtemplated.

=head1 PORTUGUESE PHONE NUMBERS

There are three kinds of telephone numbers in Portugal (currently):
residential, mobile and service numbers.

All of these numbers are composed of nine digits.

=head2 RESIDENTIAL NUMBERS

Residential numbers always start with the digit 2. The first few digits
identify the region it belongs to. Here is the list (note that the function
C<area_of> may return accentuated words):

=over residential

=item 21  lisboa

=item 22  porto

=item 231 mealhada

=item 232 mangualde,tondela,viseu

=item 233 figueira da foz

=item 234 aveiro,agueda

=item 236 pombal

=item 239 coimbra,condeixa,penacova

=item 242 santarem

=item 243 santarem

=item 244 marinha grande,leiria

=item 245 portalegre

=item 249 tomar,torres novas

=item 251 valenca

=item 252 famalicao,povoa do varzim,santo tirso,trofa

=item 253 braga,fafe,guimaraes,barcelos

=item 254 regua

=item 255 amarante,felgueiras,penafiel

=item 256 ovar,sao joao da madeira

=item 258 viana do castelo

=item 259 vila real

=item 261 mafra,torres vedras,lourinha

=item 263 caldas da rainha,peniche

=item 265 setubal

=item 266 evora

=item 268 estremoz

=item 269 santiago do cacem

=item 271 guarda

=item 272 castelo branco

=item 273 braganca

=item 274 serta

=item 275 covilha

=item 276 chaves

=item 277 castelo branco

=item 278 mirandela

=item 279 moncorvo

=item 281 tavira

=item 282 lagos,portimao

=item 283 beja

=item 284 beja

=item 285 beja

=item 286 beja

=item 289 faro,quarteira

=item 291 funchal

=item 292 horta,madalena,santa cruz das flores

=item 295 angra do heroismo

=item 296 ponta delgada

=back

=head2 MOBILE NUMBERS

Mobile numbers always start with the digit 9. The first two digits
identify the operator it belongs to. Here is the list:

=over mobile

=item 91  Vodafone / Yorn

=item 93  Optimus

=item 96  TMN

=back

=head2 SERVICE NUMBERS

Service numbers start with 707, 760, 800 or 808 (currently). Please refer to
Portugal Telecom in order to know how they work.

=over service

=item 707 número único

=item 760 número único

=item 800 número grátis

=item 808 chamada local

=back

=head1 AUTHOR

Jose Alves de Castro, E<lt>jac@natura.di.uminho.pt<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2004 by Jose Alves de Castro

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
