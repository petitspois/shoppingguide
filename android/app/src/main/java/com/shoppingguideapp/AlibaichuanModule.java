package com.shoppingguideapp;


import com.alibaba.baichuan.android.trade.AlibcTrade;
import com.alibaba.baichuan.android.trade.AlibcTradeSDK;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeCallback;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeInitCallback;
import com.alibaba.baichuan.android.trade.constants.AlibcConstants;
import com.alibaba.baichuan.android.trade.model.AlibcShowParams;
import com.alibaba.baichuan.android.trade.model.AlibcTaokeParams;
import com.alibaba.baichuan.android.trade.model.OpenType;
import com.alibaba.baichuan.android.trade.model.TradeResult;
import com.alibaba.baichuan.android.trade.page.AlibcBasePage;
import com.alibaba.baichuan.android.trade.page.AlibcPage;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;

import java.util.HashMap;
import java.util.Map;

public class AlibaichuanModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private static final String TAG = "AlibaichuanModule";
    private final static String INVALID_PARAM = "invalid";

    private Map<String, String> exParams;//yhhpass参数
    private AlibcShowParams alibcShowParams;//页面打开方式，默认，H5，Native
    private AlibcTaokeParams alibcTaokeParams = new AlibcTaokeParams("mm_133381264_167800014_51139000127", null, null);//淘客参数，包括pid，unionid，subPid


    public AlibaichuanModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        alibcShowParams = new AlibcShowParams(OpenType.Native, false);
        exParams = new HashMap<>();
        exParams.put(AlibcConstants.ISV_CODE, "rnappisvcode");
    }



    @Override
    public String getName(){
        return "RNAlibcSdk";
    }

    @ReactMethod
    public void init(final Promise promise){
        AlibcTradeSDK.asyncInit(super.getCurrentActivity().getApplication(), new AlibcTradeInitCallback() {
            @Override
            public void onSuccess() {
                promise.resolve("success");
            }

            @Override
            public void onFailure(int code, String msg) {
                //初始化失败，可以根据code和msg判断失败原因，详情参见错误说明
                WritableMap map = Arguments.createMap();
                map.putInt("code", code);
                map.putString("msg", msg);
                promise.resolve(map);
            }
        });
    }

    @ReactMethod
    public void show(final ReadableMap param, final Callback callback) {
        String type = param.getString("type");
        switch(type){
            case "url":
                this._show(new AlibcPage(param.getString("payload")), callback);
                break;
            default:
                callback.invoke(INVALID_PARAM);
                break;
        }
    }

    private void _show(AlibcBasePage page, final Callback callback) {
        AlibcTrade.show(getCurrentActivity(),
                page,
                this.alibcShowParams,
                this.alibcTaokeParams,
                this.exParams,
                new AlibcTradeCallback() {
                    @Override
                    public void onTradeSuccess(TradeResult tradeResult) {
                        callback.invoke(tradeResult);
                    }

                    @Override
                    public void onFailure(int code, String msg) {
                        WritableMap map = Arguments.createMap();
                        map.putString("type", "error");
                        map.putInt("code", code);
                        map.putString("msg", msg);
                        callback.invoke(msg);
                    }
                });
    }

}