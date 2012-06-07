//
//  RequestMoneyService.m
//  PdThx
//
//  Created by James Rhodes on 5/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestMoneyService.h"
#import "Environment.h"
#import "SBJsonParser.h"
#import "JSON.h"

@implementation RequestMoneyService

@synthesize requestMoneyCompleteDelegate;

-(id)init {
    self = [super init];
    
    return self;
}
-(void) requestMoney:(NSString *)theAmount toRecipient:(NSString *)theRecipientUri fromSender:(NSString *)theSenderUri withComment:(NSString *)theComments withSecurityPin:(NSString *)securityPin
       fromUserId: (NSString *)userId withFromAccount:(NSString *)fromAccount
    withFromLatitude:(double) latitude
   withFromLongitude: (double) longitude withRecipientFirstName: (NSString*) recipientFirstName withRecipientLastName: (NSString*) recipientLastName withRecipientImageUri:(NSString*) recipientImageUri {
    
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [NSString stringWithString:@"PaystreamMessages"];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl,  rootUrl, apiKey]] autorelease];  
    NSDictionary *paymentData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 apiKey, @"apiKey",
                                 theSenderUri, @"senderUri",
                                 fromAccount, @"senderAccountId",
                                 theRecipientUri, @"recipientUri",
                                 theAmount, @"amount",
                                 theComments, @"comments",
                                 securityPin, @"securityPin",
                                 @"PaymentRequest", @"messageType",
                                 [NSString stringWithFormat:@"%f",latitude], @"latitude",
                                 [NSString stringWithFormat:@"%f",longitude], @"longitude",
                                 recipientFirstName, @"recipientFirstName",
                                 recipientLastName, @"recipientLastName",
                                 recipientImageUri, @"recipientImageUri",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation];
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(sendMoneyComplete:)];
    [request setDidFailSelector:@selector(sendMoneyFailed:)];
    
    [request startAsynchronous];
    
    [paymentData release];
}
-(void) sendMoneyComplete:(ASIHTTPRequest *)request
{
    
    if([request responseStatusCode] == 201 ) {
        
        NSLog(@"Request Sent");
        
        [requestMoneyCompleteDelegate requestMoneyDidComplete];
        
    }
    else {
        NSLog(@"Error Requesting Money");
        
        NSString* message = [NSString stringWithString: @"Unable to send request for money"];
        
        [requestMoneyCompleteDelegate requestMoneyDidFail: message];
    }
    
}
-(void) sendMoneyFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Money Failed");
    
    NSString* message = [NSString stringWithString: @"Unable to send request for money"];
    
    [requestMoneyCompleteDelegate requestMoneyDidFail: message];
}
- (void)dealloc
{
    [requestObj release];
    
    [super dealloc];
}
@end
