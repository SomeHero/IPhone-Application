//
//  Contact.m
//  PdThx
//
//  Created by James Rhodes on 12/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize name, phoneNumber, emailAddress, facebookID, imgData, firstName, lastName;
@synthesize recipientUri;
@synthesize recipientId;

-(NSComparisonResult)compare:(Contact*)otherContact {
    NSString * comparedProperty1 = ( self.lastName.length == 0 ? self.firstName : self.lastName );
    NSString * comparedProperty2 = ( otherContact.lastName.length == 0 ? otherContact.firstName : otherContact.lastName );
    
    if ( [comparedProperty1 caseInsensitiveCompare:comparedProperty2] == NSOrderedSame )
        return [self compareMore:otherContact];
    else {
        return [comparedProperty1 caseInsensitiveCompare:comparedProperty2];
    }
}


-(NSComparisonResult)compareMore:(Contact*)otherContact {
    NSString *comparedProperty1 = self.firstName;
    NSString *comparedProperty2 = otherContact.firstName;
    
    if ( [comparedProperty1 caseInsensitiveCompare:comparedProperty2] == NSOrderedSame ){
        if ( self.facebookID != (id)[NSNull null] && ![self.facebookID isEqualToString:@""] )
            return NSOrderedAscending;
    } else {
        return [comparedProperty1 caseInsensitiveCompare:comparedProperty2];
    }
    
    return [comparedProperty1 caseInsensitiveCompare:comparedProperty2];
}
                
- (void)dealloc {
    [name release];
    [phoneNumber release];
    [emailAddress release];
    [facebookID release];
    [imgData release];
    [firstName release];
    [lastName release];
    [recipientUri release];
    [recipientId release];
    
    [super dealloc];
}
@end    