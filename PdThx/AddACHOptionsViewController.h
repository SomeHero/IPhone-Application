//
//  AddACHOptionsViewController.h
//  PdThx
//
//  Created by Christopher Magee on 9/5/12.
//
//

#import "UISetupUserBaseViewController.h"

@interface AddACHOptionsViewController : UISetupUserBaseViewController
{
    IBOutlet UIButton *takePictureButton;
    
    IBOutlet UIButton *enterManuallyButton;
    IBOutlet UIView *navBar;
}

@property (nonatomic, retain) UIButton * takePictureButton;
@property (nonatomic, retain) UIButton * enterManuallyButton;
@property (nonatomic, retain) UIView *navBar;

- (IBAction)pressedTakePictureButton:(id)sender;
- (IBAction)pressedEnterManuallyButton:(id)sender;

@end
