//
//  AddMeCodeViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIModalBaseViewController.h"
#import "PayPointService.h"

@interface AddMeCodeViewController : UIModalBaseViewController
{
    IBOutlet UITextField* txtMeCode;
    PayPointService* payPointService;
}

-(IBAction)btnSubmitClicked;

@end
