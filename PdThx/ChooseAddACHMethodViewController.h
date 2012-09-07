//
//  ChooseAddACHMethodViewController.h
//  PdThx
//
//  Created by Christopher Magee on 9/7/12.
//
//

#import "UIModalBaseViewController.h"
#import "UserACHSetupCompleteProtocol.h"

@interface ChooseAddACHMethodViewController : UIModalBaseViewController
{
    IBOutlet UIButton *takePictureButton;
    
    IBOutlet UIButton *enterManuallyButton;
    
    id<UserACHSetupCompleteProtocol> achSetupDidComplete;
}

@property(nonatomic, retain) id<UserACHSetupCompleteProtocol> achSetupDidComplete;

@property (nonatomic, retain) UIButton * takePictureButton;
@property (nonatomic, retain) UIButton * enterManuallyButton;

- (IBAction)pressedTakePictureButton:(id)sender;
- (IBAction)pressedEnterManuallyButton:(id)sender;

@end
