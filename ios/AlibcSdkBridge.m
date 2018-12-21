//
//  AlibcSdkBridge.m
//  react_native_calendar
//
//  Created by petitspois on 08/04/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "AlibcSdkBridge.h"
#import <React/RCTLog.h>

@implementation AlibcSdkBridge{
  AlibcTradeTaokeParams *taokeParams;
  AlibcTradeShowParams *showParams;
}

- (void)init:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject
{
  
  NSString * bundleID = [NSBundle mainBundle].bundleIdentifier;
  
  NSLog(@"%@=====================================", bundleID);
  // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
  [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
    resolve(@"success");
    NSLog(@"Init success============");
  } failure:^(NSError *error) {
    reject(@"500", error.description, nil);
    NSLog(@"Init failed--------: %@", error.description);
  }];
  
  [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
  
  // 配置全局的淘客参数
  //如果没有阿里妈妈的淘客账号,setTaokeParams函数需要调用
  AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
  [[AlibcTradeSDK sharedInstance] setTaokeParams:taokeParams];
  
  // 设置全局配置，是否强制使用h5
  [[AlibcTradeSDK sharedInstance] setIsForceH5:NO];
  
}


- (void)show: (NSDictionary *)param callback: (RCTResponseSenderBlock)callback
{
  NSString *type = param[@"type"];
  id<AlibcTradePage> page;
  if ([type isEqualToString:@"detail"]) {
    page = [AlibcTradePageFactory itemDetailPage:(NSString *)param[@"payload"]];
  } else if ([type isEqualToString:@"url"]) {
    page = [AlibcTradePageFactory page:(NSString *)param[@"payload"]];
  } else if ([type isEqualToString:@"shop"]) {
    page = [AlibcTradePageFactory shopPage:(NSString *)param[@"payload"]];
  } else if ([type isEqualToString:@"orders"]) {
    NSDictionary *payload = (NSDictionary *)param[@"payload"];
    page = [AlibcTradePageFactory myOrdersPage:[payload[@"orderType"] integerValue] isAllOrder:[payload[@"isAllOrder"] boolValue]];
  } else if ([type isEqualToString:@"addCard"]) {
    page = [AlibcTradePageFactory addCartPage:(NSString *)param[@"payload"]];
  } else if ([type isEqualToString:@"mycard"]) {
    page = [AlibcTradePageFactory myCartsPage];
  } else {
    RCTLog(@"not implement");
    return;
  }
  
  [self _show:page callback:callback];
}

-(void)_show:(id<AlibcTradePage>)page callback: (RCTResponseSenderBlock)callback{
  
  id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
  [service show: [UIApplication sharedApplication].delegate.window.rootViewController page:page showParams:nil taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        if (result.result == AlibcTradeResultTypeAddCard) {
          NSDictionary *ret = @{@"type": @"card"};
          callback(@[[NSNull null], ret]);
        } else if (result.result == AlibcTradeResultTypePaySuccess) {
          NSDictionary *ret = @{@"type": @"pay", @"orders": result.payResult.paySuccessOrders};
          callback(@[[NSNull null], ret]);
        }
      }
      tradeProcessFailedCallback:^(NSError * _Nullable error) {
        NSDictionary *ret = @{@"code": @(error.code), @"msg":error.description};
        callback(@[ret]);
      }
  ];
  
}

+ (instancetype) sharedInstance
{
  static AlibcSdkBridge *instance = nil;
  if (!instance) {
    instance = [[AlibcSdkBridge alloc] init];
  }
  return instance;
}

@end
