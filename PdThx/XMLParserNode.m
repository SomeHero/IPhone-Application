//
//  XMLParserNode.m
//
//  Created by Mitek Systems on 4/12/10.
//  Copyright 2010 Mitek Systems, Inc. All rights reserved.
//

#import "XMLParserNode.h"


@implementation XMLParserNode


@synthesize nodeName;
@synthesize parentNode;
@synthesize childNodes;
@synthesize nodeContent;
@synthesize nodeAttributes;


- (id)initWithName:(NSString *)elementName attributes:(NSDictionary *)attributes parent:(id)parent children:(NSMutableArray *)children parser:(NSXMLParser *)parser {
    self = [super init];
    if (self) {
		
		//verbose = YES;
		
		childNodes = [NSMutableArray arrayWithCapacity:1];
		
		nodeContent = [[NSMutableString alloc] initWithCapacity:50];
		
		[self setNodeName:elementName];
		
		[self setParentNode:parent];
		
		if (children)
			[self.childNodes addObjectsFromArray:children];
		
		if(attributes)
			self.nodeAttributes = [attributes copy];

		[parser setDelegate:self]; // CHILD SET AS DELEGATE
		
		if(verbose) NSLog(@"XML: Created Element for %@ ",elementName);
    }
    return self;
}


+ (id)nodeWithName:(NSString *)elementName attributes:(NSDictionary *)attributes parent:(XMLParserNode *)parent children:(NSMutableArray *)children parser:(NSXMLParser *)parser {
    return [[[self class] alloc] initWithName:elementName
									attributes:attributes 
										parent:parent 
									  children:children
										parser:parser];
}

#pragma mark -
#pragma mark NSXMLParser Delegate Methods


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	
	XMLParserNode *newNode = [[XMLParserNode alloc] initWithName:elementName attributes:attributeDict parent:self children:nil parser:parser];
	[self.childNodes addObject:newNode];
	
	if(verbose) NSLog(@"XML: Adding Child of name: %@ to myself named %@, now %d objects in array",[newNode nodeName], [self nodeName], [[self childNodes] count]);

	//    [self addChild:[Element elementWithName:elementName
	//								 attributes:attributeDict parent:self children:nil parser:parser]];


}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

	// Append the data
	[self.nodeContent appendString:string];
	
	if(verbose) NSLog(@"XML: Node <%@> received content: %@",self.nodeName, string);

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

	XMLParserNode *parent = [self parentNode];
	[parser setDelegate:parent];					// Reset the parser delegate to the parent
	
	if(verbose) NSLog(@"XML: Node <%@> element ended",self.nodeName);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {

	if(verbose) NSLog(@"%@",[NSString stringWithFormat:@"XML: Error %i, Description: %@, Line: %i, Column: %i", [parseError code],
							 [[parser parserError] localizedDescription], [parser lineNumber],
							 [parser columnNumber]]);
}

@end
