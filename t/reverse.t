use lib 't/lib';
use JTTest;
use XML::Invisible qw(make_parser make_canonicaliser);

sub run_test {
  my ($grammar_text, $doc, $expected_canonical, $label) = @_;
  my $parser = make_parser($grammar_text);
  my $got_forward = $parser->($doc);
  my $got_reversed = make_canonicaliser($grammar_text)->($got_forward);
  is $got_reversed, $expected_canonical, "$label reversed";
  my $reparsed = $parser->($got_reversed);
  is_deeply $reparsed, $got_forward, "$label reparsed is same as first";
}

run_test(
  <<'EOF',
expr: target assign source
target: name
assign: (- EQUAL -)
source: name
name: /( ALPHA (: ALPHA | DIGIT )* )/
EOF
  'a = b',
  'a=b',
  'basic',
);

done_testing;
