//
//  XMLParser.m
//
//  Created by Mitek Systems on 4/12/10.
//  Copyright 2010 Mitek Systems, Inc. All rights reserved.
//

#import "XMLParser.h"
#import "XMLParserNode.h"

@implementation XMLParser

- (id) init {
	if(self = [super init]) {
		
		
	}
	return self;
}

- (XMLParserNode *) parseXMLFromData:(NSData *) data {
	
	xmlParser = [[NSXMLParser alloc] initWithData:data];
	[xmlParser setShouldResolveExternalEntities:NO];
	
	rootNode = [XMLParserNode nodeWithName:@"__ROOT__" attributes:nil parent:nil children:nil parser:xmlParser];
	
	return [xmlParser parse] ? rootNode : nil;
}

- (XMLParserNode *) parseXMLFromURL:(NSURL *) url {
	
	xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[xmlParser setShouldResolveExternalEntities:NO];
	
	rootNode = [XMLParserNode nodeWithName:@"__ROOT__" attributes:nil parent:nil children:nil parser:xmlParser];
	
	return [xmlParser parse] ? rootNode : nil;
}

@end
