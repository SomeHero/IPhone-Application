//
//  XMLWebService.h
//
//  Created by Mitek Systems on 10/8/10.
//  Copyright 2010 Mitek Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMLWebServiceDelegate

@optional

- (void)wsStartBusyDialog;
- (void)wsEndBusyDialog;

- (void)wsCallDataReturned:(NSData*)xmlData;
- (void)wsCallFullDictionaryReturned:(NSDictionary*)xmlDict;

- (void)wsCallFailed:(NSError*)err;

@required

//- (id)upperBar;						// Bar to put button in, must be UINavigationBar, UINavigationItem or UIToolbar

@end


@interface XMLWebService : NSObject {

	NSURLConnection		*conn;
	BOOL				verbose;
	
	// Dictionary parser variables
	BOOL				removeSoapTags;
}

@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSMutableData *inboundData;
@property (nonatomic, strong) id delegate;

@property (nonatomic, strong) NSString *rootReturn;
@property (nonatomic, strong) NSArray *forceArray;
@property (nonatomic, assign) BOOL removeSoapTags;


- (BOOL) callTheWS:(NSString *)serviceURL 
		withAction:(NSString *)soapAction
			toRoot:(NSString *)soapRoot
	   withMessage:(NSString *)soapMsg
		rootReturn:(NSString *)inRootReturn			// Root tag of return
		forceArray:(NSArray *)inForceArray			// Array of tags to force as arrays
		removeSoap:(BOOL)removeSoap					// YES will remove soap headers, only matters if rootReturn is nil or not found
		syncronous:(BOOL)sync;

-(void) connectionDidFinishLoading:(NSURLConnection *) connection;
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error;

@end
