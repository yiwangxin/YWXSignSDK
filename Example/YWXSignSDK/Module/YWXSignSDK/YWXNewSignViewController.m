//
//  YWXNewSignViewController.m
//  YWXSignSDKDemo
//
//  Created by szyx on 2021/3/25.
//

#import "YWXNewSignViewController.h"
#import "YWXSignDataViewController.h"
#import <YWXSignSDK/YWXSignSDK.h>
#import "YWXDemoNetManager.h"
#import "YWXEnvironmentViewController.h"
#import "YWXQRCodeScanViewController.h"
#import "YWXUserInfoViewController.h"
#import "YWXCreatQRCodeController.h"

static NSString *KEnvironmentKeyName = @"serverType";

@interface YWXNewSignViewController ()


@end

@implementation YWXNewSignViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [YWXSignManager.sharedManager setupUIForNavigationBarTintColor:UIColor.redColor
                                      navigationBarBackgroundColor:UIColor.yellowColor];
}

- (void)changeEnvironmentWith:(YWXDemoEnvironment)currentEnvironment {
    YWXEnvironment environment;
    switch (currentEnvironment) {
        case YWXDemoEnvironmentProduction:
            environment =     YWXEnvironmentPublic;
            break;
        case YWXDemoEnvironmentAcceptance:
            environment =     YWXEnvironmentTest;
            break;
        case YWXDemoEnvironmentTesting:
            environment = YWXEnvironmentBeta;
            break;
        case YWXDemoEnvironmentDevelopment:
            environment = YWXEnvironmentDev;
            break;
    }
    [YWXSignManager.sharedManager startWithClientId:self.clientInfoView.clientId environment:environment];
    YWXDemoNetManager.sharedManager.environment = currentEnvironment;
    [self updateInfo];
}

- (void)updateInfo {
    NSString *version = YWXSignManager.sharedManager.versionString;
    YWXEnvironment environment = YWXSignManager.sharedManager.currentEnvironment;
    BOOL isExistCert = YWXSignManager.sharedManager.existsCert;
    NSString *sdkLanguage = YWXSignManager.sharedManager.currentLanguage;
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
        case TestBusinessTypeQrCode:
            [self showQRCodeScanViewController];
            break;
        case TestBusinessTypeQrCodeShow:
            [self showQRCodeCreatController];
            break;
        case TestBusinessTypeChangeService:
            [self showChangeServiceController];
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
        case TestBusinessTypeOpenGrantSign:
            [self grandSign];
            break;
        case TestBusinessTypeCloseGrantSign:
            [self closeGrandSign];
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

#pragma mark - 证书下证

- (void)startCertDownLoad {
    __weak typeof(self) weakSelf = self;
    [YWXSignManager.sharedManager certDownWithPhone:self.clientInfoView.phoneNumber completion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"证书下载" code:code message:message info:info];
        [weakSelf updateInfo];
    }];
}

- (void)startUpdataCert {
    __weak typeof(self) weakSelf = self;
    [YWXSignManager.sharedManager certUpdateWithCompletion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"证书更新" code:code message:message info:info];
        [weakSelf updateInfo];
    }];
}

- (void)startResetCert {
    __weak typeof(self) weakSelf = self;
    [YWXSignManager.sharedManager certResetPinWithCompletion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"证书重置" code:code message:message info:info];
        [weakSelf updateInfo];
    }];
}


-(void)cleanCert {
    [YWXSignManager.sharedManager clearCert];
    [self showAlertWith:@"清除证书" code:@"0" message:@"success" info:@{}];
    [self updateInfo];
}
#pragma mark - 签章设置

-(void)setCertStampImage {
    [YWXSignManager.sharedManager drawStampWithFirmIds:nil completion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [self showAlertWith:@"设置签章" code:code message:message info:info];
    }];
}

#pragma mark - 签名

-(void)showSignDataController {
    YWXSignDataViewController *signDataController = [[YWXSignDataViewController alloc] init];
    signDataController.clientId = self.clientInfoView.clientId;
    signDataController.openId = YWXSignManager.sharedManager.openId;
    __weak typeof(self) weakSelf = self;
    signDataController.signButtonClickCallBack = ^(NSArray * _Nonnull uniqueIDs) {
        [YWXSignManager.sharedManager signWithUniqueIdList:uniqueIDs
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
        [YWXSignManager.sharedManager qrDisposeWithString:result completion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
            [weakSelf showAlertWith:@"二维码扫描" code:code message:message info:info];
        }];
        
    }];
    
}

/// 跳转到二维码创建页面
-(void)showQRCodeCreatController {
    YWXCreatQRCodeController *controller = [[YWXCreatQRCodeController alloc] init];
    controller.clientId = self.clientInfoView.clientId;
    controller.openIdTextField.text = YWXSignManager.sharedManager.openId;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 自动签
/// 开启自动签
-(void)openAutoSign:(NSString *)sysTag {
    __weak typeof(self) weakSelf = self;
    [YWXSignManager.sharedManager signForStartSignAutoWithSysTag:sysTag completion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"开启自动签名" code:code message:message info:info];
    }];
    
}


