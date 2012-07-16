//
//  ZendeskDropboxSampleAppDelegate.m
//  ZendeskDropboxSample
//
//  Created by Bill on 02/06/2009.
//  Copyright Zendesk Inc 2009. All rights reserved.
//

#import "ZendeskDropboxSampleAppDelegate.h"
#import "ZendeskDropboxSampleViewController.h"

@implementation ZendeskDropboxSampleAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
