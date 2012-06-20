
#import "ViewController.h"

/**
 @author Fabio Rodella fabio@crocodella.com.br
 */

#define K_SLIDEVIEW_HEIGHT 300
#define K_SLIDEVIEW_WIDTH 240

#define K_SLIDEVIEW_CLOSED_CENTER_X 420
#define K_SLIDEVIEW_CLOSED_CENTER_Y 260
#define K_SLIDEVIEW_OPEN_CENTER_X 200
#define K_SLIDEVIEW_OPEN_CENTER_Y 260


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat xOffset = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        xOffset = 224;
    }
    
    pullRightView = [[PullableView alloc] initWithFrame:CGRectMake(0, 0, K_SLIDEVIEW_WIDTH, K_SLIDEVIEW_HEIGHT)];
    pullRightView.backgroundColor = [UIColor lightGrayColor];
    pullRightView.openedCenter = CGPointMake(K_SLIDEVIEW_CLOSED_CENTER_X, K_SLIDEVIEW_CLOSED_CENTER_Y);
    pullRightView.closedCenter = CGPointMake(K_SLIDEVIEW_OPEN_CENTER_X, K_SLIDEVIEW_OPEN_CENTER_Y);
    pullRightView.center = pullRightView.closedCenter;
    pullRightView.animate = YES;
    
    pullRightView.handleView.backgroundColor = [UIColor darkGrayColor];
    pullRightView.handleView.frame = CGRectMake(0, 0, 40, 40);
    
    [self.view addSubview:pullRightView];
    [pullRightView release];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened
{
    NSLog(@"Opened?: %@", opened);
}

@end
