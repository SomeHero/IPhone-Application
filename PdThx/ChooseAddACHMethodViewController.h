//
//  ChooseAddACHMethodViewController.h
//  PdThx
//
//  Created by Christopher Magee on 9/7/12.
//
//

#import "UIModalBaseViewController.h"
#import "ACHSetupCompleteProtocol.h"

@interface ChooseAddACHMethodViewController : UIModalBaseViewController<ACHSetupCompleteProtocol>
{
    IBOutlet UIButton *takePictureButton;
    
    IBOutlet UIButton *enterManuallyButton;
    
    id<ACHSetupCompleteProtocol> achSetupComplete;
}

@property(nonatomic, retain) id<ACHSetupCompleteProtocol> achSetupComplete;

@property (nonatomic, retain) UIButton * takePictureButton;
@property (nonatomic, retain) UIButton * enterManuallyButton;

- (IBAction)pressedTakePictureButton:(id)sender;
- (IBAction)pressedEnterManuallyButton:(id)sender;

@end
