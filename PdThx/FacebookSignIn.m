//
//  FacebookSignIn.m
//  PdThx
//
//  Created by James Rhodes on 6/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookSignIn.h"
#import "FBHelperReturnProtocol.h"


@implementation FacebookSignIn

@synthesize returnDelegate;

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
    [super dealloc];
}

-(void)getFacebookFriendsWithDelegate:(id)returnDelegatez withSocialNetworkUserId:(NSString*)userId withSocialNetworkAccessToken:(NSString*)accessToken
{
    returnDelegate = returnDelegatez;
    ASIHTTPRequest* requestObj;
    
    // Example request:
    //https://graph.facebook.com/me/friends?access_token=AAAAAAITEghMBAMR0wyKmBEIpCgCt6GHRfPZAWvnVFDPqzyRxZCOyfZA9F8iSnZAQLJJlZBFUdZBpOCqu7h8Dfzy8QFlBnIKAjB4MTiJTIEWwZDZD
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat:@"https://graph.facebook.com/%@/friends?access_token=%@&limit=5000",userId,accessToken]] autorelease];
    
    requestObj= [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj setRequestMethod: @"GET"];
    
    [requestObj setDelegate:self];
    [requestObj setDidFinishSelector:@selector(getFacebookFriendsDidComplete:)];
    [requestObj setDidFailSelector:@selector(getFacebookFriendsDidFail:)];
    
    [requestObj startAsynchronous];
}

-(void) getFacebookFriendsDidComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary*jsonResult = [parser objectWithString:[request responseString]];
    
    [parser release];
    
    [returnDelegate linkedFacebookFriendsDidLoad:jsonResult];
}

-(void) getFacebookFriendsDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Facebook friends failed to load.");
}


- (void)signInWithFacebook:(id)returnProtocol
{
    PdThxAppDelegate* appDelegate = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]);
    
    returnDelegate = returnProtocol;
    
    [FBSession openActiveSessionWithPermissions:appDelegate.permissions allowLoginUI:YES
                              completionHandler:^(FBSession *session,
                                                  FBSessionState status,
                                                  NSError *error)
     {
         if (session.isOpen)
         {
             FBRequest *me = [FBRequest requestForMe];
             [me startWithCompletionHandler: ^(FBRequestConnection *connection,
                                               NSDictionary<FBGraphUser> *my,
                                               NSError *error)
              {
                  if ( error )
                  {
                      NSLog(@"Error getting facebook 'me' request. Stopping.");
                      [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Sign In Failed"];
                      NSLog ( @"Error occurred -> %@" , [error description] );
                      [returnDelegate fbSignInCancelled];
                  }
                  else
                  {
                      [returnDelegate fbSignInCompleteWithMEResponse:my];
                  }
              }];
         }
     }];
}

-(void)getFacebookFriends:(id)sender
{
    PdThxAppDelegate* appDelegate = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]);
    
    FBRequest *friends = [FBRequest requestForMyFriends];
    [friends startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if ( error )
        {
            NSLog(@"Error getting facebook friends...");
            [appDelegate showErrorWithStatus:@"Error!" withDetailedStatus:@"Friends Failed"];
            NSLog ( @"Error occurred -> %@" , [error description] );
            [returnDelegate fbSignInCancelled];
        } else {
            [sender facebookFriendsDidLoad:result];
        }
    }];
}


