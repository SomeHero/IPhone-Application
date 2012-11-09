//
//  PersonalizeViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonalizeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PdThxAppDelegate.h"
#import "User.h"
#import "ASIFormDataRequest.h"

@interface PersonalizeViewController ()

@end

@implementation PersonalizeViewController

@synthesize firstNameField, lastNameField, userImageButton, saveContinueButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tabBarController.tabBar setUserInteractionEnabled:NO];

    SetupNavigationView *setupNavBar = [[SetupNavigationView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
    [setupNavBar setActiveState:@"Personalize" withJoinComplete:YES whereActivateComplete:YES wherePersonalizeComplete:NO whereEnableComplete:NO];
    
    [navBar addSubview:setupNavBar];
    
    [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:[[UIView new] autorelease]] autorelease]];
    
    [self setTitle: @"Personalize"];
    firstNameField.delegate = self;
    lastNameField.delegate = self;
    
    userService = [[UserService alloc] init];
    [userService setPersonalizeUserCompleteDelegate: self];
    
    validationHelper = [[ValidationHelper alloc] init];
    
    [userImageButton.layer setCornerRadius:6.0];
    [userImageButton.layer setMasksToBounds:YES];
    [userImageButton.layer setBorderWidth:0.2];
    [userImageButton.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"PersonalizeViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}   
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    if(user.firstName != (id)[NSNull null] && [user.firstName length] > 0)
        firstNameField.text = user.firstName;
    else
        firstNameField.text = @"";
    
    if(user.lastName != (id)[NSNull null] && [user.lastName length] > 0)
        lastNameField.text = user.lastName;
    else
        lastNameField.text = @"";
    
    if([user.imageUrl length] > 0)
    {
        [userImageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: user.imageUrl]]] forState:UIControlStateNormal];
    }
    else {
        [userImageButton setBackgroundImage:[UIImage imageNamed: @"avatar-50x50.png"] forState:UIControlStateNormal];
    }
        
    self.navigationItem.leftBarButtonItem = nil;   
}
- (void)viewDidUnload
{
    [userImageButton release];
    userImageButton = nil;
    [firstNameField release];
    firstNameField = nil;
    [lastNameField release];
    lastNameField = nil;
    [saveContinueButton release];
    saveContinueButton = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [userImageButton release];
    [firstNameField release];
    [lastNameField release];
    [saveContinueButton release];
    [userService release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (IBAction)pressedSaveContinue:(id)sender 
{
    [firstNameField resignFirstResponder];
    [lastNameField resignFirstResponder];
    
    BOOL isValid = YES;
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(isValid && ![validationHelper isRequired:firstNameField.text])
    {
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"First Name is Required"];
        
        isValid = NO;
    }

    if(isValid && ![validationHelper isRequired:lastNameField.text])
    {
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Last Name is Required"];
        
        isValid = NO;
    }
    if(isValid)
    {
        NSString* imageUrl = @"";
        
        if(user.imageUrl != (id)[NSNull null])
            imageUrl = user.imageUrl;
        
        // Update user for next time.
        appDelegate.user.firstName = firstNameField.text;
        appDelegate.user.lastName = lastNameField.text;
        appDelegate.user.imageUrl = imageUrl;
        
        [appDelegate showWithStatus:@"Updating Profile" withDetailedStatus:@""];
        [userService personalizeUser:user.userId WithFirstName:firstNameField.text withLastName:lastNameField.text withImage: imageUrl];
    }
}

-(void) personalizeUserDidComplete
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showSuccessWithStatus:@"Profile Updated" withDetailedStatus:@""];
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow:self];
}

-(void) personalizeUserDidFail:(NSString*) response withErrorCode:(int)errorCode {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Failed!" withDetailedStatus:@"Check data connection"];
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow:self];
}

-(IBAction) bgTouched:(id) sender
{
    [firstNameField resignFirstResponder];
    [lastNameField resignFirstResponder];
}

-(IBAction) chooseImageClicked:(id) sender
{
    UIActionSheet*imageInputChoose = [[UIActionSheet alloc] initWithTitle:@"Choose an input source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [imageInputChoose showInView:self.view];
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
    
    [userImageButton setBackgroundImage:originalImage forState:UIControlStateNormal];
    [appDelegate showWithStatus:@"Uploading" withDetailedStatus:@"Saving your image, please wait"];
    
    NSString *imageName = @"uploaded.jpg";
    
    UIGraphicsBeginImageContext(CGSizeMake(320,480));
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
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlToSend];
    // Upload a file on disk
    [request addData:imageData withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:@"file"];
    [request setDelegate:self];
    [request startAsynchronous];
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

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [textField resignFirstResponder];
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self pressedSaveContinue:self];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)chooseMemberImageDidComplete: (NSString*) imageUrl {
//do nothing
}

@end
