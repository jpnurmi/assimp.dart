/*
---------------------------------------------------------------------------
Open Asset Import Library (assimp)
---------------------------------------------------------------------------

Copyright (c) 2006-2019, assimp team



All rights reserved.

Redistribution and use of this software in source and binary forms,
with or without modification, are permitted provided that the following
conditions are met:

* Redistributions of source code must retain the above
  copyright notice, this list of conditions and the
  following disclaimer.

* Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the
  following disclaimer in the documentation and/or other
  materials provided with the distribution.

* Neither the name of the assimp team, nor the names of its
  contributors may be used to endorse or promote products
  derived from this software without specific prior
  written permission of the assimp team.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------
*/

import 'dart:ffi';

/** @file defs.h
 *  @brief Assimp build configuration setup. See the notes in the comment
 *  blocks to find out how to customize _your_ Assimp build.
 */

//////////////////////////////////////////////////////////////////////////
/* Define ASSIMP_DOUBLE_PRECISION to compile assimp
     * with double precision support (64-bit). */
//////////////////////////////////////////////////////////////////////////

//#ifdef ASSIMP_DOUBLE_PRECISION
//typedef double ai_real;
//typedef signed long long int ai_int;
//typedef unsigned long long int ai_uint;
//static const int ASSIMP_AI_REAL_TEXT_PRECISION = 16;
//#else // ASSIMP_DOUBLE_PRECISION
//typedef float ai_real;
//typedef signed int ai_int;
//typedef unsigned int ai_uint;
const int ASSIMP_AI_REAL_TEXT_PRECISION = 8; // 16

//////////////////////////////////////////////////////////////////////////
/* Useful constants */
//////////////////////////////////////////////////////////////////////////

/* This is PI. Hi PI. */
const double AI_MATH_PI = (3.141592653589793238462643383279);
const double AI_MATH_TWO_PI = (AI_MATH_PI * 2.0);
const double AI_MATH_HALF_PI = (AI_MATH_PI * 0.5);

/* And this is to avoid endless casts to float */
const double AI_MATH_PI_F = (3.1415926538);
const double AI_MATH_TWO_PI_F = (AI_MATH_PI_F * 2.0);
const double AI_MATH_HALF_PI_F = (AI_MATH_PI_F * 0.5);

/* Tiny macro to convert from radians to degrees and back */
double AI_DEG_TO_RAD(double x) => ((x) * 0.0174532925);
double AI_RAD_TO_DEG(double x) => ((x) * 57.2957795);

/* Numerical limits */
const double ai_epsilon = 0.00001; // ai_real
