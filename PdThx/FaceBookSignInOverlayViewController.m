//
//  FaceBookSignInOverlayViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FaceBookSignInOverlayViewController.h"

@implementation FaceBookSignInOverlayViewController

@synthesize facebookSignInCompleteDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    faceBookSignInHelper = [[FacebookSignIn alloc] init];
    
    signInUserService = [[SignInUserService alloc] init];
    [signInUserService setUserSignInCompleteDelegate:self];
    
    service = [[SignInWithFBService alloc] init];
    service.fbSignInCompleteDelegate = self;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if ( ![fBook isSessionValid] )
        [faceBookSignInHelper signInWithFacebook:facebookSignInCompleteDelegate];
    else {
        [fBook requestWithGraphPath:@"me" andDelegate:self];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
