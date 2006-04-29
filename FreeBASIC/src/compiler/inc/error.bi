#ifndef __ERROR_BI__
#define __ERROR_BI__

''	FreeBASIC - 32-bit BASIC Compiler.
''	Copyright (C) 2004-2006 Andre Victor T. Vicentini (av1ctor@yahoo.com.br)
''
''	This program is free software; you can redistribute it and/or modify
''	it under the terms of the GNU General Public License as published by
''	the Free Software Foundation; either version 2 of the License, or
''	(at your option) any later version.
''
''	This program is distributed in the hope that it will be useful,
''	but WITHOUT ANY WARRANTY; without even the implied warranty of
''	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
''	GNU General Public License for more details.
''
''	You should have received a copy of the GNU General Public License
''	along with this program; if not, write to the Free Software
''	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA.

'' errors
enum FBERRMSG_ENUM
	FB_ERRMSG_OK
	FB_ERRMSG_ARGCNTMISMATCH
	FB_ERRMSG_EXPECTEDEOF
	FB_ERRMSG_EXPECTEDEOL
	FB_ERRMSG_DUPDEFINITION
	FB_ERRMSG_EXPECTINGAS
	FB_ERRMSG_EXPECTEDLPRNT
	FB_ERRMSG_EXPECTEDRPRNT
	FB_ERRMSG_UNDEFINEDSYMBOL
	FB_ERRMSG_EXPECTEDEXPRESSION
	FB_ERRMSG_EXPECTEDEQ
	FB_ERRMSG_EXPECTEDCONST
	FB_ERRMSG_EXPECTEDTO
	FB_ERRMSG_EXPECTEDNEXT
	FB_ERRMSG_EXPECTEDVAR
	FB_ERRMSG_EXPECTEDIDENTIFIER		= FB_ERRMSG_EXPECTEDVAR
	FB_ERRMSG_TABLESFULL
	FB_ERRMSG_EXPECTEDMINUS
	FB_ERRMSG_EXPECTEDCOMMA
	FB_ERRMSG_SYNTAXERROR
	FB_ERRMSG_ELEMENTNOTDEFINED
	FB_ERRMSG_EXPECTEDENDTYPE
	FB_ERRMSG_TYPEMISMATCH
	FB_ERRMSG_INTERNAL
	FB_ERRMSG_PARAMTYPEMISMATCH
	FB_ERRMSG_FILENOTFOUND
	FB_ERRMSG_ILLEGALOUTSIDEASTMT
	FB_ERRMSG_INVALIDDATATYPES
	FB_ERRMSG_INVALIDCHARACTER
	FB_ERRMSG_FILEACCESSERROR
	FB_ERRMSG_RECLEVELTOODEPTH
	FB_ERRMSG_EXPECTEDPOINTER
	FB_ERRMSG_EXPECTEDLOOP
	FB_ERRMSG_EXPECTEDWEND
	FB_ERRMSG_EXPECTEDTHEN
	FB_ERRMSG_EXPECTEDENDIF
	FB_ERRMSG_ILLEGALEND
	FB_ERRMSG_EXPECTEDCASE
	FB_ERRMSG_EXPECTEDENDSELECT
	FB_ERRMSG_WRONGDIMENSIONS
	FB_ERRMSG_INNERPROCNOTALLOWED
	FB_ERRMSG_EXPECTEDENDSUBORFUNCT
	FB_ERRMSG_ILLEGALPARAMSPEC
	FB_ERRMSG_VARIABLENOTDECLARED
	FB_ERRMSG_VARIABLEREQUIRED
	FB_ERRMSG_ILLEGALOUTSIDECOMP
	FB_ERRMSG_EXPECTEDENDASM
	FB_ERRMSG_PROCNOTDECLARED
	FB_ERRMSG_EXPECTEDSEMICOLON
	FB_ERRMSG_UNDEFINEDLABEL
	FB_ERRMSG_TOOMANYDIMENSIONS
	FB_ERRMSG_EXPECTEDSCALAR
	FB_ERRMSG_ILLEGALOUTSIDEASUB
	FB_ERRMSG_EXPECTEDDYNAMICARRAY
	FB_ERRMSG_CANNOTRETURNFIXLENFROMFUNCTS
	FB_ERRMSG_ARRAYALREADYDIMENSIONED
	FB_ERRMSG_ILLEGALRESUMEERROR
	FB_ERRMSG_PARAMTYPEMISMATCHAT
	FB_ERRMSG_ILLEGALPARAMSPECAT
	FB_ERRMSG_EXPECTEDENDWITH
	FB_ERRMSG_ILLEGALINSIDEASUB
	FB_ERRMSG_EXPECTEDARRAY
	FB_ERRMSG_EXPECTEDLBRACKET
	FB_ERRMSG_EXPECTEDRBRACKET
	FB_ERRMSG_TOOMANYEXPRESSIONS
	FB_ERRMSG_EXPECTEDRESTYPE
	FB_ERRMSG_RANGETOOLARGE
	FB_ERRMSG_FORWARDREFNOTALLOWED
	FB_ERRMSG_INCOMPLETETYPE
	FB_ERRMSG_ARRAYNOTALLOCATED
	FB_ERRMSG_EXPECTEDINDEX
	FB_ERRMSG_EXPECTEDENDENUM
	FB_ERRMSG_CANTINITDYNAMICARRAYS
	FB_ERRMSG_INVALIDBITFIELD
	FB_ERRMSG_TOOMANYPARAMS
	FB_ERRMSG_MACROTEXTTOOLONG
	FB_ERRMSG_INVALIDCMDOPTION
	FB_ERRMSG_CANTINITDYNAMICSTRINGS
	FB_ERRMSG_RECURSIVEUDT
	FB_ERRMSG_RECURSIVEMACRO
	FB_ERRMSG_CANTREDIMARRAYFIELDS
	FB_ERRMSG_CANTINCLUDEPERIODS
	FB_ERRMSG_EXEMISSING
	FB_ERRMSG_ARRAYOUTOFBOUNDS
	FB_ERRMSG_MISSINGCMDOPTION
	FB_ERRMSG_MATHOVERFLOW
	FB_ERRMSG_EXPECTEDANY
	FB_ERRMSG_EXPECTEDENDSCOPE
	FB_ERRMSG_ILLEGALINSIDEASCOPE
	FB_ERRMSG_CANTPASSUDTRESULTBYREF
	FB_ERRMSG_AMBIGUOUSCALLTOPROC
	FB_ERRMSG_NOMATCHINGPROC
	FB_ERRMSG_DIVBYZERO
	FB_ERRMSG_STACKUNDERFLOW
	FB_ERRMSG_CANTINITDYNAMICFIELDS
	FB_ERRMSG_BRANCHTOBLOCKWITHLOCALVARS
	FB_ERRMSG_BRANCHTARTGETOUTSIDECURRPROC
	FB_ERRMSG_BRANCHCROSSINGDYNDATADEF

	FB_ERRMSGS
