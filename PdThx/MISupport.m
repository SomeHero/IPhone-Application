//
//  MISupport.m
//  MobileImagingLibrary
//
//  Created by Mitek Systems on 11/25/10.
//  Copyright 2010 Mitek Systems, Inc. All rights reserved.
//

#import "MISupport.h"
#import "MIUser.h"

@implementation MISupport

@synthesize parent;
@synthesize ws;


- (id) init {
	
    if ((self = [super init])) {
        // Custom initialization
    }
    return self;
}



- (BOOL) doTheCall:(NSString *)action 
		   message:(NSString *)soapMsg 
			  from:(MIUser *)inParent 
		 returnSel:(SEL)ret 
		  errorSel:(SEL)err 		
		rootReturn:(NSString *)rootReturn
		forceArray:(NSArray *)forceArray
		   verbose:(BOOL)inVerbose  {
	
	self.parent = inParent;
	retSel = ret;
	errSel = err;
	verbose = inVerbose;
	
	self.ws = nil;
	self.ws = [[XMLWebService alloc] init];
	[self.ws setDelegate:self];
	
	if(inVerbose)
		NSLog(@"MMI - %@ sent to WebService at %@",action,inParent.urlString);
	
	[self.ws callTheWS:inParent.urlString
			withAction:action
				toRoot:@"http://www.miteksystems.com/"
		   withMessage:soapMsg
			rootReturn:rootReturn
			forceArray:forceArray
			removeSoap:YES
			syncronous:NO];
	
	return YES;
}


- (void) wsCallFailed:(NSError *)err {
	
	if(verbose)
		NSLog(@"MMI - WebService Failure signaled - %@",[err description]);
	
	// Optionally signal the caller
	if(self.parent.delegate && errSel && [self.parent.delegate respondsToSelector:errSel])

// MJG from http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
// MJG removed the compiler warning
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[self.parent.delegate performSelector:errSel withObject:err];
#pragma clang diagnostic pop

	else if(verbose)
		NSLog(@"MMI - No Delegate Error Method specified");
}

- (void) wsCallFullDictionaryReturned:(NSDictionary *)xmlDict {
	
	if(verbose)
		NSLog(@"MMI - WebService Success signaled.");
	
	// Optionally signal the caller
	if(!self.parent.delegate)
		return;
	
	if(!retSel)
		return;
	
	if(![self.parent.delegate respondsToSelector:retSel])
		return;
	
	if(self.parent.delegate && retSel && [self.parent.delegate respondsToSelector:retSel])

        // MJG from http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
        // MJG removed the compiler warning
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[self.parent.delegate performSelector:retSel withObject:xmlDict];
#pragma clang diagnostic pop

	else if(verbose)
		NSLog(@"MMI - No Delegate Return Method specified");	
}

@end
