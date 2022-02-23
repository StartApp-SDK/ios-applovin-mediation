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

#import "StartioMAXInterstitialAdapter.h"
#import "StartioMAXAdapterError.h"
#import "StartioMAXExtras.h"
#import <StartApp/StartApp.h>

@interface StartioMAXInterstitialAdapter()<STADelegateProtocol>
@property (nonatomic, strong) STAStartAppAd *interstitialAd;
@property (nonatomic, weak) id<MAInterstitialAdapterDelegate> delegate;
@end

@implementation StartioMAXInterstitialAdapter
- (void)loadInterstitialAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MAInterstitialAdapterDelegate>)delegate {
    StartioMAXExtras *extras = [[StartioMAXExtras alloc] initWithParamsDictionary:parameters.customParameters];
    self.delegate = delegate;
    self.interstitialAd = [[STAStartAppAd alloc] init];
    [self.interstitialAd loadAdWithDelegate:self withAdPreferences:extras.prefs];
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
        [self.delegate didFailToLoadInterstitialAdWithError:[StartioMAXAdapterError maAdapterErrorFromSTAError:error]];
    }
}

- (void)didShowAd:(STAAbstractAd *)ad {
    if ([self.delegate respondsToSelector:@selector(didDisplayInterstitialAd)]) {
        [self.delegate didDisplayInterstitialAd];
    }
}

- (void)failedShowAd:(STAAbstractAd *)ad withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(didFailToDisplayInterstitialAdWithError:)]) {
        [self.delegate didFailToDisplayInterstitialAdWithError:[StartioMAXAdapterError maAdapterErrorFromSTAError:error]];
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
