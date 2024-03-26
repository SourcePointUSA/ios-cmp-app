//
//  SPUSNatConsentObjcSpec.m
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 26.03.24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import ConsentViewController;

@interface SPUSNatConsentObjcSpec : XCTestCase

@end

@implementation SPUSNatConsentObjcSpec
- (void)testEmpty {
    SPUSNatConsent *consents = [SPUSNatConsent empty];
    XCTAssertNil(consents.uuid);
    XCTAssertFalse(consents.applies);
    XCTAssertEqualObjects(consents.consentStrings, @[]);
    XCTAssertEqualObjects(consents.vendors, @[]);
    XCTAssertEqualObjects(consents.categories, @[]);
    XCTAssertFalse(consents.objcStatuses.rejectedAny);
    XCTAssertFalse(consents.objcStatuses.consentedToAll);
    XCTAssertFalse(consents.objcStatuses.consentedToAny);
    XCTAssertFalse(consents.objcStatuses.hasConsentData);
    XCTAssertFalse(consents.objcStatuses.sellStatus);
    XCTAssertFalse(consents.objcStatuses.shareStatus);
    XCTAssertFalse(consents.objcStatuses.sensitiveDataStatus);
    XCTAssertFalse(consents.objcStatuses.gpcStatus);
}

- (void)testConsentString {
    SPUSNatConsent_ConsentString *consentString = [
        [SPUSNatConsent_ConsentString alloc]
           initWithSectionId:0
           sectionName:@"foo"
           consentString:@"bar"
    ];
    XCTAssertEqual(consentString.sectionId, 0);
    XCTAssertEqual(consentString.sectionName, @"foo");
    XCTAssertEqual(consentString.consentString, @"bar");
}

- (void)testConsentable {
    SPConsentable *consentable = [
        [SPConsentable alloc]
        initWithId:@"123"
        consented:TRUE
    ];
    XCTAssertEqual(consentable.id, @"123");
    XCTAssertTrue(consentable.consented);
}
@end

