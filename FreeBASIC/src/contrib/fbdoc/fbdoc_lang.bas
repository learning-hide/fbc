''  fbdoc - FreeBASIC User's Manual Converter/Generator
''	Copyright (C) 2006 Jeffery R. Marshall (coder[at]execulink.com) and
''  the FreeBASIC development team.
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


'' fbdoc_lang
''
'' chng: jun/2006 written [coderJeff]
''

option explicit

#include once "common.bi"
#include once "COptions.bi"

dim shared as COptions ptr lang = NULL

'':::::
sub Lang_Create( )

	if( lang <> NULL ) then
		exit sub
	end if

	lang = COptions_New( )

end sub

'':::::
sub Lang_Destroy( )
	if( lang = NULL ) then
		exit sub
	end if
	
	COptions_Delete( lang )
	lang = NULL
	
end sub

'':::::
function Lang_LoadOptions _
	( _
		byval sFileName as zstring ptr, _
		byval bNoReset as integer _
	) as integer

	Lang_Create
	Lang_Create

	if( lang = NULL ) then
		return FALSE
	end if
		
	if( bNoReset = FALSE ) then
		COptions_Clear( lang )
	end if

	function = COptions_ReadFromFile( lang, sFileName )

end function

function Lang_GetOption _
	( _
		byval sKey as zstring ptr, _
		byval sDefault as zstring ptr _
	) as string

	if( lang = NULL ) then
		return ""
	end if
	
	function = COptions_Get( lang, sKey, sDefault )

end function

function Lang_ExpandString _
	( _
		byval sText as zstring  ptr _
	) as string

	return COptions_ExpandString( lang, sText )

end function
