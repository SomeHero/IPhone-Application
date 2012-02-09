//
//  PdThxAppDelegate.h
//  PdThx
//
//  Created by James Rhodes on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PdThxViewController;

@interface PdThxAppDelegate : NSObject <UIApplicationDelegate> {
    NSString* _recipientUri;
    NSString* _amount;
    NSString* _comments;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *welcomeController;
@property (nonatomic, retain) IBOutlet UIViewController *signInController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController  *registerNavigationController;
@property(nonatomic, retain) IBOutlet UINavigationController *setupPasswordController;
@property(nonatomic, retain) IBOutlet UINavigationController *signInViewController;
-(void)switchToMainController;
-(void)switchToConfirmation;
-(void)switchToSetPasswordController;
-(void)switchToRegisterController;
-(void)switchToWelcomeController;
-(void)switchToSignInController;
-(void)setRecipientUri: (NSString*) recipientUri;
-(void)setAmount: (NSString*) amount;
-(void)setComments: (NSString*) comments;
-(void)signOut;
-(void)forgetMe;

@end
