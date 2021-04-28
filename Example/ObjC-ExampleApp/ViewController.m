//
//  ViewController.m
//  ObjC-ExampleApp
//
//  Created by Vilas on 08/02/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "ViewController.h"
@import ConsentViewController;

@interface ViewController ()<SPDelegate> {
    SPConsentManager *consentManager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SPPropertyName *propertyName = [[SPPropertyName alloc] init:@"mobile.multicampaign.demo" error:NULL];

    SPCampaign *campaign = [[SPCampaign alloc]
                            initWithEnvironment: SPCampaignEnvPublic
                            targetingParams: [NSDictionary dictionary]];

    SPCampaigns *campaigns = [[SPCampaigns alloc]
                              initWithGdpr: campaign
                              ccpa: campaign
                              ios14: campaign];

    consentManager = [[SPConsentManager alloc]
                      initWithAccountId:22
                      propertyName: propertyName
                      campaigns: campaigns
                      delegate: self];

    [consentManager loadMessageForAuthId: NULL];
}

- (void)onSPUIReady:(SPMessageViewController * _Nonnull)controller {
    [self presentViewController:controller animated:true completion:NULL];
}

- (void)onAction:(SPAction * _Nonnull)action from:(SPMessageViewController * _Nonnull)controller {
    NSLog(@"onAction: %@", action);
}

- (void)onSPUIFinished:(SPMessageViewController * _Nonnull)controller {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)onConsentReadyWithConsents:(SPUserData *)consents {
    NSLog(@"onConsentReady: %@", consents);
}
@end
