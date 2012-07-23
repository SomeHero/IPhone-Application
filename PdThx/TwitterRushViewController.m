//
//  TwitterRushViewController.m
//  TwitterRush

#import "TwitterRushViewController.h"
#import "SA_OAuthTwitterEngine.h"

/* Define the constants below with the Twitter 
   Key and Secret for your application. Create
   Twitter OAuth credentials by registering your
   application as an OAuth Client here: http://twitter.com/apps/new
 */

#define kOAuthConsumerKey				@"tIjdO9B0UiGlU6z87pHA"		//REPLACE With Twitter App OAuth Key  
#define kOAuthConsumerSecret			@"w4vH5DNUWW83AaKrU99GlfgM1nRw77xMk8MPEiHKls"		//REPLACE With Twitter App OAuth Secret

@implementation TwitterRushViewController

@synthesize tweetTextField; 

#pragma mark Custom Methods

-(IBAction)updateTwitter:(id)sender
{
	//Dismiss Keyboard
	[tweetTextField resignFirstResponder];
	
	//Twitter Integration Code Goes Here
    [_engine getFriends:@"thejamesrhodes"];
}

#pragma mark ViewController Lifecycle

- (void)viewDidAppear: (BOOL)animated {
	
	// Twitter Initialization / Login Code Goes Here
    if(!_engine){  
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret;  
    }  	
    
    if(![_engine isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        if (controller){  
            [self presentModalViewController: controller animated: YES];  
        }  
    }    
}
- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
    NSLog(@"Got Results");
}
- (void)statusesReceived:(NSArray *)userInfo forRequest:(NSString *)identifier
{
    [userInfo count];
    
    for(int i=0; i < [userInfo count]; i++)
    {
        NSMutableDictionary* dict = [userInfo objectAtIndex:i];
        NSMutableDictionary* user = [dict objectForKey: @"user"];
        
        NSLog(@"%@", [user valueForKey: @"name"]);
    }
}
- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier
{
    [userInfo count];
}
	   
- (void)viewDidUnload {	
	[tweetTextField release];
	tweetTextField = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_engine release];
	[tweetTextField release];
    [super dealloc];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"athData"];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}
@end
