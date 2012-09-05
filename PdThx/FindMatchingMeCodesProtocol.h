//
//  FindMatchingMeCodesProtocol.h
//  PdThx
//
//  Created by Christopher Magee on 8/31/12.
//
//

#import <Foundation/Foundation.h>

@protocol FindMatchingMeCodesProtocol;

@protocol FindMatchingMeCodesProtocol <NSObject>

-(void)foundMeCodes:(NSMutableArray*)meCodes matchingSearchTerm:(NSString*)searchTerm;

@end
