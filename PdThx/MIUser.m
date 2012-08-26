//
//  MIUser.m
//  MobileImagingLibrary
//
//  Created by Mitek Systems on 11/7/10.
//  Copyright 2010 Mitek Systems, Inc. All rights reserved.
//

#import "MIUser.h"
#import "MISupport.h"
#import "MIBase64.h"
#import "XMLWebService.h"

@implementation MIUser

@synthesize verbose;
@synthesize username;
@synthesize password;
@synthesize urlString;
@synthesize orgId;
@synthesize deviceUniqueID;
@synthesize delegate;
@synthesize jobSettings;


- (id) initWithURL:(NSString *)inURL orgName:(NSString *)inOrgName username:(NSString *)inUsername password:(NSString *)inPassword {
	
    if ((self = [super init])) {

		if(!inUsername || !inPassword || !inURL || !inOrgName)
			return nil;
		
		self.verbose = NO;
		self.username = inUsername;
		self.password = inPassword;
		self.urlString = inURL;
		self.orgId = inOrgName;
        self.deviceUniqueID = self.getUniqueDeviceID;
		
    }
	
    return self;
}

- (NSString *) version {
	
	return @"1.0";
}


#pragma mark -
#pragma mark Job Settings Fetch Methods

- (void) loadJobSettings:(NSString *)inDocIdentifier {

	if(jobSettings == nil) {
		
		NSString *soapMsg = [NSString stringWithFormat:
							 @"<userName>%@</userName>"
							 "<password>%@</password>"
							 "<phoneKey>%@</phoneKey>"
							 "<orgName>%@</orgName>"
							 "<documentIdentifier>%@</documentIdentifier>",
							 self.username,
							 self.password,
							 self.deviceUniqueID,
							 // MJG [[UIDevice currentDevice] uniqueIdentifier],
							 self.orgId,
							 inDocIdentifier?:@""
							 ];
		
		XMLWebService *ws = [[XMLWebService alloc] init];
		[ws setDelegate:self];
		[ws callTheWS:self.urlString
		   withAction:@"GetJobSettings"
			   toRoot:@"http://www.miteksystems.com/"
		  withMessage:soapMsg
		   rootReturn:@"GetJobSettingsResult"
		   forceArray:nil
		   removeSoap:NO
		   syncronous:YES];
	}
}

- (void) wsCallFailed:(NSError *)err {

	if(verbose)
		NSLog(@"MMI - Failure signaled loading Job Settings - %@", [err description]);
	
}


- (void) wsCallFullDictionaryReturned:(NSDictionary *)xmlDict {

	[self setJobSettings:xmlDict];
	
	if(verbose)
		NSLog(@"MMI - Success getting Job Settings: %@",[xmlDict description]);
}


#pragma mark -
#pragma mark Internal Methods

- (NSString *)getUniqueDeviceID {
    
    // do we already have one stored?
    NSString *uuidStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"UUID"];
    if(uuidStr) {
        // yes, return it
        return uuidStr;
        
    } else {
        // no, create it, store it, and return it
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidCFStr = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        uuidStr = [NSString stringWithString:(__bridge NSString *) uuidCFStr];
        [[NSUserDefaults standardUserDefaults] setObject:uuidStr forKey:@"UUID"];
        CFRelease(uuidCFStr);
        CFRelease(uuidRef);
        return uuidStr;        
    }
}

