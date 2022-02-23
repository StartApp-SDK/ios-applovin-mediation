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

#import "StartioMAXAdapter.h"
#import "StartioMAXAdViewAdapter.h"
#import "StartioMAXInterstitialAdapter.h"
#import "StartioMAXRewardedAdapter.h"
#import "StartioMAXNativeAdapter.h"
#import <StartApp/StartApp.h>

static NSString * const kAdapterVersion = @"0.0.1";

static NSString * const kAppIdKey = @"app_id";

@interface StartioMAXAdapter()<MAAdViewAdapter, MAInterstitialAdapter, MARewardedAdapter, MANativeAdAdapter>
@property (nonatomic, strong) StartioMAXAdViewAdapter *adViewAdapter;
@property (nonatomic, strong) StartioMAXInterstitialAdapter *interstitialAdapter;
@property (nonatomic, strong) StartioMAXRewardedAdapter *rewardedAdapter;
@property (nonatomic, strong) StartioMAXNativeAdapter *nativeAdapter;
@end

@implementation StartioMAXAdapter

- (void)initializeWithParameters:(id<MAAdapterInitializationParameters>)parameters completionHandler:(nonnull void (^)(MAAdapterInitializationStatus, NSString * _Nullable))completionHandler {
    NSString *appID = parameters.serverParameters[kAppIdKey];
    if (appID.length != 0) {
        if ([NSThread isMainThread]) {
            [self setupStartioSDKWithAppID:appID parameters:parameters];
            completionHandler(MAAdapterInitializationStatusInitializedSuccess, nil);
        }
        else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self setupStartioSDKWithAppID:appID parameters:parameters];
            });
            completionHandler(MAAdapterInitializationStatusInitializedSuccess, nil);
        }
    }
    else {
        completionHandler(MAAdapterInitializationStatusInitializing, @"No Start.io AppID provided yet");
    }
}

- (void)setupStartioSDKWithAppID:(NSString *)appID parameters:(id<MAAdapterInitializationParameters>)parameters {
    [STAStartAppSDK sharedInstance].appID = appID;
    
    if (parameters.ageRestrictedUser.boolValue) {
        STASDKPreferences *prefs = [[STASDKPreferences alloc] init];
        prefs.age = parameters.ageRestrictedUser.unsignedIntegerValue;
        [[STAStartAppSDK sharedInstance] setPreferences:prefs];
    }
    
    [[STAStartAppSDK sharedInstance] setUserConsent:parameters.hasUserConsent.boolValue forConsentType:@"pas" withTimestamp:[NSDate timeIntervalSinceReferenceDate]];
    
    [[STAStartAppSDK sharedInstance] addWrapperWithName:@"MAX" version:kAdapterVersion];
}

- (NSString *)SDKVersion {
    return [[STAStartAppSDK sharedInstance] version];
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
    self.adViewAdapter = [[StartioMAXAdViewAdapter alloc] init];
    [self.adViewAdapter loadAdViewAdapterWithParameters:parameters adFormat:adFormat andNotify:delegate];
}

#pragma mark - MAInterstitialAdapter methods
- (void)loadInterstitialAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MAInterstitialAdapterDelegate>)delegate {
    self.interstitialAdapter = [[StartioMAXInterstitialAdapter alloc] init];
    [self.interstitialAdapter loadInterstitialAdForParameters:parameters andNotify:delegate];
}

- (void)showInterstitialAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MAInterstitialAdapterDelegate>)delegate {
    [self.interstitialAdapter showInterstitialAdForParameters:parameters andNotify:delegate];
}

#pragma mark - MARewardedAdapter methods
- (void)loadRewardedAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MARewardedAdapterDelegate>)delegate {
    self.rewardedAdapter = [[StartioMAXRewardedAdapter alloc] init];
    [self.rewardedAdapter loadRewardedAdForParameters:parameters andNotify:delegate];
}

- (void)showRewardedAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MARewardedAdapterDelegate>)delegate {
    [self.rewardedAdapter showRewardedAdForParameters:parameters andNotify:delegate];
}

#pragma mark - MANativeAdAdapter methods
- (void)loadNativeAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MANativeAdAdapterDelegate>)delegate {
    self.nativeAdapter = [[StartioMAXNativeAdapter alloc] init];
    [self.nativeAdapter loadNativeAdForParameters:parameters andNotify:delegate];
}
@end