/// 获取自动签信息
-(void)getAutoSignInfo {
    __weak typeof(self) weakSelf = self;
    [YWXSignManager.sharedManager signAutoInfoWithCompletion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"获取自动签名信息" code:code message:message info:info];
    }];
    
}

/// 退出自动签
-(void)quitAutoSign:(NSString *)sysTag {
    NSString *tSysTag = sysTag;
    if (sysTag.length <= 0) {
        tSysTag = nil;
    }
    __weak typeof(self) weakSelf = self;
    [YWXSignManager.sharedManager stopSignAutoWithSysTag:tSysTag completion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"关闭自动签名" code:code message:message info:info];
    }];
}

#pragma mark - 签名配置
/// 开启免密
-(void)openFreePin:(NSString *)days {
    __weak typeof(self) weakSelf = self;
    NSInteger day = [days integerValue];
    [YWXSignManager.sharedManager keepPinWithDays:day completion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"开启免密" code:code message:message info:info];
    }];
}

/// 关闭免密
-(void)closeFreePin {
    [YWXSignManager.sharedManager clearPin];
    [self showAlertWith:@"关闭免密" code:@"0" message:@"success" info:@{}];
}

/// 开启生物识别
-(void)openBiometricsStatus {
    __weak typeof(self) weakSelf = self;
    [YWXSignManager.sharedManager startBiometricAuthenticationForSignWithCompletion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"开启生物识别" code:code message:message info:info];
    }];
}

-(void)closeBiometricsStatus {
    [YWXSignManager.sharedManager stopBiometricAuthenticationForSignWithCompletion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [self showAlertWith:@"关闭生物识别" code:code message:message info:info];
    }];
    
}

#pragma mark - 用户信息
/// 获取用户信息
-(void)showUserInfo {
    __weak typeof(self) weakSelf = self;
    [YWXSignManager.sharedManager requestUserInfoWithCompletion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        if ([code isEqualToString:@"0"]) {
            YWXUserInfoViewController *userInfoController = [[YWXUserInfoViewController alloc] init];
            userInfoController.openId = YWXSignManager.sharedManager.openId;
            userInfoController.freePin = YWXSignManager.sharedManager.isPinExempt;
            userInfoController.userInfoDictionary = info;
            userInfoController.stampImageBase64 = YWXSignManager.sharedManager.signatureBase64EncodedString;
            [weakSelf.navigationController pushViewController:userInfoController animated:YES];
        } else {
            [weakSelf showAlertWith:@"获取用户信息" code:code message:message info:info];
        }
    }];
    
}

-(void)showCertDetail {
    __weak typeof(self) weakSelf = self;
    [YWXSignManager.sharedManager showCertDetailWithCompletion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"显示证书详情" code:code message:message info:info];
    }];
}

-(void)grandSign {
    __weak typeof(self) weakSelf = self;
    [YWXSignManager.sharedManager grantSignAuthorizationToFirmId:self.clientInfoView.clientId grantedUserId:@"7cb82cab534c4599b8fdcfcc15d27cd4" hours:10 completion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"开启授权签名" code:@"0" message:@"success" info:@{}];
    }];
}

-(void)closeGrandSign {
    __weak typeof(self) weakSelf = self;
    [YWXSignManager.sharedManager stopGrantSignAuthorizationToFirmId:self.clientInfoView.clientId
                                                               grantUniqueId:@"21ebeb7d502945a89a8d98834d2f5eb4"
                                                                  completion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable info) {
        [weakSelf showAlertWith:@"关闭授权签名" code:code message:message info:info];
    }];
}


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

- (void)getSDKVersion {
    NSString *versionString = [YWXSignManager.sharedManager versionString];
    [self showAlertWith:@"当前SDK版本" code:@"0" message:versionString info:@{}];
}

- (void)checkIsExistCert {
    BOOL isCertificateExist = [YWXSignManager.sharedManager existsCert];
    NSString *message = [NSString stringWithFormat:@"证书：%@",isCertificateExist == YES ? @"存在" : @"不存在"];
    [self showAlertWith:@"是否存在证书" code:@"0" message:message info:@{}];
}

-(void)showChangeServiceController {
    YWXEnvironmentViewController *envControler = [[YWXEnvironmentViewController alloc] init];
    envControler.environmentKeyName = KEnvironmentKeyName;
    __weak typeof(self) weakSelf = self;
    envControler.environmentChangeBlack = ^(YWXDemoEnvironment currentEnvironment) {
        [weakSelf changeEnvironmentWith:currentEnvironment];
    };
    [self.navigationController pushViewController:envControler animated:YES];
}

-(void)showPinWindow{
    [YWXSignManager.sharedManager showPinWindowWithCompletion:^(YWXSignStatusCode  _Nonnull code, NSString * _Nonnull message, id  _Nullable data) {
        [self showAlertWith:@"展示密码输入" code:code message:message info:data];
    }];
}

@end
