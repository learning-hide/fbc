
#ifndef __FB_RTERR_H__
#define __FB_RTERR_H__


typedef enum _FB_RTERROR {
	FB_RTERROR_OK = 0,
	FB_RTERROR_ILLEGALFUNCTIONCALL,
	FB_RTERROR_FILENOTFOUND,
	FB_RTERROR_FILEIO,
	FB_RTERROR_OUTOFMEM,
	FB_RTERROR_ILLEGALRESUME,
	FB_RTERROR_MAX
} FB_RTERROR;


#endif /*__FB_RTERR_H__*/
