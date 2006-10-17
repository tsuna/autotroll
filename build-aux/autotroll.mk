# Makerules.
# This file is part of AutoTroll.
# Copyright (C) 2006  Benoit Sigoure.
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

 # ------------- #
 # DOCUMENTATION #
 # ------------- #

# See autotroll.m4 :)


SUFFIXES = .moc.cpp .cpp .cc .cxx .C

.h.moc.cpp:
	$(MOC) $(QT_CPPFLAGS) $< -o $@

.h.moc.cc:
	$(MOC) $(QT_CPPFLAGS) $< -o $@

.h.moc.cxx:
	$(MOC) $(QT_CPPFLAGS) $< -o $@

.h.moc.C:
	$(MOC) $(QT_CPPFLAGS) $< -o $@

# FIXME: Add support for UIC?

DISTCLEANFILES = $(BUILT_SOURCES)
