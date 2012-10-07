//
//  ZendeskDropboxSampleViewController.m
//  ZendeskDropboxSample
//
//  Created by Bill on 02/06/2009.
//  Copyright Zendesk Inc 2009. All rights reserved.
//

#import "ZendeskDropboxSampleViewController.h"
#import "ZendeskDropbox.h"

@implementation ZendeskDropboxSampleViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSNotificationCenter *centre = [NSNotificationCenter defaultCenter];
	[centre addObserver:self selector:@selector(keyboardNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
	[centre addObserver:self selector:@selector(keyboardNotification:) name:UITextViewTextDidBeginEditingNotification object:nil];
	sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(submitTicket)];
	self.navigationItem.rightBarButtonItem = sendButton;
}

- (void)keyboardNotification:(NSNotification *)aNotification {
	CGRect myframe;
	if ( [[aNotification name] isEqual:UITextFieldTextDidBeginEditingNotification] && !showingKeyboard ) {
		// shrink the tableview
		myframe = tableView.frame;
		myframe.size.height -= 216.0;
		tableView.frame = myframe;
		showingKeyboard = YES;
	} else if ([[aNotification name] isEqual:UITextViewTextDidBeginEditingNotification] && !showingKeyboard ) {
		// expand the table view
		myframe = tableView.frame;
		myframe.size.height -= 216.0;
		tableView.frame = myframe;
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		showingKeyboard = YES;
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[sendButton release];
	[descriptionView release];
	[emailView release];
	[subjectView release];
    [super dealloc];
}

- (IBAction)submitTicket {
	ZendeskDropbox *ticketSubmission = [[ZendeskDropbox alloc] init];
	ticketSubmission.delegate = self;
	sendButton.enabled = NO;
	[ticketSubmission sendTicket:[NSDictionary dictionaryWithObjectsAndKeys:descriptionView.text, ZendeskDropboxDescription, emailView.text, ZendeskDropboxEmail, subjectView.text, ZendeskDropboxSubject, nil]];
}

#pragma mark ticket submission delegate
- (void)submissionDidFinishLoading:(ZendeskDropbox *)connection {
	sendButton.enabled = YES;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Ticket sent to server successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[connection release];
}

- (void)submission:(ZendeskDropbox *)connection didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[error userInfo] valueForKey:NSLocalizedDescriptionKey] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	sendButton.enabled = YES;
	[connection release];
}

#pragma mark Table view methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"Email";
		case 1:
			return @"Subject";
		case 2:
			return @"Description";
		default:
			break;
	}
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if ( section == 2 ) return @"Please fill in details above, we'll get back to you as soon as possible.";
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell * cell;
	
	switch (indexPath.section) {
		case 0:
		{
			if ( !( cell = [tableView dequeueReusableCellWithIdentifier:@"emailcell"] ) ) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"emailcell"] autorelease];
			}
//			cell.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
//			cell.text = @"Email";
//			cell.textColor = [UIColor darkGrayColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if ( emailView == nil ) {
				emailView = [[UITextField alloc] initWithFrame:CGRectMake(5.0, 7.0, 290.0, 37.0)];
				emailView.font = [UIFont systemFontOfSize:22.0];
				emailView.keyboardType = UIKeyboardTypeEmailAddress;
				emailView.autocorrectionType = UITextAutocorrectionTypeNo;
				emailView.borderStyle = UITextBorderStyleNone;
				[cell.contentView addSubview:emailView];
			}
			emailView.text = user.emailAddress;
//			cell.accessoryView = emailView;
			break;
		}
		case 1:
		{
			if ( !( cell = [tableView dequeueReusableCellWithIdentifier:@"subjectcell"] ) ) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"subjectcell"] autorelease];
			}
			//			cell.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
//			cell.text = @"Subject";
//			cell.textColor = [UIColor darkGrayColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if ( subjectView == nil ) {
				subjectView = [[UITextField alloc] initWithFrame:CGRectMake(5.0, 7.0, 290.0, 37.0)];
				subjectView.font = [UIFont systemFontOfSize:22.0];
				subjectView.borderStyle = UITextBorderStyleNone;
				
//				NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
//				[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//				[dateFormatter setTimeStyle:NSDateFormatterLongStyle];
//				
//				NSDate *date = [NSDate date];
//				subjectView.text = [dateFormatter stringFromDate:date];
				[cell.contentView addSubview:subjectView];
			}
//			cell.accessoryView = subjectView;
			break;
		}
		case 2:
		{
			if ( !( cell = [tableView dequeueReusableCellWithIdentifier:@"descriptioncell"] ) ) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"descriptioncell"] autorelease];
			}
			if ( descriptionView == nil ) {
				descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 8.0, 300.0, 110.0)];
				descriptionView.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
				descriptionView.scrollEnabled = NO;
				[cell.contentView addSubview:descriptionView];
			}
			//cell.selectionStyle = UITableViewCellSelectionStyleNone;
			break;
		}
		default:
			break;
	}
    
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( indexPath.section > 1 ) return 130.0;
	return 44.0;
}

@end
