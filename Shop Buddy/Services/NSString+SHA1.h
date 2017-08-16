//
//  NSString+SHA1.h
//  DigitEyes
//

#import <Foundation/Foundation.h>

@interface NSString (SHA1)

- (NSString *)hashedValue:(NSString *)key;

@end
