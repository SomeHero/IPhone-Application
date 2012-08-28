//
//  MIPController.m
//  
//
//  Created by Mitek Systems on 3/13/12.
//  Copyright (c) 2012 Mitek Systems, Inc. All rights reserved.
//

#import "MIPController.h"

static MIPController *gInstance = NULL;

@interface MIPController ()

@property (nonatomic, strong) id<MIPControllerDelegate> delegate;
@property (nonatomic, strong) NSDictionary *masterJobSettings;

@end

@implementation MIPController

@synthesize miUser = _miUser;
@synthesize delegate = _delegate;
@synthesize masterJobSettings = _masterJobSettings;
@synthesize allJobSettings = _allJobSettings;

@synthesize serverURL;
@synthesize jobName;
@synthesize orgID;
@synthesize returnedVideoParams;

+ (MIPController *)sharedInstance {
    @synchronized(self)
    {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    return(gInstance);
}

- (id)init {
    self = [super init];
    if (self) {
        gInstance = self;
    }
    return self;
}


- (void)dropDelegate:(id<MIPControllerDelegate>)inDelegate
{
    if(inDelegate == _delegate)
        self.delegate = nil;
}

#pragma mark - Authentication

- (BOOL)connect:(NSString *)username password:(NSString *)password delegate:(id<MIPControllerDelegate>)inDelegate
{
    if(_miUser)
        self.miUser = nil;
    
    if(_delegate)
        self.delegate = nil;
    
    if(inDelegate)
        self.delegate = inDelegate;
    else
        return NO;
    
    _miUser = [[MIUser alloc] initWithURL:serverURL orgName:orgID username:username password:password];
	if(_miUser != nil) {
        
        // Authenticate the user
        [_miUser setDelegate:self];
        if([_miUser authenticateUser])
            return YES;
	}
    return NO;
}

- (void)authenticateUserReturn:(NSDictionary *)dict {
    
    if([[dict objectForKey:@"SecurityResult"] integerValue]) {
        if (_delegate && [_delegate respondsToSelector:@selector(connectFailure)])
            [_delegate connectFailure];
    }
    else {
        [_miUser loadJobSettings:jobName];
        self.masterJobSettings = [NSDictionary dictionaryWithDictionary:_miUser.jobSettings];
        self.allJobSettings = [dict objectForKey:@"AvailableJobs"];
        
        if (_delegate && [_delegate respondsToSelector:@selector(connectSuccess)])
            [_delegate connectSuccess];
    }
    return;
}

- (void)authenticateUserError:(NSError *)err {
    
    if (_delegate && [_delegate respondsToSelector:@selector(connectFailure)])
        [_delegate connectFailure];
}

#pragma mark - Job Settings

- (NSDictionary *)jobSettings
{
    return self.masterJobSettings;
}

- (NSDictionary *)settingsForCurrentJob
{
    [_miUser setJobSettings:nil];
    [_miUser loadJobSettings:jobName];
    self.masterJobSettings = [NSDictionary dictionaryWithDictionary:_miUser.jobSettings];
    return [self jobSettings];
}

- (void)saveReturnedVideoParams:(NSDictionary *)params {
    self.returnedVideoParams = params;
}

- (NSDictionary *)processVideoParams {
    return nil;
}

#pragma mark - Send Image

- (BOOL)sendImage:(UIImage *)inImage delegate:(id<MIPControllerDelegate>)inDelegate
{
    if(!_miUser || !inDelegate)
        return NO;
    
    if(_delegate)
        self.delegate = nil;
    
    self.delegate = inDelegate;
    
    //    NSDictionary *hintsDictionary = [self processVideoParams];
    
    return [_miUser insertPhoneTransaction:inImage 
                        DocumentIdentifier:jobName
                             DocumentHints:@""
                           DataReturnLevel:23
                           ReturnImageType:1
                               RotateImage:1
                                      Note:@""];
}

- (BOOL)sendBase64EncodedImage:(NSString *)inStringImage delegate:(id<MIPControllerDelegate>)inDelegate
{
    if(!_miUser || !inDelegate)
        return NO;
    
    if(_delegate)
        self.delegate = nil;
    
    self.delegate = inDelegate;
    
    //    NSDictionary *hintsDictionary = [self processVideoParams];
    
    return [_miUser insertPhoneTransactionWithBase64EncodedImage:inStringImage 
                        DocumentIdentifier:jobName
                             DocumentHints:@""
                           DataReturnLevel:23
                           ReturnImageType:1
                               RotateImage:1
                                      Note:@""];
}

- (void) insertPhoneTransactionError:(NSError *)err {
	
	NSLog(@"Failure signaled - %@", [err description]);
	
    if (_delegate && [_delegate respondsToSelector:@selector(imageFailure:)])
        [_delegate imageFailure:err];
}

- (void) insertPhoneTransactionReturn:(NSDictionary *)xmlDict
{
	
    if (_delegate && [_delegate respondsToSelector:@selector(imageSuccess:)])
        [_delegate imageSuccess:xmlDict];
}

@end
