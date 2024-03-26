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
    SPGCMDataObjc *gcmData = [[SPGDPRConsent empty] objcGoogleConsentMode];
    SPGCMDataObjc_ObjcStatus unset = SPGCMDataObjc_ObjcStatusUnset;

    XCTAssertEqual(gcmData.adStorage, unset);
    XCTAssertEqual(gcmData.analyticsStorage, unset);
    XCTAssertEqual(gcmData.adUserData, unset);
    XCTAssertEqual(gcmData.adPersonalization, unset);
}
@end
