%module ctp

%{
#include "../lib/ThostFtdcMdApi.h"
#include "../lib/ThostFtdcTraderApi.h"
#include "../lib/ThostFtdcUserApiDataType.h"
#include "../lib/ThostFtdcUserApiStruct.h"
%}

%include "../lib/ThostFtdcUserApiDataType.h"
%include "../lib/ThostFtdcUserApiStruct.h"
%include "../lib/ThostFtdcMdApi.h"
%include "../lib/ThostFtdcTraderApi.h"
