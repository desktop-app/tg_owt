/*
 * OpenH264 dlopen code
 *
 *  Copyright (c) 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef HAVE_LIBOPENH264_DLOPEN_H
#define HAVE_LIBOPENH264_DLOPEN_H

#ifdef WEBRTC_USE_H264_DLOPEN

#include <wels/codec_api.h>
#include <wels/codec_ver.h>

int oh264_WelsCreateSVCEncoder(ISVCEncoder **ppEncoder);
#define WelsCreateSVCEncoder oh264_WelsCreateSVCEncoder

void oh264_WelsDestroySVCEncoder(ISVCEncoder *pEncoder);
#define WelsDestroySVCEncoder oh264_WelsDestroySVCEncoder

int oh264_WelsGetDecoderCapability(SDecoderCapability *pDecCapability);
#define WelsGetDecoderCapability oh264_WelsGetDecoderCapability

long oh264_WelsCreateDecoder(ISVCDecoder **ppDecoder);
#define WelsCreateDecoder oh264_WelsCreateDecoder

void oh264_WelsDestroyDecoder(ISVCDecoder *pDecoder);
#define WelsDestroyDecoder oh264_WelsDestroyDecoder

OpenH264Version oh264_WelsGetCodecVersion(void);
#define WelsGetCodecVersion oh264_WelsGetCodecVersion

void oh264_WelsGetCodecVersionEx(OpenH264Version *pVersion);
#define WelsGetCodecVersionEx oh264_WelsGetCodecVersionEx

int loadLibOpenH264(void);

#endif /* WEBRTC_USE_H264_DLOPEN */

#endif /* HAVE_LIBOPENH264_DLOPEN_H */
