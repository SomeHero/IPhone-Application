//
//  EditProfileViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

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
    profileSections = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).myApplication.profileSections;
    
    attributeValues = [[NSMutableArray alloc] init];
    
    userAttributeService = [[UserAttributeService alloc] init];
    [userAttributeService setUserSettingsCompleteProtocol: self];
    
    userService = [[UserService alloc] init];
    [userService setPersonalizeUserCompleteDelegate: self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    UserAttribute* updatedAttribute = [[UserAttribute alloc] init];
    updatedAttribute.attributeId = ((UIProfileTextField*)textField).attributeId;
    updatedAttribute.attributeValue = textField.text;
    
    [userAttributeService updateUserAttribute:updatedAttribute.attributeId withValue:updatedAttribute.attributeValue forUser:user.userId];
    
    for(int i = 0; i < [user.userAttributes count]; i++)
    {
        UserAttribute* userAttribute = [user.userAttributes objectAtIndex:i];
        
        if([updatedAttribute.attributeId isEqualToString:userAttribute.attributeId])
        {
            userAttribute.attributeValue = updatedAttribute.attributeValue;
        }
    }
    
    [updatedAttribute     release];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    UserAttribute* updatedAttribute = [[UserAttribute alloc] init];
    updatedAttribute.attributeId = ((UIProfileTextView*)textView).attributeId;
    updatedAttribute.attributeValue = textView.text;
    
    [userAttributeService updateUserAttribute:updatedAttribute.attributeId withValue:updatedAttribute.attributeValue forUser:user.userId];
    
    for(int i = 0; i < [user.userAttributes count]; i++)
    {
        UserAttribute* userAttribute = [user.userAttributes objectAtIndex:i];
        
        if([updatedAttribute.attributeId isEqualToString:userAttribute.attributeId])
        {
            userAttribute.attributeValue = updatedAttribute.attributeValue;
        }
    }
    
    [updatedAttribute release];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [profileSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1 + [[profileSections objectAtIndex: section] profileItems].count;
    else {
        return [[profileSections objectAtIndex: section] profileItems].count;
    }
}
- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
            return 90;
        else 
        {
            ProfileItem* profileItem = [[[profileSections objectAtIndex:indexPath.section] profileItems] objectAtIndex:indexPath.row - 1];
            
            if([profileItem.itemType isEqualToString: @"LongText"])
                return 120;
        }
    } else {
        
        ProfileItem* profileItem = [[[profileSections objectAtIndex:indexPath.section] profileItems] objectAtIndex:indexPath.row];
        
        if([profileItem.itemType isEqualToString: @"LongText"])
            return 120;
    }
    
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *HeaderCellIdentifier = @"Header";
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            UICustomProfileHeaderViewController *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UICustomProfileHeaderViewController" owner:self options:nil];
                cell = [nib objectAtIndex:0];

            
            
            [cell.btnUserImage.layer setCornerRadius:6.0];
            [cell.btnUserImage.layer setMasksToBounds:YES];
            [cell.btnUserImage.layer setBorderWidth:0.2];
            [cell.btnUserImage.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
            
            if(user.imageUrl != (id)[NSNull null] && [user.imageUrl length] > 0) {
                [cell.btnUserImage setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: user.imageUrl]]] forState:UIControlStateNormal];
            }else {
                [cell.btnUserImage setBackgroundImage:[UIImage imageNamed: @"avatar-50x50.png"] forState:UIControlStateNormal];
            }
            
            
            return cell;
            
        }
        else {
            UICustomProfileRowViewController *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UICustomProfileRowViewController" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            ProfileItem* profileItem = [[[profileSections objectAtIndex:indexPath.section] profileItems] objectAtIndex:indexPath.row - 1];
            
            
            return [self renderCell:cell withProfileItem: profileItem];
            
        }
    }
    else {
        UICustomProfileRowViewController *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UICustomProfileRowViewController" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        ProfileItem* profileItem = [[[profileSections objectAtIndex:indexPath.section] profileItems] objectAtIndex:indexPath.row];
        
        return [self renderCell:cell withProfileItem: profileItem];
    }
}
-(UITableViewCell*)renderCell: (UICustomProfileRowViewController*) cell withProfileItem:(ProfileItem*) profileItem
{
    cell.lblAttributeName.text = [profileItem label];
    

    if([[profileItem itemType] isEqualToString: @"ShortText"])
    {
        UIProfileTextField* txtField = [[UIProfileTextField alloc] initWithFrame:CGRectMake(0, cell.txtAttributeValue.frame.size.height/2 - 8, cell.txtAttributeValue.frame.size.width, 30)];
        txtField.delegate = self;
        txtField.attributeId= profileItem.attributeId;
        txtField.font = [UIFont systemFontOfSize:14];
        [txtField setReturnKeyType: UIReturnKeyDone];
        
        for(int i = 0; i < [user.userAttributes count]; i++)
        {
            UserAttribute* userAttribute = [user.userAttributes objectAtIndex:i];
            
            if([profileItem.attributeId isEqualToString:userAttribute.attributeId])
            {
                txtField.text = userAttribute.attributeValue;
            }
        }
    
        
        [cell.txtAttributeValue addSubview:txtField];

    } 
    else if([[profileItem itemType] isEqualToString: @"ImageCapture"])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 2, 150, cell.frame.size.height - 6);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btn setTitle:@"take picture" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(captureImage:) forControlEvents:UIControlEventTouchUpInside];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setBackgroundColor: [UIColor clearColor]];
        [btn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
        
        [cell.txtAttributeValue addSubview:btn];
        
    } else if([[profileItem itemType] isEqualToString: @"SocialAccount"])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 2, 150, cell.frame.size.height - 6);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btn setTitle:@"link account" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(linkAccount:) forControlEvents:UIControlEventTouchUpInside];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setBackgroundColor: [UIColor clearColor]];
        [btn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
        
        [cell.txtAttributeValue addSubview:btn];
        
    } 
    else if([[profileItem itemType] isEqualToString: @"Picker"])
    {
        UIProfileOptionSelectButton *btn = [UIProfileOptionSelectButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 2, 150, cell.frame.size.height - 6);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btn setTitle:@"select" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setBackgroundColor: [UIColor clearColor]];
        [btn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
        [btn setOptions: profileItem.options];
        [btn setOptionSelectAttributeId: profileItem.attributeId];
        [btn setSelectOptionHeader:profileItem.selectOptionHeader];
        [btn setSelectOptionDescription:profileItem.selectOptionDescription];
        
        for(int i = 0; i < [user.userAttributes count]; i++)
        {
            UserAttribute* userAttribute = [user.userAttributes objectAtIndex:i];
            
            if([profileItem.attributeId isEqualToString:userAttribute.attributeId])
            {
                btn.selectedOption = userAttribute.attributeValue;
                [btn setTitle:userAttribute.attributeValue forState:UIControlStateNormal];
            }
        }
        
        
        [cell.txtAttributeValue addSubview:btn];
        
    }
    else if([[profileItem itemType] isEqualToString: @"LongText"]) {
        
        UIProfileTextView* txtView = [[UIProfileTextView alloc] initWithFrame:CGRectMake(0, 10, cell.txtAttributeValue.frame.size.width - 5, 100)];
        [txtView setBackgroundColor: [UIColor clearColor]];
        txtView.attributeId= profileItem.attributeId;
        [txtView setDelegate: self];
        [txtView setReturnKeyType: UIReturnKeyDone];
        
        for(int i = 0; i < [user.userAttributes count]; i++)
        {
            UserAttribute* userAttribute = [user.userAttributes objectAtIndex:i];
            
            if([profileItem.attributeId isEqualToString:userAttribute.attributeId])
            {
                txtView.text = userAttribute.attributeValue;
            }
        }
        
        cell.txtAttributeValue.frame = CGRectMake(cell.txtAttributeValue.frame.origin.x, cell.txtAttributeValue.frame.origin.y, cell.txtAttributeValue.frame.size.width,
                                                   100);
        [cell.txtAttributeValue addSubview:txtView];
        
        [txtView release];
    }
    else if([[profileItem itemType] isEqualToString: @"Switch"])
    {
        UIProfileSwitch* switchItem = [[UIProfileSwitch alloc] initWithFrame:CGRectMake(0, cell.txtAttributeValue.frame.size.height/2- 12, cell.txtAttributeValue.frame.size.width, cell.txtAttributeValue.frame.size.height)];
        switchItem.attributeId = profileItem.attributeId;
        
        [switchItem addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
        
        [switchItem setOn: false];
        for(int i = 0; i < [user.userAttributes count]; i++)
        {
            UserAttribute* userAttribute = [user.userAttributes objectAtIndex:i];
            
            if([profileItem.attributeId isEqualToString:userAttribute.attributeId])
            {
                if([userAttribute.attributeValue isEqualToString: @"On"]) {
                    [switchItem setOn: true];
                }
            }
        }

        
        [cell.txtAttributeValue addSubview:switchItem];
        
        [switchItem release];
        
    }
    
    return cell;

}
- (IBAction) flip: (id) sender {
    UIProfileSwitch *onoff = (UIProfileSwitch *) sender;
    NSString* attributeValue = onoff.on ? @"On" : @"Off";
    
    UserAttribute* updatedAttribute = [[UserAttribute alloc] init];
    updatedAttribute.attributeId = onoff.attributeId;
    updatedAttribute.attributeValue = attributeValue;
    
    [userAttributeService updateUserAttribute:updatedAttribute.attributeId withValue:updatedAttribute.attributeValue forUser:user.userId];
}
-(void) selectOption: (id)sender {
    selectModalViewController = [[[SelectModalViewController alloc] initWithFrame:self.view.bounds] autorelease];
    
    optionSelectAttributeId = ((UIProfileOptionSelectButton*)sender).optionSelectAttributeId; 
    NSMutableArray* options = ((UIProfileOptionSelectButton*)sender).options;
    
    [selectModalViewController setOptionSelectDelegate: self];
    selectModalViewController.optionItems= options;
    selectModalViewController.selectedOptionItem = ((UIProfileOptionSelectButton*)sender).selectedOption;
    selectModalViewController.headerText = ((UIProfileOptionSelectButton*)sender).selectOptionHeader;
    selectModalViewController.descriptionText = ((UIProfileOptionSelectButton*)sender).selectOptionDescription;
    
    [self.view addSubview:selectModalViewController];
    [selectModalViewController show];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return  [[profileSections objectAtIndex: section] sectionHeader];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    
    label.font = [UIFont boldSystemFontOfSize:12];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view autorelease];
    [view addSubview:label];
    
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
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        UIActionSheet*imageInputChoose = [[UIActionSheet alloc] initWithTitle:@"Choose an input source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
        [imageInputChoose showInView:self.view];
    }
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Photo"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose Existing"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    else
    {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"Using info here so I can inspect it... %@", info);
    
    UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissModalViewControllerAnimated:YES];
    [appDelegate showWithStatus:@"Uploading" withDetailedStatus:@"Saving your image, please wait"];
    
    NSString *imageName = @"uploaded.jpg";
    
    UIGraphicsBeginImageContext(CGSizeMake(320,320));
    UIImage *newImage=nil;
    
    [originalImage drawInRect:CGRectMake(0, -50,320,480)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self imageUpload:UIImagePNGRepresentation(newImage) filename:imageName];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imageUpload:(NSData *)imageData filename:(NSString *)filename
{
    Environment *myEnvironment = [Environment sharedInstance];
    User* tmpUser = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/upload_member_image?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, tmpUser.userId, myEnvironment.pdthxAPIKey]] autorelease];
    
    ASIFormDataRequest *uploadReq = [ASIFormDataRequest requestWithURL:urlToSend];
    // Upload a file on disk
    [uploadReq addData:imageData withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:@"file"];
    [uploadReq setDelegate:self];
    [uploadReq startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 )
    {
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSString* fileName = [[jsonDictionary valueForKey: @"ImageUrl"] copy];
        
        NSLog(@"Image Uploaded F/N:%@", fileName);
        appDelegate.user.imageUrl = fileName;
        [appDelegate showSuccessWithStatus:@"Success!" withDetailedStatus:@"Profile image updated"];
        [profileTable reloadData];
    }
    else
    {
        NSLog(@"Error Uploading Image");
        [appDelegate showSimpleAlertView:NO withTitle:@"Image Error" withSubtitle:@"Could not upload image" withDetailedText:@"Please check your data connection and try again." withButtonText:@"Ok" withDelegate:self];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showSimpleAlertView:NO withTitle:@"Image Error" withSubtitle:@"Could not upload image" withDetailedText:@"Please check your data connection and try again." withButtonText:@"Ok" withDelegate:self];
}

