use Test::Base;

if (eval("require YAML; 1")) {
    plan tests => 1 * blocks;
}
else {
    plan skip_all => "YAML.pm required for this test"; exit;
}

my ($block) = blocks;

eval {
    XXX($block->text)
};
is $@, $block->xxx, $block->name;

__DATA__
=== XXX Test
--- text eval
+{ foo => 'bar' }
--- xxx
---
foo: bar
...
  at t/xxx.t line 13
