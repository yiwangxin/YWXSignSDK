//
//  YWXSignSDK_ExampleUITests.m
//  YWXSignSDK_ExampleUITests
//
//  Created by szyx on 2021/5/12.
//  Copyright © 2021 XiaoY2017. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface YWXSignSDK_ExampleUITests : XCTestCase
@property (nonatomic, strong) XCUIApplication *app;
@property (nonatomic, strong) XCUIElementQuery *tablesQuery;
@property (nonatomic, assign) BOOL isOpenAutoSign;
@end

@implementation YWXSignSDK_ExampleUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    if (self.app == nil) {
        XCUIApplication *app = [[XCUIApplication alloc] init];
        self.app = app;
        [app launch];
        XCUIElementQuery *tablesQuery = app.tables;
        self.tablesQuery = tablesQuery;
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testLaunchPerformance {
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)) {
        // This measures how long it takes to launch your application.
        [self measureWithMetrics:@[[[XCTApplicationLaunchMetric alloc] init]] block:^{
            [[[XCUIApplication alloc] init] launch];
        }];
    }
}

- (void)testAll {
    [self testClearCert];
    [self testChangeLanguageAndService];
    [self testCertDownload];
    [self testSignData];
    [self testAutoSign];
    [self testCheckCertInfo];
    [self testAllOpenFreeSignProcess];
    [self testResetCertPassword];
    [self testSignData];
    [self testClearCert];
}

/// 切换环境到开发环境并且切换为中文语言
- (void)testChangeLanguageAndService {
    
    XCUIApplication *app = self.app;
    XCUIElementQuery *tablesQuery = self.tablesQuery;
    XCUIElement *peizhi = tablesQuery.staticTexts[@"\u914d\u7f6e"];
    [peizhi tap];
    [tablesQuery.staticTexts[@"\u5207\u6362\u73af\u5883"] tap];
    [app.staticTexts[@"\u5f00\u53d1\u73af\u5883"] tap];
    [app.staticTexts[@"\u4fee\u6539\u73af\u5883"] tap];
    XCUIElement *okButton = app.buttons[@"OK"];
    if ([okButton waitForExistenceWithTimeout:10]) {
        [okButton tap];
    }
    
    if ([peizhi waitForExistenceWithTimeout:10]) {
        [[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"\u7cfb\u7edf\u8bed\u8a00"].element swipeUp];
        [tablesQuery.staticTexts[@"中文语言"] tap];
        XCUIElement *okButton = app.buttons[@"OK"];
        if ([okButton waitForExistenceWithTimeout:5]) {
            [okButton tap];
        }
        [peizhi tap];
    }
    
}


/// 测试证书下载
- (void)testCertDownload {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = self.tablesQuery;
    XCUIElement *phoneTextField = app.textFields[@"\u8bf7\u586b\u5199\u624b\u673a\u53f7"];
    
    NSString *phone = [phoneTextField value];
    if (![phone isEqualToString:@"18519115509"]) {
        [phoneTextField tap];
        [self cleanTextFieldText:phoneTextField];
        [phoneTextField typeText:@"18519115509"];
    }
    [self closeKeyBoard:app];
    // 打开下证列表
    XCUIElement *certCell = tablesQuery.staticTexts[@"\u4e0b\u8bc1"];
    XCUIElement *downLoadCertCell = tablesQuery.staticTexts[@"\u4e0b\u8f7d\u8bc1\u4e66"];
    if (!downLoadCertCell.exists) {
        [certCell tap];
    }
    // 点击下载证书
    [downLoadCertCell tap];
    [self inputCertPasswordForDownLoadCert];
    [certCell tap];
}

// 测试批量签名
-(void)testSignData {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = self.tablesQuery;
    XCUIElement *signGroupCell = tablesQuery.staticTexts[@"\u7b7e\u540d"];
    XCUIElement *signCell = tablesQuery.staticTexts[@"\u6279\u91cf\u7b7e\u540d"];
    if (!signCell.exists) {
        [signGroupCell tap];
    }
    [signCell tap];
    XCUIElement *tonbuButton  = app.staticTexts[@"点击同步处方数据"];
    [tonbuButton tap];
    XCUIElement *orderInfoLabel  = app.staticTexts[@"已同步1/1条待签数据到医网信"];
    NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:exists evaluatedWithObject:orderInfoLabel handler:nil];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    XCUIElement *signButton = app.buttons[@"\u6279\u91cf\u7b7e\u540d"];
    [signButton tap];
    XCUIElement *okButton = app.buttons[@"OK"];
    [self inputSignPassword];
    if ([okButton waitForExistenceWithTimeout:60]) {
        [okButton tap];
    }
    [app.navigationBars[@"\u65b0\u7b7e\u540d"].buttons[@"\u65b0\u7b7e\u540d"] tap];
    [signGroupCell tap];
}

