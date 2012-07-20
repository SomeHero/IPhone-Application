//
//  ZendeskDropboxSampleAppDelegate.h
//  ZendeskDropboxSample
//
//  Created by Bill on 02/06/2009.
//  Copyright Zendesk Inc 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZendeskDropboxSampleViewController;

@interface ZendeskDropboxSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *viewController;

@end

