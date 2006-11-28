''	FreeBASIC - 32-bit BASIC Compiler.
''	Copyright (C) 2004-2007 The FreeBASIC development team.
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


'' atom constants and literals parsing
''
'' chng: sep/2004 written [v1ctor]


#include once "inc\fb.bi"
#include once "inc\fbint.bi"
#include once "inc\parser.bi"
#include once "inc\ast.bi"

'':::::
function cConstantEx _
	( _
		byval sym as FBSYMBOL ptr, _
		byref expr as ASTNODE ptr _
	) as integer

	dim as integer dtype = any
	dim as FBSYMBOL ptr subtype = any

  	'' ID
  	lexSkipToken( )

	dtype = symbGetType( sym )
	subtype = symbGetSubType( sym )

  	select case as const dtype
  	case FB_DATATYPE_CHAR, FB_DATATYPE_WCHAR
  		expr = astNewVAR( symbGetConstValStr( sym ), 0, dtype )

  	case FB_DATATYPE_ENUM
  		expr = astNewENUM( symbGetConstValInt( sym ), subtype )

  	case FB_DATATYPE_LONGINT, FB_DATATYPE_ULONGINT
  		expr = astNewCONSTl( symbGetConstValLong( sym ), dtype )

  	case FB_DATATYPE_SINGLE, FB_DATATYPE_DOUBLE
  		expr = astNewCONSTf( symbGetConstValFloat( sym ), dtype )

  	case FB_DATATYPE_LONG, FB_DATATYPE_ULONG
  		if( FB_LONGSIZE = len( integer ) ) then
  			expr = astNewCONSTi( symbGetConstValInt( sym ), dtype, subtype )
  		else
  			expr = astNewCONSTl( symbGetConstValLong( sym ), dtype )
  		end if

  	case else
  		expr = astNewCONSTi( symbGetConstValInt( sym ), dtype, subtype )

  	end select

  	function = TRUE

end function

'':::::
'' EnumConstant	=		ID '.' ID .
''
function cEnumConstant _
	( _
		byval parent as FBSYMBOL ptr, _
		byref expr as ASTNODE ptr _
	) as integer static

	dim as FBSYMBOL ptr elm
	dim as FBSYMCHAIN ptr chain_

	function = FALSE

	'' ID
	lexSkipToken( )

	'' '.'
	lexSkipToken( LEXCHECK_NOPERIOD )

	'' ID
    select case lexGetClass( )
    case FB_TKCLASS_IDENTIFIER, FB_TKCLASS_QUIRKWD

    case else
		if( errReport( FB_ERRMSG_EXPECTEDIDENTIFIER ) = FALSE ) then
			exit function
		else
			'' error recovery: fake a node
			expr = astNewCONSTi( 0, FB_DATATYPE_INTEGER )
			return TRUE
		end if
	end select

	chain_ = symbLookupAt( symbGetNamespace( parent ), lexGetText( ), FALSE )

	elm = symbFindByClass( chain_, FB_SYMBCLASS_CONST )
    if( elm = NULL ) then
    	if( errReportUndef( FB_ERRMSG_ELEMENTNOTDEFINED, lexGetText( ) ) = FALSE ) then
    		exit function
		else
			'' error recovery: fake a node
			lexSkipToken( )
			expr = astNewCONSTi( 0, FB_DATATYPE_INTEGER )
			return TRUE
		end if
    end if

    if( symbGetParent( elm ) <> parent ) then
    	if( errReportUndef( FB_ERRMSG_ELEMENTNOTDEFINED, lexGetText( ) ) = FALSE ) then
    		exit function
		else
			'' error recovery: fake a node
			lexSkipToken( )
			expr = astNewCONSTi( 0, FB_DATATYPE_INTEGER )
			return TRUE
		end if
    end if

    function = cConstantEx( elm, expr )

end function

'':::::
'' Constant       = ID .
''
function cConstant _
	( _
		byval chain_ as FBSYMCHAIN ptr, _
		byref expr as ASTNODE ptr _
	) as integer static

	dim as FBSYMBOL ptr sym

	sym = symbFindByClass( chain_, FB_SYMBCLASS_CONST )
	if( sym <> NULL ) then
  		function = cConstantEx( sym, expr )
  	else
		function = FALSE
  	end if

end function

