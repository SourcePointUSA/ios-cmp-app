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
                            initWithTargetingParams: [NSDictionary dictionary]
                            groupPmId: nil];

    SPCampaigns *campaigns = [[SPCampaigns alloc]
                              initWithGdpr: campaign
                              ccpa: NULL
                              ios14: NULL];

    consentManager = [[SPConsentManager alloc]
                      initWithAccountId:22
                      propertyName: propertyName
                      campaignsEnv: SPCampaignEnvPublic
                      campaigns: campaigns
                      delegate: self];

    [consentManager loadMessageForAuthId: NULL publisherData:NULL];
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

- (void)onConsentReadyWithUserData:(SPUserData *)userData {
    NSLog(@"GDPR Applies: %d", userData.objcGDPRApplies);
    NSLog(@"GDPR: %@", userData.objcGDPRConsents);
    NSLog(@"CCPA Applies: %d", userData.objcCCPAApplies);
    NSLog(@"CCPA: %@", userData.objcCCPAConsents);
}
@end
