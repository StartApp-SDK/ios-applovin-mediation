/**
 * Copyright 2021 Start.io Inc
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "StartioAppLovinAdapterError.h"
#import <StartApp/STAErrorCodes.h>

@implementation StartioAppLovinAdapterError
+ (MAAdapterError *)maAdapterErrorFromSTAError:(NSError *)error {
    NSInteger maAdapterErrorCode = 0;
    MAAdapterError *adapterError = nil;
    if (error) {
        switch ((STAError)error.code) {
            case STAErrorUnexpected:
                maAdapterErrorCode = MAAdapterError.errorCodeUnspecified;
                break;
            case STAErrorNoInternetConnection:
                maAdapterErrorCode = MAAdapterError.errorCodeNoConnection;
                break;
            case STAErrorInternal:
                maAdapterErrorCode = MAAdapterError.errorCodeInternalError;
                break;
            case STAErrorAppIDNotSet:
                maAdapterErrorCode = MAAdapterError.errorCodeNotInitialized;
                break;
            case STAErrorInvalidParams:
                maAdapterErrorCode = MAAdapterError.errorCodeInvalidConfiguration;
                break;
            case STAErrorAdRules:
                maAdapterErrorCode = MAAdapterError.errorCodeInternalError;
                break;
            case STAErrorExpectedAdParamsMissingOrInvalid:
                maAdapterErrorCode = MAAdapterError.errorCodeInternalError;
                break;
            case STAErrorAdTypeNotSupported:
                maAdapterErrorCode = MAAdapterError.errorCodeInternalError;
                break;
            case STAErrorAdAlreadyDisplayed:
                maAdapterErrorCode = MAAdapterError.errorCodeInternalError;
                break;
            case STAErrorAdExpired:
                maAdapterErrorCode = MAAdapterError.errorCodeAdExpired;
                break;
            case STAErrorAdNotReady:
                maAdapterErrorCode = MAAdapterError.errorCodeAdNotReady;
                break;
            case STAErrorAdIsLoading:
                maAdapterErrorCode = MAAdapterError.errorCodeInvalidLoadState;
                break;
            case STAErrorNoContent:
                maAdapterErrorCode = MAAdapterError.errorCodeNoFill;
                break;
            default:
                maAdapterErrorCode = MAAdapterError.errorCodeUnspecified;
                break;
        }
        adapterError = [MAAdapterError errorWithCode:maAdapterErrorCode errorString:error.localizedDescription thirdPartySdkErrorCode:error.code thirdPartySdkErrorMessage:error.localizedDescription];
    }
    else {
        adapterError = [MAAdapterError errorWithCode:MAAdapterError.errorCodeUnspecified errorString:@"StartAppSDK failed to load ad" thirdPartySdkErrorCode:-1 thirdPartySdkErrorMessage:@"Error not set"];
    }
    return adapterError;
}
@end
