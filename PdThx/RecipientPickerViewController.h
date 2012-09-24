//
//  RecipientPickerViewController.h
//  PdThx
//
//  Created by Christopher Magee on 9/16/12.
//
//

#import "UIBaseViewController.h"
#import "UserService.h"
#import "SetContactProtocol.h"
#import "SetContactAndAmountProtocol.h"

#import "PdThxAppDelegate.h"

@interface RecipientPickerViewController : UIBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITextField *txtSearchBox;
    IBOutlet UITableView *tableView;
    
    UserService* userService;
    TSPopoverController *popoverController;
    
    id<ContactSelectChosenProtocol> contactChosenDelegate;
    id<SetContactProtocol> didSetContactDelegate;
    id<SetContactAndAmountProtocol> didSetContactAndAmountDelegate;
    
    NSMutableDictionary * tableImagesDownloading;
}

@property (nonatomic, retain) PdThxAppDelegate* appDelegate;

// Array to hold the current list of contacts.
// Contacts will be added to this array (and cleared)
// when resetting the table view data.
@property (nonatomic, retain) NSMutableDictionary* shownContacts;
@property (nonatomic, retain) NSMutableArray* tableSections;

@property (nonatomic, retain) UserService* userService;

/*      Return Delegates        */
// Contact Chosen from List
@property (assign) id contactChosenDelegate;
@property (assign) id didSetContactDelegate;
@property (assign) id didSetContactAndAmountDelegate;

- (IBAction)searchBoxChanged:(id)sender;

-(void)findMeCodes:(NSString*)searchTerm;

@end
