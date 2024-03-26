//
//  SPGDPRConsentObjcSpec.m
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 26.03.24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import ConsentViewController;

@interface SPGDPRConsentObjcSpec : XCTestCase

@end

@implementation SPGDPRConsentObjcSpec
- (void)testGCMData {
    SPGDPRConsent *consents = [SPGDPRConsent empty];
    XCTAssertEqual(consents.googleConsentMode.objcAdStorage, 0);
    XCTAssertEqual(consents.googleConsentMode.objcAnalyticsStorage, 0);
    XCTAssertEqual(consents.googleConsentMode.objcAdUserData, 0);
    XCTAssertEqual(consents.googleConsentMode.objcAdPersonalization, 0);
}
@end
