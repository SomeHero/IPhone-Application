//
//  MISupport.h
//  MobileImagingLibrary
//
//  Created by Mitek Systems on 11/25/10.
//  Copyright 2010 Mitek Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLWebService.h"

@class MIUser;

@interface MISupport : NSObject < XMLWebServiceDelegate > {
	
	MIUser *parent;
	SEL retSel;
	SEL errSel;
	
	XMLWebService *ws;
	
	BOOL verbose;
}

@property (nonatomic, strong) MIUser *parent;
@property (nonatomic, strong) XMLWebService *ws;

- (BOOL) doTheCall:(NSString *)action 
		   message:(NSString *)soapMsg 
			  from:(MIUser *)inParent 
		 returnSel:(SEL)ret 
		  errorSel:(SEL)err 
		rootReturn:(NSString *)rootReturn
		forceArray:(NSArray *)forceArray
		   verbose:(BOOL)inVerbose;


@end
