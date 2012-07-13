//
//  CocoaZendesk.h
//  CocoaZendesk
//
//  Created by Bill So on 06/05/2009.
//  Copyright 2009 Zendesk Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Error code
 */
enum {
	ZDErrorMissingSubject =				-610001,
	ZDErrorMissingDescription =			-610002,
	ZDErrorMissingEmail =				-610003,
};

extern NSString *const ZendeskDropboxDescription;
extern NSString *const ZendeskDropboxEmail;
extern NSString *const ZendeskDropboxSubject;
extern NSString *const ZendeskURLDoesNotExistException;

/** delegate_methods Delegate methods
 */

/** ZendeskDropbox object is the only object you need to create to send ticket to Zendesk. ZendeskDropbox provides asynchronous sending of ticket to Zendesk server.
 To use this class, you must add a key ZDURL to your application's plist. Put your Zendesk URL as value, e.g. mysite.zendesk.com.
 */
@interface ZendeskDropbox : NSObject {
	id delegate;
	NSMutableData * receivedData;
	NSString *baseURL;
	NSString *tag;
}

@property (retain, nonatomic) id delegate; /** set or get the delegate.  */

/** Submit ticket to Zendesk server. This function returns immediately without waiting the ticket to be sent to Zendesk server.
 */
- (void)sendTicket:(NSDictionary *)ticketInfo;

@end



@interface NSObject (ZendeskDropboxDelegate)

/** Sent when connected to Zendesk server
 */
- (void)submissionConnectedToServer:(ZendeskDropbox *)connection;
/** Sent when the ticket is submitted to Zendesk server successfully
 */
- (void)submissionDidFinishLoading:(ZendeskDropbox *)connection;
/** Sent when ticket submission failed.
 */
- (void)submission:(ZendeskDropbox *)connection didFailWithError:(NSError *)error;

@end
