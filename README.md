# CPAN Changes File

This is a proposed spec for CPAN Changes files, and a lash-up parser.

HAARG has been working on a parser, and without even seeing it, I suspect
that his may will be what we go forward with, assuming we can't work out
a way to support this within the existing CPAN::Changes module.

## Prototype parser

The lib/ directory contains an incomplete prototype parser for the spec.
It can handle single level bullets and only handles dates as YYYY-MM-DD.

I'm just using the parser to test the sensibility of the spec,
and evolve ideas for the API.

There's a script bin/changes2html which shows how the parser is used.

