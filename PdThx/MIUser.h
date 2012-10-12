//
//  MIUser.h
//  MobileImagingLibrary
//
//  Created by Mitek Systems on 11/7/10.
//  Copyright 2010 Mitek Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MIUserDelegate

@optional

// Authenticate User
- (void)authenticateUserReturn:(NSDictionary *)dict;
- (void)authenticateUserError:(NSError *)err;

// GetJobSettings
- (void)getJobSettingsReturn:(NSDictionary *)dict;
- (void)getJobSettingsError:(NSError *)err;

// GetPhoneTransactionList
- (void)getPhoneTransactionListReturn:(NSDictionary *)dict;
- (void)getPhoneTransactionListError:(NSError *)err;

// InsertPhoneTransaction
- (void)insertPhoneTransactionReturn:(NSDictionary *)dict;
- (void)insertPhoneTransactionError:(NSError *)err;

// GetPhoneTransaction
- (void)getPhoneTransactionReturn:(NSDictionary *)dict;
- (void)getPhoneTransactionError:(NSError *)err;

// UpdatePhoneTransaction
- (void)updatePhoneTransactionReturn:(NSDictionary *)dict;
- (void)updatePhoneTransactionError:(NSError *)err;

@required

@end

@class MISupport;

@interface MIUser : NSObject {
	
	BOOL	verbose;

	NSString *username;
	NSString *password;
	NSString *urlString;
	NSString *orgId;
    NSString *deviceUniqueID;
	
	id delegate;
	
	NSDictionary *jobSettings;
	
    MISupport *authenticateUserSupport;
	MISupport *getJobSettingsSupport;
	MISupport *getPhoneTransactionListSupport;
	MISupport *insertPhoneTransactionSupport;
	MISupport *getPhoneTransactionSupport;
	MISupport *updatePhoneTransactionSupport;
}

@property (nonatomic, assign) BOOL verbose;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *orgId;
@property (nonatomic, strong) NSString *deviceUniqueID;
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NSDictionary *jobSettings;


- (id)initWithURL:(NSString *)inURL orgName:(NSString *)inOrgName username:(NSString *)inUsername password:(NSString *)inPassword;

- (NSString *) version;

- (BOOL) authenticateUser;

- (void) loadJobSettings:(NSString *)inDocIdentifier;

- (BOOL) getJobSettings:(NSString *)			inDocIdentifier;

- (BOOL) getPhoneTransactionList;

- (BOOL) insertPhoneTransaction:(UIImage *)		inImage
			 DocumentIdentifier:(NSString *)	inDocIdentifier
                  DocumentHints:(NSString *)    inDocHints
				DataReturnLevel:(NSInteger)		inDataReturnLevel
				ReturnImageType:(NSInteger)		inReturnType
					RotateImage:(NSInteger)		inRotateImage
                           Note:(NSString *)    inNote;

- (BOOL) insertPhoneTransactionWithBase64EncodedImage:(NSString *)		inStringImage
			 DocumentIdentifier:(NSString *)	inDocIdentifier
                  DocumentHints:(NSString *)    inDocHints
				DataReturnLevel:(NSInteger)		inDataReturnLevel
				ReturnImageType:(NSInteger)		inReturnType
					RotateImage:(NSInteger)		inRotateImage
                           Note:(NSString *)    inNote;
/*
- (BOOL) insertPhoneTransaction:(UIImage *)		inImage
			 DocumentIdentifier:(NSString *)	inDocIdentifier
				DataReturnLevel:(NSInteger)		inDataReturnLevel
				ReturnImageType:(NSInteger)		inReturnType
					RotateImage:(NSInteger)		inRotateImage
                          Data1:(NSString *)    inData1
                          Data2:(NSString *)    inData2
                          Data3:(NSString *)    inData3
                          Data4:(NSString *)    inData4
                          Data5:(NSString *)    inData5;
*/
- (BOOL) getPhoneTransaction:(NSInteger)		inTransactionId
			 DataReturnLevel:(NSInteger)		inDataReturnLevel
			 ReturnImageType:(NSInteger)		inReturnType
				 RotateImage:(NSInteger)		inRotateImage;

- (BOOL) updatePhoneTransaction:(NSInteger)		inTransactionId
		 UpdatedExtractedRawOcr:(NSString *)	inExtractedRawOcr
				UpdatedCodeLine:(NSString *)	inCodeLine
						   List:(NSArray *)		inList;

@end


@interface MIExtractedField : NSObject {
	
	NSString *name;
	NSString *value;
	NSInteger confidence;
	NSString *valueStandardized;
	NSInteger upperLeftX;
	NSInteger upperLeftY;
	NSInteger lowerRightX;
	NSInteger lowerRightY;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, assign) NSInteger confidence;
@property (nonatomic, retain) NSString *valueStandardized;
@property (nonatomic, assign) NSInteger upperLeftX;
@property (nonatomic, assign) NSInteger upperLeftY;
@property (nonatomic, assign) NSInteger lowerRightX;
@property (nonatomic, assign) NSInteger lowerRightY;

@end

