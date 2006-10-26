# Program to check:
check_PROGRAMS = testme
testme_SOURCES = testme.cc

# If your test programs includes header from the source tree:
# AM_CPPFLAGS += -I $(top_srcdir)/src
# Use AM_CFLAGS for C code. Don't play with CXXFLAGS/CFLAGS.

# If your test programs needs to link with some library from the source tree:
# LDADD = $(top_builddir)/src/libfoo.la

# List your tests here:
TESTS = testme.test

$(TESTS):
	for i in $(TESTS); do \
          $(LN_S) -f $(top_srcdir)/tests/test.sh $$i || exit 1; \
        done

EXTRA_DIST = $(TESTS:.test=.stdout)
CLEANFILES = *.my_stdout *.my_stderr
TESTS_ENVIRONMENT = SRCDIR=$(srcdir)

# List the tests that are expected to fail:
# XFAIL_TESTS =