-(void)linkNewFacebookAccount:(id)callback
{
    [self setReturnDelegate:callback];
    
    FBSession *newSess = [[FBSession alloc] init];
    [newSess openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
     {
         if ( error )
         {
             NSLog(@"Error, did not open new session.");
             
             PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
             [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Linking Failed"];
         }
         else
         {
             NSLog(@"Opened session.");
             [self saveLinkedFacebookSession:session];
         }
     }];
}

-(void)unlinkFacebookAccount:(id)callback
{
    [self setReturnDelegate:callback];
    
    [self deleteSavedLinkedFacebookSession];
}

-(void)deleteSavedLinkedFacebookSession
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/SocialNetworks", myEnvironment.pdthxWebServicesBaseUrl, appDelegate.user.userId]] autorelease];
    
    
    // TODO: Finish Implementation of Web Services for Unlinking a Facebook Account.
    
    NSDictionary *meCodeData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Facebook",@"SocialNetworkType", nil];
    
    NSString *newJSON = [meCodeData JSONRepresentation];
    
    ASIHTTPRequest* requestObj;
    requestObj= [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];
    
    [requestObj setDelegate:self];
    [requestObj setDidFinishSelector:@selector(unlinkFacebookSucceeded:)];
    [requestObj setDidFailSelector:@selector(unlinkFacebookFailed:)];
    
    [requestObj startAsynchronous];
}

-(void) unlinkFacebookSucceeded:(ASIHTTPRequest *)request
{
    NSLog(@"Link FB Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if ( [request responseStatusCode] == 200 || [request responseStatusCode] == 201 )
    {
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showSuccessWithStatus:@"Success!" withDetailedStatus:@"Facebook Unlinked"];
    }
    else
    {
        [self unlinkFacebookFailed:request];
    }
}

-(void) unlinkFacebookFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Link Facebook failed with Exception");
    NSLog(@"Link FB Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Unlinking Failed"];
}


-(void)saveLinkedFacebookSession:(FBSession*)sessionOpened
{
    [FBSession setActiveSession:sessionOpened];
    
    FBRequest*meRequest = [FBRequest requestForMe];
    
    [meRequest startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *my, NSError *error)
    {
        if ( error )
        {
            NSLog(@"Error getting linked facebook session, with reason %@", [error description]);
            
            PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Linking Failed"];
        }
        else
        {
            NSLog(@"Linked Facebook Session Opened -> Setting information in user social networks and calling service.");
            
            User* user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
            
            NSMutableDictionary*socialNetworkDictionary = [[NSMutableDictionary alloc] init];
            
            [socialNetworkDictionary setObject:@"Facebook" forKey:@"SocialNetwork"];
            [socialNetworkDictionary setObject:[my objectForKey:@"id"] forKey:@"SocialNetworkUserId"];
            [socialNetworkDictionary setObject:[FBSession activeSession].accessToken forKey:@"SocialNetworkUserToken"];
            
            //[user.socialNetworks setObject:socialNetworkDictionary forKey:@"Facebook"];
            
            [self updateRemoteServerSocialNetworks:user.userId withSocialNetwork:socialNetworkDictionary];
        }
    }];
}

-(void)updateRemoteServerSocialNetworks:(NSString*)userId withSocialNetwork:(NSMutableDictionary*)socialNetworkDictionary
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/SocialNetworks", myEnvironment.pdthxWebServicesBaseUrl, userId]] autorelease];
    
    NSDictionary *meCodeData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Facebook",@"SocialNetworkType",
                                [socialNetworkDictionary objectForKey:@"SocialNetworkUserId"],@"SocialNetworkUserId",
                                [socialNetworkDictionary objectForKey:@"SocialNetworkUserToken"],@"SocialNetworkUserToken",
                                nil];
    
    NSString *newJSON = [meCodeData JSONRepresentation];
    
    ASIHTTPRequest* requestObj;
    requestObj= [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];
    
    [requestObj setDelegate:self];
    [requestObj setDidFinishSelector:@selector(linkFacebookSucceeded:)];
    [requestObj setDidFailSelector:@selector(linkFacebookFailed:)];
    
    [requestObj startAsynchronous];
}

-(void) linkFacebookSucceeded:(ASIHTTPRequest *)request
{
    NSLog(@"Link FB Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if ( [request responseStatusCode] == 200 || [request responseStatusCode] == 201 )
    {
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showSuccessWithStatus:@"Success!" withDetailedStatus:@"Facebook Linked!"];
    }
    else
    {
        [self linkFacebookFailed:request];
    }
}

-(void) linkFacebookFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Link Facebook failed with Exception");
    NSLog(@"Link FB Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Linking Failed"];
}

@end