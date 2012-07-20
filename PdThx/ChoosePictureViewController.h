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
#import "CustomAlertViewProtocol.h"
#import "ChooseMemberImageProtocol.h"

@interface ChoosePictureViewController : UIModalBaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, CustomAlertViewProtocol>{
	UIImageView * imageView;
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
    NSDictionary* images;
    UIImage* selectedImage;
    id<ChooseMemberImageProtocol> chooseMemberImageDelegate;
}

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;
@property (nonatomic, retain) id<ChooseMemberImageProtocol> chooseMemberImageDelegate;
-(IBAction) getPhoto:(id) sender;

@end
