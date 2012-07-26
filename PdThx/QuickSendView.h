//
//  QuickSendView.h
//  PdThx
//
//  Created by James Rhodes on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickSendButtonProtocol.h"

@interface QuickSendView : UIView
{
    IBOutlet UIButton *qs1button;
    IBOutlet UIButton *qs2button;
    IBOutlet UIButton *qs3button;
    IBOutlet UIButton *qs4button;
    IBOutlet UIButton *qs5button;
    IBOutlet UIButton *qs6button;
    IBOutlet UIButton *qs7button;
    IBOutlet UIButton *qs8button;
    IBOutlet UIButton *qs9button;
    
    IBOutlet UILabel *qs1toplabel;
    IBOutlet UILabel *qs1bottomlabel;
    
    IBOutlet UILabel *qs2toplabel;
    IBOutlet UILabel *qs2bottomlabel;
    
    IBOutlet UILabel *qs3toplabel;
    IBOutlet UILabel *qs3bottomlabel;
    
    IBOutlet UILabel *qs4toplabel;
    IBOutlet UILabel *qs4bottomlabel;
    
    IBOutlet UILabel *qs5toplabel;
    IBOutlet UILabel *qs5bottomlabel;
    
    IBOutlet UILabel *qs6toplabel;
    IBOutlet UILabel *qs6bottomlabel;
    
    IBOutlet UILabel *qs7toplabel;
    IBOutlet UILabel *qs7bottomlabel;
    
    IBOutlet UILabel *qs8toplabel;
    IBOutlet UILabel *qs8bottomlabel;
    
    IBOutlet UILabel *qs9toplabel;
    IBOutlet UILabel *qs9bottomlabel;
    
    id<QuickSendButtonProtocol> buttonDelegate;
}

@property (nonatomic,retain) UIButton* qs1button;
@property (nonatomic,retain) UIButton* qs2button;
@property (nonatomic,retain) UIButton* qs3button;
@property (nonatomic,retain) UIButton* qs4button;
@property (nonatomic,retain) UIButton* qs5button;
@property (nonatomic,retain) UIButton* qs6button;
@property (nonatomic,retain) UIButton* qs7button;
@property (nonatomic,retain) UIButton* qs8button;
@property (nonatomic,retain) UIButton* qs9button;

@property (nonatomic,retain) UILabel* qs1toplabel;
@property (nonatomic,retain) UILabel* qs1bottomlabel;
@property (nonatomic,retain) UILabel* qs2toplabel;
@property (nonatomic,retain) UILabel* qs2bottomlabel;
@property (nonatomic,retain) UILabel* qs3toplabel;
@property (nonatomic,retain) UILabel* qs3bottomlabel;
@property (nonatomic,retain) UILabel* qs4toplabel;
@property (nonatomic,retain) UILabel* qs4bottomlabel;
@property (nonatomic,retain) UILabel* qs5toplabel;
@property (nonatomic,retain) UILabel* qs5bottomlabel;
@property (nonatomic,retain) UILabel* qs6toplabel;
@property (nonatomic,retain) UILabel* qs6bottomlabel;
@property (nonatomic,retain) UILabel* qs7toplabel;
@property (nonatomic,retain) UILabel* qs7bottomlabel;
@property (nonatomic,retain) UILabel* qs8toplabel;
@property (nonatomic,retain) UILabel* qs8bottomlabel;
@property (nonatomic,retain) UILabel* qs9toplabel;
@property (nonatomic,retain) UILabel* qs9bottomlabel;

@property (assign) id buttonDelegate;

- (IBAction)qs1pressed:(id)sender;
- (IBAction)qs2pressed:(id)sender;
- (IBAction)qs3pressed:(id)sender;
- (IBAction)qs4pressed:(id)sender;
- (IBAction)qs5pressed:(id)sender;
- (IBAction)qs6pressed:(id)sender;
- (IBAction)qs7pressed:(id)sender;
- (IBAction)qs8pressed:(id)sender;
- (IBAction)qs9pressed:(id)sender;








@end
