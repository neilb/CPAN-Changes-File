# Specification for CPAN Changes files

This is based on a conversation between HAARG and NEILB
at the QA Hackathon 2014. Words like *must* as per RFC 2119.

The simplest typical Changes file would have a title,
release lines with version number and date, and blocks of text
describing each release, indented by at least one space.

## Overview

A changes file comprises the following:

 * It should contain a title line that identifies the module or distribution
 * It may contain additional preamble / introductory text
 * It must contain one or more release sections.

## Title

The first non-whitespace line should be a title that identifies the file.
The format I've seen way more than any other is:

    Revision history for Perl module Foo::Bar

I first wrote this as a *must*, because people might hit the file via
google. We could just consider this as preamble, but some service wanting
to present the whole document in a web page might reasonably want to
format the title differently from the rest of the preamble.

## Preamble

Zero or more lines of text, the only restriction being that a line
cannot start with the release header pattern.

## Releases

Each release comprises a header line followed by an optional body.
Blank line(s) between header and body are optional.

## Release header

A header line has no leading whitespace and contains the following elements:

 * The version number, with or without a leading 'v'. To be honest I've
   previously said no leading 'v', but it's a fairly common notation,
   so we should probably support it.
 * A timestamp which is minimally a date in ISO 8601 format.
 * Any additional text is treated as an opaque *release note*.

## Release body

A release body is either a bulleted list or an opaque blob of text.
If a parser can see a bulleted list, it would return that,
otherwise a client can get the release body verbatim, presumably
to render in a `<pre>` block.

## Bulleted list

These have the following characteristics:

  * Can have as many levels of indentation as you like.
  * Use the markdown bullet characters: * + -
  * If bullet characters line up vertically, we assume they're at the
    same level.
  * If there's a tab character in the leading whitespace,
    give up trying to parse bullets.
  * If a line doesn't start with a bullet character, it's a continuation line.

Should we support the following addition?

  * If a continuation line is idented four or more spaces beyond the
    previous line of text,
    then it's a verbatim block of text within the bullet.

We should just look at a load of Changes files and see whether they
include code samples and the like.

It would keep things nice and simple if we didn't have to support this,
but if enough files in the wild already do this, then we should seriously
consider supporting it, otherwise they'll look goofy when presented in
MetaCPAN.

## Misc

 * Lines starting with a hash (pound symbol, for Americans) indicates
   a comment? A service presenting (an extract of) a Changes file
   wouldn't display comments.
 * The filename may be Changes, CHANGES, ChangeLog, or NEWS
 * The content is assumed to be UTF-8

