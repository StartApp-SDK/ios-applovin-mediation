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

#import "StartioAppLovinInterstitialAdapter.h"
#import "StartioAppLovinAdapterError.h"
#import "StartioAppLovinExtras.h"
@import StartApp;

@interface StartioAppLovinInterstitialAdapter()<STADelegateProtocol>
@property (nonatomic, strong) STAStartAppAd *interstitialAd;
@property (nonatomic, weak) id<MAInterstitialAdapterDelegate> delegate;
@end

@implementation StartioAppLovinInterstitialAdapter
- (void)loadInterstitialAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MAInterstitialAdapterDelegate>)delegate {
    StartioAppLovinExtras *extras = [[StartioAppLovinExtras alloc] initWithParamsDictionary:parameters.customParameters];
    STAAdPreferences *startAppAdPreferences = extras.prefs;
    startAppAdPreferences.placementId = [StartioAppLovinExtras placementIdFromAdapterResponseParameters:parameters];
    self.delegate = delegate;
    self.interstitialAd = [[STAStartAppAd alloc] init];
    [self.interstitialAd loadAdWithDelegate:self withAdPreferences:startAppAdPreferences];
}

- (void)showInterstitialAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MAInterstitialAdapterDelegate>)delegate {
    self.delegate = delegate;
    [self.interstitialAd showAd];
}


- (void)didLoadAd:(STAAbstractAd *)ad {
    if ([self.delegate respondsToSelector:@selector(didLoadInterstitialAd)]) {
        [self.delegate didLoadInterstitialAd];
    }
}

- (void)failedLoadAd:(STAAbstractAd *)ad withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(didFailToLoadInterstitialAdWithError:)]) {
        [self.delegate didFailToLoadInterstitialAdWithError:[StartioAppLovinAdapterError maAdapterErrorFromSTAError:error]];
    }
}

- (void)didShowAd:(STAAbstractAd *)ad {
    if ([self.delegate respondsToSelector:@selector(didDisplayInterstitialAd)]) {
        [self.delegate didDisplayInterstitialAd];
    }
}

- (void)failedShowAd:(STAAbstractAd *)ad withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(didFailToDisplayInterstitialAdWithError:)]) {
        [self.delegate didFailToDisplayInterstitialAdWithError:[StartioAppLovinAdapterError maAdapterErrorFromSTAError:error]];
    }
}

- (void)didClickAd:(STAAbstractAd *)ad {
    if ([self.delegate respondsToSelector:@selector(didClickInterstitialAd)]) {
        [self.delegate didClickInterstitialAd];
    }
}

- (void)didCloseAd:(STAAbstractAd *)ad {
    if ([self.delegate respondsToSelector:@selector(didHideInterstitialAd)]) {
        [self.delegate didHideInterstitialAd];
    }
}
@end
