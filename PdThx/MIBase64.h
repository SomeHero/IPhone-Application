//
//  MIBase64.h
//

#import <Foundation/Foundation.h>

@interface MIBase64 : NSObject

+ (NSString *)base64Encoding:(NSData *)input;
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

@end
