//
//  PaystreamBaseViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaystreamMessage.h"
#import "PaystreamService.h"



@interface PaystreamBaseViewController : UIViewController 
{
    PaystreamMessage* messageDetail;
    PaystreamService* paystreamServices;
}

@property(nonatomic, retain) PaystreamMessage* messageDetail;


@end
