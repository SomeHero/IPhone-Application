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
    NSString *firstName;
    NSString *lastName;
    NSString *phoneNumber;
    NSString *emailAddress;
    NSString *facebookID;
    UIImage *imgData;
    NSString *recipientUri;
}

@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* phoneNumber;
@property(nonatomic, retain) NSString *emailAddress;
@property(nonatomic, retain) NSString *facebookID;
@property(nonatomic, retain) UIImage *imgData;
@property(nonatomic, retain) NSString *firstName;
@property(nonatomic, retain) NSString *lastName;
@property(nonatomic, retain) NSString *recipientUri;

-(NSComparisonResult)compare:(Contact*)otherContact;

@end