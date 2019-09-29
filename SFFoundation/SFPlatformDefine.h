//
//  SFPlatformDefine.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/26.
//  Copyright © 2019 lvv. All rights reserved.
//

#ifndef SFPlatformDefine_h
#define SFPlatformDefine_h

#if SF_MACOS
#   define SFColor NSColor
#   define SFImage NSImage
#   define SFBezierPath NSBezierPath
#   define UIEdgeInsets NSEdgeInsets
#   define UIImageResizingMode NSImageResizingMode
#   define UIImageResizingModeStretch NSImageResizingModeStretch
#   define UIImageResizingModeTile NSImageResizingModeTile
#endif

#if SF_IOS
#   define SFColor UIColor
#   define SFImage UIImage
#   define SFBezierPath UIBezierPath
#endif

#if !defined(SF_EXTERN)
#   if defined(__cplusplus)
#       define SF_EXTERN extern "C"
#   else
#       define SF_EXTERN extern
#   endif
#endif

#if !defined(SF_EXTERN_C_BEGIN)
#   ifdef __cplusplus
#       define SF_EXTERN_C_BEGIN extern "C" {
#       define SF_EXTERN_C_END   }
#   else
#       define SF_EXTERN_C_BEGIN
#       define SF_EXTERN_C_END
#   endif
#endif

#if !defined(LONG)
#   define LONG    long
#endif

#if !defined(ULONG)
#   define ULONG    unsigned long
#endif

#if !defined(LONGLONG)
#   define LONGLONG    long long
#endif

#if !defined(ULONGLONG)
#   define ULONGLONG    unsigned long long
#endif

#if !defined(atomic_inc_return)
#   define atomic_inc_return(v)    (atomic_fetch_add(v, 1) + 1)
#endif

#if !defined(atomic_dec_return)
#   define atomic_dec_return(v)    (atomic_fetch_sub(v, 1) - 1)
#endif

#endif /* SFPlatformDefine_h */
