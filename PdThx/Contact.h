//
//  Contact.h
//  PdThx
//
//  Created by James Rhodes on 12/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Contact : NSObject {
	NSString* userId;
    NSString *name;
    NSString *firstName;
    NSString *lastName;
    NSString *paypoint;
    NSString *facebookID;
    UIImage *imgData;
    NSString *recipientUri;
    NSString* recipientId;
    NSString* preferredAccountId;
    NSMutableArray* paypoints;
}

@property(nonatomic, retain) NSString* userId;
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* paypoint;
@property(nonatomic, retain) NSString *facebookID;
@property(nonatomic, retain) UIImage *imgData;
@property(nonatomic, retain) NSString *firstName;
@property(nonatomic, retain) NSString *lastName;
@property(nonatomic, retain) NSString *recipientUri;
@property(nonatomic, retain) NSString* recipientId;
@property(nonatomic, retain) NSString* prefferedAccountId;
@property(nonatomic, retain) NSMutableArray* paypoints;

-(NSComparisonResult)compare:(Contact*)otherContact;

@end