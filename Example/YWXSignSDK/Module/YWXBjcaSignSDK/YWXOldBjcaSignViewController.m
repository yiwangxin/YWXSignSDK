//
//  YWXOldBjcaSignViewController.m
//  YWXSignSDKDemo
//
//  Created by szyx on 2021/3/26.
//  Copyright © 2021 Beijing Digital Yixin Technology Co., Ltd. All rights reserved.
//

#import "YWXOldBjcaSignViewController.h"
#import "YWXSignDataViewController.h"
#import "YWXQRCodeScanViewController.h"
#import "YWXCreatQRCodeController.h"
#import "YWXUserInfoViewController.h"
#import "YWXEnvironmentViewController.h"
#import "YWXDemoNetManager.h"
#import "YWXEnvironmentViewController.h"

#import <YWXBjcaSignSDK/YWXBjcaSignManager.h>
#import <YWXSignFoundation/YWXNetworkManager.h>
#import <YWXSignFoundation/YWXSignFoundation.h>

static NSString *KXBYEnvironmentKeyName = @"serverType";

@interface YWXOldBjcaSignViewController ()

@property (nonatomic, strong) YWXBjcaSignManager *signManager;

@end

@implementation YWXOldBjcaSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signManager = YWXBjcaSignManager.sharedManager;
    __weak typeof(self) weakSelf = self;
    [YWXEnvironmentViewController getCurrentEnviromentWithEnvironmentKeyName:KXBYEnvironmentKeyName
                                                      environmentChangeBlack:^(YWXDemoEnvironment currentEnvironment) {
        [weakSelf changeEnvironmentWith:currentEnvironment];
    }];

}

- (void)changeEnvironmentWith:(YWXDemoEnvironment)currentEnvironment {
    YWXEnvironment environment;
    switch (currentEnvironment) {
        case YWXDemoEnvironmentProduction:
            environment = YWXEnvironmentProduction;
            break;
        case YWXDemoEnvironmentAcceptance:
            environment = YWXEnvironmentAcceptance;
            break;
        case YWXDemoEnvironmentTesting:
            environment = YWXEnvironmentTesting;
            break;
        case YWXDemoEnvironmentDevelopment:
            environment = YWXEnvironmentDevelopment;
            break;
    }
    [self.signManager startWithClientId:self.clientInfoView.clientId environment:environment];
    YWXDemoNetManager.sharedManager.environment = currentEnvironment;
    [self updateInfo];
}

- (void)updateInfo {
    NSString *version = self.signManager.versionString;
    YWXEnvironment environment = self.signManager.currentEnvironment;
    BOOL isExistCert = self.signManager.existsCert;
    NSString *sdkLanguage = self.signManager.currentLanguage;
    [self updateFooterInfoWithVersion:version
                          serviceType:environment
                          isExistCert:isExistCert
                          sdkLanguage:sdkLanguage];
}

- (void)didSelectSignBusiness:(YWXSignBusinessModel *)signBusinessModel {
    switch (signBusinessModel.businessType) {
        case TestBusinessTypeCertDown:
            [self startCertDownLoad];
            break;
        case TestBusinessTypeUpdate:
            [self startUpdataCert];
            break;
        case TestBusinessTypeReset:
            [self startResetCert];
            break;
        case TestBusinessTypeCleanCert:
            [self cleanCert];
            break;
        case TestBusinessTypeUserInfo:
            [self showUserInfo];
            break;
        case TestBusinessTypeCertDetail:
            [self showCertDetail];
            break;
        case TestBusinessTypeStamp:
            [self setCertStampImage];
            break;
        case TestBusinessTypeSignList:
            [self showSignDataController];
            break;
        case TestBusinessTypeChangeService:
            [self showChangeServiceController];
            break;
        case TestBusinessTypeQrCode:
            [self showQRCodeScanViewController];
            break;
        case TestBusinessTypeQrCodeShow:
            [self showQRCodeCreatController];
            break;
        case TestBusinessTypeSignForSignAuto:
            [self openAutoSign:signBusinessModel.inputText];
            break;
        case TestBusinessTypeSignAutoInfo:
            [self getAutoSignInfo];
            break;
        case TestBusinessTypeStopSignAuto:
            [self quitAutoSign:signBusinessModel.inputText];
            break;
        case TestBusinessTypeFreePin:
            [self openFreePin:signBusinessModel.inputText];
            break;
        case TestBusinessTypeCleanFreePin:
            [self closeFreePin];
            break;
        case TestBusinessTypeFingerPin:
            [self openBiometricsStatus];
            break;
        case TestBusinessTypeFingerPinClose:
            [self closeBiometricsStatus];
            break;
        case TestBusinessTypeLanguageChinese:
            [self changeLanguageToChinese];
            break;
        case TestBusinessTypeLanguageEnglish:
            [self changeLanguageToEnglish];
            break;
        case TestBusinessTypeLanguageSystem:
            [self changeLanguageToSystem];
            break;
        case TestBusinessTypeCertExist:
            [self checkIsExistCert];
            break;
        case TestBusinessTypeVersion:
            [self getSDKVersion];
            break;
        default:
            break;
    }
    
}

