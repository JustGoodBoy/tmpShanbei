//
//  UIDevice+SHAN_UUID.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/26.
//

#import "UIDevice+SHAN_UUID.h"

@class KeyChainStore;

static NSMutableDictionary * _keychainMap(NSString *serviceName) {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            serviceName, (id)kSecAttrService,
            serviceName, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

static void _keyChainSave(NSString *data, NSString *serviceName) {
    NSMutableDictionary *keychainQuery = _keychainMap(serviceName);
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

static id _dataFormKeyChain(NSString *serviceName) {
    id data = nil;
    NSMutableDictionary *keychainQuery = _keychainMap(serviceName);
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            data = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", serviceName, e);
        } @finally {}
    }
    if (keyData) CFRelease(keyData);
    return data;
}

@implementation UIDevice (SHAN_UUID)
+ (NSString *)shan_uuid {
    NSString *devied_ID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString * uuid = (NSString *)_dataFormKeyChain(devied_ID);
    if (!uuid.length) {
        uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
        _keyChainSave(uuid, devied_ID);
    }
    return uuid;
}


@end