'':::::
'' LitString	= 	STR_LITERAL STR_LITERAL* .
''
function cStrLiteral _
	( _
		byref expr as ASTNODE ptr _
	) as integer static

    dim as integer dtype
	dim as FBSYMBOL ptr sym
    dim as integer lgt, isunicode
    dim as zstring ptr zs
	dim as wstring ptr ws

    expr = NULL

	do
  		dtype = lexGetType( )
		lgt = lexGetTextLen( )

  		if( dtype <> FB_DATATYPE_WCHAR ) then
			'' escaped? convert to internal format..
			if( lexGetToken( ) = FB_TK_STRLIT_ESC ) then
				zs = hReEscape( lexGetText( ), lgt, isunicode )
			else
				zs = lexGetText( )

				'' any '\'?
				if( lexGetHasSlash( ) ) then
					if( fbPdCheckIsSet( FB_PDCHECK_ESCSEQ ) ) then
						if( lexGetToken( ) <> FB_TK_STRLIT_NOESC ) then
							if( hHasEscape( zs ) ) then
								errReportWarn( FB_WARNINGMSG_POSSIBLEESCSEQ, _
										   	   zs, _
										   	   FB_ERRMSGOPT_ADDCOLON or FB_ERRMSGOPT_ADDQUOTES )
							end if
						end if
					end if
				end if

				isunicode = FALSE
			end if

			if( isunicode = FALSE ) then
               	sym = symbAllocStrConst( zs, lgt )
			'' convert to unicode..
			else
				sym = symbAllocWstrConst( wstr( *zs ), lgt )
				dtype = FB_DATATYPE_WCHAR
			end if

  		else
			'' escaped? convert to internal format..
			if( lexGetToken( ) = FB_TK_STRLIT_ESC ) then
				ws = hReEscapeW( lexGetTextW( ), lgt )
			else
				ws = lexGetTextW( )

				'' any '\'?
				if( lexGetHasSlash( ) ) then
					if( fbPdCheckIsSet( FB_PDCHECK_ESCSEQ ) ) then
						if( lexGetToken( ) <> FB_TK_STRLIT_NOESC ) then
							if( hHasEscapeW( ws ) ) then
								errReportWarn( FB_WARNINGMSG_POSSIBLEESCSEQ )
							end if
						end if
					end if
				end if
			end if

			sym = symbAllocWstrConst( ws, lgt )
		end if

		if( expr = NULL ) then
			expr = astNewVAR( sym, 0, dtype )
		else
			expr = astNewBOP( AST_OP_ADD, expr, astNewVAR( sym, 0, dtype ) )
		end if

		lexSkipToken( )

  		'' not another literal string?
  		if( lexGetClass( ) <> FB_TKCLASS_STRLITERAL ) then
			exit do
		end if
	loop

	function = TRUE

end function

'':::::
function cNumLiteral _
	( _
		byref expr as ASTNODE ptr, _
		byval skiptoken as integer _
	) as integer

	dim as integer dtype = any

  	dtype = lexGetType( )
  	select case as const dtype
  	case FB_DATATYPE_LONGINT
		expr = astNewCONSTl( vallng( *lexGetText( ) ), dtype )

	case FB_DATATYPE_ULONGINT
		expr = astNewCONSTl( valulng( *lexGetText( ) ), dtype )

  	case FB_DATATYPE_SINGLE, FB_DATATYPE_DOUBLE
		expr = astNewCONSTf( val( *lexGetText( ) ), dtype )

	case FB_DATATYPE_UINT
		expr = astNewCONSTi( valuint( *lexGetText( ) ), dtype )

  	case FB_DATATYPE_LONG
		if( FB_LONGSIZE = len( integer ) ) then
			expr = astNewCONSTi( valint( *lexGetText( ) ), dtype )
		else
			expr = astNewCONSTl( vallng( *lexGetText( ) ), dtype )
		end if

	case FB_DATATYPE_ULONG
		if( FB_LONGSIZE = len( integer ) ) then
			expr = astNewCONSTi( valuint( *lexGetText( ) ), dtype )
		else
			expr = astNewCONSTl( valulng( *lexGetText( ) ), dtype )
		end if

	case else
		expr = astNewCONSTi( valint( *lexGetText( ) ), dtype )
  	end select

  	if( skiptoken ) then
  		lexSkipToken( )
  	end if

  	function = TRUE

end function

'':::::
''Literal		  = NUM_LITERAL
''				  | STR_LITERAL STR_LITERAL* .
''
function cLiteral _
	( _
		byref litexpr as ASTNODE ptr _
	) as integer

	function = FALSE

	select case lexGetClass( )
	'' NUM_LITERAL?
	case FB_TKCLASS_NUMLITERAL
		return cNumLiteral( litexpr )

  	'' (STR_LITERAL STR_LITERAL*)?
  	case FB_TKCLASS_STRLITERAL
        return cStrLiteral( litexpr )

  	end select

end function

