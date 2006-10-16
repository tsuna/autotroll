# Build Qt apps with the autotools (Autoconf/Automake).
# M4 macros.
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

# Simply invoke AT_WITH_QT in your configure.ac. This will do the following:
#  - Add a --with-qt option to your configure
#  - Find qmake, moc and uic and save them in the make variables $(QMAKE),
#    $(MOC), $(UIC).
#  - Save the path to Qt in $(QT_PATH)
#  - Find the flags to use Qt, that is:
#     * $(QT_DEFINES): -D's defined by qmake.
#     * $(QT_CFLAGS): CFLAGS as defined by qmake (C?!)
#     * $(QT_CXXFLAGS): CXXFLAGS as defined by qmake.
#     * $(QT_INCPATH): -I's defined by qmake.
#     * $(QT_CPPFLAGS): Same as $(QT_DEFINES) + $(QT_INCPATH)
#     * $(QT_LFLAGS): LFLAGS defined by qmake.
#     * $(QT_LDFLAGS): Same thing as $(QT_LFLAGS).
#     * $(QT_LIBS): LIBS defined by qmake.
#
# You *MUST* invoke $(MOC) and/or $(UIC) where necessary. AutoTroll provides
# you with Makerules to ease this, here is a sample Makefile.am to use with
# AutoTroll which builds the code given in the chapter 7 of the Qt Tutorial:
# http://doc.trolltech.com/4.2/tutorial-t7.html
#
# -------------------------------------------------------------------------
# include $(top_srcdir)/build-aux/autotroll.mk
#
# ACLOCAL_AMFLAGS = -I build-aux
#
# bin_PROGRAMS = lcdrange
# lcdrange_SOURCES =  lcdrange.cpp lcdrange.moc.cpp lcdrange.h main.cpp
# lcdrange_CXXFLAGS = $(AM_CXXFLAGS) $(QT_CXXFLAGS)
# lcdrange_CPPFLAGS = $(AM_CPPFLAGS) $(QT_CPPFLAGS)
# lcdrange_LDFLAGS  = $(QT_LDFLAGS) $(LDFLAGS)
# lcdrange_LDADD    = $(QT_LIBS) $(LDADD)
#
# BUILT_SOURCES = lcdrange.moc.cpp
# -------------------------------------------------------------------------

