//
//  PayStreamService.m
//  PdThx
//
//  Created by James Rhodes on 5/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SendMoneyService.h"
#import "Environment.h"
#import "SBJsonParser.h"
#import "JSON.h"


@implementation SendMoneyService

@synthesize sendMoneyCompleteDelegate;

-(id)init {
    self = [super init];
    
    return self;
}

-(void) sendMoney:(NSString *)theAmount toRecipient:(NSString *)theRecipientUri fromSender:(NSString *)theSenderUri withComment:(NSString *)theComments withSecurityPin:(NSString *)securityPin
       fromUserId: (NSString *)userId withFromAccount:(NSString *)fromAccount withFromLatitude:(double)latitude
withFromLongitude:(double)longitude withRecipientFirstName: (NSString*) recipientFirstName withRecipientLastName: (NSString*) recipientLastName withRecipientImageUri:(NSString*) recipientImageUri
{
    
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [NSString stringWithFormat:@"PaystreamMessages"];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl,rootUrl, apiKey]] autorelease];  
    
    NSDictionary *paymentData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 apiKey, @"apiKey",
                                 theSenderUri, @"senderUri",
                                 fromAccount, @"senderAccountId",
                                 theRecipientUri, @"recipientUri",
                                 theAmount, @"amount",
                                 theComments, @"comments",
                                 [NSString stringWithFormat:@"%f",latitude], @"latitude",
                                 [NSString stringWithFormat:@"%f",longitude], @"longitude",
                                 securityPin, @"securityPin",
                                 @"Payment", @"messageType",
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
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 201 ) {
        
        [sendMoneyCompleteDelegate sendMoneyDidComplete];
        
        NSLog(@"Money Sent");
        
    }
    else {
        
        NSString* message = [NSString stringWithString: @"Unable to send money"];
        
        [sendMoneyCompleteDelegate sendMoneyDidFail: message];
        
        NSLog(@"Error Sending Money");
    }
    
}
-(void) sendMoneyFailed:(ASIHTTPRequest *)request
{
    NSString* message = [NSString stringWithString: @"Unable to send money"];
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [sendMoneyCompleteDelegate sendMoneyDidFail: message];
    
    NSLog(@"Send Money Failed");
}
- (void)dealloc
{
    [requestObj release];
    
    [super dealloc];
}

@end