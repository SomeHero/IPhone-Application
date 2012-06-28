//
//  ChoosePictureViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIModalBaseViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Environment.h"
#import "User.h"
#import "PdThxAppDelegate.h"

@interface ChoosePictureViewController : UIModalBaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIImageView * imageView;
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
    NSDictionary* images;
}

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;

-(IBAction) getPhoto:(id) sender;

@end
