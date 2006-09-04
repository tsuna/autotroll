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

## ------------- ##
## Package setup ##
## ------------- ##

AC_INIT([AutoTroll Demo], [0.2], [tsuna@lrde.epita.fr], [autotroll-demo])

AC_CONFIG_AUX_DIR([build-aux])

AM_INIT_AUTOMAKE([foreign -Wall])

## -------------------- ##
## Tool/Compilers setup ##
## -------------------- ##

# Look for a C++ compiler.
AC_LANG([C++])
AC_PROG_CXX

# If you need to create a library, USE libtool:
AC_PROG_LIBTOOL

# If you happen to have some C code:
AC_LANG([C])
AC_PROG_CC

# Speed the compilation up and tweak warning flags.
if test "$GXX" = yes; then
  AM_CXXFLAGS="$AM_CXXFLAGS -Wall -W -Weffc++ -pipe"
  AC_SUBST([AM_CXXFLAGS])
fi

AC_CONFIG_FILES([
  Makefile
    src/Makefile
    tests/Makefile
])

AC_OUTPUT