-(void)didSelectButtonWithIndex:(int)index
{
    // No options, just dismiss.
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) dismissAlertView];
}

#pragma mark UITextFieldDelegate methods
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    UserAttribute* updatedAttribute = [[UserAttribute alloc] init];
    updatedAttribute.attributeId = [NSString stringWithFormat: @"%d", textField.tag];
    updatedAttribute.attributeValue = textField.text;
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if(textField.tag == 1)
    {
        [textField setText: @"$0.00"];
        
        return NO;
    } 
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
-(void) optionDidSelect:(NSString*) optionId {
    
    //if([selectModal.accountType isEqualToString: @"Send"]) {
    //    [bankAccountService setPreferredSendAccount:optionId forUserId:user.userId];
    //}
    //else {
     //   [bankAccountService setPreferredReceiveAccount:optionId forUserId:user.userId];
    //}
    UserAttribute* updatedAttribute = [[UserAttribute alloc] init];
    updatedAttribute.attributeId = optionSelectAttributeId;
    updatedAttribute.attributeValue = optionId;
    
    [userAttributeService updateUserAttribute:updatedAttribute.attributeId withValue:updatedAttribute.attributeValue forUser:user.userId];
    
    
    [updatedAttribute release];
    [selectModalViewController hide];
    
    [profileTable reloadData];
}
-(void)getUserSettingsDidComplete: (NSMutableArray*) userSettings {
    
}
-(void)getUserSettingsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode {
    
    
}
-(void)updateUserSettingsDidComplete: (NSString*) attributeKey withValue: (NSString*) attributeValue {
    NSLog(@"%@", @"Update Settings");

    bool found = false;
    for(int i = 0; i < [user.userAttributes count]; i++)
    {
        UserAttribute* userAttribute = [user.userAttributes objectAtIndex:i];
        
        if([attributeKey isEqualToString:userAttribute.attributeId])
        {
            userAttribute.attributeValue = attributeValue;
            found = true;
        }
    }
    
    if(!found)
    {
        UserAttribute* attribute = [UserAttribute alloc];
        attribute.attributeId = attributeKey;
        attribute.attributeName = @"";
        attribute.attributeValue = attributeValue;
        
        [user.userAttributes addObject: attribute];
    }
}
-(void)updateUserSettingsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode {
    
}

-(IBAction) bgTouched:(id) sender {
    [currentTextField resignFirstResponder];
}
-(void)chooseMemberImageDidComplete: (NSString*) imageUrl {
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    user.imageUrl = imageUrl;
    
    [profileTable reloadData];
    
    [self dismissModalViewControllerAnimated:YES];
    
    [userService personalizeUser:user.userId WithFirstName:user.firstName withLastName:user.lastName withImage: imageUrl];
    
}
-(void) personalizeUserDidComplete {
     NSLog(@"%@", @"Image Uploaded");
    
}
-(void) personalizeUserDidFail:(NSString*) response withErrorCode:(int)errorCode {
    
}


@end
