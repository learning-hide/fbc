/* libfb initialization */

#include "fb.h"
#include <locale.h>

FB_RTLIB_CTX __fb_ctx /* not initialized */;
static int __fb_is_inicnt = 0;

/* called from fbrt0 */
void fb_hRtInit( void )
{
	/* already initialized? */
	++__fb_is_inicnt;
	if( __fb_is_inicnt != 1 )
		return;

	/* initialize context */
	memset( &__fb_ctx, 0, sizeof( FB_RTLIB_CTX ) );
    
	/* os-dep initialization */
	fb_hInit( );

#ifdef ENABLE_MT
	fb_TlsInit( );
#endif

	/**
	 * With the default "C" locale (which is just plain 7-bit ASCII),
	 * our mbstowcs() calls (from fb_wstr_ConvFromA()) fail to convert
	 * zstrings specific to the user's locale to Unicode wstrings.
	 *
	 * To fix this we must tell the CRT to use the user's locale setting,
	 * i.e. the locale given by LC_* or LANG environment variables.
	 *
	 * We should change the LC_CTYPE setting only, to affect the behaviour
	 * of the codepage <-> Unicode conversion functions, but not for
	 * example LC_NUMERIC, which would affect things like the decimal
	 * separator used by float <-> string conversion functions.
	 *
	 * Don't bother doing it under DJGPP - there we don't really support
	 * wstrings anyways, and the setlocale() reference increases .exe size.
	 */
#ifndef HOST_DOS
	setlocale( LC_CTYPE, "" );
#endif
}

/* called from fbrt0 */
void fb_hRtExit( void )
{
	--__fb_is_inicnt;
	if( __fb_is_inicnt != 0 )
		return;

	/* Doing clean-up here in the rtlib's global dtor, instead of using
	   atexit().

	   FB supports global ctors/dtors, and thus FB programs can call FB
	   functions from there. Hence the rtlib/gfxlib2 initialization must
	   be the first global ctor, and the clean-up must be the last global
	   dtor. This is done by fbrt0.c. We can't rely on atexit() for this,
	   because sometimes the atexit handlers can be called before the global
	   dtors, sometimes after.

	   Some observations about atexit() behaviour: it depends on context,
	   e.g. whether it's called from a global ctor or global dtor or main(),
	   or whether it's a shared lib/DLL or executable,
	   and it depends on the platform (e.g. GNU/Linux vs MinGW-w64). */

	fb_FileReset( );

	if( __fb_ctx.exit_gfxlib2 )
		__fb_ctx.exit_gfxlib2( );

	/* os-dep termination */
	fb_hEnd( 0 );

#ifdef ENABLE_MT
	fb_TlsExit( );
#endif

	/* If an error message was stored, print it now, after the console was
	   cleaned up. At least the DOS gfxlib clears the console on exit,
	   thus any error messages must be printed after that or they would
	   not be visible. */
	if( __fb_ctx.errmsg )
		fputs( __fb_ctx.errmsg, stderr );
}

/* called by FB program */
FBCALL void fb_Init( int argc, char **argv, int lang )
{
	__fb_ctx.argc = argc;
	__fb_ctx.argv = argv;
	__fb_ctx.lang = lang;
}

/* called by FB program */
FBCALL void fb_End( int errlevel )
{
	exit( errlevel );
}
