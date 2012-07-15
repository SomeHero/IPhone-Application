//
//  ContactTypeSelectViewController.m
//  TSPopoverDemo
//
//  Created by James Rhodes on 7/14/12.
//  Copyright (c) 2012 ar.ms. All rights reserved.
//

#import "ContactTypeSelectViewController.h"

@interface ContactTypeSelectViewController ()

@end

@implementation ContactTypeSelectViewController

@synthesize contactSelectWasSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)allContactsClicked:sender {
    [contactSelectWasSelected contactWasSelected: @"All"];
}
-(IBAction)phoneContactsClicked:sender {
    [contactSelectWasSelected contactWasSelected: @"Phone"];    
}
-(IBAction)facebookContactsClicked:sender {
    [contactSelectWasSelected contactWasSelected: @"Facebook"];
}
-(IBAction)nonProfitsContactsClicked:sender {
    [contactSelectWasSelected contactWasSelected: @"NonProfits"];
}
-(IBAction)publicDirectoryContactsClicked:sender {
    [contactSelectWasSelected contactWasSelected: @"Public"];
}

@end