- (void)testAutoSign {
    [self testOpenAutoSign];
    if (!self.isOpenAutoSign) {
        [self testStartAutoSign];
        [self testOpenAutoSign];
    }
    [self testCheckAutoSignInfo];
    [self testSignData];
    [self testCheckAutoSignInfo];
    [self testCloseAutoSignInfo];
    [self testSignData];
}

// 测试发起开自动签授权
-(void)testStartAutoSign {
    XCUIApplication *app = self.app;
    XCUIElementQuery *tablesQuery = self.tablesQuery;
    XCUIElement *signCell = tablesQuery.staticTexts[@"\u7b7e\u540d"];
    XCUIElement *creatQRCodeCell = tablesQuery.staticTexts[@"\u4e8c\u7ef4\u7801\u521b\u5efa"];
    if (!creatQRCodeCell.exists) {
        [signCell tap];
    }
    // 点击创建二维码
    [creatQRCodeCell tap];
    // 点击V3自动签
    [app.staticTexts[@"V3\u81ea\u52a8\u7b7e\u540d"] tap];
    sleep(3);
    XCUIElement *okButton = app.buttons[@"OK"];
    if ([okButton waitForExistenceWithTimeout:10]) {
        [okButton tap];
    }
    XCUIElement *closeButton = app.staticTexts[@"\u5173\u95ed"];
    if ([closeButton waitForExistenceWithTimeout:10]) {
        [closeButton tap];
    }
    [app.navigationBars[@"\u65b0\u7b7e\u540d"].buttons[@"\u65b0\u7b7e\u540d"] tap];
    // 关闭签名列表
    [signCell tap];

}

- (void)testOpenAutoSign {
    XCUIApplication *app = self.app;
    XCUIElementQuery *tablesQuery = self.tablesQuery;
    // 点击自动签列表
    XCUIElement *autoSignCell = tablesQuery.staticTexts[@"\u81ea\u52a8\u7b7e\u540d"];
    [autoSignCell tap];
    XCUIElement *sysTagTextField = [tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"\u5f00\u542f\u81ea\u52a8\u7b7e"].textFields[@"\u8bf7\u8f93\u5165sysTag"];
    
    NSString *sysTag = (sysTagTextField.value);
    if (![sysTag isEqualToString:@"his"]) {
        [sysTagTextField tap];
        [self cleanTextFieldText:sysTagTextField];
        [sysTagTextField typeText:@"his"];
    }
    [self closeKeyBoard:app];
    //点击打开自动签
    XCUIElement *openAutoSignCell = tablesQuery.staticTexts[@"\u5f00\u542f\u81ea\u52a8\u7b7e"];
    [openAutoSignCell tap];
    [self inputSignPassword];
    self.isOpenAutoSign = YES;
    if (app.staticTexts[@"开启自动签名0"].exists) {
        self.isOpenAutoSign = YES;
    } else {
        self.isOpenAutoSign = NO;
    }
    XCUIElement *okButton = app.buttons[@"OK"];
    if ([okButton waitForExistenceWithTimeout:5]) {
        [okButton tap];
    }
    // 点击关闭自动签名cell
    [autoSignCell tap];

}

// 测试查看自动签信息
-(void)testCheckAutoSignInfo {
    XCUIApplication *app = self.app;
    XCUIElementQuery *tablesQuery = self.tablesQuery;
    // 点击自动签列表
    XCUIElement *autoSignCell = tablesQuery.staticTexts[@"\u81ea\u52a8\u7b7e\u540d"];
    // 点击查看自动签名信息
    XCUIElement *autoSignInfoCell = tablesQuery.staticTexts[@"\u83b7\u53d6\u81ea\u52a8\u7b7e\u4fe1\u606f"];
    if (!autoSignInfoCell.exists) {
        // 如果不存在则点开配置列表
        [autoSignCell tap];
    }
    [autoSignInfoCell tap];
    sleep(3);
    XCUIElement *okButton = app.buttons[@"OK"];
    if ([okButton waitForExistenceWithTimeout:5]) {
        [okButton tap];
    }
    [autoSignCell tap];
}

