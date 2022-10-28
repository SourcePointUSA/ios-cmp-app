//
//  ViewController.m
//  ObjC-ExampleApp
//
//  Created by Vilas on 08/02/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "ViewController.h"
#import "SPSdkStatus.h"
@import ConsentViewController;

@interface ViewController ()<SPDelegate> {
    SPConsentManager *consentManager;
    SPSdkStatus sdkStatus;
    __weak IBOutlet UILabel *sdkStatusLabel;
    __weak IBOutlet UILabel *idfaValueLabel;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAccessibilityIds];

    sdkStatus = SPSdkStatusNotStarted;
    [self updateUIFields];

    SPPropertyName *propertyName = [[SPPropertyName alloc] init:@"mobile.multicampaign.demo" error:NULL];

    SPCampaign *campaign = [[SPCampaign alloc]
                            initWithTargetingParams: [NSDictionary dictionary]
                            groupPmId: nil];

    SPCampaigns *campaigns = [[SPCampaigns alloc]
                              initWithGdpr: campaign
                              ccpa: NULL
                              ios14: campaign
                              environment: SPCampaignEnvPublic];

    consentManager = [[SPConsentManager alloc]
                      initWithAccountId:22
                      propertyId: 16893
                      propertyName: propertyName
                      campaigns: campaigns
                      delegate: self];

    [consentManager loadMessageForAuthId: NULL publisherData:NULL];
    sdkStatus = SPSdkStatusRunning;
    [self updateUIFields];
}

- (void)setupAccessibilityIds {
    sdkStatusLabel.accessibilityIdentifier = @"sdkStatusLabel";
    idfaValueLabel.accessibilityIdentifier = @"idfaStatusLabel";
    [self setIsAccessibilityElement:false];
    [self setAccessibilityElements: @[sdkStatusLabel, idfaValueLabel]];
}

- (void)updateUIFields {
    idfaValueLabel.text = [SPIDFAStatusBridge currentString];
    sdkStatusLabel.text = [self sdkStatusToString: sdkStatus];
}

- (NSString*)sdkStatusToString: (SPSdkStatus)status {
    switch(status) {
        case SPSdkStatusNotStarted:
            return @"Not Started";
        case SPSdkStatusRunning:
            return @"Running";
        case SPSdkStatusFinished:
            return @"Finished";
        case SPSdkStatusNotErrored:
            return @"Errored";
    }
}

- (void)onSPUIReady:(SPMessageViewController * _Nonnull)controller {
    [self presentViewController:controller animated:true completion:NULL];
}

- (void)onAction:(SPAction * _Nonnull)action from:(SPMessageViewController * _Nonnull)controller {
    NSLog(@"onAction: %@", action);
}

- (void)onSPUIFinished:(SPMessageViewController * _Nonnull)controller {
    [self updateUIFields];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)onErrorWithError:(SPError *)error {
    sdkStatus = SPSdkStatusNotErrored;
    [self updateUIFields];
    NSLog(@"Something went wrong: %@", error);
}

- (void)onConsentReadyWithUserData:(SPUserData *)userData {
    sdkStatus = SPSdkStatusFinished;
    [self updateUIFields];
    NSLog(@"GDPR Applies: %d", userData.objcGDPRApplies);
    NSLog(@"GDPR: %@", userData.objcGDPRConsents);
    NSLog(@"CCPA Applies: %d", userData.objcCCPAApplies);
    NSLog(@"CCPA: %@", userData.objcCCPAConsents);
}
@end
