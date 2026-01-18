%module(directors="1") ctp

// Suppress problematic warnings and directives
%{
#define SWIG_PYTHON_STRICT_BYTE_CHAR
#include "../lib/ThostFtdcUserApiDataType.h"
#include "../lib/ThostFtdcUserApiStruct.h"
#include "../lib/ThostFtdcMdApi.h"
#include "../lib/ThostFtdcTraderApi.h"
%}

// Typemaps for char arrays (C-style strings)
%typemap(jstype) char[ANY] "String"
%typemap(jtype) char[ANY] "String"
%typemap(jni) char[ANY] "jstring"

%typemap(in) char[ANY] (char temp[$1_dim0]) {
  if ($input) {
    const char *$1_str = jenv->GetStringUTFChars($input, 0);
    strncpy(temp, $1_str, $1_dim0 - 1);
    temp[$1_dim0 - 1] = '\0';
    jenv->ReleaseStringUTFChars($input, $1_str);
  } else {
    temp[0] = '\0';
  }
  $1 = temp;
}

%typemap(out) char[ANY] {
  $result = jenv->NewStringUTF($1);
}

%typemap(javaout) char[ANY] {
  return $jnicall;
}

// Include headers with SWIG directives to handle problematic definitions
%ignore CThostFtdcReqUserLoginField::OneTimePassword;

%include "../lib/ThostFtdcUserApiDataType.h"
%include "../lib/ThostFtdcUserApiStruct.h"
%include "../lib/ThostFtdcMdApi.h"
%include "../lib/ThostFtdcTraderApi.h"
