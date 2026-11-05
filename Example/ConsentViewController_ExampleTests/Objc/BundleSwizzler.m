//
//  BundleSwizzler.m
//  ConsentViewController_ExampleTests
//
//  Swizzles Bundle.main.path(forResource:ofType:) to redirect
//  SourcepointConfigGDPR lookups to the test bundle
//

#import "BundleSwizzler.h"
#import <objc/runtime.h>

static BOOL swizzlingEnabled = NO;
static NSString *configPath = nil;
static NSString *targetConfigFileName = nil;

@implementation BundleSwizzler

+ (void)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector forClass:(Class)class {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    if (!originalMethod || !swizzledMethod) {
        NSLog(@"BundleSwizzler: WARNING - Could not find methods to swizzle: %@ -> %@",
              NSStringFromSelector(originalSelector),
              NSStringFromSelector(swizzledSelector));
        return;
    }

    BOOL didAddMethod = class_addMethod(class,
                                       originalSelector,
                                       method_getImplementation(swizzledMethod),
                                       method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class,
                          swizzledSelector,
                          method_getImplementation(originalMethod),
                          method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)enableConfigFileRedirection:(NSString *)configFileName {
    if (swizzlingEnabled) {
        NSLog(@"BundleSwizzler: Swizzling already enabled");
        return;
    }

    targetConfigFileName = configFileName;

    // Find the config file in all loaded bundles
    for (NSBundle *bundle in [NSBundle allBundles]) {
        NSString *path = [bundle pathForResource:configFileName ofType:@"json"];
        if (path) {
            configPath = path;
            NSLog(@"BundleSwizzler: Found config at: %@", configPath);
            break;
        }
    }

    if (!configPath) {
        NSLog(@"BundleSwizzler: WARNING - Could not find %@.json in any bundle!", configFileName);
        return;
    }

    // Swizzle multiple Bundle resource lookup methods
    Class bundleClass = [NSBundle class];

    // Swizzle pathForResource:ofType:
    [self swizzleMethod:@selector(pathForResource:ofType:)
               withMethod:@selector(swizzled_pathForResource:ofType:)
                 forClass:bundleClass];

    // Swizzle pathForResource:ofType:inDirectory:
    [self swizzleMethod:@selector(pathForResource:ofType:inDirectory:)
               withMethod:@selector(swizzled_pathForResource:ofType:inDirectory:)
                 forClass:bundleClass];

    // Swizzle URLForResource:withExtension:
    [self swizzleMethod:@selector(URLForResource:withExtension:)
               withMethod:@selector(swizzled_URLForResource:withExtension:)
                 forClass:bundleClass];

    swizzlingEnabled = YES;
    NSLog(@"BundleSwizzler: Swizzling enabled for %@.json", configFileName);
}

+ (void)disableConfigFileRedirection {
    if (!swizzlingEnabled) {
        return;
    }

    // Swap all methods back
    Class bundleClass = [NSBundle class];

    [self swizzleMethod:@selector(pathForResource:ofType:)
               withMethod:@selector(swizzled_pathForResource:ofType:)
                 forClass:bundleClass];

    [self swizzleMethod:@selector(pathForResource:ofType:inDirectory:)
               withMethod:@selector(swizzled_pathForResource:ofType:inDirectory:)
                 forClass:bundleClass];

    [self swizzleMethod:@selector(URLForResource:withExtension:)
               withMethod:@selector(swizzled_URLForResource:withExtension:)
                 forClass:bundleClass];

    swizzlingEnabled = NO;
    configPath = nil;
    targetConfigFileName = nil;
    NSLog(@"BundleSwizzler: Swizzling disabled");
}

@end

// Category to add the swizzled method to NSBundle
@implementation NSBundle (Swizzling)

- (NSString *)swizzled_pathForResource:(NSString *)name ofType:(NSString *)ext {
    // If swizzling is enabled and this is a request for the target config file,
    // return the path we found earlier
    if (swizzlingEnabled &&
        name && targetConfigFileName && [name isEqualToString:targetConfigFileName] &&
        ext && [ext isEqualToString:@"json"]) {
        NSLog(@"BundleSwizzler: Intercepted path(forResource:ofType:) for %@.json, returning: %@", targetConfigFileName, configPath);
        return configPath;
    }

    // Otherwise, call the original implementation
    // Note: This calls the swizzled method which is actually the original implementation
    return [self swizzled_pathForResource:name ofType:ext];
}

- (NSString *)swizzled_pathForResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath {
    // If swizzling is enabled and this is a request for the target config file,
    // return the path we found earlier
    if (swizzlingEnabled &&
        name && targetConfigFileName && [name isEqualToString:targetConfigFileName] &&
        ext && [ext isEqualToString:@"json"]) {
        NSLog(@"BundleSwizzler: Intercepted path(forResource:ofType:inDirectory:) for %@.json, returning: %@", targetConfigFileName, configPath);
        return configPath;
    }

    // Otherwise, call the original implementation
    return [self swizzled_pathForResource:name ofType:ext inDirectory:subpath];
}

- (NSURL *)swizzled_URLForResource:(NSString *)name withExtension:(NSString *)ext {
    // If swizzling is enabled and this is a request for the target config file,
    // return a URL for the path we found earlier
    if (swizzlingEnabled &&
        name && targetConfigFileName && [name isEqualToString:targetConfigFileName] &&
        ext && [ext isEqualToString:@"json"]) {
        NSLog(@"BundleSwizzler: Intercepted URLForResource:withExtension: for %@.json, returning: %@", targetConfigFileName, configPath);
        return [NSURL fileURLWithPath:configPath];
    }

    // Otherwise, call the original implementation
    return [self swizzled_URLForResource:name withExtension:ext];
}

@end
