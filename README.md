AutoTroll
=========

This is a demo of AutoTroll.

What is it?
-----------

It shows how to use the [Qt GUI library](https://www.qt.io) with
[automake](https://www.gnu.org/software/automake), a tool for generating
`Makefile.in` file templates, which in turn are converted to real
`Makefile`s using [autoconf](https://www.gnu.org/software/autoconf).

License
-------

AutoTroll is distributed under the GPLv2+ with exception.

Current status
--------------

Currently, the main file of interest in this repository is
`build-aux/autotroll.m4`, which works with Qt5.  All other files are still
related mainly to Qt3.

Example project
---------------

See the git repository of [ttfautohint](http://repo.or.cz/ttfautohint.git/)
for an example project that uses (a recent incarnation of) autotroll.
