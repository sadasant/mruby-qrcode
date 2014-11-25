#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "mruby.h"
#include "mruby/string.h"
#include "mruby/value.h"
#include "qrcmd.h"
#include "mruby/ext/qrcode.h"

#if MRUBY_RELEASE_NO < 10000
#include "error.h"
#else
#include "mruby/error.h"
#endif

void
qr_addData(mrb_state *mrb, QRCMD_PTR_TYPE *qr, char *content, int mode) {
  qr_byte_t source[QRCMD_SRC_MAX];
  int i;
  int srclen = 0;
  int content_len = strlen(content);

  for (i = 0; i < content_len && srclen < QRCMD_SRC_MAX; i++){
    source[srclen++] = (qr_byte_t)content[i];
  }

  if (!qrCmdAddData2(qr, source, srclen, mode)) {
    char errinfo[QR_ERR_MAX];
    snprintf(&(errinfo[0]), QR_ERR_MAX, "%s", qrCmdGetErrorInfo(qr));
    qrCmdDestroy(qr);
    mrb_raisef(mrb, E_QR_ERROR, "Failed to add content: %s. %s", content, errinfo);
  }
}

mrb_value
mrb_qr_s__generate(mrb_state *mrb, mrb_value self)
{
  QRCMD_PTR_TYPE *qr;

  mrb_int version, mode, eclevel, masktype, fmt, mag;
  mrb_value content_mrb, result_mrb;

  char *content;
  int buf_size;
  qr_byte_t *buf;

  int sep     = QR_DIM_SEP;
  int errcode = QR_ERR_NONE;

  mrb_get_args(mrb, "Siiiiii", &content_mrb, &version, &mode, &eclevel, &masktype, &fmt, &mag);

  content = mrb_str_to_cstr(mrb, content_mrb);

  qr = qrInit(version, mode, eclevel, masktype, QRCMD_MAX_NUM_B &errcode);
  if (qr == NULL) {
    mrb_raisef(mrb, E_QR_ERROR, "generating the QRCode failed with error code: %d", (mrb_int)errcode);
    return mrb_nil_value();
  }

  qr_addData(mrb, qr, content, mode);

  if (!qrCmdFinalize(qr)) {
    mrb_raisef(mrb, E_QR_ERROR, "QR ERROR: %s", qrCmdGetErrorInfo(qr));
    qrCmdDestroy(qr);
    return mrb_nil_value();
  }

  buf        = qrGetSymbol(qr, fmt, sep, mag, &buf_size);
  result_mrb = mrb_str_new(mrb, buf, (size_t)buf_size);

  free(buf);

  return result_mrb;
}

void
mrb_mruby_qrcode_gem_init(mrb_state* mrb)
{
  struct RClass *qr;

  qr = mrb_define_class(mrb, "QR", mrb->object_class);

  mrb_define_class_method(mrb , qr, "_generate", mrb_qr_s__generate, MRB_ARGS_REQ(7));
}

void
mrb_mruby_qrcode_gem_final(mrb_state* mrb)
{
}
