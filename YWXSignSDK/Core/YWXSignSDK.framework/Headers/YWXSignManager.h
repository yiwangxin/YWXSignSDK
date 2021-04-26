//
//  YWXSignManager.h
//  YWXSignSDK
//
//  Created by Weipeng Qi on 2021/3/23.
//  Copyright © 2021 Beijing Digital Yixin Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YWXSignSDK/YWXSignStatus.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWXSignManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 单例对象。
+ (instancetype)sharedManager;

#pragma mark - 初始化

/// SDK 初始化工作。
- (void)startWithClientID:(NSString *)clientID environment:(YWXEnvironment)environment;

#pragma mark - 证书相关

/// 本地证书是否存在。
@property (nonatomic, readonly, assign) BOOL isCertificateExist;

/// 下载证书。
- (void)downloadCertificateWithPhoneNumber:(NSString *)phoneNumber
                                completion:(nullable YWXSignCompletionBlock)completion;

/// 更新证书。
- (void)updateCertificateWithCompletion:(nullable YWXSignCompletionBlock)completion;

/// 重置证书密码。
- (void)resetCertificatePasswordWithCompletion:(nullable YWXSignCompletionBlock)completion;

/// 打开证书详情。
- (void)showCertificateDetailWithNavigationBarTintColor:(nullable UIColor *)navigationBarTintColor
                           navigationBarBackgroundColor:(nullable UIColor *)navigationBarBackgroundColor
                                             completion:(nullable YWXSignCompletionBlock)completion;

/// 移除本地证书。
- (BOOL)removeLocalCertificate;

#pragma mark - 签章相关

/// 签章图片的 base64 字符串，如果签章不存在则为 nil。
@property (nullable, nonatomic, readonly, copy) NSString *signatureBase64EncodedString;

/// 签章配置。
- (void)setupSignatureWithNavigationBarTintColor:(nullable UIColor *)navigationBarTintColor
                    navigationBarBackgroundColor:(nullable UIColor *)navigationBarBackgroundColor
                                      completion:(nullable YWXSignCompletionBlock)completion;

/// 批量签章配置。
- (void)setupSignatureWithFirmIDs:(nullable NSArray<NSString *> *)firmIDs
             navigationBarTintColor:(nullable UIColor *)navigationBarTintColor
       navigationBarBackgroundColor:(nullable UIColor *)navigationBarBackgroundColor
                         completion:(nullable YWXSignCompletionBlock)completion;

#pragma mark - 签名相关

/// 普通签名接口
/// @param uniqueIDs 签名数据
/// @param completion 回调
- (void)signWithUniqueIDs:(NSArray<NSString *> *)uniqueIDs
               completion:(nullable YWXSignCompletionBlock)completion;

/// 批量签名。(医网信APP专用)
/// @param uniqueIDs 签名数据的uniqueID数组
/// @param firmID 对应子厂商id
/// @param completion 回调
- (void)signWithFirmID:(NSString *)firmID
             uniqueIDs:(NSArray<NSString *> *)uniqueIDs
            completion:(nullable YWXSignCompletionBlock)completion;

/// 对二维码信息进行识别处理
/// @param QRString 二维码字符串信息
/// @param completion 回调
- (void)signWithQRString:(NSString *)QRString
              completion:(nullable YWXSignCompletionBlock)completion;

#pragma mark - 自动签

/// 开启自动签名
/// @param sysTag sysTag
/// @param completion 回调
- (void)enableAutomaticSignatureWithSysTag:(NSString *)sysTag
                                completion:(nullable YWXSignCompletionBlock)completion;

/// 关闭自动签名
/// @param sysTag sysTag
/// @param completion 回调
- (void)disableAutomaticSignatureWithSysTag:(NSString *)sysTag
                                 completion:(nullable YWXSignCompletionBlock)completion;


/// 开启自动签名
/// @param firmID 子厂商id
/// @param sysTag sysTag
/// @param completion 回调
- (void)enableAutomaticSignatureWithFirmID:(NSString *)firmID
                                    sysTag:(NSString *)sysTag
                                completion:(nullable YWXSignCompletionBlock)completion;

/// 关闭自动签名
/// @param firmID 子厂商id
/// @param sysTag sysTag
/// @param completion 回调
- (void)disableAutomaticSignatureWithWithFirmID:(NSString *)firmID
                                         sysTag:(NSString *)sysTag
                                     completion:(YWXSignCompletionBlock)completion;

/// 获取自动签名信息
/// @param completion 回调
- (void)requestAutomaticSignatureInfoWithCompletion:(nullable YWXSignCompletionBlock)completion;

#pragma mark - 免密

/// 开启免密签名
/// @param days 单位天（1-60）
/// @param completion 回调
- (void)enablePasswordLessSignatureWithDays:(NSInteger)days
                                 completion:(nullable YWXSignCompletionBlock)completion;

/// 关闭免密签名。
- (void)disablePasswordLessSignature;

/// 当前是否处于免密状态
@property (nonatomic, readonly, assign) BOOL isPasswordLessSignatureEnabled;

#pragma mark - 生物识别设置

/// 开启生物识别
/// @param completion 回调
- (void)enableBiometricAuthenticationForSignatureWithCompletion:(nullable YWXSignCompletionBlock)completion;

/// 关闭生物识别
/// @param completion 回调
- (void)disableBiometricAuthenticationForSignatureWithCompletion:(nullable YWXSignCompletionBlock)completion;

/// 签名的  Touch ID / Face ID 是否开启。
@property (nonatomic, readonly, assign) BOOL isBiometricAuthenticationEnabled;

#pragma mark - 授权签名

/// 开启授权签名
/// @param firmID 子厂商id
/// @param grantedUserID 指定授权用户的id
/// @param hours 单位小时
/// @param completion 回调
- (void)grantSignatureAuthorizationToFirmID:(NSString *)firmID
                              grantedUserID:(NSString *)grantedUserID
                                      hours:(NSInteger)hours
                                 completion:(nullable YWXSignCompletionBlock)completion;

/// 关闭授权签名
/// @param firmID 子厂商id
/// @param grantUniqueId 授权唯一标识id
/// @param completion 回调
- (void)disableGrantSignatureAuthorizationToFirmID:(NSString *)firmID
                                     grantUniqueId:(NSString *)grantUniqueId
                                        completion:(nullable YWXSignCompletionBlock)completion;

#pragma mark - 配置

/// SDK 当前的开发环境。
@property (nonatomic, readonly, assign) YWXEnvironment currentEnvironment;

/// SDK 当前开发环境的 URL 地址。
@property (nonatomic, readonly, copy) NSString *currentEnvironmentURL;

/// 当前版本号。
@property (nonatomic, readonly, copy) NSString *versionString;

/// 当前显示的语言。
@property (nonatomic, readonly, copy) NSString *currentLanguage;

/// 用户的 openID，证书不存在时为 nil。
@property (nullable, nonatomic, readonly, copy) NSString *openID;

/// 获取用户信息。
- (void)requestUserInfoWithCompletion:(nullable YWXSignCompletionBlock)completion;

/// 修改界面语言。
- (void)changePreferredLanguage:(NSString *)language;

@end

NS_ASSUME_NONNULL_END
