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
@synthesize determineRecipientCompleteDelegate;

-(id)init {
    self = [super init];
    
    return self;
}

-(void) sendMoney:(NSString *)theAmount toRecipient:(NSString*)recipientId withRecipientUri:(NSString *)theRecipientUri fromSender:(NSString *)theSenderUri withComment:(NSString *)theComments withSecurityPin:(NSString *)securityPin
       fromUserId: (NSString *)userId withFromAccount:(NSString *)fromAccount withFromLatitude:(double)latitude
withFromLongitude:(double)longitude withRecipientFirstName: (NSString*) recipientFirstName withRecipientLastName: (NSString*) recipientLastName withRecipientImageUri:(NSString*) recipientImageUri
{
    
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [NSString stringWithFormat:@"PaystreamMessages"];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl,rootUrl, apiKey]] autorelease];  
    
    NSDictionary *paymentData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 apiKey, @"apiKey",
                                 userId, @"senderId",
                                 recipientId, @"recipientId",
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
        
        NSString* message = @"Unable to send money";
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        bool isLockedOut = [[jsonDictionary objectForKey: @"isLockedOut"] boolValue];
        NSInteger numberOfPinCodeFailures = [[jsonDictionary valueForKey: @"numberOfPinCodeFailures"] intValue];
        
        [sendMoneyCompleteDelegate sendMoneyDidFail:message isLockedOut:isLockedOut withPinCodeFailures:numberOfPinCodeFailures];
        
        NSLog(@"Error Sending Money");
    }
    
}
-(void) sendMoneyFailed:(ASIHTTPRequest *)request
{
    NSString* message = @"Unable to send money";
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    BOOL isLockedOut = [[jsonDictionary valueForKey: @"isLockedOut"] boolValue];
    NSInteger numberOfPinCodeFailures = [[jsonDictionary valueForKey: @"numberOfPinCodeFailures"] intValue];
    
    [sendMoneyCompleteDelegate sendMoneyDidFail: message isLockedOut:isLockedOut withPinCodeFailures:numberOfPinCodeFailures];
    
    NSLog(@"Send Money Failed");
}

-(void) determineRecipient:(NSArray*) recipientUris
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [NSString stringWithFormat:@"PaystreamMessages/multiple_uris"];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/%@", myEnvironment.pdthxWebServicesBaseUrl,rootUrl]] autorelease];  
    
    NSDictionary *recipientData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   recipientUris, @"recipientUris",
                                   nil];
    
    NSString *newJSON = [recipientData JSONRepresentation];
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(determineRecipientComplete:)];
    [request setDidFailSelector:@selector(determineRecipientDidFail:)];
    
    [request startAsynchronous];
    
    [recipientData release];
}

-(void) determineRecipientComplete: (ASIHTTPRequest*) request
{
    if (request.responseStatusCode == 204)
    {
        [determineRecipientCompleteDelegate determineRecipientDidComplete:nil];
    }
    else if (request.responseStatusCode == 200)
    {
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSArray *jsonArray = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        
        [determineRecipientCompleteDelegate determineRecipientDidComplete:jsonArray];        
    }
    else
    {
        [determineRecipientCompleteDelegate determineRecipientDidFail:[request responseStatusMessage]];
    }
}

-(void) determineRecipientDidFail: (ASIHTTPRequest*) request
{
    [determineRecipientCompleteDelegate determineRecipientDidFail:[request responseStatusMessage]];
}

- (void)dealloc
{
    [requestObj release];
    [determineRecipientCompleteDelegate release];
    [sendMoneyCompleteDelegate release];
    
    [super dealloc];
}

@end