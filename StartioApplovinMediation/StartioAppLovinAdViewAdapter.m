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

#import "StartioAppLovinAdViewAdapter.h"
#import "StartioAppLovinAdapterError.h"
#import "StartioAppLovinExtras.h"
#import <StartApp/StartApp.h>

@interface StartioAppLovinAdViewAdapter()<STABannerDelegateProtocol>
@property (nonatomic, strong) STABannerView *bannerView;
@property (nonatomic, weak) id<MAAdViewAdapterDelegate> delegate;
@end

@implementation StartioAppLovinAdViewAdapter

- (void)loadAdViewAdapterWithParameters:(id<MAAdapterResponseParameters>)parameters adFormat:(MAAdFormat *)adFormat andNotify:(id<MAAdViewAdapterDelegate>)delegate {
    StartioAppLovinExtras *extras = [[StartioAppLovinExtras alloc] initWithParamsDictionary:parameters.customParameters];
    self.delegate = delegate;
    STABannerSize bannerSize;
    if (adFormat == MAAdFormat.banner) {
        bannerSize = STA_PortraitAdSize_320x50;
    }
    else if (adFormat == MAAdFormat.mrec) {
        bannerSize = STA_MRecAdSize_300x250;
    }
    else {
        bannerSize.size = adFormat.size;
        bannerSize.isAuto = NO;
    }
    
    self.bannerView = [[STABannerView alloc] initWithSize:bannerSize origin:CGPointZero adPreferences:extras.prefs withDelegate:self];
    [self.bannerView loadAd];
}


- (void)bannerAdIsReadyToDisplay:(STABannerView *)banner {
    if ([self.delegate respondsToSelector:@selector(didLoadAdForAdView:)]) {
        [self.delegate didLoadAdForAdView:self.bannerView];
    }
}

- (void)didSendImpressionForBannerAd:(STABannerView *)banner {
    if ([self.delegate respondsToSelector:@selector(didDisplayAdViewAd)]) {
        [self.delegate didDisplayAdViewAd];
    }
}

- (void) failedLoadBannerAd:(STABannerView *)banner withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(didFailToLoadAdViewAdWithError:)]) {
        [self.delegate didFailToLoadAdViewAdWithError:[StartioAppLovinAdapterError maAdapterErrorFromSTAError:error]];
    }
}

- (void) didClickBannerAd:(STABannerView *)banner {
    if ([self.delegate respondsToSelector:@selector(didClickAdViewAd)]) {
        [self.delegate didClickAdViewAd];
    }
}

@end
