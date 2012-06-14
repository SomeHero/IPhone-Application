//
//  SendMoneyRequest.m
//  PdThx
//
//  Created by James Rhodes on 2/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SendMoneyRequest.h"

@implementation SendMoneyRequest


+ (SendMoneyRequest *)sendMoneyRequest
{
    static SendMoneyRequest *request = NULL;
    
    @synchronized(self)
    {
        if (request == NULL)
            request = [[self alloc] init];
    }
    
    return(request);
}

-(void) setRecipientUri: (NSString*) recipient
{
    _recipientUri = recipient;
}
-(NSString *) recipientUri
{
    return _recipientUri;
}
-(void) setAmount:(NSString *)amount 
{
    _amount = amount;
}
-(NSString *) amount
{
    return _amount;
}
-(void) setComments:(NSString *)comments
{
    _comments = comments;
}
-(void) reset {
    _recipientUri = @"";
    _amount = @"";
    _comments = @"";
}
-(NSString *) comments
{
    return _comments;
}
- (id)retain
{
    return self;
}
- (oneway void)release
{
    // do nothing
}

- (id)autorelease
{
    return self;
}
- (NSUInteger)retainCount
{
    return NSUIntegerMax; // This is sooo not zero
}
@end
