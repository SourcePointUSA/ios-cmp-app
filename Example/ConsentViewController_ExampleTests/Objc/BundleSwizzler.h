//
//  BundleSwizzler.h
//  ConsentViewController_ExampleTests
//
//  Swizzles Bundle.main.path(forResource:ofType:) to redirect
//  SourcepointConfigGDPR lookups to the test bundle
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BundleSwizzler : NSObject

/// Enable swizzling to intercept Bundle resource lookups for a specific config file
/// Call this before initializing SPDidomiConsentManager in tests
/// @param configFileName The name of the config file (without extension), e.g., "SourcepointConfigGDPR"
+ (void)enableConfigFileRedirection:(NSString *)configFileName;

/// Disable swizzling after tests complete
+ (void)disableConfigFileRedirection;

@end

NS_ASSUME_NONNULL_END
