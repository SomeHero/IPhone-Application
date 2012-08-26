//
//  MIWebService.m
//
//  Created by Mitek Engineering on 10/8/10.
//  Copyright 2010 Mitek Systems, Inc. All rights reserved.
//

#import "XMLWebService.h"
#import "XMLParser.h"
#import "XMLParserNode.h"


@implementation XMLWebService


@synthesize conn;
@synthesize inboundData;
@synthesize delegate;
@synthesize rootReturn;
@synthesize forceArray;
@synthesize removeSoapTags;


- (id) init {
	if(self = [super init]) {
		
		verbose = NO;

	}
	return self;
}

- (void) dealloc {
	
	if(conn)
		[conn cancel];
}


- (BOOL) callTheWS:(NSString *)serviceURL			// eg: http://mobileimaging.miteksystems.com/ImagingPhoneService.asmx
		withAction:(NSString *)soapAction			// eg: ProcessImage
			toRoot:(NSString *)soapRoot				// eg: http://www.miteksystems.com/
	   withMessage:(NSString *)soapMsg				// body parameters
		rootReturn:(NSString *)inRootReturn			// Root tag of return
		forceArray:(NSArray *)inForceArray			// Array of tags to force as arrays
		removeSoap:(BOOL)removeSoap					// YES will remove soap headers, only matters if rootReturn is nil or not found
		syncronous:(BOOL)sync						// syncronous call to server
{
	
	// Put up the busy dialog
	if(delegate && [delegate respondsToSelector:@selector(wsStartBusyDialog)])
		[delegate wsStartBusyDialog];

	// Clean up any pending call
	if(conn) {
		[conn cancel];
		self.conn = nil;
	}
	
	self.rootReturn = inRootReturn;
	self.forceArray = inForceArray;
	self.removeSoapTags = removeSoap;
	
	// Setup the URL
    NSURL *url = [NSURL URLWithString:serviceURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
/*	
	NSString *rawString = [NSString stringWithFormat:@"%@",value];
	NSString *encodedString = [[[[[rawString stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;"] 
								  stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"] 
								 stringByReplacingOccurrencesOfString: @"'" withString: @"&#39;"] 
								stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"] 
							   stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
	if([rawString isEqual:encodedString] == NO) {
		NSLog(@"Modified String");
	}
	[requestParameters appendFormat:@"<%@>%@</%@>", name, encodedString, name];
*/	
	// Build the soap message 
	NSString *soapBody = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
						 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
						 "<soap:Body>"
						 "<%@ xmlns=\"%@\">%@</%@>"
						 "</soap:Body>"
						 "</soap:Envelope>",
						 soapAction,soapRoot,soapMsg,soapAction];

	// Setup the Headers
    NSString *msgLength = [NSString stringWithFormat:@"%d",[soapBody length]];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:[NSString stringWithFormat:@"%@%@",soapRoot,soapAction] forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	
	// And the method and body
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];

	
	if(sync) {
		
		NSURLResponse *resp;
		NSError *err;
		NSData *inData = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&err];
		if(inData) {
			[self setInboundData:[NSMutableData dataWithData:inData]];
			[self connectionDidFinishLoading:nil];
			return YES;
		}
		else {
			[self connection:nil didFailWithError:err];
			return NO;
		}
	}
	else {
		// Init the connection
		conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
		if (conn)
			[self setInboundData:[NSMutableData dataWithLength:100]];
		
		if(verbose) NSLog(@"Connection %@Established",conn ? @"" : @"NOT ");
		
		// Put down the busy dialog if failed
		if(conn == nil && delegate && [delegate respondsToSelector:@selector(wsEndBusyDialog)])
			[delegate wsEndBusyDialog];
		
		return (conn != nil);		
	}
}


#pragma mark -
#pragma mark Node to NSDictionary Parsing Support

- (BOOL) needArray:(NSArray *)inArray forKey:(NSString *)key {
	
	// First check the forced array list
	if([self.forceArray containsObject:key])
		return YES;
	
	// Then check if there are any duplicate entries.
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
	for(XMLParserNode *node in inArray)
		[dict setValue:node.nodeContent forKey:node.nodeName];
	return [inArray count] != [dict count];
}


