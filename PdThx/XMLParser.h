//
//  XMLParser.h
//
//  Created by Mitek Systems on 4/12/10.
//  Copyright 2010 Mitek Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMLParserNode;

@interface XMLParser : NSObject {
	
	NSXMLParser *xmlParser;
	XMLParserNode *rootNode;
	
	BOOL verbose;
}

- (id) init;
- (XMLParserNode *) parseXMLFromData:(NSData *) data;
- (XMLParserNode *) parseXMLFromURL:(NSURL *) url;
	

@end
