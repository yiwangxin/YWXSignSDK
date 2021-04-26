//
//  MainTabBarController.m
//  YWXSignSDKDemo
//
//  Created by szyx on 2021/3/25.
//

#import "MainTabBarController.h"
#import "YWXBaseNavigationController.h"
#import "YWXNewSignViewController.h"
#import "YWXOldBjcaSignViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubController];
}

- (void)addSubController {
//#if TARGETSTYPE == 1
    YWXNewSignViewController *newSignController = [[YWXNewSignViewController alloc] init];
    [self setChildViewController:newSignController title:@"新签名" imageName:@"arrow_up" seleceImageName:@"arrow_down"];
//#elif TARGETSTYPE == 2
//    YWXOldBjcaSignViewController *oldBjcaSignController = [[YWXOldBjcaSignViewController alloc] init];
//    [self setChildViewController:oldBjcaSignController title:@"旧签名" imageName:@"arrow_up" seleceImageName:@"arrow_down"];
//#endif
}

-(void)setChildViewController:(UIViewController*)controller
                        title:(NSString *)title
                    imageName:(NSString *)imageName
              seleceImageName:(NSString *)selectImageName {
    controller.title = title;
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = [UIImage imageNamed:imageName];
    controller.tabBarItem.selectedImage = [UIImage imageNamed:selectImageName];
    YWXBaseNavigationController *navController = [[YWXBaseNavigationController alloc] initWithRootViewController:controller];
    [self addChildViewController:navController];
}

@end
