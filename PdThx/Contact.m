//
//  Contact.m
//  PdThx
//
//  Created by James Rhodes on 12/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize userId;
@synthesize name, facebookID, imgData, firstName, lastName;
@synthesize recipientId;
@synthesize preferredAccountId;
@synthesize paypoints;
@synthesize showDetailIcon;
@synthesize merchant;

-(id) init
{
    [super init];
    
    if (self)
    {
        paypoints = [[NSMutableArray alloc] init];
        showDetailIcon = false;
    }
    
    return self;
}

-(NSComparisonResult)compare:(Contact*)otherContact
{
    NSString * comparedProperty1 = ( self.lastName.length == 0 ? self.firstName : self.lastName );
    NSString * comparedProperty2 = ( otherContact.lastName.length == 0 ? otherContact.firstName : otherContact.lastName );
    
    if ( [comparedProperty1 caseInsensitiveCompare:comparedProperty2] == NSOrderedSame )
        return [self compareMore:otherContact];
    else
        return [comparedProperty1 caseInsensitiveCompare:comparedProperty2];
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

-(NSString*)getSenderName
{
    if ( name != (id)[NSNull null] && name.length > 0 )
    {
        return name;
    }
    else if ( firstName != (id)[NSNull null] && lastName != (id)[NSNull null] && firstName.length > 0 && lastName.length > 0 )
    {
        return [NSString stringWithFormat:@"%@ %@",firstName, lastName];
    } else if ( paypoints && [paypoints count] > 0 )
    {
        return [paypoints objectAtIndex:0];
    } else {
        return recipientId;
    }
}
    
- (void)dealloc {
    [name release];
    [facebookID release];
    [imgData release];
    [firstName release];
    [lastName release];
    [recipientId release];
    [preferredAccountId release];
    [paypoints release];
    [merchant release];

    [super dealloc];
}
@end    