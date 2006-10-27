#  _____ _____  ____  __ _____ 
# |  ___|_ _\ \/ /  \/  | ____|
# | |_   | | \  /| |\/| |  _|  
# |  _|  | | /  \| |  | | |___ 
# |_|   |___/_/\_\_|  |_|_____|
#                              

include $(top_srcdir)/build-aux/autotroll.mk

# For a program:
bin_PROGRAMS = lcdrange
lcdrange_SOURCES = main.cc lcdrange.cpp lcdrange.moc.cpp lcdrange.h qt_main.cpp
lcdrange_CXXFLAGS = $(QT_CXXFLAGS) $(AM_CXXFLAGS)
lcdrange_CPPFLAGS = $(QT_CPPFLAGS) $(AM_CPPFLAGS)
lcdrange_LDFLAGS  = $(QT_LDFLAGS) $(LDFLAGS)
lcdrange_LDADD    = $(QT_LIBS) $(LDADD)

BUILT_SOURCES = lcdrange.moc.cpp