AC_DEFUN([AT_WITH_QT],
[
  test x"$TROLL" != x && echo 'ViM rox emacs.'

  # Memo: AC_ARG_WITH(package, help-string, [if-given], [if-not-given])
  AC_ARG_WITH([qt],
              [AS_HELP_STRING([--with-qt],
                 [Path to Qt @<:@Look in PATH and /usr/local/Trolltech@:>@])],
              [QT_PATH=$withval], [QT_PATH=])

  # Find Qt.
  if test -d /usr/local/Trolltech; then
    # Try to find the latest version.
    tmp_qt_paths=`echo /usr/local/Trolltech/*/bin | tr ' ' '\n' | sort -nr \
                                              | xargs | sed 's/  */:/g'`
  fi

  # Find qmake.
  AC_PATH_PROGS([QMAKE], [qmake], [missing], [$QT_PATH:$PATH:$tmp_qt_paths])
  if test x"$QMAKE" = xmissing; then
    AC_MSG_ERROR([Cannot find qmake in your PATH. Try using --with-qt.])
  fi

  # Find moc (Meta Object Compiler).
  AC_PATH_PROGS([MOC], [moc], [missing], [$QT_PATH:$PATH:$tmp_qt_paths])
  if test x"$MOC" = xmissing; then
    AC_MSG_ERROR([Cannot find moc (Meta Object Compiler) in your PATH. Try using --with-qt.])
  fi

  # Find uic (User Interface Compiler).
  AC_PATH_PROGS([UIC], [uic], [missing], [$QT_PATH:$PATH:$tmp_qt_paths])
  if test x"$UIC" = xmissing; then
    AC_MSG_ERROR([Cannot find uic (User Interface Compiler) in your PATH. Try using --with-qt.])
  fi

  # If we don't know the path to Qt, guess it from the path to qmake.
  if test x"$QT_PATH" = x; then
    QT_PATH=`dirname "$QMAKE"`
  fi
  if test x"$QT_PATH" = x; then
    AC_MSG_ERROR([Cannot find the path to your Qt install. Use --with-qt.])
  fi
  AC_SUBST([QT_PATH])

  mkdir conftest.dir
  cd conftest.dir
  cat >conftest.cpp <<_ASEOF
#include <QApplication>
#include <QPushButton>
#include <QWidget>

class MyWidget : public QWidget
{
public:
  MyWidget(QWidget *parent = 0);
public slots:
  void setValue(int value);
signals:
  void valueChanged(int newValue);
private:
  int value_;
};

MyWidget::MyWidget(QWidget *parent)
  : QWidget(parent), value_ (42)
{
  QPushButton* quit = new QPushButton(tr("Quit"), this);
  connect(quit, SIGNAL(clicked()), qApp, SLOT(quit()));
}

void MyWidget::setValue(int value)
{
  value_ = value;
}

int main(int argc, char **argv)
{
  QApplication app(argc, argv);
  MyWidget widget;
  widget.show();
  return app.exec();
}
_ASEOF
  if $QMAKE -project; then :; else
    AC_MSG_ERROR([Calling $QMAKE -project failed.])
  fi
  if $QMAKE; then :; else
    AC_MSG_ERROR([Calling $QMAKE failed.])
  fi

  # Try to compile a simple Qt app.
  AC_CACHE_CHECK([whether we can build a simple Qt app], [at_cv_qt_build],
  [at_cv_qt_build=ko
  : ${MAKE=make}
  if $MAKE >&AS_MESSAGE_LOG_FD 2>&1; then
    at_cv_qt_build=ok
  else
    at_cv_qt_build=ko
    echo "$as_me: failed program was:" >&AS_MESSAGE_LOG_FD
    cat conftest.cpp | sed 's/^/| /' >&AS_MESSAGE_LOG_FD
  fi
  ])dnl end: AC_CACHE_CHECK(at_cv_qt_build)

  if test x$at_cv_qt_build != xok; then
    AC_MSG_ERROR([Cannot build a test Qt program])
  fi

  # This sed filter is applied after an expression of the form: /^FOO.*=/!d;
  # It starts by removing the beginning of the line, removing references to
  # SUBLIBS, removing unecessary whitespaces at the beginning, and prefixes
  # all variable uses by QT_.
  qt_sed_filter='s///;
                 s/$(SUBLIBS)//g;
                 s/^ *//;
                 s/\$(\(@<:@A-Z_@:>@@<:@A-Z_@:>@*\))/$(QT_\1)/g'

  # Find the DEFINES of Qt (should have been named CPPFLAGS).
  AC_CACHE_CHECK([for the DEFINES to use with Qt], [at_cv_env_QT_DEFINES],
  [at_cv_env_QT_DEFINES=`sed "/^DEFINES@<:@^A-Z@:>@*=/!d;$qt_sed_filter" Makefile`])
  AC_SUBST([QT_DEFINES], [$at_cv_env_QT_DEFINES])

  # Find the CFLAGS of Qt (We can use Qt in C?!)
  AC_CACHE_CHECK([for the CFLAGS to use with Qt], [at_cv_env_QT_CFLAGS],
  [at_cv_env_QT_CFLAGS=`sed "/^CFLAGS@<:@^A-Z@:>@*=/!d;$qt_sed_filter" Makefile`])
  AC_SUBST([QT_CFLAGS], [$at_cv_env_QT_CFLAGS])

  # Find the CXXFLAGS of Qt.
  AC_CACHE_CHECK([for the CXXFLAGS to use with Qt], [at_cv_env_QT_CXXFLAGS],
  [at_cv_env_QT_CXXFLAGS=`sed "/^CXXFLAGS@<:@^A-Z@:>@*=/!d;$qt_sed_filter" Makefile`])
  AC_SUBST([QT_CXXFLAGS], [$at_cv_env_QT_CXXFLAGS])

  # Find the INCPATH of Qt.
  AC_CACHE_CHECK([for the INCPATH to use with Qt], [at_cv_env_QT_INCPATH],
  [at_cv_env_QT_INCPATH=`sed "/^INCPATH@<:@^A-Z@:>@*=/!d;$qt_sed_filter" Makefile`])
  AC_SUBST([QT_INCPATH], [$at_cv_env_QT_INCPATH])

  AC_SUBST([QT_CPPFLAGS], ["$at_cv_env_QT_DEFINES $at_cv_env_QT_INCPATH"])

  # Find the LFLAGS of Qt (Should have been named LDFLAGS)
  AC_CACHE_CHECK([for the LDFLAGS to use with Qt], [at_cv_env_QT_LDFLAGS],
  [at_cv_env_QT_LDFLAGS=`sed "/^LFLAGS@<:@^A-Z@:>@*=/!d;$qt_sed_filter" Makefile`])
  AC_SUBST([QT_LFLAGS], [$at_cv_env_QT_LDFLAGS])
  AC_SUBST([QT_LDFLAGS], [$at_cv_env_QT_LDFLAGS])

  # Find the LIBS of Qt.
  AC_CACHE_CHECK([for the LIBS to use with Qt], [at_cv_env_QT_LIBS],
  [at_cv_env_QT_LIBS=`sed "/^LIBS@<:@^A-Z@:>@*=/!d;$qt_sed_filter" Makefile`])
  AC_SUBST([QT_LIBS], [$at_cv_env_QT_LIBS])

  cd ..
  rm -rf conftest.dir
])
