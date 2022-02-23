//
//  SHANBaseViewController.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import "SHANBaseViewController.h"
#import "UIViewController+RootController.h"
#import "UINavigationBar+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "SHANCommentManager.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@implementation SHANBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createBaseLayout];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar shan_navBarBackGroundColor:[UIColor whiteColor] image:nil isOpaque:NO];//颜色
    [self.navigationController.navigationBar shan_navBarBottomLineHidden:YES];//隐藏底线
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

+ (UIViewController *)currentViewController {
    return [self shan_PresentingController];
}

- (void)back {
    if ([SHANCommentManager sharedCommentMark].showType == SHANShowViewControllerTypePresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createBaseLayout {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

@end

@implementation SHANBaseNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

@end