- (UIImage *)scaleImage:(UIImage *)image toMaximum:(CGFloat)mx forceOrientation:(BOOL)force {
	
	// Scale the new image size, expanded math for simplicity
	CGFloat small = image.size.height < image.size.width ? image.size.height : image.size.width;
	CGFloat big = image.size.height > image.size.width ? image.size.height : image.size.width;
	CGFloat mn = small * (mx / big);
	
	// Define some sizes for landscape/portait.  Again expanded for clarity
	CGSize landscapesize = { mx, mn };
	CGSize portraitsize = {mn, mx };
	CGSize size;
	
	// Deal with orientation
	if(force) {
		size = landscapesize;
	} else {
		// Use the camera orientation to pick the correct aspect
		if (image.imageOrientation == UIImageOrientationUp || image.imageOrientation == UIImageOrientationDown)
			size = landscapesize;
		else
			size = portraitsize;
	}
	
	// Setup the cg context
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Math reminder: angle in radians = angle in degrees * Pi / 180
	
	if (force || image.imageOrientation == UIImageOrientationUp) {	// left landscape
		CGContextScaleCTM(context, 1.0, -1.0);
		CGContextTranslateCTM(context, 0.0, -size.height);
		
	} else if (image.imageOrientation == UIImageOrientationRight) {		//portrait
		CGContextRotateCTM (context, ( 90.0f * M_PI / 180.0f));
		CGContextScaleCTM(context, 1.0, -1.0);
		
	} else if (image.imageOrientation == UIImageOrientationLeft) {	// upside down
		CGContextRotateCTM (context, ( -90.0f * M_PI / 180.0f));
		CGContextScaleCTM(context, 1.0, -1.0);
		CGContextTranslateCTM(context, -size.height , -size.width);
		
	} else if (image.imageOrientation == UIImageOrientationDown) {  // right landscape
		CGContextScaleCTM(context, -1.0, 1.0);
		CGContextTranslateCTM(context, -size.width, 0.0);
	}
	
	// draw the image to the context. do note that the width and height are always in landscape regardless of the choice above
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, landscapesize.width, landscapesize.height), image.CGImage);
	
	// make the UIImage
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// and end the context
	UIGraphicsEndImageContext();
	
	// return the thumbnail image
	return scaledImage;
}


#pragma mark -
#pragma mark External Methods

- (BOOL) authenticateUser {
    
	NSString *soapMsg = [NSString stringWithFormat:
						 @"<userName>%@</userName>"
						 "<password>%@</password>"
						 "<phoneKey>%@</phoneKey>"
						 "<orgName>%@</orgName>",
						 self.username,
						 self.password,
                         self.deviceUniqueID,
                         // MJG [[UIDevice currentDevice] uniqueIdentifier],
						 self.orgId
						 ];
	
	authenticateUserSupport = [[MISupport alloc] init];	
	return [authenticateUserSupport doTheCall:@"AuthenticateUser" 
									message:soapMsg 
									   from:self 
								  returnSel:@selector(authenticateUserReturn:) 
								   errorSel:@selector(authenticateUserError:) 
								 rootReturn:@"AuthenticateUserResult"
								 forceArray:nil
									verbose:self.verbose];
    
    
}



- (BOOL) getJobSettings:(NSString *) inDocIdentifier
{
	NSString *soapMsg = [NSString stringWithFormat:
						 @"<userName>%@</userName>"
						 "<password>%@</password>"
						 "<phoneKey>%@</phoneKey>"
						 "<orgName>%@</orgName>"
						 "<documentIdentifier>%@</documentIdentifier>",
						 self.username,
						 self.password,
                         self.deviceUniqueID,
                         // MJG [[UIDevice currentDevice] uniqueIdentifier],
						 self.orgId,
						 inDocIdentifier?:@""
						 ];
	
	getJobSettingsSupport = [[MISupport alloc] init];	
	return [getJobSettingsSupport doTheCall:@"GetJobSettings" 
									message:soapMsg 
									   from:self 
								  returnSel:@selector(getJobSettingsReturn:) 
								   errorSel:@selector(getJobSettingsError:) 
								 rootReturn:@"GetJobSettingsResult"
								 forceArray:nil
									verbose:self.verbose];
}


- (BOOL) getPhoneTransactionList
{
	NSString *soapMsg = [NSString stringWithFormat:
						 @"<userName>%@</userName>"
						 "<password>%@</password>"
						 "<phoneKey>%@</phoneKey>"
						 "<orgName>%@</orgName>",
						 self.username,
						 self.password,
                         self.deviceUniqueID,
                         // MJG [[UIDevice currentDevice] uniqueIdentifier],
						 self.orgId
						 ];
	
	getPhoneTransactionListSupport = [[MISupport alloc] init];	
	BOOL ret = [getPhoneTransactionListSupport doTheCall:@"GetPhoneTransactionList" 
												 message:soapMsg 
													from:self 
											   returnSel:@selector(getPhoneTransactionListReturn:) 
												errorSel:@selector(getPhoneTransactionListError:) 
											  rootReturn:@"GetPhoneTransactionListResult" 
											  forceArray:[NSArray arrayWithObject:@"TransactionIDs"]
												 verbose:self.verbose];
	if(verbose)
		NSLog(@"MMI - getPhoneTransactionList initiated%@successfully.",ret?@" ":@" un");
	return ret;
}

