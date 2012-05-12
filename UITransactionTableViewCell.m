//
//  UITransactionTableViewCell.m
//  PdThx
//
//  Created by James Rhodes on 4/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UITransactionTableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UITransactionTableViewCell
@synthesize lblRecipientUri, lblTransactionDate, imgTransactionType, lblAmount, imgTransactionStatus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        lblRecipientUri = [[UILabel alloc]init];
        lblRecipientUri.textAlignment = UITextAlignmentLeft;
        lblRecipientUri.font = [UIFont fontWithName:@"Helvetica-Bold" size: 14];
        [lblRecipientUri setTextColor: UIColorFromRGB(0x3c3c3c)];
        [lblRecipientUri setBackgroundColor: [UIColor clearColor]];
        lblTransactionDate = [[UILabel alloc]init];
        lblTransactionDate.textAlignment = UITextAlignmentLeft;
        lblTransactionDate.font = [UIFont fontWithName:@"Helvetica-Bold" size: 12];
        [lblTransactionDate setTextColor: UIColorFromRGB(0x757678)];
        [lblTransactionDate setBackgroundColor: [UIColor clearColor]];
        
        imgTransactionType = [[UIImageView alloc]init];
        [imgTransactionType sizeToFit];
        [imgTransactionType setBackgroundColor: [UIColor clearColor]];
        
        lblAmount = [[UILabel alloc] init];
        lblAmount.textAlignment = UITextAlignmentRight;
        lblAmount.font = [UIFont fontWithName:@"Helvetica" size: 17];
        [lblAmount setTextColor: UIColorFromRGB(0x1c8839)];
        [lblAmount sizeToFit];
        [lblAmount setBackgroundColor: [UIColor clearColor]];
        [lblAmount setAdjustsFontSizeToFitWidth:YES];
        
        imgTransactionStatus= [[UIImageView alloc] init];
        [imgTransactionStatus setBackgroundColor: [UIColor clearColor]];
        
        [self.contentView addSubview:lblRecipientUri];
        [self.contentView addSubview:lblTransactionDate];
        [self.contentView addSubview:imgTransactionType];
        [self.contentView addSubview:imgTransactionStatus];
        [self.contentView addSubview:lblAmount];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGFloat widthX = contentRect.size.width;
    //CGFloat boundsY = contentRect.origin.y;
    CGFloat heightY = contentRect.size.height;
    
    CGRect frame;
    frame= CGRectMake(boundsX+15, heightY/2 - 13, 18, 27);
    imgTransactionType.frame = frame;
    
    frame= CGRectMake(boundsX+50 ,5, 200, 25);
    lblRecipientUri.frame = frame;
    
    frame= CGRectMake(boundsX+50 ,35, 100, 15);
    lblTransactionDate.frame = frame;
    
    frame = CGRectMake(widthX-100, heightY/2 -8, 20, 17);
    imgTransactionStatus.frame = frame;
    
    frame= CGRectMake(widthX-60, 0, 50, heightY);
    lblAmount.frame = frame;
}

- (void)dealloc
{
    [lblRecipientUri release];
    [lblTransactionDate release];
    [imgTransactionType release];
    [lblAmount release];
    [imgTransactionStatus release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
