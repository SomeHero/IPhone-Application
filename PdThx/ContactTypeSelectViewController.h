//
//  ContactTypeSelectViewController.h
//  TSPopoverDemo
//
//  Created by James Rhodes on 7/14/12.
//  Copyright (c) 2012 ar.ms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactTypeSelectWasSelectedDelegate.h"

@interface ContactTypeSelectViewController : UIViewController
{
    id<ContactTypeSelectWasSelectedDelegate> contactSelectWasSelected;
}

@property(nonatomic, retain) id contactSelectWasSelected;

-(IBAction)allContactsClicked:sender;
-(IBAction)phoneContactsClicked:sender;
-(IBAction)facebookContactsClicked:sender;
-(IBAction)nonProfitsContactsClicked:sender;
-(IBAction)publicDirectoryContactsClicked:sender;

@end
