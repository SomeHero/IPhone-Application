//
//  ACHAccountReminderProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 This class is used to handle getting back to the main navigation controller
 when logging in and getting the skip/addnow dialog for setting up an ACH Account
 */

@protocol ACHAccountReminderProtocol <NSObject>

-(void)didAddACHAccount;
-(void)didSkipACHAccount;

@end
