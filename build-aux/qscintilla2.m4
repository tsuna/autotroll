# M4 macros to build Qt apps that use qscintilla2 with the autotools
# (Autoconf/Automake).
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

# This file relies on values (QT_*) defined by AutoTroll.
# Although it is not *required* to use AutoTroll along with this file, doing
# so provides better results since QScintilla is often located where Qt is.

# WITH_QSCINTILLA2()
# ------------------
AC_DEFUN([WITH_QSCINTILLA2],
[ AC_REQUIRE([AC_PROG_CXX])
  AC_REQUIRE([AC_EXEEXT])

  AC_ARG_WITH([qscintilla2],
              [AS_HELP_STRING([--with-qscintilla2].
                 [LDFLAGS to use for qscintilla2 @<:@-lqscintilla2 + Same as Qt@:>@])],
              [QSCINTILLA2_LDFLAGS=$withval], [QSCINTILLA2_LDFLAGS='-lqscintilla2'])

  # FIXME: Can we use a macro from autoconf to make something similar?
  AC_CACHE_CHECK([for lib qscintilla2], [qt_cv_lqscintilla2],
  [qt_cv_lqscintilla2=no
  cat >conftest.cpp <<_ASEOF
#include <qsciscintilla.h>
struct Test: public QsciScintilla
{
};

int main ()
{
  Test t;
}
_ASEOF
  # Dirty hack :(
  # Qt adds $(QT_DEFINES) in $QT_CXXFLAGS: we need to expand it here!
  eval_qt_defines_sed="s/\$(QT_DEFINES)/$QT_DEFINES/"
  MY_QT_CXXFLAGS=`echo "$QT_CXXFLAGS" | sed "$eval_qt_defines_sed"`

  echo "$as_me:$LINENO: running: $CXX $QT_CPPFLAGS $AM_CPPFLAGS $CPPFLAGS \
          $MY_QT_CXXFLAGS $AM_CXXFLAGS $CXXFLAGS \
          $QT_LDFLAGS $LDFLAGS \
          $QSCINTILLA2_LDFLAGS $QT_LIBS $LIBS conftest.cpp -o conftest$EXEEXT;" \
        >&AS_MESSAGE_LOG_FD
  if $CXX $QT_CPPFLAGS $AM_CPPFLAGS $CPPFLAGS \
          $MY_QT_CXXFLAGS $AM_CXXFLAGS $CXXFLAGS \
          $QT_LDFLAGS $LDFLAGS \
          $QSCINTILLA2_LDFLAGS $QT_LIBS $LIBS conftest.cpp -o conftest$EXEEXT \
       >&AS_MESSAGE_LOG_FD 2>&1;
  then
    if test x"$QT_LIBS" != x; then
      qt_cv_lqscintilla2="$QSCINTILLA2_LDFLAGS + Qt stuff"
    else
      qt_cv_lqscintilla2="$QSCINTILLA2_LDFLAGS"
    fi
  fi
  if test x"$qt_cv_lqscintilla2" = xno; then
    echo "$as_me:$LINENO: failed program was:" >&AS_MESSAGE_LOG_FD
    sed 's/^/| /' conftest.cpp >&AS_MESSAGE_LOG_FD
  fi
  rm -f conftest.cpp conftest$EXEEXT
  ])dnl End of AC_CACHE_CHECK for -lqscintilla2

  if test x"$qt_cv_lqscintilla2" = xno; then
    AC_MSG_ERROR([Cannot link with -lqscintilla2.])
  fi
])
