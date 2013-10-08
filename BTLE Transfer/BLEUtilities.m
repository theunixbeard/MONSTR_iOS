//
//  BLEUtilities.m
//  BTLE Transfer
//
//  Created by Ben Gelsey on 9/30/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "BLEUtilities.h"
#import <math.h>
#define StringFromBOOL(b) ((b) ? @"YES" : @"NO")

@implementation BLEUtilities

/* Converts a hex string to a number. The MSB (bit not byte) is a sign bit.
 * Returns true on success, false if invalid hex string.
 */
+(BOOL)hexString:(NSString *) inputHexString toNumber:(NSArray **) result width:(NSUInteger) width count:(NSUInteger) count {
  NSMutableString *hexString = [NSMutableString stringWithString:inputHexString];
  NSInteger currentInt = 0;
  BOOL isNegative;
  NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:count];
  NSArray *resultArray;
  
  unichar hexChar;
  for(NSUInteger i = 0; i < count; ++i) {
    currentInt = 0;
    isNegative = false;
    hexChar = [hexString characterAtIndex:i * width];
    // Check if valid hex character, bail if invalid
    if(![BLEUtilities validHexCharacter:hexChar]) {
      NSLog(@"Invalid Hex Char: %c", hexChar);
      return false;
    }
    NSLog(@"yes 8s! %@", hexString);
    // Check if MSB upper half, if so make negative and subtract 8
    if([BLEUtilities validUpperHalfHexCharacter:hexChar]) {
      isNegative = true;
      unichar modifiedChar = [BLEUtilities subtract8FromHex:hexChar];
      NSRange range = {.location = i * width, .length = 1};
      [hexString replaceCharactersInRange: range
                               withString: [NSString stringWithCharacters:&modifiedChar length:1]];
    }
    NSLog(@"no 8s! %@, is negative: %@", hexString, StringFromBOOL(isNegative));
    for(NSUInteger j = 0; j < width; ++j) {
      // Check if valid hex character, bail if invalid
      hexChar = [hexString characterAtIndex:(i * width) + j];
      // Check if valid hex character, bail if invalid
      if(![BLEUtilities validHexCharacter:hexChar]) {
        NSLog(@"Invalid Hex Char2: %c at index %d", hexChar, (i*width)+j);
        return false;
      }
      // Convert to int
      NSInteger tempInt;
      [BLEUtilities mod16FromHex:hexChar toNumber:&tempInt];
      // Accumulate actual number
      currentInt = currentInt*16 + tempInt;
    }
    // Negate if necessary and store in returnArray
    if(isNegative) {
      currentInt *= -1;
    }
    [returnArray insertObject: [NSNumber numberWithInt:currentInt] atIndex: i];
  }
  
  // Convert result to NSArray and return
  resultArray = [returnArray copy];
  *result = resultArray;
  return true;
}

/* Uses all elements in the vector to come up with its norm */
+(NSNumber *)normOfVector: (NSArray *) vector {
  NSNumber *resultNorm;
  double resultDouble = 0;
  
  // Iterate over vector, add up squares of each element
  for(int i = 0; i < [vector count]; ++i) {
    NSNumber* vectorValue = (NSNumber *)[vector objectAtIndex: i];
    resultDouble += pow([vectorValue doubleValue], 2.0);
  }
  
  // Take square root of entire thing
  resultDouble = sqrt(resultDouble);
  
  // Convert result to NSNumber and return
  resultNorm = [NSNumber numberWithDouble: resultDouble];
  return resultNorm;
}

/* Private helper methods */

/* Returns 'X' on failure, valid hex char otherwise */
+(BOOL)mod16FromHex: (unichar) c toNumber: (NSInteger *) number {
  NSInteger intNumber = 0;
  if(![BLEUtilities validHexCharacter: c]) {
    return false;
  }
  if([BLEUtilities validLetterHexCharacter: c] ) {
    intNumber = 10 + (c - 'A');
  } else {
    intNumber = c - '0';
  }
  *number = intNumber;
  return true;
}

/* Returns 'X' on failure, valid hex char otherwise */
+(unichar) subtract8FromHex:(unichar) c {
  if(![BLEUtilities validUpperHalfHexCharacter: c]) {
    return 'X';
  } else if(c == '8' || c == '9') {
    return c - 8;
  } else {
    return '7' - ('F' - c);
  }
}

+(BOOL) validUpperHalfHexCharacter: (unichar) c {
  if(c == '8' || c == '9') {
    return true;
  } else if (c >= 'A' && c <= 'F') {
    return true;
  }
  return false;
}

+(BOOL) validLowerHalfHexCharacter: (unichar) c{
  if(c >= '0' && c <= '7') {
    return true;
  }
  return false;
}
     
+(BOOL) validNumberHexCharacter: (unichar) c{
  if(c >= '0' && c <= '9') {
    return true;
  }
  return false;
}
+(BOOL) validLetterHexCharacter: (unichar) c{
  if(c >= 'A' && c <= 'F') {
   return true;
 }
  return false;
}

+(BOOL) validHexCharacter: (unichar) c {
  return [BLEUtilities validUpperHalfHexCharacter: c] || [BLEUtilities validLowerHalfHexCharacter: c];
}



@end
