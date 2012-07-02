//
//  AddPhoneViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIModalBaseViewController.h"
#import "PayPointService.h"

@interface AddPhoneViewController : UIModalBaseViewController
{
    IBOutlet UITextField* txtPhoneNumber;
    PayPointService* payPointService;
}

-(IBAction)btnSubmitClicked;

@end
