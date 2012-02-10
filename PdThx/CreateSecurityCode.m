//
//  CreateSecurityCode.m
//  PdThx
//
//  Created by James Rhodes on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateSecurityCode.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>
#import "VerificationMobileDevice.h"
#import "ACHAccountSetup.h"

@implementation CreateSecurityCode
@synthesize recipientMobileNumber, amount, comment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *img=[[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
    img.image=[UIImage imageNamed:@"background_nav.png"];
    [self.view addSubview:img];
    
    UILabel *lbl=[[[UILabel alloc] initWithFrame:CGRectMake(0, 8, 320, 80)] autorelease];
    lbl.text=@"Set Security Pin";
    lbl.font=[UIFont boldSystemFontOfSize:25];
    lbl.textAlignment=UITextAlignmentCenter;
    lbl.textColor=[UIColor whiteColor];
    lbl.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:lbl];
    

}
-(void) viewDidAppear:(BOOL)animated{
    _viewLock=[[[ALUnlockPatternView alloc] initWithFrame:CGRectMake(36, 140, 200, 200)] autorelease];
    _viewLock.delegate=self;
    _viewLock.lineColor=[UIColor whiteColor];
    _viewLock.lineWidth=12;
    _viewLock.lineColor=[UIColor colorWithRed:0.576 green:0.816 blue:0.133 alpha:1.000];
    [_viewLock setCellsBackgroundImage:[UIImage imageNamed:@"nSel.png"] forState:UIControlStateNormal];
    [_viewLock setCellsBackgroundImage:[UIImage imageNamed:@"sel.png"] forState:UIControlStateSelected];
    [_viewLock setCellsBackgroundImage:[UIImage imageNamed:@"hSel.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_viewLock];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)unlockPatternView:(ALUnlockPatternView *)patternView didSelectCellAtIndex:(int)index andpartialCode:
(NSString *)partialCode{
    NSString *state=@"";    
    for (int i=1; i<=9; i++)
        state=[state stringByAppendingFormat:@"%d",[_viewLock isCellSelected:i]];
    NSLog(@"%@",state);
    //NSLog(@"%d %@",index,partialCode);
    //[_delegate insertedCode:partialCode];
}
-(void)unlockPatternView:(ALUnlockPatternView *)patternView selectedCode:(NSString *)code{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userId = [prefs stringForKey:@"userId"];
    
    NSLog(@"Your code is %@", code);

    if([code length] > 3 && [code length] < 6) {
        [self setSecurityPin:code forUser: userId];
    }
    else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Invalid Pin"
                                                                message: @"Select a pin between 4 and 6 dots"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            
        [alertView show];
        [alertView release];
    }
    
}
-(void) setSecurityPin:(NSString *) securityPin forUser:(NSString *) userId
{
    
    NSString *rootUrl = [NSString stringWithString: @"pdthx.me"];
    NSString *apiKey = [NSString stringWithString: @"bda11d91-7ade-4da1-855d-24adfe39d174"];
    NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"http://%@/Services/UserService/SetupSecurityPin?apiKey=%@", rootUrl, apiKey]] autorelease];  
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 userId, @"userId",
                                 deviceId, @"deviceId",
                                 securityPin, @"securityPin",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(setSecurityPinComplete:)];
    [request setDidFailSelector:@selector(setSecurityPinFailed:)];
    
    [request startAsynchronous];
}
-(void) setSecurityPinComplete: (ASIHTTPRequest *) request {
    
    NSString *theJSON = [request responseString];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    bool success = [[jsonDictionary objectForKey:@"success"] boolValue];
    NSString *message = [[NSString alloc] initWithString:[jsonDictionary objectForKey:@"message"]];
    
    if(success) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setBool:YES forKey:@"setupSecurityPin"];
        [prefs synchronize];
        
        ACHAccountSetup* viewController = [[ACHAccountSetup alloc] initWithNibName:@"ACHAccountSetup" bundle:nil];
        viewController.title = @"Setup Your ACH Account";
    
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Unable to Setup Your Pin"
                                                            message: @"Something happened.  We were unable to setup your pin.  Try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
    }
    
}
-(void) registerUserFailed:(ASIHTTPRequest *)request
{
    // statsCommuniqueDoneProblem ... !
    NSLog(@"Setup Security Pin Failed");
}

@end
