//
//  FacebookSignIn.m
//  PdThx
//
//  Created by James Rhodes on 6/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookSignIn.h"
#import "FBHelperReturnProtocol.h"
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const FBSessionStateChangedNotification;
NSString *const FBSessionStateChangedNotification = @"com.paidthx.ios:FBSessionStateChangedNotification";

@implementation FacebookSignIn

@synthesize returnDelegate;
@synthesize getFacebookFriendsDelegate;
@synthesize linkDelegate;
@synthesize unlinkDelegate;

- (id) init
{
    if (self == [super init])
    {
        service = [[SignInWithFBService alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
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
    
    [getFacebookFriendsDelegate linkedFacebookFriendsDidLoad:jsonResult];
}

-(void) getFacebookFriendsDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Facebook friends failed to load.");
}

- (void)signInWithFacebook:(id)returnProtocol
{
    [FBSettings setLoggingBehavior:[NSSet setWithObjects:FBLoggingBehaviorFBRequests, FBLoggingBehaviorFBURLConnections, FBLoggingBehaviorAccessTokens, FBLoggingBehaviorSessionStateTransitions, nil]];
    
    PdThxAppDelegate* appDelegate = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]);
    returnDelegate = returnProtocol;
    
    
    [FBSession openActiveSessionWithPermissions:appDelegate.permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self signedInWithSession:session state:state error:error];
     }];
    
    /*[FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self signedInWithSession:session state:state error:error];
     }];
     */
}

- (void)signedInWithSession:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
        {
            NSLog(@"Session opened...");
            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error)
                {
                    [returnDelegate fbSignInCompleteWithMEResponse:result];
                } else {
                    [returnDelegate fbSignInCancelled];
                }
            }];
            break;
        }
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error)
    {
        NSLog(@"Error, %@",error);
        [returnDelegate fbSignInCancelled];
    }
}

-(void)getFacebookFriends:(id)sender
{
    PdThxAppDelegate* appDelegate = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]);
    
    if ( [FBSession activeSession].isOpen )
    {
        FBRequest *friends = [FBRequest requestForMyFriends];
        [friends startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
        {
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
    } else {
        [appDelegate showErrorWithStatus:@"Facebook Error" withDetailedStatus:@"No active session"];
        [returnDelegate fbSignInCancelled];
    }
}

-(void)linkNewFacebookAccount:(id)callback
{
    [self setLinkDelegate:callback];
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [FBSession openActiveSessionWithReadPermissions:appDelegate.permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
    {
        if ( error )
        {
            NSLog(@"Error, did not open new session.");
            [appDelegate showSimpleAlertView:NO withTitle:@"Error" withSubtitle:@"Facebook Link Failed" withDetailedText:@"We were unable to link your PaidThx account with Facebook. Please check your wireless connection and try again." withButtonText:@"Ok" withDelegate:self];
            [linkDelegate facebookAccountLinkFailed];
            
        }
        else
        {
            NSLog(@"Opened session. %@", [FBSession activeSession].isOpen ? @"YES!" : @"NO!");
            [self saveLinkedFacebookSession:session];
        }
    }];
}

-(void)unlinkFacebookAccount:(id)callback
{
    [self setUnlinkDelegate:callback];
    [self deleteSavedLinkedFacebookSession];
}

-(void)deleteSavedLinkedFacebookSession
{
    Environment *myEnvironment = [Environment sharedInstance];
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];

    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/SocialNetworks/unlink", myEnvironment.pdthxWebServicesBaseUrl, appDelegate.user.userId]] autorelease];
    
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
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ( [request responseStatusCode] == 200 || [request responseStatusCode] == 201 )
    {
        [self removeSavedFacebookAccount];
        
        [appDelegate showSimpleAlertView:YES withTitle:@"Success" withSubtitle:@"Facebook Unlinked" withDetailedText:@"Your Facebook account has been unlinked from your PaidThx account. Your friends will not be seen in your contact list anymore." withButtonText:@"Ok" withDelegate:self];
        [unlinkDelegate facebookAccountUnlinkSuccess];
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
    
    [appDelegate showSimpleAlertView:NO withTitle:@"Error" withSubtitle:@"Facebook Unlink Failed" withDetailedText:@"We were unable to unlink your PaidThx account with Facebook. Please check your wireless connection and try again." withButtonText:@"Ok" withDelegate:self];
    
    [unlinkDelegate facebookAccountUnlinkFailed];
}

-(void)removeSavedFacebookAccount
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary*mutableSocialNetworks = [appDelegate.user.socialNetworks mutableCopy];
    
    [mutableSocialNetworks removeObjectForKey:@"Facebook"];
    
    [appDelegate.user setSocialNetworks:mutableSocialNetworks];
}

