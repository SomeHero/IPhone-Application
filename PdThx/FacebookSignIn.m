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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[fBook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[fBook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self requestUserFBInfo];
}

- (void)signInWithFacebook:(id)sender {
    PdThxAppDelegate* appDelegate = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]);
    
    userInfoDelegate = sender;
    
    NSArray * permissions = [[NSArray alloc] initWithObjects:@"email",@"read_friendlists", @"publish_stream", nil];
    
    fBook = appDelegate.fBook;
    
    [fBook setSessionDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        fBook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        fBook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if ( ![fBook isSessionValid] ){
        [fBook authorize:permissions];
    } else {
        [self requestUserFBInfo];
    }
    
    [permissions release];
}

-(void)requestUserFBInfo
{
    PdThxAppDelegate*appDelegate = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]);
    [fBook requestWithGraphPath:@"me" andDelegate:userInfoDelegate];
    [fBook requestWithGraphPath:@"me/friends" andDelegate:appDelegate];
}


-(void) request:(FBRequest *)request didLoad:(id)result
{
    [service validateUser:result];
}

-(void) request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog ( @"Error occurred -> %@" , [error description] );
}

@end