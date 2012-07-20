//
//  AddPhoneViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIModalBaseViewController.h"
#import "PayPointService.h"
#import "AddPayPointCompleteProtocol.h"

@interface AddPhoneViewController : UIModalBaseViewController
{
    IBOutlet UITextField* txtPhoneNumber;
    PayPointService* payPointService;
    id<AddPayPointCompleteProtocol> addPayPointComplete;
}

@property(nonatomic, retain) id<AddPayPointCompleteProtocol> addPayPointComplete;

-(IBAction)btnSubmitClicked;


@end
