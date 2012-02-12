//
//  ProfileController.h
//  Fanatical
//
//  Created by James Rhodes on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileController : UIViewController
<UITableViewDataSource, UITableViewDelegate> {
    NSDictionary *profileOptions;
    NSArray *sections;
}
@property(nonatomic, retain) NSDictionary *profileOptions;
@property(nonatomic, retain) NSArray *sections;

@end
