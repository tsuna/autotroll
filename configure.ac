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
#AC_LANG([C])
#AC_PROG_CC

# AutoTroll with Qt.
AT_WITH_QT

AC_CONFIG_FILES([
  Makefile
    src/Makefile
    gui/Makefile
    tests/Makefile
])

AC_OUTPUT
