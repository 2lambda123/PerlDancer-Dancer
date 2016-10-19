use strict;
use warnings;
use Test::More import => ['!pass'];

use Dancer ':syntax';
use Dancer::Config;

plan skip_all => "YAML or YAML::XS needed to run these tests"
    unless Dancer::ModuleLoader->load('YAML::XS')
        or Dancer::ModuleLoader->load('YAML');

plan skip_all => "File::Temp 0.22 required"
    unless Dancer::ModuleLoader->load( 'File::Temp', '0.22' );

plan tests => 2;

my $module = Dancer::ModuleLoader->load('YAML::XS') ? 'YAML::XS' : 'YAML';

eval {
    Dancer::Config::load_settings_from_yaml('foo', $module);
};

like $@, qr/Unable to parse the configuration file/, 'non-existent yaml file';

my $dir = File::Temp::tempdir(CLEANUP => 1, TMPDIR => 1);

my $config_file = File::Spec->catfile($dir, 'settings.yml');

open my $fh, '>', $config_file;
print $fh 'foo: bar: baz';
close $fh;

eval {
    Dancer::Config::load_settings_from_yaml($config_file, $module);
};

like $@, qr/Unable to parse the configuration file/, 'invalid yaml file';

File::Temp::cleanup();
