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
        
        if ([self isValidFormattedPayPoint:uri] == 1)
        {
            cell.contactDetail.text = @"Phone Number";
        }
        else if ([self isValidFormattedPayPoint:uri] == 2)
        {
            cell.contactDetail.text = @"Email Address";
            [cell.imgRecipient setBackgroundImage:[UIImage imageNamed:@"email-30x30.png"] forState:UIControlStateNormal];
        }
        else {
            cell.contactDetail.text = @"Facebook";
            [cell.imgRecipient setBackgroundImage:[UIImage imageNamed:@"facebook-30x30.png"] forState:UIControlStateNormal];
        }
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

-(int)isValidFormattedPayPoint: (NSString*) paypoint {
    // Do handling for entry of text field where entry does not match
    // any contacts in the user's contact list.
    
    // The only cases we need to handle are: Phone Number and Email
    NSString * numOnly = [[paypoint componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    NSRange numOnly2 = [[[paypoint componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+-() "]] componentsJoinedByString:@""] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]  options:NSCaseInsensitiveSearch];
    if([paypoint length] < 1)
        return 0;
    if ( [paypoint isEqualToString:numOnly] || numOnly2.location == NSNotFound ) {
        // Is only Numbers, I think?
        if ( [numOnly characterAtIndex:0] == '1' || [numOnly characterAtIndex:0] == '0' )
            numOnly = [numOnly substringFromIndex:1]; // Do not include country codes
        if ( [numOnly length] == 10 )
            return 1;
    } else {
        if ( [paypoint	 rangeOfString:@"@"].location != NSNotFound && [paypoint rangeOfString:@"."].location != NSNotFound ){
            // Contains both @ and a period. Now check if there's atleast:
            // SOMETHING before the @
            // SOMETHING after the @ before the .
            // SOMETHING after the .
            if ( [paypoint rangeOfString:@"@"].location != 0 
                && [paypoint rangeOfString:@"."].location != ([paypoint rangeOfString:@"@"].location + 1) && [paypoint length] != [paypoint rangeOfString:@"."].location+1 )
                return 2;
        }
    }
    
    return 0;
}


- (void)dealloc {
    [selectRecipientTable release];
    [recipients release];
    [txtHeader release];
    [selectRecipientDelegate release];
    [headerText release];
    [super dealloc];
}

@end
