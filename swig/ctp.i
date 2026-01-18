%module(directors="1") ctp

%{
#include "../lib/ThostFtdcUserApiDataType.h"
#include "../lib/ThostFtdcUserApiStruct.h"
#include "../lib/ThostFtdcMdApi.h"
#include "../lib/ThostFtdcTraderApi.h"
%}

// Disable default constructors and char array initialization
%feature("nodefaultctor");
%feature("nodefaultdtor");

// Handle char arrays as byte arrays to avoid string literal issues
%apply char [] { char* };

%typemap(javacode) SWIGTYPE %{
  public String get_string_field(String fieldName) {
    // Custom getter for string fields
    return "";
  }
  
  public void set_string_field(String fieldName, String value) {
    // Custom setter for string fields
  }
%}

// Typemap for char[N] - treat as byte array buffer
%typemap(jstype) char [ANY] "byte[]"
%typemap(jtype) char [ANY] "byte[]"
%typemap(jni) char [ANY] "jbyteArray"

%typemap(in) char [ANY] (char temp[$1_dim0]) {
  jbyte *arr = jenv->GetByteArrayElements($input, 0);
  memcpy(temp, arr, $1_dim0);
  jenv->ReleaseByteArrayElements($input, arr, 0);
  $1 = temp;
}

%typemap(out) char [ANY] {
  jbyteArray jarr = jenv->NewByteArray($1_dim0);
  jenv->SetByteArrayRegion(jarr, 0, $1_dim0, (jbyte*)$1);
  $result = jarr;
}

%typemap(javaout) char [ANY] {
  return $jnicall;
}

%typemap(javadir) char [ANY] "inout"

// Skip problematic enum/macro definitions that might cause issues
#define SWIG_SKIP_TYPEDEFS 1

%include "../lib/ThostFtdcUserApiDataType.h"
%include "../lib/ThostFtdcUserApiStruct.h"
%include "../lib/ThostFtdcMdApi.h"
%include "../lib/ThostFtdcTraderApi.h"
