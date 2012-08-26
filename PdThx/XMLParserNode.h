//
//  XMLParserNode.h
//
//  Created by Mitek Systems on 4/12/10.
//  Copyright 2010 Mitek Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParserNode : NSObject <NSXMLParserDelegate> {

	BOOL verbose;
	
	NSMutableString *nodeContent;
	NSDictionary *nodeAttributes;
}

@property (nonatomic, strong) NSString *nodeName;
@property (nonatomic, strong) XMLParserNode *parentNode;
@property (nonatomic, strong) NSMutableArray *childNodes;

@property (nonatomic, strong) NSMutableString *nodeContent;
@property (nonatomic, strong) NSDictionary *nodeAttributes;


+ (id)nodeWithName:(NSString *)elementName attributes:(NSDictionary *)attributes parent:(XMLParserNode *)parent children:(NSMutableArray *)children parser:(NSXMLParser *)parser;

@end
