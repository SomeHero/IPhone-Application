//
//  SelectRecipientViewControllerViewController.m
//  PdThx
//
//  Created by Edward Mitchell on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectRecipientViewController.h"
#import "SelectRecipientCell.h"

@interface SelectRecipientViewController ()

@end

@implementation SelectRecipientViewController
@synthesize selectRecipientTable, recipients, noMatchFound;
@synthesize selectRecipientDelegate, txtHeader;

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
    txtHeader.text = headerText;
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [selectRecipientTable release];
    selectRecipientTable = nil;
    [txtHeader release];
    txtHeader = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated
{
    [selectRecipientTable reloadData];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (noMatchFound)
    {
        [selectRecipientDelegate selectRecipient: [recipients objectAtIndex:indexPath.row]];
    }
    else {
        NSDictionary* dic = [recipients objectAtIndex:indexPath.row];
        [selectRecipientDelegate selectRecipient:[NSString stringWithFormat:@"%@", [dic objectForKey:@"userUri"]]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectRecipientCell* cell = (SelectRecipientCell*) [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectRecipientCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (noMatchFound)
    {
        NSString* uri = [recipients objectAtIndex:indexPath.row];
        
        cell.contactName.text = uri;
    }
    else {
        NSDictionary* dic = [recipients objectAtIndex:indexPath.row];
        
        cell.contactName.text = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"firstName"], [dic objectForKey:@"lastName"]];
        cell.contactDetail.text = [dic objectForKey:@"userUri"];
        //[cell.imgRecipient setBackgroundImage: [dic objectForKey:@"picture"] forState:UIControlStateNormal]; 
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipients count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)dealloc {
    [selectRecipientTable release];
    [recipients release];
    [txtHeader release];
    [selectRecipientDelegate release];
    [super dealloc];
}

@end
