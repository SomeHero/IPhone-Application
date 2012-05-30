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

-(NSComparisonResult)compare:(Contact*)otherContact {
    NSString * comparedProperty1 = ( self.lastName.length == 0 ? self.firstName : self.lastName );
    NSString * comparedProperty2 = ( otherContact.lastName.length == 0 ? otherContact.firstName : otherContact.lastName );
    
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
    
    [super dealloc];
}
@end