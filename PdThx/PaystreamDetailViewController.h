//
//  PaystreamDetailViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"


@interface PaystreamDetailViewController : UIViewController {
    Contact* messageDetail;
}

@property(nonatomic, retain) Contact* messageDetail;

@end
