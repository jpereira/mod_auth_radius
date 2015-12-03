# Author: Jorge Pereira <jpereiran@gmail.com>
# Date: Qua Dez  2 18:17:20 BRST 2015
####

AC_PREREQ([2.59])
export CFLAGS LIBS LDFLAGS CPPFLAGS     

AC_INIT(mod_auth_radius.c)
#AM_INIT_AUTOMAKE([-Wall foreign])

AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_MAKE_SET
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT8_T

AC_CHECKING(whether apxs is available)
AC_SUBST(APXS)
AC_SUBST(DSO)
AC_SUBST(ALL)

dnl # Module version
MOD_RADIUS_MAJOR_VERSION=`cat VERSION | cut -f1 -d.`
MOD_RADIUS_MINOR_VERSION=`cat VERSION | cut -f2 -d.`
MOD_RADIUS_INCRM_VERSION=`cat VERSION | cut -f3 -d.`
MOD_RADIUS_VERSION="${MOD_RADIUS_MAJOR_VERSION}.${MOD_RADIUS_MINOR_VERSION}.${MOD_RADIUS_INCRM_VERSION}"
AC_DEFINE_UNQUOTED([MOD_RADIUS_VERSION],["${MOD_RADIUS_VERSION}"],[mod_auth_radius version])

dnl #
dnl #  See if we have Git.
dnl #
AC_CHECK_PROG(GIT, git, yes, no)

dnl #  append the current git hash onto the version string
if test -d $srcdir/.git -a "x$GIT" = "xyes"; then 
  MOD_RADIUS_VERSION_COMMIT=`git log --pretty=format:'%h' -n 1`
  AC_DEFINE_UNQUOTED([MOD_RADIUS_VERSION_COMMIT],["${MOD_RADIUS_VERSION_COMMIT}"],[Commit HEAD at time of configuring])
fi

# apxs
AC_MSG_CHECKING(for --with-apxs)
AC_ARG_WITH(apxs,
	[AS_HELP_STRING(
		[--with-apxs],
		[Path to Apache apxs command (2.2.x)]
	)],
	APXS=$withval)
dnl We need to reset CFLAGS after AC_PROG_CC sets it. apxs will provide
dnl its own CFLAGS and gets confused when we try to feed ours to it.
CFLAGS=

if test -z "$APXS" || test "$APXS" = yes; then
	APXS=apxs
	for location in /usr/local/apache/bin/apxs \
		/usr/local/apache2/bin/apxs /opt/csw/apache2/sbin/apxs; do

		if test -e $location; then
			APXS=$location
		fi
	done
fi

AC_MSG_CHECKING(whether apxs works)
if $APXS -q CFLAGS >/dev/null; then
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
	AC_MSG_ERROR(Cannot build mod_auth_radius without a valid apxs program)
fi

# enable module
AC_ARG_WITH(activate,
	[AS_HELP_STRING(
		[--with-activate],
		[Activate mod_auth_radius in httpd.conf]
	)],
	test "$withval" != no && ACTIVATE=-a
)

# freeradius headers
AC_ARG_WITH(freeradius-headers,
	[AS_HELP_STRING(
		[--with-freeradius-headers],
		[Specify the path to the FreeRADIUS header files]
	)],
	[FREERADIUS_INCDIR="$withval"]
)

# libfreeradius-radius.so
AC_ARG_WITH(freeradius-libdir,
	[AS_HELP_STRING(
		[--with-freeradius-libdir],
		[Specify the path to the FreeRADIUS libraries]
	)],
	[FREERADIUS_LIBDIR="$withval"]
)

if test "x${FREERADIUS_LIBDIR}" = "x"; then
	fr_lib=""
	for fr_libdir in /usr/lib/freeradius /usr/local/lib/freeradius /opt/radius/lib/freeradius; do
		fr_lib="${fr_libdir}/libfreeradius-radius.so"
		echo -n "Looking for libfreeradius-radius.so in ${fr_libdir} ..."
		if test -f "$fr_lib"; then
			echo "yes"
			break
		else
			echo "no"
		fi
	done
	if ! test -f "$fr_lib"; then
		AC_MSG_ERROR(Cannot build mod_auth_radius without libfreeradius-radius > $FREERADIUS_LIBDIR)
	fi
	FREERADIUS_LIBDIR="$fr_libdir"
fi

# set the flags
CFLAGS="$CFLAGS -I${FREERADIUS_INCDIR}"
LDFLAGS="$LDFLAGS -L${FREERADIUS_LIBDIR} -Wl,-R${FREERADIUS_LIBDIR}"

# functions
AC_CHECK_LIB(freeradius-radius, dict_init,
	found_mod_auth_radius_libs=yes; LIBS="-lfreeradius-radius $LIBS",
	AC_MSG_ERROR(You must have libfreeradius-radius to build mod_auth_radius.)
)

# headers
AC_HEADER_STDC
AC_C_CONST

AC_CHECK_FUNCS([gethostbyname])
AC_CHECK_FUNCS([gettimeofday])
AC_CHECK_FUNCS([inet_ntoa])
AC_CHECK_FUNCS([memset])
AC_CHECK_FUNCS([select])
AC_CHECK_FUNCS([socket])
AC_CHECK_FUNCS([strchr])
AC_CHECK_FUNCS([strerror])
AC_CHECK_FUNCS([strstr])
AC_CHECK_HEADERS([arpa/inet.h])
AC_CHECK_HEADERS([netdb.h])

AC_CHECK_HEADERS([freeradius/radius.h])
if test "$ac_cv_header_freeradius_freeradius_h" = "yes"; then
    AC_CHECK_HEADERS([stdio.h])
else
    AC_CHECK_HEADERS([libradius.h])
fi

AC_SUBST(APXS)
AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(LDFLAGS)
AC_SUBST(LIBS)
AC_SUBST(TLS)
AC_SUBST(ACTIVATE)

AC_CONFIG_HEADER(config.h)
#AC_CONFIG_FILES([Makefile])
AC_OUTPUT(Makefile)

