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

#import <AppLovinSDK/AppLovinSDK.h>
#import "ViewController.h"

static let kInterstitialUnitId = @"<INTERSTITIAL_UNIT_ID>";
static let kRewardedUnitId = @"<REWARDED_UNIT_ID>";
static let kNativeUnitId = @"<NATIVE_UNIT_ID>";
static let kBannerUnitId = @"<BANNER_UNIT_ID>";
static let kMrecUnitId = @"<MREC_UNIT_ID>";

@interface ViewController () <MAAdViewAdDelegate, MARewardedAdDelegate, MANativeAdDelegate>

@property (weak, nonatomic) IBOutlet UITextView* messageTextView;
@property (weak, nonatomic) IBOutlet UIButton* showInterstitialButton;
@property (weak, nonatomic) IBOutlet UIButton* showRewardedButton;
@property (weak, nonatomic) IBOutlet UIButton* showNativeButton;

@property (nonatomic, nullable) MAInterstitialAd *interstitialAd;
@property (nonatomic, nullable) MARewardedAd* rewardedAd;
@property (nonatomic, nullable) MAAdView* adView;

@property (nonatomic, strong) MANativeAdLoader *nativeAdLoader;
@property (nonatomic, strong) MAAd *nativeAd;
@property (nonatomic, strong) MANativeAdView *nativeAdView;

@property (nonatomic) BOOL needToStrechInlineView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Interstitial

- (IBAction)loadInterstitial:(UIButton*)sender {
    self.interstitialAd = [[MAInterstitialAd alloc] initWithAdUnitIdentifier:kInterstitialUnitId];
    self.interstitialAd.delegate = self;
    
    // Load the first ad
    [self.interstitialAd loadAd];
}

- (IBAction)showInterstitial:(UIButton*)sender {
    if ([self.interstitialAd isReady]) {
        [self.interstitialAd showAd];
    }
}

#pragma mark - Rewarded

- (IBAction)loadRewarded:(UIButton*)sender {
    self.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier:kRewardedUnitId];
    self.rewardedAd.delegate = self;
    
    // Load the first ad
    [self.rewardedAd loadAd];
}

- (IBAction)showRewarded:(UIButton*)sender {
    if ([self.rewardedAd isReady]) {
        [self.rewardedAd showAd];
    }
}

#pragma mark - Native

- (IBAction)loadNative:(UIButton*)sender {
    self.nativeAdLoader = [[MANativeAdLoader alloc] initWithAdUnitIdentifier:kNativeUnitId];
    self.nativeAdLoader.nativeAdDelegate = self;
    self.nativeAdView = [self createNativeAdView];
    [self.nativeAdLoader loadAdIntoAdView:self.nativeAdView];
}

- (IBAction)showNative:(UIButton*)sender {
    [self cleanBottomEdge];
    self.showNativeButton.enabled = NO;
    [self addViewCenteredOnBottomEdge:self.nativeAdView withSize:CGSizeMake(300, 250)];
}

- (MANativeAdView *)createNativeAdView {
    UINib *nativeAdViewNib = [UINib nibWithNibName: @"NativeAdView" bundle: NSBundle.mainBundle];
    MANativeAdView *nativeAdView = [nativeAdViewNib instantiateWithOwner:nil options:nil].firstObject;
    MANativeAdViewBinder *binder = [[MANativeAdViewBinder alloc] initWithBuilderBlock:^(MANativeAdViewBinderBuilder *builder) {
        builder.iconImageViewTag = 1;
        builder.titleLabelTag = 2;
        builder.bodyLabelTag = 3;
        builder.callToActionButtonTag = 4;
    }];
    [nativeAdView bindViewsWithAdViewBinder:binder];
    return nativeAdView;
}

#pragma mark - Banner

- (IBAction)loadBanner:(UIButton*)sender {
    [self cleanBottomEdge];
    
    self.adView = [[MAAdView alloc] initWithAdUnitIdentifier:kBannerUnitId];
    
    self.adView.delegate = self;
    
    // Banner height on iPhone and iPad is 50 and 90, respectively
    CGFloat height = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 90 : 50;
    self.adView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
    
    // Set background or background color for banners to be fully functional
    self.adView.backgroundColor = UIColor.clearColor;
    
    // Load the ad
    [self.adView loadAd];
    
    self.needToStrechInlineView = YES;
}

#pragma mark - MREC

