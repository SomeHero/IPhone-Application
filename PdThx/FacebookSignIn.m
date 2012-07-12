//
//  FacebookSignIn.m
//  PdThx
//
//  Created by James Rhodes on 6/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookSignIn.h"


@implementation FacebookSignIn


- (id) init 
{
    if (self == [super init])
    {
        service = [[SignInWithFBService alloc] init];
    }
    
    return self;
}
- (void)dealloc {
    [service release];
    [fBook release];
    [super dealloc];
}


-(void)fbDidLogin
{
    NSLog(@"Got here.");
    NSLog(@"FBExpirationDate: %@", fBook.expirationDate);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:fBook.accessToken forKey:@"FBAccessTokenKey"];
    [defaults setValue:fBook.expirationDate forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self requestUserFBInfo];
}


- (void)signInWithFacebook:(id)sender {
    userInfoDelegate = sender;
    
    NSArray * permissions = [[NSArray alloc] initWithObjects:@"email",@"read_friendlists", @"publish_stream", nil];
    
    fBook = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).fBook;
    fBook.sessionDelegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        fBook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        fBook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    [defaults synchronize];
    
    if ( ![fBook isSessionValid] ){
        [fBook authorize:permissions];
    } else {
        [self requestUserFBInfo];
    }
    
    [permissions release];
}

-(void)requestUserFBInfo
{
    
    NSLog(@"FBExpirationDate: %@", fBook.expirationDate);
    
    PdThxAppDelegate*appDelegate = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]);
    [fBook requestWithGraphPath:@"me" andDelegate:userInfoDelegate];
    [fBook requestWithGraphPath:@"me/friends" andDelegate:appDelegate];
}
@end