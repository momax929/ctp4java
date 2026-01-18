%module ctp

%{
// Minimize what we include
#include "../lib/ThostFtdcUserApiDataType.h"
%}

// Use minimal wrapping - only process typedefs and critical structures
%include "../lib/ThostFtdcUserApiDataType.h"
