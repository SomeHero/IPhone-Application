//
//  SelectModalViewController.m
//  PdThx
//
//  Created by James Rhodes on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectModalViewController.h"

@interface SelectModalViewController ()

@end

@implementation SelectModalViewController

@synthesize optionItems;
@synthesize selectedOptionItem;
@synthesize accountType;
@synthesize optionSelectDelegate;
@synthesize headerText;
@synthesize descriptionText;

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        
        [self setInnerMargin: 0.0f];
        
        self.cornerRadius = 8.0f;
        [self setBorderWidth: 2.0f];
        [self setBorderColor: [UIColor colorWithRed:51/255.0 green:153/255.0 blue:51/255.0 alpha:1.0]];
        
        
        UITableView *tv = [[[UITableView alloc] initWithFrame:CGRectZero] autorelease];
        [tv setDataSource:self];
        [tv setDelegate: self];
        [tv setBackgroundColor: [UIColor whiteColor]];
        
        [tv.layer setMasksToBounds:YES];
        [tv.layer setCornerRadius:self.cornerRadius];
        
        [tv setRowHeight: 75];
        
        v = tv;
        
        [v.layer setMasksToBounds:YES];
        
        [self.contentView addSubview:v];
        [self.contentContainer bringSubviewToFront:self.roundedRect];
        [self.roundedRect setBackgroundColor:[UIColor clearColor]];
        [self.roundedRect setUserInteractionEnabled:NO];
        
        self.contentContainer.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.contentContainer.layer.shadowOpacity = 0.5;
        //self.contentContainer.layer.shadowRadius = 1;
        self.contentContainer.layer.shadowOffset = CGSizeMake(0, 8.0f);
        
        [self.contentView setClipsToBounds:YES];
        [self.contentContainer bringSubviewToFront: self.closeButton];
    }	
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [v setFrame:self.contentView.bounds];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [optionItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString* optionItem = [optionItems objectAtIndex: indexPath.row];
    [cell.textLabel setFont: [UIFont boldSystemFontOfSize: 16]];
    cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:54/255.0 blue:62/255.0 alpha:1];
    cell.textLabel.text = optionItem;
    cell.imageView.image =  [UIImage  imageNamed: @"icon-settings-bank-40x40.png"];
    
    if([optionItem isEqualToString:selectedOptionItem])
    {
        cell.accessoryView.frame = CGRectMake(cell.accessoryView.frame.origin.x - 40, cell.accessoryView.frame.origin.y, cell.accessoryView.frame.size.width, cell.accessoryView.frame.size.height);
        
        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingPassed62x62.png"]] autorelease];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
/*
 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 return @"Select Your Receiving Account";
 }
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 90.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // Create label with section title
    UILabel *topLabel = [[[UILabel alloc] init] autorelease];
    topLabel.frame = CGRectMake(0, 0, 280, 26);
    
    topLabel.textColor = [UIColor blackColor];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.font = [UIFont boldSystemFontOfSize:15];
    topLabel.text = headerText;
    
    
    UITextView *descriptionTextView = [[[UITextView alloc] init] autorelease];
    descriptionTextView.frame = CGRectMake(0, 18, 280, 46);
    descriptionTextView.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
    descriptionTextView.textAlignment = UITextAlignmentLeft;
    
    descriptionTextView.textColor = [UIColor blackColor];
    descriptionTextView.backgroundColor = [UIColor clearColor];
    descriptionTextView.font = [UIFont systemFontOfSize: 14];
    descriptionTextView.text = descriptionText;
    
    
    // Create header view and add label as a subview
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(20, 12, 280, 82)];
    [headerView autorelease];
    [headerView addSubview:topLabel];
    
    [headerView addSubview:descriptionTextView];
    [headerView setAutoresizesSubviews:YES];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    [view autorelease];
    [view addSubview:headerView];
    [view setBackgroundColor: [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];  
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 88, 320, 2)];
    [bottomBorder setBackgroundColor: [UIColor colorWithRed:51/255.0 green:153/255.0 blue:51/255.0 alpha:1.0]];
    
    [view addSubview: bottomBorder];
    
    return view;
}
/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [optionSelectDelegate optionDidSelect: [optionItems objectAtIndex: [indexPath row]]];
    
}
-(void)dealloc {
    [super dealloc];
    
    [v release];
}
@end