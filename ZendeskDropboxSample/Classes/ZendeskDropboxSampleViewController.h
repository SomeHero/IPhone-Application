//
//  ZendeskDropboxSampleViewController.h
//  ZendeskDropboxSample
//
//  Created by Bill on 02/06/2009.
//  Copyright Zendesk Inc 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZendeskDropboxSampleViewController : UIViewController {
	UITextField *emailView;
	UITextField *subjectView;
	UITextView *descriptionView;
	
	IBOutlet UIBarButtonItem *sendButton;
	IBOutlet UITableView *tableView;
	
	BOOL showingKeyboard;
}

- (IBAction)submitTicket;

@end