- (IBAction)loadMREC:(UIButton*)sender {
    [self cleanBottomEdge];
    
    self.adView = [[MAAdView alloc] initWithAdUnitIdentifier:kMrecUnitId adFormat:MAAdFormat.mrec];
    self.adView.delegate = self;
    
    // MREC width and height are 300 and 250 respectively, on iPhone and iPad
    CGFloat width = 300;
    CGFloat height = 250;
    self.adView.frame = CGRectMake(0, 0, width, height);
    
    // Set background or background color for MREC ads to be fully functional
    self.adView.backgroundColor = UIColor.clearColor;
    
    // Load the ad
    [self.adView loadAd];
}

#pragma mark - Utils

- (void)addViewCenteredOnBottomEdge:(UIView*)view withSize:(CGSize)size {
    [self addViewAnimated:view];
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:size.width],
        [view.heightAnchor constraintEqualToConstant:size.height],
        [view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}

- (void)addViewStretchedOnBottomEdge:(UIView*)view height:(CGFloat)height {
    [self addViewAnimated:view];
    [NSLayoutConstraint activateConstraints:@[
        [view.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [view.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [view.heightAnchor constraintEqualToConstant:height]
    ]];
}

- (void)addViewAnimated:(UIView*)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view];
    
    view.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        view.alpha = 1;
    }];
}

- (void)cleanBottomEdge {
    [self.adView removeFromSuperview];
    [self.nativeAdView removeFromSuperview];
}

- (void)logMessage:(nonnull NSString*)message {
    [self.messageTextView insertText:[@"\n" stringByAppendingString:message]];
    let bottom = NSMakeRange(self.messageTextView.text.length - 1, 1);
    [self.messageTextView scrollRangeToVisible:bottom];
    
    NSLog(@"%@", message);
}

- (void)enable:(BOOL)enable showButtonForAdUnit:(nonnull NSString *)adUnit {
    if ([adUnit isEqualToString:kInterstitialUnitId]) {
        self.showInterstitialButton.enabled = enable;
    }
    else if ([adUnit isEqualToString:kRewardedUnitId]) {
        self.showRewardedButton.enabled = enable;
    }
}

#pragma mark - MAAdDelegate Protocol
- (void)didLoadAd:(MAAd *)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
    if ([ad.adUnitIdentifier isEqualToString:kBannerUnitId]) {
        [self.adView stopAutoRefresh];
        [self addViewStretchedOnBottomEdge:self.adView height:self.adView.frame.size.height];
    }
    else if ([ad.adUnitIdentifier isEqualToString:kMrecUnitId]) {
        [self.adView stopAutoRefresh];
        [self addViewCenteredOnBottomEdge:self.adView withSize:self.adView.frame.size];
    }
    else {
        [self enable:YES showButtonForAdUnit:ad.adUnitIdentifier];
    }
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    [self logMessage:NSStringFromSelector(_cmd)];
    [self enable:NO showButtonForAdUnit:adUnitIdentifier];
}

- (void)didClickAd:(MAAd *)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    [self logMessage:NSStringFromSelector(_cmd)];
    [self enable:NO showButtonForAdUnit:ad.adUnitIdentifier];
}

- (void)didDisplayAd:(nonnull MAAd *)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
    [self enable:NO showButtonForAdUnit:ad.adUnitIdentifier];
}

- (void)didHideAd:(nonnull MAAd *)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
    [self enable:NO showButtonForAdUnit:ad.adUnitIdentifier];
}

#pragma mark - MAAdViewAdDelegate Protocol
- (void)didExpandAd:(MAAd *)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)didCollapseAd:(MAAd *)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
}

#pragma mark - MARewardedAdDelegate Protocol
- (void)didCompleteRewardedVideoForAd:(nonnull MAAd *)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)didRewardUserForAd:(nonnull MAAd *)ad withReward:(nonnull MAReward *)reward {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)didStartRewardedVideoForAd:(nonnull MAAd *)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
}

#pragma mark - MANativeAdDelegate Protocol
- (void)didLoadNativeAd:(MANativeAdView *)nativeAdView forAd:(MAAd *)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
    if (self.nativeAd) {
        [self.nativeAdLoader destroyAd:self.nativeAd];
    }
    self.nativeAd = ad;

    if (self.nativeAdView) {
        [self.nativeAdView removeFromSuperview];
    }
    self.nativeAdView = nativeAdView;
    
    self.showNativeButton.enabled = YES;
}

- (void)didFailToLoadNativeAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    self.showNativeButton.enabled = NO;
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)didClickNativeAd:(MAAd *)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
}
@end
