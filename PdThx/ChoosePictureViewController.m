//
//  ChoosePictureViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChoosePictureViewController.h"


@implementation ChoosePictureViewController

@synthesize imageView,choosePhotoBtn, takePhotoBtn;
@synthesize chooseMemberImageDelegate;


-(IBAction) getPhoto:(id) sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	if((UIButton *) sender == choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	
	[self presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	images = [info copy];
    
    selectedImage = [[images objectForKey:@"UIImagePickerControllerOriginalImage"] retain];
    imageView.image = selectedImage; 
    
    [picker dismissModalViewControllerAnimated:YES];

}


- (void)imageUpload:(NSData *)imageData filename:(NSString *)filename{

    Environment *myEnvironment = [Environment sharedInstance];
    User* tmpUser = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/upload_member_image?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, tmpUser.userId, myEnvironment.pdthxAPIKey]] autorelease];  
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlToSend];
    // Upload a file on disk
    [request addData:imageData withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:@"file"];
    [request setDelegate:self];
    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSString* fileName = [[jsonDictionary valueForKey: @"ImageUrl"] copy];
        
        NSLog(@"Image Uploaded F/N:%@", fileName);
        
        [chooseMemberImageDelegate chooseMemberImageDidComplete: fileName];
    }
    else {
        NSLog(@"Error Uploading Image");

    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    // Parse this responseString for better error handling
    //NSString *receivedString = [request responseString];
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
    // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
    // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
    // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
    [appDelegate showAlertWithResult:false withTitle:@"Image Upload Error" withSubtitle:@"We could not upload your image." withDetailText:@"We apologize, your image was not correctly processed. Please be sure that you have a data connection (WiFi, 3G or higher) and try again. Thank you!" withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0
          withRightButtonImageString:@"smallButtonGrey240x78.png"withRightButtonSelectedImageString:@"smallButtonGrey240x78.png" withRightButtonTitle:@"Not Shown" withRightButtonTitleColor:[UIColor whiteColor] withTextFieldPlaceholderText: @"" withDelegate:self];
}

-(void)didSelectButtonWithIndex:(int)index
{
    // No options, just dismiss.
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) dismissAlertView];
}


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



- (void)viewDidLoad {
 
    [super viewDidLoad];
    
    UIBarButtonItem *uploadButton =  [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonSystemItemAction target:self action:@selector(uploadClicked)];
    
    self.navigationItem.rightBarButtonItem= uploadButton;
    [uploadButton release];
 }
-(void)uploadClicked {
    
    //[imageView setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    NSString *imageName = @"uploaded.jpg";
    UIGraphicsBeginImageContext(CGSizeMake(320,480)); 
    UIImage *newImage=nil;
    
    [selectedImage drawInRect:CGRectMake(0, 0,320,480)];
    newImage = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext();
    
    [self imageUpload:UIImagePNGRepresentation(newImage) filename:imageName];

}




/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    
    [images dealloc];
}

@end