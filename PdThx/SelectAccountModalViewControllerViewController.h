//
//  SelectAccountModalViewControllerViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAModalPanel.h"
#import "BankAccount.h"
#import "ModalSelectProtocol.h"

@interface SelectAccountModalViewControllerViewController: UAModalPanel<UITableViewDataSource, UITableViewDelegate> 
{
    UIView *v;
	NSMutableArray* bankAccounts;
    NSString* selectedAccount;
    NSString* accountType;
    
    NSString* headerText;
    NSString* descriptionText; 
    
    id<ModalSelectProtocol> optionSelectDelegate;
}


@property(nonatomic, retain) NSString* headerText;
@property(nonatomic, retain) NSString* descriptionText;

@property(nonatomic, retain) id optionSelectDelegate;

@property(nonatomic, retain) NSMutableArray* bankAccounts;
@property(nonatomic, retain) NSString* selectedAccount;
@property(nonatomic, retain) NSString* accountType;



@end
