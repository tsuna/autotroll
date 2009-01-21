#! /bin/sh
# Basic test script.
# This file is part of AutoTroll.
# Copyright (C) 2006  Benoit Sigoure <tsuna@lrde.epita.fr>
#
# AutoTroll is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
# USA.
#
# In addition, as a special exception, the copyright holders of AutoTroll
# give you unlimited permission to copy, distribute and modify the configure
# scripts that are the output of Autoconf when processing the macros of
# AutoTroll.  You need not follow the terms of the GNU General Public License
# when using or distributing such scripts, even though portions of the text of
# AutoTroll appear in them. The GNU General Public License (GPL) does govern
# all other use of the material that constitutes AutoTroll.
#
# This special exception to the GPL applies to versions of AutoTroll
# released by the copyright holders of AutoTroll.  Note that people who make
# modified versions of AutoTroll are not obligated to grant this special
# exception for their modified versions; it is their choice whether to do so.
# The GNU General Public License gives permission to release a modified version
# without this exception; this exception also makes it possible to release a
# modified version which carries forward this exception.

  # ------------- #
  # Documentation #
  # ------------- #

# This test script provides a simple way to generate test suites using
# GNU Automake. Note that once the test suite is generated and distributed,
# only standard POSIX make is required.
#
# This script will check the output (on stdout and/or stderr) of a program
# against a reference output (if available) whereas Automake's builtin test
# feature only checks the return value (without using DejaGnu).

# Quick Setup
# -----------

# Better than a long explanation, here is a sample test suite to put in your
# tests/Makefile.am:
#
# check_PROGRAMS = foo bar
# foo_SOURCES = foo.c
# bar_SOURCES = bar.c aux.c
# TESTS = foo.test bar.test
#
# SUFFIXES = .test
# .c.test:
# 	$(LN_S) -f $(srcdir)/test.sh $@
                           # ^^^^^^^ where test.sh is this script.
#
# EXTRA_DIST = test.sh
# CLEANFILES = *.my_stdout *.my_stderr
# TESTS_ENVIRONMENT = SRCDIR=$(srcdir)

# Alternatively, you can generate the .test files like this:
# $(TESTS): Makefile.am
# 	for i in $(TESTS); do $(LN_S) -f $(srcdir)/test.sh $$i; done
                  # where test.sh is this script.  ^^^^^^^
# If all your tests use the script, you don't have to bother with TESTS:
# TESTS = $(check_PROGRAMS:=.test)

# How to use
# ----------

# Simply run `make check' or better, `make distcheck' :)
# By default, only the return value will be checked -- which is just what
# Automake does by default. If you want to check stderr/stdout, you need to
# create (or generate) reference output files. Eg: foo.stdout, foo.stderr or
# foo.ret (for the return value).
#
# You can do this by hand or use this script to generate the output:
# $ make check GEN=stdout
# will run all your tests and save their output in `test-name.stdout'. The
# next time you run `make check', stdout will be checked against the saved
# (reference) output. Running this again will simply update (overwrite)
# reference files.
#
# You can also use `GEN=stderr' or `GEN=ret'.
# If you encounter any problem, try `make check DEBUG=1'
# You can also `make check VERBOSE=1' in order to get the output on stdout and
# stderr as the tests run. Note that when doing this, stdout will always
# appear first, then stderr. Messages on stdout/stderr will not be interleaved
# as they might originally be. This is because stdout/stderr are buffered.
#
# When you generate reference output files, you might want to version them.
# When you run `make check GEN=something', files are generated in the build
# tree. You might want to move them to the source tree and `svn add' them. You
# might also want to distribute them (using EXTRA_DIST = $(TESTS:.test=.stdout)
# for instance, or list the .stdout/.stderr/.ret manually).

# new_reference_output_file [ret|stdout|stderr] <ref-file>
new_reference_output_file()
{
  test -s $bprog.my_$1 && return 0 # Skip empty files.
  # Simply update existing reference output file.
  if test x"$2" != x; then
    cp -f $bprog.my_$1 $2
  else # Create new reference output file (try first in SRCDIR).
    cp -f $bprog.my_$1 $SRCDIR/$bprog.$1 \
    || cp -f $bprog.my_$1 $bprog.$1 || {
      echo "$0: cannot generate $bprog.$1" >&2
      script_exit=1
    }
  fi
}

test x"$DEBUG" != x && set -x

# Program to test
prog=`echo "$0" | sed 's/\.test$//;y/ /_/'`
# Basename of the program to test
bprog=`basename $prog`

test -f $prog || {
  echo "$prog: No such file or directory." >&2
  exit 127
}

test -x $prog || {
  echo "$prog: Not executable." >&2
  exit 126
}

# We NEED the env var SRCDIR
test x"$SRCDIR" = x && echo "$0: \$SRCDIR is empty" >&2 && exit 42

# default values
ref_ret=0;     check_ret='no'
ref_stdout=''; check_stdout='no'
ref_stderr=''; check_stderr='no'

# Find reference output files (if they are provided).
for i in ret stdout stderr; do
  # Search first in build dir, then where the prog is (should be build dir
  # too, but we never know) then finally in the SRCDIR.
  for f in ./$bprog.$i $prog.$i $SRCDIR/$bprog.$i; do
    if [ -f "$f" ]; then
      if [ -r "$f" ]; then
        # Meta-programming in Sh \o/
        eval ref_$i="$f"
        eval check_$i='yes'
        break
      else
        echo "$0: warning: "$f" isn't readable" >&2
      fi
    fi
  done
done

# Run the program to check and save outputs.
$prog >$bprog.my_stdout 2>$bprog.my_stderr
my_ret=$?

# Return value of this script.
script_exit=0

# Are we trying to generate reference output files?
if test "x$GEN" = xret; then
  echo "$my_ret" >$bprog.my_ret
  new_reference_output_file ret "$ref_var"
  rm -f $bprog.my_ret
fi

if [ $check_ret = 'no' ]; then # Check that the test returned 0 anyway.
  if [ $my_ret -ne 0 ]; then
    script_exit=1
    echo "$0: bad return value, got $my_ret, expected 0" >&2
  fi
else
  ref_ret_val=`cat "$ref_ret"`
  ref_ret_without_digits=`echo "$ref_ret_val" | sed 's/[0-9]//g'`
  if [ x"$ref_ret_without_digits" != x ]; then
    script_exit=1
    echo "$0: invalid content for $ref_ret, maybe run \`make check GEN=ret'?"
  fi
  if [ $my_ret -ne "$ref_ret_val" ]; then
    script_exit=1
    echo "$0: bad return value, got $my_ret, expected $ref_ret_val" >&2
  fi
fi

# Check stdout and stderr.
for i in stdout stderr; do
  check_var=check_$i
  check_var=`eval echo \\\$$check_var`
  ref_var=ref_$i
  ref_var=`eval echo \\\$$ref_var`

  # Display their output (a bit late...).
  test "x$VERBOSE" != x && cat $bprog.my_$i

  # Are we trying to generate reference output files?
  if test "x$GEN" = x$i; then
    new_reference_output_file $i "$ref_var"
  fi

  if [ $check_var = 'yes' ]; then
    if cmp -s $bprog.my_$i $ref_var; then
      rm -f $bprog.my_$i # Good output, remove temporary file.
    else
      script_exit=1
      echo "$0: wrong output on $i" >&2
      diff -u $ref_var $bprog.my_$i
    fi
  else
    rm -f $bprog.my_$i # No reference output => remove temporary file.
  fi
done

exit $script_exit
