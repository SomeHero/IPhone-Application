//
//  Contact.h
//  PdThx
//
//  Created by James Rhodes on 12/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Contact : NSObject {	
    NSString *name;	
    NSString *phoneNumber;
    //NSString *twitterName;
    //NSString *emailAddress;
    //NSString *googlePlusName;
}

@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* phoneNumber;

@end