//
//  myProgressHud.m
//  PdThx
//
//  Created by James Rhodes on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "myProgressHud.h"

@interface myProgressHud ()

@end

@implementation myProgressHud

@synthesize topLabel, detailLabel, activityIndicator, imgView, fadedLayer, layerToAnimate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fadedLayer.backgroundColor = [UIColor whiteColor];
    self.layerToAnimate.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [activityIndicator release];
    activityIndicator = nil;
    [topLabel release];
    topLabel = nil;
    [detailLabel release];
    detailLabel = nil;
    [imgView release];
    imgView = nil;
    [fadedLayer release];
    fadedLayer = nil;
    [layerToAnimate release];
    layerToAnimate = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [activityIndicator release];
    [topLabel release];
    [detailLabel release];
    [imgView release];
    [fadedLayer release];
    [layerToAnimate release];
    [super dealloc];
}
@end
