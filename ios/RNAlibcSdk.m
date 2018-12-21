//
//  RNAlibcSdk.m
//  react_native_calendar
//
//  Created by petitspois on 08/04/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "RNAlibcSdk.h"
#import "AlibcSdkBridge.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>

@implementation RNAlibcSdk

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(init,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  [[AlibcSdkBridge sharedInstance] init:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(show: (NSDictionary *)param callback: (RCTResponseSenderBlock)callback){
  [[AlibcSdkBridge sharedInstance] show:param callback:callback];
}

@end


