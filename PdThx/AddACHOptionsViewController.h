//
//  AddACHOptionsViewController.h
//  PdThx
//
//  Created by Christopher Magee on 9/5/12.
//
//

#import "UIModalBaseViewController.h"
#import "ACHSetupCompleteProtocol.h"

@interface AddACHOptionsViewController : UIModalBaseViewController<ACHSetupCompleteProtocol>
{
    IBOutlet UIButton *takePictureButton;
    
    IBOutlet UIButton *enterManuallyButton;
    IBOutlet UIView *navBar;
    
    id<ACHSetupCompleteProtocol> achSetupComplete;
}

@property(nonatomic, retain) id<ACHSetupCompleteProtocol> achSetupComplete;
@property (nonatomic, retain) UIButton * takePictureButton;
@property (nonatomic, retain) UIButton * enterManuallyButton;
@property (nonatomic, retain) UIView *navBar;

- (IBAction)pressedTakePictureButton:(id)sender;
- (IBAction)pressedEnterManuallyButton:(id)sender;

@end
