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

#include <dlfcn.h>
#include <cstddef>

#include "h264_dlopen.h"

/*
 * The symbol binding makes sure we do not run into strict aliasing issues which
 * can lead into segfaults.
 */
typedef int (*__oh264_WelsCreateSVCEncoder)(ISVCEncoder **);
typedef void (*__oh264_WelsDestroySVCEncoder)(ISVCEncoder *);
typedef int (*__oh264_WelsGetDecoderCapability)(SDecoderCapability *);
typedef long (*__oh264_WelsCreateDecoder)(ISVCDecoder **);
typedef void (*__oh264_WelsDestroyDecoder)(ISVCDecoder *);
typedef OpenH264Version (*__oh264_WelsGetCodecVersion)(void);
typedef void (*__oh264_WelsGetCodecVersionEx)(OpenH264Version *);

#define OH264_SYMBOL_ENTRY(i)                                                  \
  union {                                                                      \
    __oh264_##i f;                                                             \
    void *obj;                                                                 \
  } _oh264_##i

struct oh264_symbols {
  OH264_SYMBOL_ENTRY(WelsCreateSVCEncoder);
  OH264_SYMBOL_ENTRY(WelsDestroySVCEncoder);
  OH264_SYMBOL_ENTRY(WelsGetDecoderCapability);
  OH264_SYMBOL_ENTRY(WelsCreateDecoder);
  OH264_SYMBOL_ENTRY(WelsDestroyDecoder);
  OH264_SYMBOL_ENTRY(WelsGetCodecVersion);
  OH264_SYMBOL_ENTRY(WelsGetCodecVersionEx);
};

/* Symbols are bound by loadLibOpenH264() */
static struct oh264_symbols openh264_symbols;

int oh264_WelsCreateSVCEncoder(ISVCEncoder **ppEncoder) {
  return openh264_symbols._oh264_WelsCreateSVCEncoder.f(ppEncoder);
}

void oh264_WelsDestroySVCEncoder(ISVCEncoder *pEncoder) {
  return openh264_symbols._oh264_WelsDestroySVCEncoder.f(pEncoder);
}

int oh264_WelsGetDecoderCapability(SDecoderCapability *pDecCapability) {
  return openh264_symbols._oh264_WelsGetDecoderCapability.f(pDecCapability);
}

long oh264_WelsCreateDecoder(ISVCDecoder **ppDecoder) {
  return openh264_symbols._oh264_WelsCreateDecoder.f(ppDecoder);
}

void oh264_WelsDestroyDecoder(ISVCDecoder *pDecoder) {
  return openh264_symbols._oh264_WelsDestroyDecoder.f(pDecoder);
}

OpenH264Version oh264_WelsGetCodecVersion(void) {
  return openh264_symbols._oh264_WelsGetCodecVersion.f();
}

void oh264_WelsGetCodecVersionEx(OpenH264Version *pVersion) {
  openh264_symbols._oh264_WelsGetCodecVersionEx.f(pVersion);
}

static void *_oh264_bind_symbol(void *handle,
                                const char *sym_name) {
    void *sym = NULL;

    sym = dlsym(handle, sym_name);
    if (sym == NULL) {
        const char *err = dlerror();
        return NULL;
    }

    return sym;
}

#define oh264_bind_symbol(handle, sym_name)                           \
  if (openh264_symbols._oh264_##sym_name.obj == NULL) {                      \
    openh264_symbols._oh264_##sym_name.obj = _oh264_bind_symbol(handle, #sym_name); \
    if (openh264_symbols._oh264_##sym_name.obj == NULL) {                    \
      return 1;                                                              \
    }                                                                        \
  }

int loadLibOpenH264(void) {
  static bool initialized = false;
  void *libopenh264 = NULL;
  const char *err = NULL;

  if (initialized) {
      return 0;
  }

#define OPENH264_LIB "libopenh264.so.7"
  libopenh264 = dlopen(OPENH264_LIB, RTLD_LAZY);
  err = dlerror();
  if (err != NULL) {
    if (libopenh264 != NULL) {
      dlclose(libopenh264);
    }
    return 1;
  }

  oh264_bind_symbol(libopenh264, WelsCreateSVCEncoder);
  oh264_bind_symbol(libopenh264, WelsDestroySVCEncoder);
  oh264_bind_symbol(libopenh264, WelsGetDecoderCapability);
  oh264_bind_symbol(libopenh264, WelsCreateDecoder);
  oh264_bind_symbol(libopenh264, WelsDestroyDecoder);
  oh264_bind_symbol(libopenh264, WelsGetCodecVersion);
  oh264_bind_symbol(libopenh264, WelsGetCodecVersionEx);

  initialized = true;

  return 0;
}
