//
//  PersonalizeViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonalizeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PdThxAppDelegate.h"
#import "User.h"
#import "ASIFormDataRequest.h"

@interface PersonalizeViewController ()

@end

@implementation PersonalizeViewController

@synthesize firstNameField, lastNameField, userImageButton, saveContinueButton;

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
    
    [self setTitle: @"Personalize"];
    
    [userImageButton.layer setCornerRadius:6.0];
    [userImageButton.layer setMasksToBounds:YES];
}   
-(void)viewDidAppear:(BOOL)animated {
    User* user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    if(user.firstName != (id)[NSNull null] && [user.firstName length] > 0)
        firstNameField.text = user.firstName;
    else
        firstNameField.text = @"";
    
    if(user.lastName != (id)[NSNull null] && [user.lastName length] > 0)
        lastNameField.text = user.lastName;
    else
        lastNameField.text = @"";
    
    if([user.imageUrl length] > 0)
    {
        [userImageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: user.imageUrl]]] forState:UIControlStateNormal];
    }
    else {
        [userImageButton setBackgroundImage:[UIImage imageNamed: @"avatar_unknown.jpg"] forState:UIControlStateNormal];
    }
}
- (void)viewDidUnload
{
    [userImageButton release];
    userImageButton = nil;
    [firstNameField release];
    firstNameField = nil;
    [lastNameField release];
    lastNameField = nil;
    [saveContinueButton release];
    saveContinueButton = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [userImageButton release];
    [firstNameField release];
    [lastNameField release];
    [saveContinueButton release];
    [super dealloc];
}
- (IBAction)pressedSaveContinue:(id)sender 
{
     [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
}
-(void)uploadFile:(NSString*)file toURL: (NSString*) uploadURL{
    
    NSURL *url = [NSURL URLWithString: uploadURL];
    
    requestObj = [ASIFormDataRequest requestWithURL:url];
    
    [requestObj setUseKeychainPersistence:YES];
    //if you have your site secured by .htaccess
    
    //[request setUsername:@"login"];
    //[request setPassword:@"password"];
    
    
    NSString *fileName = [NSString stringWithFormat:@"ipodfile%@.jpg", file];
    [requestObj addPostValue:fileName forKey:@"name"];
    
    // Upload an image
    //NSData *imageData = UIImageJPEGRepresentation([UIImage imageName:fileName])
    //[request setData:imageData withFileName:fileName andContentType:@"image/jpeg" forKey:@"userfile"];
    
    [requestObj setDelegate:self];
    [requestObj setDidFinishSelector:@selector(uploadRequestFinished:)];
    [requestObj setDidFailSelector:@selector(uploadRequestFailed:)];
    
    [requestObj startAsynchronous];
}

- (void)uploadRequestFinished:(ASIHTTPRequest *)request{    
    NSString *responseString = [request responseString];
    NSLog("Upload response %@", responseString);
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    
    NSLog(@" Error - Statistics file upload failed: \"%@\"",[[request error] localizedDescription]); 
}
@end
