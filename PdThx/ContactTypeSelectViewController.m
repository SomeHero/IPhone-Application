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
    [contactSelectWasSelected contactWasSelected: 1];
}
-(IBAction)phoneContactsClicked:sender {
    [contactSelectWasSelected contactWasSelected: 2];    
}
-(IBAction)facebookContactsClicked:sender {
    [contactSelectWasSelected contactWasSelected: 3];
}
-(IBAction)nonProfitsContactsClicked:sender {
    [contactSelectWasSelected contactWasSelected: 4];
}
-(IBAction)publicDirectoryContactsClicked:sender {
    [contactSelectWasSelected contactWasSelected: 5];
}

@end
