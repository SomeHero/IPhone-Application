//
//  ContactSelectViewController.h
//  PdThx
//
//  Created by James Rhodes on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "PhoneNumberFormatting.h"
#import "IconDownloader.h"
#import "ContactSelectChosenProtocol.h"
#import "UIContactSelectBaseViewControllerViewController.h"

@interface ContactSelectViewController : UIContactSelectBaseViewControllerViewController    
{}

- (IBAction)pressedSearchBox:(id)sender;

@end