// 关闭自动签
-(void)testCloseAutoSignInfo {
    XCUIApplication *app = self.app;
    XCUIElementQuery *tablesQuery = self.tablesQuery;
    // 点击自动签列表
    XCUIElement *autoSignCell = tablesQuery.staticTexts[@"\u81ea\u52a8\u7b7e\u540d"];
    // 点击关闭自动签
    XCUIElement *closeAutoSignCell = tablesQuery.staticTexts[@"\u9000\u51fa\u81ea\u52a8\u7b7e"];
    if (!closeAutoSignCell.exists) {
        [autoSignCell tap];
    }
    [closeAutoSignCell tap];
    sleep(2);
    XCUIElement *okButton = app.buttons[@"OK"];
    if ([okButton waitForExistenceWithTimeout:5]) {
        [okButton tap];
    }
    self.isOpenAutoSign = NO;
    [autoSignCell tap];
}

/// 查看证书详情
-(void)testCheckCertInfo {
    XCUIApplication *app = self.app;
    XCUIElementQuery *tablesQuery = self.tablesQuery;
    XCUIElement *certInfoGroupCell = tablesQuery.staticTexts[@"\u8bc1\u4e66\u4fe1\u606f"];
    XCUIElement *certInfoCell = tablesQuery.staticTexts[@"\u83b7\u53d6\u7528\u6237\u4fe1\u606f"];
    if (!certInfoCell.exists) {
        [certInfoGroupCell tap];
    }
    [certInfoCell tap];
    sleep(20);
    [app.navigationBars[@"\u65b0\u7b7e\u540d"].buttons[@"\u65b0\u7b7e\u540d"] tap];
    [certInfoGroupCell tap];
}

/// 走一遍开启免密签名，然后关闭免密签名流程
-(void)testAllOpenFreeSignProcess {
    // 开启免密
    [self testOpenFreeSign];
    // 检查证书信息
    [self testCheckCertInfo];
    // 检查签名
    [self testSignData];
    // 检查关闭免密
    [self testCloseFreeSign];
    // 检查证书信息
    [self testCheckCertInfo];
    // 再次检查签名是否需要输入密码
    [self testSignData];
}


