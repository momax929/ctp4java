%module ctp

%{
#include "../lib/ThostFtdcUserApiDataType.h"
#include "../lib/ThostFtdcUserApiStruct.h"
%}

// Disable all member variable access to prevent initialization code generation
%feature("nodefaultctor");
%feature("noproxy");

// Don't generate getters/setters for struct members with char arrays
%typemap(globalin) SWIGTYPE * "";

%include "../lib/ThostFtdcUserApiDataType.h"
%include "../lib/ThostFtdcUserApiStruct.h"