end enum

enum FBWARNINGMSG_ENUM
	FB_WARNINGMSG_PASSINGSCALARASPTR			= 1
	FB_WARNINGMSG_PASSINGPTRTOSCALAR
	FB_WARNINGMSG_PASSINGDIFFPOINTERS
	FB_WARNINGMSG_SUSPICIOUSPTRASSIGN
	FB_WARNINGMSG_IMPLICITCONVERSION
	FB_WARNINGMSG_CANNOTEXPORT
	FB_WARNINGMSG_IDNAMETOOBIG
	FB_WARNINGMSG_NUMBERTOOBIG
	FB_WARNINGMSG_LITSTRINGTOOBIG
	FB_WARNINGMSG_POINTERFIELDS
	FB_WARNINGMSG_DYNAMICFIELDS
	FB_WARNINGMSG_IMPLICITALLOCATION

	FB_WARNINGMSGS
end enum

'' runtime errors
enum FBRTERROR_ENUM
	FB_RTERROR_OK = 0
	FB_RTERROR_ILLEGALFUNCTIONCALL
	FB_RTERROR_FILENOTFOUND
	FB_RTERROR_FILEIO
	FB_RTERROR_OUTOFMEM
	FB_RTERROR_ILLEGALRESUME
	FB_RTERROR_OUTOFBOUNDS
	FB_RTERROR_SIGINT
	FB_RTERROR_SIGILL
	FB_RTERROR_SIGFPE
	FB_RTERROR_SIGSEGV
	FB_RTERROR_SIGTERM
	FB_RTERROR_SIGABRT
	FB_RTERROR_SIGQUIT
end enum


declare	sub 		errInit					( )

declare	sub 		errEnd					( )

declare sub 		hReportErrorEx			( byval errnum as integer, _
											  byval msgex as zstring ptr, _
											  byval linenum as integer = 0 )

declare sub 		hReportError			( byval errnum as integer, _
											  byval isbefore as integer = FALSE )

declare function 	hGetLastError 			( ) as integer

declare function 	hGetErrorCnt 			( ) as integer

declare sub 		hReportWarning			( byval msgnum as integer, _
											  byval msgex as zstring ptr = NULL )

declare sub 		hReportParamError		( byval proc as any ptr, _
					   						  byval pnum as integer, _
					   						  byval pid as zstring ptr, _
					   						  byval msgnum as integer )

declare sub 		hReportParamWarning		( byval proc as any ptr, _
					   						  byval pnum as integer, _
					   						  byval pid as zstring ptr, _
					   						  byval msgnum as integer )
#endif ''__ERROR_BI__
