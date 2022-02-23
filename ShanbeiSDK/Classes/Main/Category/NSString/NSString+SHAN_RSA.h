//
//  NSString+SHAN_RSA.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/12/9.
//

#import <Foundation/Foundation.h>

static NSString *const RSA_PublicKey = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjGkU3HqQ55QeqwenzX8pJPKb21ijvIOu/YOfuyRo6aNGfP2JXireEkatP81rQ2YFiS4pqWGQaiZ/pTKFFTjsk9nVFIqYTxo5QIF19HeTXeINKyQQ6YN3GV4n0FYv5bRGmjX/OHxIvKTz2NpjZglCBydw8ZCz1AsXvt1LEls9yPn5EqIUK5y4SS4b6I2xDwoubCTv1zE7Ciai6VWqrTHi0A9UaWtSh07cINqjOfcZ26FlXpbHRTgSMH4qf3t8amPUOpoAR93v35Q94aMguvy4e2isRV2Mv2fKUHjeCl4IhiMIaLN4c3is5aJBSQSm82myCdv9jh7g0xR/nSCGZ7lwyQIDAQAB";

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SHAN_RSA)

/// RSA加密
+ (NSString *)shan_RSA_encryptString:(NSString *)str publicKey:(NSString *)pubKey;

/// RSA解密
+ (NSString *)shan_RSA_decryptString:(NSString *)str publicKey:(NSString *)pubKey;
@end

NS_ASSUME_NONNULL_END
