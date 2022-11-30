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

#import "StartioAppLovinNativeAd.h"
@import StartApp;

@interface StartioAppLovinNativeAd()
@property (nonatomic, strong) STANativeAdDetails *nativeAdDetails;
@end

@implementation StartioAppLovinNativeAd

- (instancetype)initWithSTANAtiveAdDetails:(STANativeAdDetails *)nativeAdDetails {
    MANativeAdImage *nativeAdImage = nil;
    if (nativeAdDetails.imageBitmap) {
        nativeAdImage = [[MANativeAdImage alloc] initWithImage:nativeAdDetails.imageBitmap];
    }
    else {
        nativeAdImage = [[MANativeAdImage alloc] initWithURL:[NSURL URLWithString:nativeAdDetails.imageUrl]];
    }
    self = [super initWithFormat:MAAdFormat.native builderBlock:^(MANativeAdBuilder * _Nonnull builder) {
        builder.title = nativeAdDetails.title;
        builder.body = nativeAdDetails.description;
        builder.callToAction = nativeAdDetails.callToAction;
        builder.icon = nativeAdImage;
    }];
    if (self) {
        self.nativeAdDetails = nativeAdDetails;
    }
    return self;
}

- (BOOL)prepareForInteractionClickableViews:(NSArray<UIView *> *)clickableViews withContainer:(UIView *)container {
    [self.nativeAdDetails registerViewForImpression:container andViewsForClick:clickableViews];
    return YES;
}
@end