- (BOOL) insertPhoneTransaction:(UIImage *)		inImage
			 DocumentIdentifier:(NSString *)	inDocIdentifier
                  DocumentHints:(NSString *)    inDocHints
				DataReturnLevel:(NSInteger)		inDataReturnLevel
				ReturnImageType:(NSInteger)		inReturnType
					RotateImage:(NSInteger)		inRotateImage
                           Note:(NSString *)    inNote
{
	
	[self loadJobSettings:inDocIdentifier];
	if(jobSettings == nil)
		return NO;
    
	// Parse job settings
	NSInteger compressionLevel = [[jobSettings objectForKey:@"RequiredCompressionLevel"] integerValue];
	CGFloat compQuality = (CGFloat)compressionLevel / 100.0f;
	CGFloat maxSize = [[jobSettings objectForKey:@"RequiredMaxImageHeightAndWidth"] floatValue];
    
	// Prepare image
	UIImage *scaled = [self scaleImage:inImage toMaximum:maxSize forceOrientation:NO];
	NSData *imageData = UIImageJPEGRepresentation(scaled, compQuality);
	NSString *base64Image = [MIBase64 base64Encoding:imageData];
	
	
	// Send it to the server
	return [self insertPhoneTransactionWithBase64EncodedImage:base64Image
                                           DocumentIdentifier:inDocIdentifier
                                                DocumentHints:inDocHints
                                              DataReturnLevel:inDataReturnLevel
                                              ReturnImageType:inReturnType
                                                  RotateImage:inRotateImage
                                                         Note:inNote];
}

// MJG added 10Jul2012 to handle new interface. The old one calls this one (see above)
- (BOOL) insertPhoneTransactionWithBase64EncodedImage:(NSString *)	inStringImage
                                   DocumentIdentifier:(NSString *)	inDocIdentifier
                                        DocumentHints:(NSString *)  inDocHints
                                      DataReturnLevel:(NSInteger)	inDataReturnLevel
                                      ReturnImageType:(NSInteger)	inReturnType
                                          RotateImage:(NSInteger)	inRotateImage
                                                 Note:(NSString *)  inNote
{

	// Send it to the server
	NSString *soapMsg = [NSString stringWithFormat:
						 @"<userName>%@</userName>"
						 "<password>%@</password>"
						 "<phoneKey>%@</phoneKey>"
                         "<orgName>%@</orgName>"
						 "<base64Image>%@</base64Image>"
						 "<compressionLevel>%d</compressionLevel>"
						 "<documentIdentifier>%@</documentIdentifier>"
                         "<documentHints>%@</documentHints>"
                         "<dataReturnLevel>%d</dataReturnLevel>"
                         "<returnImageType>%d</returnImageType>"
                         "<rotateImage>%d</rotateImage>"
                         "<note>%@</note>",
						 self.username,
						 self.password,
                         self.deviceUniqueID,
                         // MJG [[UIDevice currentDevice] uniqueIdentifier],
						 self.orgId,
						 inStringImage?:@"",
						 30,                    // MJG Robert says this is not used at the MIP so we can hard code it
						 inDocIdentifier?:@"",
                         inDocHints?:@"",
                         inDataReturnLevel,
						 inReturnType,
                         inRotateImage,
                         inNote?:@""
						 ];
	
	insertPhoneTransactionSupport = [[MISupport alloc] init];	
	BOOL ret = [insertPhoneTransactionSupport doTheCall:@"InsertPhoneTransaction" 
												message:soapMsg 
												   from:self 
											  returnSel:@selector(insertPhoneTransactionReturn:) 
											   errorSel:@selector(insertPhoneTransactionError:) 
											 rootReturn:@"InsertPhoneTransactionResult"
											 forceArray:[NSArray arrayWithObject:@"ExtractedFields"]
												verbose:self.verbose];
	if(verbose)
		NSLog(@"MMI - insertPhoneTransaction initiated%@successfully.",ret?@" ":@" un");
	return ret;
}