- (NSDictionary *) parseNodes:(XMLParserNode *)node into:(NSMutableDictionary *)dict via:(NSMutableArray*)array level:(NSInteger)nodeLevel {
	
/*	
	if(!nodeLevel) {
		NSMutableDictionary *subdict = [[NSMutableDictionary alloc] initWithCapacity:10];
		dict = subdict;
	}
*/	
	BOOL needArray = [self needArray:[node childNodes] forKey:node.nodeName];
	if(verbose) NSLog(@"Array %@needed for <%@>",needArray?@"":@"not ",node.nodeName);
	
	if(![node.childNodes count] && !needArray) {
		if(verbose) NSLog(@"Terminal Node <%@> Found, adding string '%@' to %@ at level %d",node.nodeName, node.nodeContent,array?@"array":@"dictionary",nodeLevel);
		if(array)
			[array addObject:[NSDictionary dictionaryWithObject:[NSString stringWithString:node.nodeContent] forKey:[NSString stringWithString:node.nodeName]]];
		else {
			if(!dict)
				dict = [[NSMutableDictionary alloc] initWithCapacity:10];
			[dict setObject:[NSString stringWithString:node.nodeContent] forKey:[NSString stringWithString:node.nodeName]];
		}
	}
	else {
		if(verbose) NSLog(@"Non-terminal Node <%@> Found.",node.nodeName);
		
		if(needArray) {
			NSMutableArray *subarray = [[NSMutableArray alloc] initWithCapacity:10];
			
			// Carry on recursions
			for( int i=0; i < [[node childNodes] count]; i++) {
				if(verbose) NSLog(@"----- Recursing with array at level %d -----",nodeLevel);
				[self parseNodes:[[node childNodes] objectAtIndex:i] into:nil via:subarray level:nodeLevel+1];
				if(verbose) NSLog(@"----- Returning with array at level %d -----",nodeLevel);
			}
			
			if(array)
				[array addObject:[NSDictionary dictionaryWithObject:[NSArray arrayWithArray:subarray] forKey:[NSString stringWithString:node.nodeName]]];
			else {
				if(!dict)
					dict = [[NSMutableDictionary alloc]initWithCapacity:10];
				[dict setObject:[NSArray arrayWithArray:subarray] forKey:node.nodeName];
				
			}
			if(verbose) NSLog(@"Terminal Node <%@>, array added to %@ at level %d",node.nodeName, array?@"array":@"dictionary",nodeLevel);
		}
		else {
			NSMutableDictionary *subdict = [[NSMutableDictionary alloc] initWithCapacity:10];
			
			// Carry on recursions
			for( int i=0; i < [[node childNodes] count]; i++) {
				if(verbose) NSLog(@"----- Recursing with dict at level %d -----",nodeLevel);
				[self parseNodes:[[node childNodes] objectAtIndex:i] into:subdict via:nil level:nodeLevel+1];
				if(verbose) NSLog(@"----- Returning with dict at level %d -----",nodeLevel);
			}
			
			if(array)
				[array addObject:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithDictionary:subdict] forKey:[NSString stringWithString:node.nodeName]]];
			else if(dict)
				[dict setObject:[NSDictionary dictionaryWithDictionary:subdict] forKey:node.nodeName];
			else 
				dict = subdict;
			
			if(verbose) NSLog(@"Terminal Node <%@>, dictionary added to %@ at level %d",node.nodeName, array?@"array":@"dictionary",nodeLevel);
		}
	}
	
	return dict;
}


- (XMLParserNode *)walkForTag:(NSString *)tag inNode:(XMLParserNode *)node {

	if([node.nodeName isEqual:tag])
		return node;
	else {
		XMLParserNode *tempNode;
		for( int i=0; i<[[node childNodes] count]; i++) {
			tempNode = [self walkForTag:tag inNode:[[node childNodes] objectAtIndex:i]];
			if(tempNode)
				return tempNode;
		}
	}
	return nil;	
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	if(verbose) NSLog(@"Connection did respond");
	
	[inboundData setLength:0];
}


-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
	
	if(verbose) NSLog(@"Connection received %d bytes",[data length]);
	
	[inboundData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
	
	if(verbose) NSLog(@"Connection failed with %@",[error description]);

	// Put down the busy dialog
	if(delegate && [delegate respondsToSelector:@selector(wsEndBusyDialog)])
		[delegate wsEndBusyDialog];
	
	// Optionally signal the caller
	if(delegate && [delegate respondsToSelector:@selector(wsCallFailed:)])
		[delegate wsCallFailed:error];
	
	// Release the data
	self.inboundData = nil;
	self.conn = nil;
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
	
	if(verbose) NSLog(@"Connection finished with %d total bytes",[inboundData length]);

	// Put down the busy dialog
	if(delegate && [delegate respondsToSelector:@selector(wsEndBusyDialog)])
		[delegate wsEndBusyDialog];
	
	// Send NSData if requested
	if(delegate && [delegate respondsToSelector:@selector(wsCallDataReturned:)]) {

		if(verbose) NSLog(@"Connection returning NSData");
		[delegate wsCallDataReturned:inboundData];
	}
	
	// Send full NSDictionary if requested
	if(delegate && [delegate respondsToSelector:@selector(wsCallFullDictionaryReturned:)]) {
		
		if(verbose) NSLog(@"Connection returning full NSDictionary");
		XMLParser *parser = [[XMLParser alloc] init];
		XMLParserNode *rootNode = [parser parseXMLFromData:inboundData];
		
		if(rootNode) {

			// First skip our placeholder root node
			XMLParserNode *newRoot = [[rootNode childNodes] objectAtIndex:0];

			// Check for rootReturn in nodes
			if(self.rootReturn) {
				XMLParserNode *temp = [self walkForTag:self.rootReturn inNode:newRoot];
				if(temp)
					newRoot = temp;
			}

			// Now remove soap members if requested
			if(self.removeSoapTags) {
				XMLParserNode *temp = [self walkForTag:@"soap:Body" inNode:newRoot];
				if(temp)
					newRoot = temp;// [[temp childNodes] objectAtIndex:0];
			}

			// parse nodes into dictionary
			NSDictionary *dict = [self parseNodes:newRoot into:nil via:nil level:0];

			// and send it to the caller
			[delegate wsCallFullDictionaryReturned:dict];
		}
		else { 
			[delegate wsCallFullDictionaryReturned:nil];
		}
	}
	
	// Release the data
	self.conn = nil;
	self.inboundData = nil;
}

@end
