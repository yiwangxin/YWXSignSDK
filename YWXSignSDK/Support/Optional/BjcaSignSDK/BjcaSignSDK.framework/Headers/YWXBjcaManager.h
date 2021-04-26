//
//  YWXBjcaManager.h
//  BjcaSignSDK
//
//  Created by szyx on 2021/3/26.
//  Copyright © 2021 Beijing Digital Yixin Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BjcaSignSDK/YWXBjcaTypeDefine.h>


NS_ASSUME_NONNULL_BEGIN

@interface YWXBjcaManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 单例对象。
+ (instancetype)sharedManager;

#pragma mark - 初始化

/// SDK 初始化工作。
- (void)startWithClientID:(NSString *)clientID environment:(YWXBjcaEnvironment)environment;

#pragma mark - 证书下证

/// 本地证书是否存在。
@property (nonatomic, readonly, assign) BOOL isCertificateExist;

/// 下证接口
/// @param phoneNumber 手机号
/// @param completion 成功回调
- (void)downloadCertificateWithPhoneNumber:(NSString *)phoneNumber
                                completion:(YWXBjcaSignCompletionBlock)completion;

/// 更新证书
/// @param completion 回调
- (void)updateCertificateWithCompletion:(YWXBjcaSignCompletionBlock)completion;

/// 重置密码
/// @param completion 回调
- (void)resetCertificatePasswordWithCompletion:(YWXBjcaSignCompletionBlock)completion;

/// 删除证书
-(BOOL)removeLocalCertificate;

/// 打开证书详情。
//- (void)showCertificateDetailWithNavigationBarTintColor:(nullable UIColor *)navigationBarTintColor
//                           navigationBarBackgroundColor:(nullable UIColor *)navigationBarBackgroundColor
//                                             completion:(nullable YWXSignCompletionBlock)completion;

#pragma mark - 签章相关

/// 签章图片的 base64 字符串，如果签章不存在则为 nil。
@property (nullable, nonatomic, readonly, copy) NSString *signatureBase64EncodedString;

//
///// 签章配置。
//- (void)setupSignatureWithNavigationBarTintColor:(nullable UIColor *)navigationBarTintColor
//                    navigationBarBackgroundColor:(nullable UIColor *)navigationBarBackgroundColor
//                                      completion:(nullable YWXSignCompletionBlock)completion;

///// 批量签章配置。
//- (void)setupSignatureWithClientIDs:(NSArray<NSString *> *)clientIDs
//             navigationBarTintColor:(nullable UIColor *)navigationBarTintColor
//       navigationBarBackgroundColor:(nullable UIColor *)navigationBarBackgroundColor
//                         completion:(nullable YWXSignCompletionBlock)completion;


#pragma mark - 签名相关

/// 批量签名
/// @param uniqueIDs 签名数据的uniqueID数组
/// @param completion 回调
- (void)signWithUniqueIDs:(NSArray<NSString *> *)uniqueIDs
               completion:(nullable YWXBjcaSignCompletionBlock)completion;

/// 批量签名。(医网信APP专用)
/// @param uniqueIDs 签名数据的uniqueID数组
/// @param firmId 对应子厂商id
/// @param completion 回调
- (void)signWithUniqueIDs:(NSArray<NSString *> *)uniqueIDs
                   firmId:(NSString *)firmId
               completion:(nullable YWXBjcaSignCompletionBlock)completion;

/// 协同签名(医网信APP专用)
/// @param uniqueIDs 签名数据uniqueIDs数组
/// @param firmId 子厂商id
/// @param completion 回调
- (void)teamSignWithUniqueIDs:(NSArray<NSString *> *)uniqueIDs
                       firmId:(NSString *)firmId
                   completion:(nullable YWXBjcaSignCompletionBlock)completion;

#pragma mark - 二维码识别处理

/// 扫描二维码进行业务处理
/// @param QRString 二维码字符串
/// @param completion 回调
- (void)signWithQRString:(NSString *)QRString
              completion:(nullable YWXBjcaSignCompletionBlock)completion;

#pragma mark - 自动签名

/// 开启自动签名
/// @param sysTag 标识需和后台保持一致
/// @param completion 回调
- (void)enableAutomaticSignatureWithSysTag:(NSString *)sysTag
                                completion:(nullable YWXBjcaSignCompletionBlock)completion;

/// 开启自动签名
/// @param sysTag 标识需和后台保持一致
/// @param firmId 子厂商id
/// @param completion 回调
- (void)enableAutomaticSignatureWithSysTag:(NSString *)sysTag
                                    firmId:(NSString *)firmId
                                completion:(nullable YWXBjcaSignCompletionBlock)completion;

/// 关闭自动签名
/// @param sysTag 标识
/// @param completion 回调
- (void)disableAutomaticSignatureWithSysTag:(NSString *)sysTag
                                 completion:(nullable YWXBjcaSignCompletionBlock)completion;

/// 关闭自动签名
/// @param sysTag 标识
/// @param firmId 自厂商
/// @param completion 回调
- (void)disableAutomaticSignatureWithSysTag:(NSString *)sysTag
                                     firmId:(NSString *)firmId
                                 completion:(nullable YWXBjcaSignCompletionBlock)completion;

/// 获取自动签名的信息。
/// @param completion 回调
- (void)requestAutomaticSignatureInfoWithCompletion:(nullable YWXBjcaSignCompletionBlock)completion;

#pragma mark - 免密、和生物识别配置

/// 当前是否处于免密状态
@property (nonatomic, readonly, assign) BOOL isPasswordLessSignatureEnabled;

/// 签名的  Touch ID / Face ID 是否开启。
@property (nonatomic, readonly, assign) BOOL isBiometricAuthenticationEnabled;

/// 开启免密签名
/// @param days 开启保存时长单位天1-60
/// @param completion 回调
- (void)enablePasswordLessSignatureWithDays:(NSInteger)days
                                 completion:(nullable YWXBjcaSignCompletionBlock)completion;

/// 关闭免密签名。
- (void)disablePasswordLessSignature;

/// 开启生物识别签名 Touch ID / Face ID
/// @param completion 回调
- (void)enableBiometricAuthenticationForSignatureWithCompletion:(nullable YWXBjcaSignCompletionBlock)completion;

/// 关闭生物识别签名 Touch ID / Face ID。
/// @param completion 回调
- (void)disableBiometricAuthenticationForSignatureWithCompletion:(nullable YWXBjcaSignCompletionBlock)completion;

///// 授权签名。
//- (void)grantSignatureAuthorizationToFirmID:(NSString *)firmID
//                              grantedUserID:(NSString *)grantedUserID
//                                      hours:(NSInteger)hours
//                                 completion:(nullable YWXSignCompletionBlock)completion;


#pragma mark - 配置

/// SDK 当前的开发环境。
@property (nonatomic, assign, readonly) YWXBjcaEnvironment currentEnvironment;
/// SDK 当前开发环境的 URL 地址。
@property (nonatomic, readonly, copy) NSString *currentEnvironmentURL;
/// 当前版本号。
@property (nonatomic, readonly, copy) NSString *version;
/// 用户的 openID，证书不存在时为 nil。
@property (nullable, nonatomic, readonly, copy) NSString *openID;

/// 获取用户信息。
/// @param completion 回调
- (void)requestUserInfoWithCompletion:(nullable YWXBjcaSignCompletionBlock)completion;

/// 当前显示的语言。
//@property (nonatomic, readonly, copy) NSString *currentLanguage;

/// 修改界面语言。
//- (void)changePreferredLanguage:(NSString *)language;

@end

NS_ASSUME_NONNULL_END
