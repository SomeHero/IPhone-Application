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

- (void)signInWithFacebook:(id)sender {
    NSArray * permissions = [[NSArray alloc] initWithObjects:@"email",@"read_friendlists", @"publish_stream", nil];
    
    fBook = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).fBook;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        fBook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        fBook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if ( ![fBook isSessionValid] )
        [fBook authorize:permissions];
    
    NSLog(@"Back from authorization... Valid? %@", [fBook isSessionValid] ? @"YES" : @"NO" );
    
    // Graph Command is Used to Graph User Information.
    // This requests only basic, and Email Address Information.
    // This does not require the user accepts the Email Address Permission
    [fBook requestWithGraphPath:@"me" andDelegate:((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate])];
    
    [permissions release];
}

@end
