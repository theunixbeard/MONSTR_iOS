//
//  BLEUtilities.h
//  BTLE Transfer
//
//  Created by Ben Gelsey on 9/30/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEUtilities : NSObject

/* Converts a hex string to a number. The MSB (bit not byte) is a sign bit */
+(BOOL)hexString:(NSString *) inputHexString toNumber:(NSArray **) result width:(NSUInteger) width count:(NSUInteger) count;

/* Uses all elements in the vector to come up with its norm */
+(NSNumber *)normOfVector: (NSArray *) vector;

@end
