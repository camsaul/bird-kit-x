//
//  NSData+X.m
//  XPlatform
//
//  Created by Cam Saül on 3/12/14.
//  Copyright (c) 2014 Cam Saül. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSData+X.h"

@implementation NSData (X)

- (NSString *)MD5Hash
{
    unsigned char result[16];
    CC_MD5([self bytes], (unsigned)[self length], result);
    NSString *imageHash = [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return imageHash;
}


@end
