//
//  YWXBjcaTypeDefine.h
//  BjcaSignSDK
//
//  Created by szyx on 2021/3/29.
//  Copyright © 2021 Beijing Digital Yixin Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

///// SDK 开发环境。
typedef NS_ENUM(NSUInteger, YWXBjcaEnvironment) {
    /// 生产环境
    YWXBjcaEnvironmentProduction,
    /// 集成环境
    YWXBjcaEnvironmentAcceptance,
    /// 测试环境
    YWXBjcaEnvironmentTesting,
    /// 开发环境
    YWXBjcaEnvironmentDevelopment,
};

//typedef void(^YWXBjcaSignCompletionBlock)(NSString * _Nullable code, NSString * _Nullable message, NSDictionary * _Nonnull info);
typedef void(^YWXBjcaSignCompletionBlock)(NSString *code, NSString *message, id info);