/// 测试开启免密
-(void)testOpenFreeSign {
    XCUIApplication *app = self.app;
    XCUIElementQuery *tablesQuery = self.tablesQuery;
    // 点击打开配置列表
    XCUIElement *configCell = tablesQuery.staticTexts[@"\u914d\u7f6e"];
    // 点击免密输入框
    XCUIElement *openFreeSignCell = tablesQuery.staticTexts[@"\u5f00\u542f\u514d\u5bc6\u7b7e\u540d"];
    if (!openFreeSignCell.exists) {
        [configCell tap];
    }
    [tablesQuery.textFields[@"\u8bf7\u8f93\u5165\u514d\u5bc6\u5929\u65701-60"] tap];
    XCUIElement *moreKey = app/*@START_MENU_TOKEN@*/.keyboards.keys[@"more"]/*[[".keyboards",".keys[@\"numbers\"]",".keys[@\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[2,0]]@END_MENU_TOKEN@*/;
    [moreKey tap];
    XCUIElement *key = app/*@START_MENU_TOKEN@*/.keyboards.keys[@"1"]/*[[".keyboards.keys[@\"1\"]",".keys[@\"1\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/;
    [key tap];
    [self closeKeyBoard:app];
    // 点击开启免密
    [openFreeSignCell tap];
    [self inputSignPassword];
    XCUIElement *okButton = app.buttons[@"OK"];
    if ([okButton waitForExistenceWithTimeout:5]) {
        [okButton tap];
    }
    // 关闭配置
    [configCell tap];
}

/// 测试关闭免密
-(void)testCloseFreeSign {
    XCUIApplication *app = self.app;
    XCUIElementQuery *tablesQuery = self.tablesQuery;
    // 点击打开配置列表
    XCUIElement *configCell = tablesQuery.staticTexts[@"\u914d\u7f6e"];
    // 打开配置列表
    [configCell tap];
    // 关闭免密
    [tablesQuery.staticTexts[@"\u6e05\u9664\u514d\u5bc6\u72b6\u6001"] tap];
    XCUIElement *okButton = app.buttons[@"OK"];
    if ([okButton waitForExistenceWithTimeout:5]) {
        [okButton tap];
    }
    // 关闭配置列表
    [configCell tap];
    
}

- (void)testClearCert {
    XCUIApplication *app = self.app;
    XCUIElementQuery *tablesQuery = self.tablesQuery;
    // 点击打开配置列表
    XCUIElement *configCell = tablesQuery.staticTexts[@"\u914d\u7f6e"];
    // 打开配置列表
    [configCell tap];
    [tablesQuery.staticTexts[@"\u6e05\u9664\u8bc1\u4e66"] tap];
    sleep(2);
    [app.buttons[@"OK"] tap];
    [configCell tap];
        
}


-(void)testResetCertPassword {
    XCUIApplication *app = self.app;
    XCUIElementQuery *tablesQuery = self.tablesQuery;
    // 打开下证列表
    [tablesQuery.staticTexts[@"\u4e0b\u8bc1"] tap];
    // 点击重置证书
    [tablesQuery.staticTexts[@"\u8bc1\u4e66\u5bc6\u7801\u91cd\u7f6e"] tap];
    if (app.staticTexts[@"证书重置1001"].exists) {
        sleep(5);
        [app.buttons[@"OK"] tap];
        [self testCertDownload];
        [self testResetCertPassword];
    } else {
        [self inputCertPasswordForDownLoadCert];
    }
    sleep(2);
    [tablesQuery.staticTexts[@"\u4e0b\u8bc1"] tap];
    sleep(2);
}

-(void)closeKeyBoard:(XCUIApplication *)app {
    if (app.toolbars[@"Toolbar"].buttons[@"Toolbar Done Button"].exists) {
        [app.toolbars[@"Toolbar"].buttons[@"Toolbar Done Button"] tap];
    }
    if (app.toolbars[@"Toolbar"].buttons[@"收起"].exists) {
        [app.toolbars[@"Toolbar"].buttons[@"收起"] tap];
    }
}

/// 在下证页面输入证书密码
-(void)inputCertPasswordForDownLoadCert {
    XCUIApplication *app = self.app;
    XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
    XCUIElement *autuCodeTextField = elementsQuery.textFields[@"\u8bf7\u8f93\u5165\u9a8c\u8bc1\u7801"];
    XCUIElement *passwordTextField = elementsQuery.secureTextFields[@"\u8bf7\u8f93\u5165\u5bc6\u7801"];
    XCUIElement *passwordAgainTextField = elementsQuery.secureTextFields[@"\u8bf7\u786e\u8ba4\u5bc6\u7801"];
    XCUIElement *downLoadButton = elementsQuery.buttons[@"\u786e\u8ba4"];
    XCUIElement *okButton = app.buttons[@"OK"];
    [autuCodeTextField tap];
    [autuCodeTextField typeText:@"123455"];
    [passwordTextField tap];
    [passwordTextField typeText:@"123456"];
    [passwordAgainTextField tap];
    [passwordAgainTextField typeText:@"123455"];
    [self closeKeyBoard:app];
    [downLoadButton tap];
    if ([okButton waitForExistenceWithTimeout:5]) {
        [okButton tap];
    }
    sleep(1);
    if (!downLoadButton.exists) {
        return;
    }
    [passwordAgainTextField tap];
    [self cleanTextFieldText:passwordAgainTextField];
    [passwordAgainTextField typeText:@"123456"];
    [self closeKeyBoard:app];
    [downLoadButton tap];
    if ([okButton waitForExistenceWithTimeout:5]) {
        [okButton tap];
    }
    sleep(1);
    [autuCodeTextField tap];
    [self cleanTextFieldText:autuCodeTextField];
    [autuCodeTextField typeText:@"123456"];
    [self closeKeyBoard:app];
    [downLoadButton tap];
    if ([okButton waitForExistenceWithTimeout:20]) {
        [okButton tap];
    }
}

- (void)cleanTextFieldText:(XCUIElement *)textField {
    XCUIApplication *app = self.app;
    [textField tap];
    NSString *textValue = [textField value];
    NSString *placeholderValue = textField.placeholderValue;
    while (![textValue isEqualToString:placeholderValue]) {
        XCUIElement *edeleteKey = app/*@START_MENU_TOKEN@*/.keys[@"Delete"]/*[[".keyboards.keys[@\"Delete\"]",".keys[@\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
        XCUIElement *zdeleteKey = app.keys[@"\u5220\u9664"];
        if (edeleteKey.exists) {
            [edeleteKey tap];
        } else if (zdeleteKey.exists){
            [zdeleteKey tap];
        }
        textValue = [textField value];
    }
}

// 测试输入签名密码123456
-(BOOL)inputSignPassword {
    XCUIApplication *app = self.app;
    XCUIElement *button1 = app.buttons[@"1"];
    XCUIElement *button2 = app.buttons[@"2"];
    XCUIElement *button3 = app.buttons[@"3"];
    XCUIElement *button4 = app.buttons[@"4"];
    XCUIElement *button5 = app.buttons[@"5"];
    XCUIElement *button6 = app.buttons[@"6"];
    BOOL isInput = NO;
    if (button1.exists) {
        [button1 tap];
        [button2 tap];
        [button3 tap];
        [button4 tap];
        [button5 tap];
        [button6 tap];
        isInput = YES;
    }
    sleep(2);
    return isInput;
}

@end
