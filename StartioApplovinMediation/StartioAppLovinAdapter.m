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

#import "StartioAppLovinAdapter.h"
#import "StartioAppLovinAdViewAdapter.h"
#import "StartioAppLovinInterstitialAdapter.h"
#import "StartioAppLovinRewardedAdapter.h"
#import "StartioAppLovinNativeAdapter.h"
@import StartApp;

static NSString * const kAdapterVersion = @"1.2.3";

static NSString * const kAppIdKey = @"app_id";

@interface StartioAppLovinAdapter()<MAAdViewAdapter, MAInterstitialAdapter, MARewardedAdapter, MANativeAdAdapter>
@property (nonatomic, strong) StartioAppLovinAdViewAdapter *adViewAdapter;
@property (nonatomic, strong) StartioAppLovinInterstitialAdapter *interstitialAdapter;
@property (nonatomic, strong) StartioAppLovinRewardedAdapter *rewardedAdapter;
@property (nonatomic, strong) StartioAppLovinNativeAdapter *nativeAdapter;
@end

@implementation StartioAppLovinAdapter

- (void)initializeWithParameters:(id<MAAdapterInitializationParameters>)parameters completionHandler:(nonnull void (^)(MAAdapterInitializationStatus, NSString * _Nullable))completionHandler {
    NSString *appID = parameters.serverParameters[kAppIdKey];
    if (appID.length != 0) {
        [self executeBlockOnMainThread:^{
            [self setupStartioSDKWithAppID:appID parameters:parameters];
        }];
        completionHandler(MAAdapterInitializationStatusInitializedSuccess, nil);
    }
    else {
        completionHandler(MAAdapterInitializationStatusInitializing, @"No Start.io AppID provided yet");
    }
}

- (void)setupStartioSDKWithAppID:(NSString *)appID parameters:(id<MAAdapterInitializationParameters>)parameters {
    STAStartAppSDK *sdk = [STAStartAppSDK sharedInstance];
    sdk.returnAdEnabled = NO;
    sdk.appID = appID;
    [sdk handleExtras:^(NSMutableDictionary<NSString *,id> *extras) {
        if (parameters.hasUserConsent) {
            extras[@"medPas"] = parameters.hasUserConsent;
        }
        
        if (parameters.ageRestrictedUser) {
            extras[@"medAgeRestrict"] = parameters.ageRestrictedUser;
        }
        
        if (parameters.doNotSell) {
            extras[@"medCCPA"] = parameters.doNotSell;
        }
    }];
    
    [sdk addWrapperWithName:@"AppLovin" version:kAdapterVersion];
}

- (NSString *)SDKVersion {
    __block NSString *version = nil;
    [self executeBlockOnMainThread:^{
        version = [[STAStartAppSDK sharedInstance] version];
    }];
    return version;
}

- (NSString *)adapterVersion {
    return kAdapterVersion;
}

- (void)destroy {
    self.adViewAdapter = nil;
    self.interstitialAdapter = nil;
    self.rewardedAdapter = nil;
    self.nativeAdapter = nil;
}

#pragma mark - MAAdViewAdapter methods
- (void)loadAdViewAdForParameters:(id<MAAdapterResponseParameters>)parameters adFormat:(MAAdFormat *)adFormat andNotify:(id<MAAdViewAdapterDelegate>)delegate {
    self.adViewAdapter = [[StartioAppLovinAdViewAdapter alloc] init];
    [self executeBlockOnMainThread:^{
        [self.adViewAdapter loadAdViewAdapterWithParameters:parameters adFormat:adFormat andNotify:delegate];
    }];
}

#pragma mark - MAInterstitialAdapter methods
- (void)loadInterstitialAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MAInterstitialAdapterDelegate>)delegate {
    self.interstitialAdapter = [[StartioAppLovinInterstitialAdapter alloc] init];
    [self executeBlockOnMainThread:^{
        [self.interstitialAdapter loadInterstitialAdForParameters:parameters andNotify:delegate];
    }];
}

- (void)showInterstitialAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MAInterstitialAdapterDelegate>)delegate {
    [self.interstitialAdapter showInterstitialAdForParameters:parameters andNotify:delegate];
}

#pragma mark - MARewardedAdapter methods
- (void)loadRewardedAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MARewardedAdapterDelegate>)delegate {
    self.rewardedAdapter = [[StartioAppLovinRewardedAdapter alloc] init];
    [self executeBlockOnMainThread:^{
        [self.rewardedAdapter loadRewardedAdForParameters:parameters andNotify:delegate];
    }];
}

- (void)showRewardedAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MARewardedAdapterDelegate>)delegate {
    [self.rewardedAdapter showRewardedAdForParameters:parameters andNotify:delegate];
}

#pragma mark - MANativeAdAdapter methods
- (void)loadNativeAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MANativeAdAdapterDelegate>)delegate {
    self.nativeAdapter = [[StartioAppLovinNativeAdapter alloc] init];
    [self executeBlockOnMainThread:^{
        [self.nativeAdapter loadNativeAdForParameters:parameters andNotify:delegate];
    }];
}

#pragma mark - Helper methods
- (void)executeBlockOnMainThread:(void(^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}
@end
