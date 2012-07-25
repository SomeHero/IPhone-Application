//
//  AboutPageViewController.h
//  PdThx
//
//  Created by Justin Cheng on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AboutPageViewController : UIViewController
{
    IBOutlet UIView *viewPanel;

    IBOutlet UIWebView *videoView;
    IBOutlet UIButton *toMobileWeb;

}


- (IBAction)linkToMobileWeb:(id)sender;
@property (nonatomic, retain) UIView *viewPanel;
@property (retain, nonatomic) IBOutlet UIWebView *videoView;

@end
