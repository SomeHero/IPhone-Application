//
//  HelpViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIModalBaseViewController.h"
#import "Environment.h"

@interface HelpViewController : UISetupUserBaseViewController
{
    IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIWebView *webView;

@end
