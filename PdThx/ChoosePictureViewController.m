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
	[picker dismissModalViewControllerAnimated:YES];
	imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    images = [info retain];
}
-(void)uploadClicked {
    //[imageView setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    UIImage *image = [images objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSString *imageName = @"uploaded.jpg";
    UIGraphicsBeginImageContext(CGSizeMake(320,480)); 
    UIImage *newImage=nil;
    [image drawInRect:CGRectMake(0, 0,320,480)];
    newImage = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext();

    [self imageUpload:UIImageJPEGRepresentation(newImage, 1.0) filename:imageName];

}

- (void)imageUpload:(NSData *)imageData filename:(NSString *)filename{
    NSURL *url = [NSURL URLWithString:@"http://23.21.203.171/api/internal/api/FileUpload"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    // Upload a file on disk
    [request setData:imageData withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:@"file"];
    [request setDelegate:self];
    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request {
    
    if([request responseStatusCode] == 201 ) {
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSString* fileName = [[jsonDictionary valueForKey: @"FileName"] copy];
        
        NSLog(@"Image Uploaded F/N:%@", fileName);
        

    }
    else {
        NSLog(@"Error Uploading Image");

    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSString *receivedString = [request responseString];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:receivedString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
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