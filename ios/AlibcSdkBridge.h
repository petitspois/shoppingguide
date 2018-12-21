//
//  AlibcSdkBridge.h
//  react_native_calendar
//
//  Created by petitspois on 08/04/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>

@interface AlibcSdkBridge : NSObject

-(void)init:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)show: (NSDictionary *)param callback: (RCTResponseSenderBlock)callback;
- (void)_show: (id<AlibcTradePage>)page callback: (RCTResponseSenderBlock)callback;
+ (instancetype)sharedInstance;

@end



