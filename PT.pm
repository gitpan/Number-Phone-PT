package Number::Phone::PT;

use 5.006;
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

our $VERSION = '0.05';

=head1 NAME

Number::Phone::PT - Validate Portuguese phone numbers

=head1 SYNOPSIS

  use Number::Phone::PT;

  $number = 258374162;

  print "$number is valid" if is_valid($number);

  print "$number belongs to a home" if is_residential($number);

  print "$number is a celular phone" if is_mobile($number);

  print "$number belongs to someone" if is_personal($number);
  # same thing as ( is_residential($number) or is_mobile($number) )

  print "$number is from " . area_of($number) if is_residential($number);

=cut

my %indicativos;
my %special;

BEGIN {
  %indicativos = (
    21  => 'lisboa',
    22  => 'porto',
    231 => 'mealhada',
    232 => 'viseu',
    233 => 'figueira da foz',
    234 => 'aveiro',
    235 => 'arganil',
    236 => 'pombal',
    238 => 'seia',
    239 => 'coimbra',
    241 => 'abrantes',
    242 => 'ponte de s�r',
    243 => 'santar�m',
    244 => 'leiria',
    245 => 'portalegre',
    249 => 'torres novas',
    251 => 'valen�a',
    252 => 'vila nova de famalic�o',
    253 => 'braga',
    254 => 'peso da r�gua',
    255 => 'penafiel',
    256 => 's�o jo�o da madeira',
    258 => 'viana do castelo',
    259 => 'vila real',
    261 => 'torres vedras',
    262 => 'caldas da ra�nha',
    263 => 'vila franca de xira',
    265 => 'set�bal',
    266 => '�vora',
    268 => 'estremoz',
    269 => 'santiago do cac�m',
    271 => 'guarda',
    272 => 'castelo branco',
    273 => 'bragan�a',
    274 => 'proen�a-a-nova',
    275 => 'covilh�',
    276 => 'chaves',
    277 => 'idanha-a-nova',
    278 => 'mirandela',
    279 => 'moncorvo',
    281 => 'tavira',
    282 => 'portim�o',
    283 => 'odemira',
    284 => 'beja',
    285 => 'moura',
    286 => 'castro verde',
    289 => 'faro',
    291 => 'funchal, porto santo',
    292 => 'corvo, faial, flores, horta, pico',
    295 => 'angra do hero�smo, graciosa, s�o jorge, terceira',
    296 => 'ponta delgada, s�o miguel, santa maria',

    91  => 'rede m�vel 91 (Vodafone / Yorn)',
    93  => 'rede m�vel 93 (Optimus)',
    96  => 'rede m�vel 96 (TMN)',

    707 => 'n�mero �nico',
    760 => 'n�mero �nico',
    800 => 'n�mero gr�tis',
    808 => 'chamada local',
  );

  %special = (  # currently unused (yet)
    # Telefones �teis
    120		=> 'Chamadas Nacionais a Pagar no Destino',
    120		=> 'PT Multivozes',
    16200	=> 'Servi�o a Clientes',
    12161	=> 'Despertar',
    1583	=> 'Telegramas Nacional',
    16208	=> 'Assist�ncia T�cnica',
    # Servi�os de informa��es
    118		=> 'Servi�o Informativo Nacional',
    12150	=> 'Meteorologia',
    12151	=> 'Horas',
    12153	=> 'Not�cias',
    12157	=> 'Desporto',
    12158	=> 'Lotaria, Totobola e Totoloto',
    # Internacional
    171		=> 'Chamadas com Assist�ncia',
    177		=> 'Listas Telef�nicas Internacionais',
    179	=> 'Informa��es Gerais sobre o Servi�o Telef�nico Internacional',
    1582	=> 'Telegramas Internacional',
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

Validates Portuguese phone numbers. Does not check whether they exist
or not; it just validates to see if they are well written.

Special numbers (as the emergency number 112, for instance), are
currently not comtemplated.

=head1 PORTUGUESE PHONE NUMBERS

There are three kinds of telephone numbers in Portugal (currently):
residential, mobile and service numbers.

All of these numbers are composed of nine digits.

=head2 RESIDENTIAL NUMBERS

Residential numbers always start with the digit 2. The first few digits
identify the region it belongs to. Here is the list (note that the function
C<area_of> may return accentuated words):

=over 4

=item 21  lisboa

=item 22  porto

=item 231 mealhada

=item 232 viseu

=item 233 figueira da foz

=item 234 aveiro

=item 235 arganil

=item 236 pombal

=item 238 seia

=item 239 coimbra

=item 241 abrantes

=item 242 ponte de sor

=item 243 santarem

=item 244 leiria

=item 245 portalegre

=item 249 torres novas

=item 251 valenca

=item 252 vila nova de famalicao

=item 253 braga

=item 254 peso da regua

=item 255 penafiel

=item 256 sao joao da madeira

=item 258 viana do castelo

=item 259 vila real

=item 261 torres vedras

=item 263 caldas da rainha

=item 265 setubal

=item 266 evora

=item 268 estremoz

=item 269 santiago do cacem

=item 271 guarda

=item 272 castelo branco

=item 273 braganca

=item 274 proenca-a-nova

=item 275 covilha

=item 276 chaves

=item 277 idanha-a-nova

=item 278 mirandela

=item 279 moncorvo

=item 281 tavira

=item 282 portimao

=item 283 odemira

=item 284 beja

=item 285 moura

=item 286 castro verde

=item 289 faro

=item 291 funchal, porto santo

=item 292 corvo, faial, flores, horta, pico

=item 295 angra do heroismo, graciosa, sao jorge, terceira

=item 296 ponta delgada, sao miguel, santa maria

=back

=head2 MOBILE NUMBERS

Mobile numbers always start with the digit 9. The first two digits
identify the operator it belongs to. Here is the list:

=over 4

=item 91  Vodafone / Yorn

=item 93  Optimus

=item 96  TMN

=back

=head2 SERVICE NUMBERS

Service numbers start with 707, 760, 800 or 808 (currently). Please refer to
Portugal Telecom in order to know how they work, as they change from time to
time.

=over 4

=item 707 numero unico

=item 760 numero unico

=item 800 numero gratis

=item 808 chamada local

=back

=head1 MESSAGE FROM THE AUTHOR

If you're using this module, please drop me a line to my e-mail. Tell
me what you're doing with it. Also, feel free to suggest new
bugs^H^H^H^H^H features.

=head1 AUTHOR

Jose Alves de Castro, E<lt>cog [at] cpan [dot] org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2004 by Jose Alves de Castro

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
