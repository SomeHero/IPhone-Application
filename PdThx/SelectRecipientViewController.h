//
//  SelectRecipientViewControllerViewController.h
//  PdThx
//
//  Created by Edward Mitchell on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIModalBaseViewController.h"
#import "SelectRecipientProtocol.h"

@interface SelectRecipientViewController : UIModalBaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UILabel *txtHeader;
    IBOutlet UITableView *selectRecipientTable;
    NSArray* recipients;
    id<SelectRecipientProtocol> selectRecipientDelegate;
    BOOL noMatchFound;
}

@property (retain, nonatomic) IBOutlet UILabel *txtHeader;
@property (retain, nonatomic) IBOutlet UITableView* selectRecipientTable;
@property (retain, nonatomic) NSArray* recipients;
@property (retain) id<SelectRecipientProtocol> selectRecipientDelegate;
@property (assign, nonatomic) BOOL noMatchFound;


@end