#pragma mark - 业务处理

#pragma mark - 证书相关

/// 证书下证
-(void)startCertDownLoad {
    __weak typeof(self) weakSelf = self;
    [self.signManager certDownWithPhone:self.clientInfoView.phoneNumber completion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"证书下载" code:code message:message info:info];
        [weakSelf updateInfo];
    }];
}

- (void)startUpdataCert {
    __weak typeof(self) weakSelf = self;
    [self.signManager certUpdateWithCompletion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"证书更新" code:code message:message info:info];
        [weakSelf updateInfo];
    }];
}

- (void)startResetCert {
    __weak typeof(self) weakSelf = self;
    [self.signManager certResetPinWithCompletion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"证书重置" code:code message:message info:info];
        [weakSelf updateInfo];
    }];
}

-(void)cleanCert {
    [self.signManager clearCert];
    [self showAlertWith:@"清除证书" code:@"0" message:@"success" info:@{}];
    [self updateInfo];
}

#pragma mark - 签章设置

-(void)setCertStampImage {
    [self.signManager drawStampWithFirmIds:nil completion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [self showAlertWith:@"设置签章" code:code message:message info:info];
    }];
}

#pragma mark - 签名
/// 跳转到签名页面
-(void)showSignDataController {
    YWXSignDataViewController *signDataController = [[YWXSignDataViewController alloc] init];
    signDataController.clientId = self.clientInfoView.clientId;
    signDataController.openId = self.signManager.openId;
    __weak typeof(self) weakSelf = self;
    signDataController.signButtonClickCallBack = ^(NSArray * _Nonnull uniqueIDs) {
        [self.signManager signWithUniqueIdList:uniqueIDs
                                            completion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
            [weakSelf showAlertWith:@"签名" code:code message:message info:info];
        }];
    };
    [self.navigationController pushViewController:signDataController animated:YES];
}

#pragma mark - 二维码
/// 进行二维码扫描
-(void)showQRCodeScanViewController {
    __weak typeof(self) weakSelf = self;
    [YWXQRCodeScanViewController showQRCodeScanWith:self scanCompletion:^(NSString * _Nonnull result) {
        NSLog(@"qrcode string:%@",result);
        /// sdk 二维码页面
        [self.signManager qrDisposeWithString:result completion:^(NSString *code, NSString *message, NSDictionary *info) {
            [weakSelf showAlertWith:@"二维码扫描" code:code message:message info:info];
        }];
    }];
    
}

/// 跳转到二维码创建页面
-(void)showQRCodeCreatController {
    YWXCreatQRCodeController *controller = [[YWXCreatQRCodeController alloc] init];
    controller.clientId = self.clientInfoView.clientId;
    controller.openIdTextField.text = self.signManager.openId;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 自动签

/// 开启自动签
-(void)openAutoSign:(NSString *)sysTag {
    __weak typeof(self) weakSelf = self;
    [self.signManager signForStartSignAutoWithSysTag:sysTag
                                              completion:^(NSString *code, NSString *message, NSDictionary *info) {
        [weakSelf showAlertWith:@"开启自动签" code:code message:message info:info];
    }];
}


/// 获取自动签信息
-(void)getAutoSignInfo {
    __weak typeof(self) weakSelf = self;
    [self.signManager signAutoInfoWithCompletion:^(NSString *code, NSString *message, NSDictionary *info) {
        [weakSelf showAlertWith:@"获取自动签名信息" code:code message:message info:info];
    }];
}

/// 退出自动签
-(void)quitAutoSign:(NSString *)sysTag {
    __weak typeof(self) weakSelf = self;
    [self.signManager stopSignAutoWithSysTag:sysTag completion:^(NSString *code, NSString *message, id info) {
        [weakSelf showAlertWith:@"关闭自动签名" code:code message:message info:info];
    }];
}


#pragma mark - 签名配置

/// 开启免密
-(void)openFreePin:(NSString *)days {
    __weak typeof(self) weakSelf = self;
    NSInteger day = [days integerValue];
    [self.signManager keepPinWithDays:day completion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, NSDictionary * _Nullable info) {
        [weakSelf showAlertWith:@"开启免密" code:code message:message info:info];
    }];
    
}

