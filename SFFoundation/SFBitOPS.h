//
//  SFBitOPS.h
//  SFFoundation
//
//  Created by vvveiii on 2019/7/4.
//  Copyright © 2019 lvv. All rights reserved.
//

#ifndef SFBITOPS_H
#define SFBITOPS_H

// https://www.coranac.com/documents/working-with-bits-and-bitfields/

#if !defined(BIT)
#   define BIT(n)                  ( 1UL << (n) )
#endif

#if !defined(BIT_SET)
#   define BIT_SET(y, mask)        ( y |=  (mask) )
#endif

#if !defined(BIT_CLEAR)
#   define BIT_CLEAR(y, mask)      ( y &= ~(mask) )
#endif

#if !defined(BIT_FLIP)
#   define BIT_FLIP(y, mask)       ( y ^=  (mask) )
#endif

#if !defined(BIT_TEST)
#   define BIT_TEST(y, mask)    ( ((y) & (mask)) != 0 )
#endif

//! Create a bitmask of length \a len.
#if !defined(BIT_MASK)
#   define BIT_MASK(len)           ( BIT(len) - 1UL )
#endif

//! Create a bitfield mask of length \a starting at bit \a start.
#if !defined(BF_MASK)
#   define BF_MASK(start, len)     ( BIT_MASK(len) << (start) )
#endif

//! Prepare a bitmask for insertion or combining.
#if !defined(BF_PREP)
#   define BF_PREP(x, start, len)  ( ((x) & BIT_MASK(len)) << (start) )
#endif


//! Extract a bitfield of length \a len starting at bit \a start from \a y.
#if !defined(BF_GET)
#   define BF_GET(y, start, len)   ( ((y) >> (start)) & BIT_MASK(len) )
#endif

//! Insert a new bitfield value \a x into \a y.
#if !defined(BF_SET)
#   define BF_SET(y, x, start, len)    ( y= ((y) &~ BF_MASK(start, len)) | BF_PREP(x, start, len) )
#endif

#endif /* SFBITOPS_H */
