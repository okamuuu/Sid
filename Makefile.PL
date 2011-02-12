use inc::Module::Install;
name 'Sid';
all_from 'lib/Sid.pm';

requires 'opts';
requires 'Cwd';
requires 'Carp';
requires 'Path::Class';
requires 'Encode';
requires 'Smart::Args';
requires 'Class::Accessor::Lite' => 0.05;
requires 'Class::Load';
requires 'MouseX::Types::Path::Class';
requires 'HTML::TreeBuilder::XPath';
requires 'Text::Markdown';
requires 'Text::Xslate';


tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