/// 关闭免密
-(void)closeFreePin {
    [self.signManager clearPin];
    [self showAlertWith:@"关闭免密" code:@"0" message:@"success" info:@{}];
}


/// 开启生物识别
-(void)openBiometricsStatus {
    [self.signManager startBiometricAuthenticationForSignWithCompletion:^(NSString *code, NSString *message, id info) {
        [self showAlertWith:@"开启生物识别" code:code message:message info:info];
    }];
}

/// 关闭生物识别
-(void)closeBiometricsStatus {
    [self.signManager stopBiometricAuthenticationForSignWithCompletion:^(NSString *code, NSString *message, id info) {
        [self showAlertWith:@"关闭生物识别" code:code message:message info:info];
    }];
}

#pragma mark - 用户信息
/// 获取用户信息
-(void)showUserInfo {
    __weak typeof(self) weakSelf = self;
    [self.signManager requestUserInfoWithCompletion:^(NSString *code, NSString *message, id info) {
        if ([code isEqualToString:@"0"]) {
            YWXUserInfoViewController *userInfoController = [[YWXUserInfoViewController alloc] init];
            userInfoController.openId = self.signManager.openId;
            userInfoController.freePin = self.signManager.isPinExempt;
            userInfoController.userInfoDictionary = info;
            userInfoController.stampImageBase64 = self.signManager.signatureBase64EncodedString;
            [weakSelf.navigationController pushViewController:userInfoController animated:YES];
        } else {
            [weakSelf showAlertWith:@"获取用户信息" code:code message:message info:info];
        }
        
    }];
}

-(void)showCertDetail {
    __weak typeof(self) weakSelf = self;
    [self.signManager showCertDetailWithCompletion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"显示证书详情" code:code message:message info:info];
    }];
}

#pragma mark - 基础信息

- (void)changeLanguageToChinese {
    [YWXSignManager.sharedManager changePreferredLanguage:@"zh"];
    [self updateInfo];
    [self showAlertWith:@"切换SDK显示语言为中文" code:@"0" message:@"success" info:@{}];
}

- (void)changeLanguageToEnglish {
    [YWXSignManager.sharedManager changePreferredLanguage:@"en"];
    [self updateInfo];
    [self showAlertWith:@"切换SDK显示语言为英文" code:@"0" message:@"success" info:@{}];
}

- (void)changeLanguageToSystem {
    [YWXSignManager.sharedManager changePreferredLanguage:@""];
    [self updateInfo];
    [self showAlertWith:@"切换SDK显示语言为系统语言" code:@"0" message:@"success" info:@{}];
}

-(void)getSDKVersion {
    NSString *versionString = [self.signManager versionString];
    [self showAlertWith:@"当前SDK版本" code:@"0" message:versionString info:@{}];
}

- (void)checkIsExistCert {
    BOOL isCertificateExist = [self.signManager existsCert];
    NSString *message = [NSString stringWithFormat:@"证书：%@",isCertificateExist == YES ? @"存在" : @"不存在"];
    [self showAlertWith:@"是否存在证书" code:@"0" message:message info:@{}];
}



-(void)showChangeServiceController {
    YWXEnvironmentViewController *envControler = [[YWXEnvironmentViewController alloc] init];
    envControler.environmentKeyName = KXBYEnvironmentKeyName;
    __weak typeof(self) weakSelf = self;
    envControler.environmentChangeBlack = ^(YWXDemoEnvironment currentEnvironment) {
        [weakSelf changeEnvironmentWith:currentEnvironment];
    };
    [self.navigationController pushViewController:envControler animated:YES];
}

@end
