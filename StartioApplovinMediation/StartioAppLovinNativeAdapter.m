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

#import "StartioAppLovinNativeAdapter.h"
#import "StartioAppLovinAdapterError.h"
#import "StartioAppLovinNativeAd.h"
#import "StartioAppLovinExtras.h"
@import StartApp;

@interface StartioAppLovinNativeAdapter()<STADelegateProtocol>
@property (nonatomic, strong) STAStartAppNativeAd *nativeAd;
@property (nonatomic, strong) StartioAppLovinNativeAd *adapterNativeAd;
@property (nonatomic, weak) id<MANativeAdAdapterDelegate> delegate;
@end

@implementation StartioAppLovinNativeAdapter
- (void)loadNativeAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MANativeAdAdapterDelegate>)delegate {
    StartioAppLovinExtras *extras = [[StartioAppLovinExtras alloc] initWithParamsDictionary:parameters.customParameters];
    self.delegate = delegate;
    self.nativeAd = [[STAStartAppNativeAd alloc] init];
    STANativeAdPreferences *nativeAdPrefs = extras.prefs;
    nativeAdPrefs.adsNumber = 1;
    nativeAdPrefs.autoBitmapDownload = YES;
    nativeAdPrefs.placementId = [StartioAppLovinExtras placementIdFromAdapterResponseParameters:parameters];
    [self.nativeAd loadAdWithDelegate:self withNativeAdPreferences:nativeAdPrefs];
}

- (MANativeAd *)maNativeAdFromSTANativeAdDetails:(STANativeAdDetails *)nativeAdDetails {
    if (nativeAdDetails) {
        self.adapterNativeAd = [[StartioAppLovinNativeAd alloc] initWithSTANAtiveAdDetails:nativeAdDetails];
        return self.adapterNativeAd;
    }
    return nil;
}

- (void)didLoadAd:(STAAbstractAd *)ad {
    if ([self.delegate respondsToSelector:@selector(didLoadAdForNativeAd:withExtraInfo:)]) {
        [self.delegate didLoadAdForNativeAd:[self maNativeAdFromSTANativeAdDetails:self.nativeAd.adsDetails.firstObject] withExtraInfo:nil];
    }
}

- (void)failedLoadAd:(STAAbstractAd *)ad withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(didFailToLoadNativeAdWithError:)]) {
        [self.delegate didFailToLoadNativeAdWithError:[StartioAppLovinAdapterError maAdapterErrorFromSTAError:error]];
    }
}

- (void)didSendImpressionForNativeAdDetails:(STANativeAdDetails *)nativeAdDetails {
    if ([self.delegate respondsToSelector:@selector(didDisplayNativeAdWithExtraInfo:)]) {
        [self.delegate didDisplayNativeAdWithExtraInfo:nil];
    }
}

- (void)didClickNativeAdDetails:(STANativeAdDetails *)nativeAdDetails {
    if ([self.delegate respondsToSelector:@selector(didClickNativeAd)]) {
        [self.delegate didClickNativeAd];
    }
}

@end