- (BOOL) getPhoneTransaction:(NSInteger)	inTransactionId
			 DataReturnLevel:(NSInteger)	inDataReturnLevel
			 ReturnImageType:(NSInteger)	inReturnType
				 RotateImage:(NSInteger)	inRotateImage
{
	
	
	NSString *soapMsg = [NSString stringWithFormat:
						 @"<userName>%@</userName>"
						 "<password>%@</password>"
						 "<phoneKey>%@</phoneKey>"
						 "<orgName>%@</orgName>"
						 "<transactionId>%d</transactionId>"
						 "<dataReturnLevel>%d</dataReturnLevel>"
						 "<returnImageType>%d</returnImageType>"
						 "<rotateImage>%d</rotateImage>",
						 self.username,
						 self.password,
                         self.deviceUniqueID,
                         // MJG [[UIDevice currentDevice] uniqueIdentifier],
						 self.orgId,
						 inTransactionId,
						 inDataReturnLevel,
						 inReturnType,
						 inRotateImage
						 ];
	
	getPhoneTransactionSupport = [[MISupport alloc] init];	
	BOOL ret = [getPhoneTransactionSupport doTheCall:@"GetPhoneTransaction" 
											 message:soapMsg 
												from:self 
										   returnSel:@selector(getPhoneTransactionReturn:) 
											errorSel:@selector(getPhoneTransactionError:) 
										  rootReturn:@"GetPhoneTransactionResult"
										  forceArray:[NSArray arrayWithObject:@"ExtractedFields"]
											 verbose:self.verbose];
	if(verbose)
		NSLog(@"MMI - getPhoneTransaction initiated%@successfully.",ret?@" ":@" un");
	return ret;
}


- (BOOL) updatePhoneTransaction:(NSInteger)		inTransactionId
		 UpdatedExtractedRawOcr:(NSString *)	inExtractedRawOcr
				UpdatedCodeLine:(NSString *)	inCodeLine
						   List:(NSArray *)		inList
{
	NSMutableString *inListXML = [[NSMutableString alloc] initWithCapacity:10];
	
	for(MIExtractedField *item in inList) {
	
		[inListXML appendString:@"<ExtractedField>"];
			[inListXML appendFormat:@"<Name>%@</Name>",item.name?:@""];
			[inListXML appendFormat:@"<Value>%@</Value>",item.value?:@""];
			[inListXML appendFormat:@"<Confidence>%d</Confidence>",item.confidence];
			[inListXML appendFormat:@"<ValueStandardized>%@</ValueStandardized>",item.valueStandardized?:@""];
			[inListXML appendFormat:@"<UpperLeftX>%d</UpperLeftX>",item.upperLeftX];
			[inListXML appendFormat:@"<UpperLeftY>%d</UpperLeftY>",item.upperLeftY];
			[inListXML appendFormat:@"<LowerRightX>%d</LowerRightX>",item.lowerRightX];
			[inListXML appendFormat:@"<LowerRightY>%d</LowerRightY>",item.lowerRightY];
		[inListXML appendString:@"</ExtractedField>"];
	}
	
	
	NSString *soapMsg = [NSString stringWithFormat:
						 @"<userName>%@</userName>"
						 "<password>%@</password>"
						 "<phoneKey>%@</phoneKey>"
						 "<orgName>%@</orgName>"
						 "<transactionId>%d</transactionId>"
						 "<updatedExtractedRawOcr>%@</updatedExtractedRawOcr>"
						 "<updatedCodeline>%@</updatedCodeline>"
						 "<updatedExtractedFields>%@</updatedExtractedFields>",
						 self.username,
						 self.password,
                         self.deviceUniqueID,
                         // MJG [[UIDevice currentDevice] uniqueIdentifier],
						 self.orgId,
						 inTransactionId,
						 inExtractedRawOcr?:@"",
						 inCodeLine?:@"",
						 inListXML?:@""
						 ];
	
	updatePhoneTransactionSupport = [[MISupport alloc] init];	
	BOOL ret = [updatePhoneTransactionSupport doTheCall:@"UpdatePhoneTransaction" 
												message:soapMsg 
												   from:self 
											  returnSel:@selector(updatePhoneTransactionReturn:) 
											   errorSel:@selector(updatePhoneTransactionError:) 
											 rootReturn:@"UpdatePhoneTransactionResult"
											 forceArray:[NSArray arrayWithObject:@"ExtractedFields"]
												verbose:self.verbose];
	if(verbose)
		NSLog(@"MMI - updatePhoneTransaction initiated%@successfully.",ret?@" ":@" un");
	return ret;
}

@end


@implementation MIExtractedField

@synthesize name;
@synthesize value;
@synthesize confidence;
@synthesize valueStandardized;
@synthesize upperLeftX;
@synthesize upperLeftY;
@synthesize lowerRightX;
@synthesize lowerRightY;


- (id) init {
	
    if ((self = [super init])) {
		
    }
	
    return self;
}



@end

