//
//  YWXOldSignDataViewController.m
//  YWXSignSDKDemo
//
//  Created by szyx on 2021/3/31.
//  Copyright © 2021 Beijing Digital Yixin Technology Co., Ltd. All rights reserved.
//

#import "YWXOldSignDataViewController.h"
#import <BjcaSignSDK/BjcaSignSDK.h>

@interface YWXOldSignDataViewController ()

@end

@implementation YWXOldSignDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)didClickSignButton:(NSArray *)uniqueIDs {
    __weak typeof(self) weakSelf = self;
    [[YWXBjcaManager sharedManager] signWithUniqueIDs:uniqueIDs completion:^(NSString *code, NSString *message, NSDictionary *info) {
        NSLog(@"%@%@",code,message);
        [weakSelf showAlertWith:@"签名业务" code:code message:message info:info];
    }];
}

@end
