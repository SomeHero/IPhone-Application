//
//  AddACHOptionsViewController.h
//  PdThx
//
//  Created by Christopher Magee on 9/5/12.
//
//

#import "UIBaseViewController.h"

@interface AddACHOptionsViewController : UIBaseViewController
{
    IBOutlet UIButton *takePictureButton;
    
    IBOutlet UIButton *enterManuallyButton;
}

@property (nonatomic, retain) UIButton * takePictureButton;
@property (nonatomic, retain) UIButton * enterManuallyButton;

- (IBAction)pressedTakePictureButton:(id)sender;
- (IBAction)pressedEnterManuallyButton:(id)sender;

@end
