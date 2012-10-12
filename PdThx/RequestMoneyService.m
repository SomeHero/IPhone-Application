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

@synthesize requestMoneyCompleteDelegate, determineRecipientCompleteDelegate;

-(id)init {
    self = [super init];
    
    return self;
}
-(void) requestMoney:(NSString *)theAmount toRecipient:(NSString *)theRecipientUri fromSender:(NSString *)theSenderUri withComment:(NSString *)theComments withSecurityPin:(NSString *)securityPin
       fromUserId: (NSString *)userId withFromAccount:(NSString *)fromAccount
    withFromLatitude:(double) latitude
   withFromLongitude: (double) longitude withRecipientFirstName: (NSString*) recipientFirstName withRecipientLastName: (NSString*) recipientLastName withRecipientImageUri:(NSString*) recipientImageUri {
    
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = @"PaystreamMessages";
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl,  rootUrl, apiKey]] autorelease];  
    NSDictionary *paymentData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 apiKey, @"apiKey",
                                 userId, @"senderId",
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
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 201 ) {
        
        NSLog(@"Request Sent");
        
        [requestMoneyCompleteDelegate requestMoneyDidComplete];
        
    }
    else {
        NSLog(@"Error Requesting Money");
       
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [requestMoneyCompleteDelegate requestMoneyDidFail:message withErrorCode:errorCode];
    }
    
}
-(void) sendMoneyFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [requestMoneyCompleteDelegate requestMoneyDidFail: message withErrorCode:errorCode];
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
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
        
        [determineRecipientCompleteDelegate determineRecipientDidFail:message withErrorCode: errorCode];
    }
}

-(void) determineRecipientDidFail: (ASIHTTPRequest*) request
{
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [determineRecipientCompleteDelegate determineRecipientDidFail:message withErrorCode: errorCode];
}


- (void)dealloc
{
    [requestObj release];
    [determineRecipientCompleteDelegate release];
    [requestMoneyCompleteDelegate release];
    
    [super dealloc];
}
@end
