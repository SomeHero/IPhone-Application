//
//  MIPController.h
//  
//
//  Created by Mitek Systems on 3/13/12.
//  Copyright (c) 2012 Mitek Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIUser.h"

@protocol MIPControllerDelegate <NSObject>

@optional

- (void)connectSuccess;
- (void)connectFailure;
- (void)imageSuccess;
- (void)imageSuccess:(NSDictionary *)xmlDict;
- (void)imageFailure:(NSError *)err;

@end

@interface MIPController : NSObject < MIUserDelegate >

+ (MIPController *) sharedInstance;

@property (nonatomic, strong) MIUser *miUser;
@property (nonatomic, strong) NSString *serverURL;
@property (nonatomic, strong) NSString *jobName;
@property (nonatomic, strong) NSString *orgID;
@property (nonatomic, strong) NSDictionary *returnedVideoParams;
@property (nonatomic, strong) NSDictionary *allJobSettings;

- (void)dropDelegate:(id<MIPControllerDelegate>)inDelegate;
- (BOOL)connect:(NSString *)username password:(NSString *)password delegate:(id<MIPControllerDelegate>)inDelegate;
- (NSDictionary *)jobSettings;
- (BOOL)sendImage:(UIImage *)inImage delegate:(id<MIPControllerDelegate>)inDelegate;
- (BOOL)sendBase64EncodedImage:(NSString *)inStringImage delegate:(id<MIPControllerDelegate>)inDelegate;
- (NSDictionary *)settingsForCurrentJob;
- (void)saveReturnedVideoParams:(NSDictionary *)params;

@end