-(void)saveLinkedFacebookSession:(FBSession*)sessionOpened
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    FBRequest*meRequest = [FBRequest requestForMe];
    
    if ( [FBSession activeSession].isOpen )
    {
        [meRequest startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *my, NSError *error)
         {
             if ( error )
             {
                 NSLog(@"Error getting linked facebook session, with reason %@", [error description]);
                 
                 [appDelegate showSimpleAlertView:NO withTitle:@"Error" withSubtitle:@"Facebook Link Failed" withDetailedText:@"We were unable to link your PaidThx account with Facebook. Please check your wireless connection and try again." withButtonText:@"Ok" withDelegate:self];
                 [linkDelegate facebookAccountLinkFailed];
             }
             else
             {
                 User* user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
                 
                 NSMutableDictionary*socialNetworkDictionary = [[NSMutableDictionary alloc] init];
                 
                 [socialNetworkDictionary setObject:@"Facebook" forKey:@"SocialNetwork"];
                 [socialNetworkDictionary setObject:[my objectForKey:@"id"] forKey:@"SocialNetworkUserId"];
                 [socialNetworkDictionary setObject:[FBSession activeSession].accessToken forKey:@"SocialNetworkUserToken"];
                 
                 NSMutableDictionary*newUserNetworks = [user.socialNetworks mutableCopy];
                 [newUserNetworks setObject:socialNetworkDictionary forKey:@"Facebook"];
                 [user setSocialNetworks:newUserNetworks];
                 
                 [self updateRemoteServerSocialNetworks:user.userId withSocialNetwork:socialNetworkDictionary];
             }
         }];
    }
}

-(void)updateRemoteServerSocialNetworks:(NSString*)userId withSocialNetwork:(NSMutableDictionary*)socialNetworkDictionary
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];

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
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"Link FB Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if ( [request responseStatusCode] == 200 || [request responseStatusCode] == 201 )
    {
        [appDelegate showSimpleAlertView:YES withTitle:@"Success" withSubtitle:@"Facebook Linked" withDetailedText:@"Your PaidThx account is now linked with Facebook. You can now easily send to your facebook friends." withButtonText:@"Ok" withDelegate:self];
        [self getFacebookFriends:appDelegate];
        [linkDelegate facebookAccountLinkSuccess];
    }
    else
    {
        [self linkFacebookFailed:request];
    }
}

-(void) linkFacebookFailed:(ASIHTTPRequest *)request
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"Link Facebook failed with Exception");
    NSLog(@"Link FB Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [appDelegate showSimpleAlertView:NO withTitle:@"Error" withSubtitle:@"Facebook Link Failed" withDetailedText:@"We were unable to link your PaidThx account with Facebook. Please check your wireless connection and try again." withButtonText:@"Ok" withDelegate:self];
    [linkDelegate facebookAccountLinkFailed];
}

-(void)didSelectButtonWithIndex:(int)index
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissAlertView];
}

-(void)didSelectButtonWithIndex:(int)index withEnteredText:(NSString *)text {}

@end