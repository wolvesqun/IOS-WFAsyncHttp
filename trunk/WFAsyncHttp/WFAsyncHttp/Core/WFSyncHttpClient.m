//
//  WFSyncHttpClient.m
//  WFAsyncHttp
//
//  Created by mba on 15-10-10.
//  Copyright (c) 2015年 wolf. All rights reserved.
//

#import "WFSyncHttpClient.h"
#import "WFAsyncHttpUtil.h"
#import "NSMutableURLRequest+WFAsyncHttpMutableURLRequest.h"

@implementation WFSyncHttpClient


#pragma mark - 网络请求接口
+ (void)System_Request_WithURLString:(NSString *)URLString
                           andParams:(NSDictionary *)params
                          andHeaders:(NSDictionary *)headers
                       andHttpMethod:(NSString *)httpMethod
                          andSuccess:(WFSuccessAsyncHttpDataCompletion)success
                          andFailure:(WFFailureAsyncHttpDataCompletion)failure
{
    // *** 传入参数无效
    if([WFAsyncHttpUtil handlerParamErrorWithURLString:URLString andSuccess:success andFailure:failure]) return;
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:10];
    
    [request setHTTPMethod:httpMethod];
    [request addHttpHeaderWithRequest:[NSMutableDictionary dictionaryWithDictionary:headers]];
    [request addParamWithDict:params];
    
    // *** start
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if(error == nil)
    {
        if(success)
        {
            NSError *error = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if(error == nil)
            {
                success(jsonObject);
            }
            else
            {
                success(data);
            }
            
        }
    }
    else
    {
        if(failure)
        {
            failure(error);
        }
    }
}

#pragma mark - GET请求
+ (void)System_GET_WithURLString:(NSString *)URLString
                      andHeaders:(NSDictionary *)headers
                      andSuccess:(WFSuccessAsyncHttpDataCompletion)success
                      andFailure:(WFFailureAsyncHttpDataCompletion)failure
{
    [self System_Request_WithURLString:URLString andParams:nil andHeaders:headers andHttpMethod:kWFHttpRequestType_GET andSuccess:success andFailure:failure];
}

+ (void)System_GET_WithURLString:(NSString *)URLString
                    andUserAgent:(NSString *)userAgent
                      andSuccess:(WFSuccessAsyncHttpDataCompletion)success
                      andFailure:(WFFailureAsyncHttpDataCompletion)failure
{
    
    [self System_GET_WithURLString:URLString andHeaders:[WFAsyncHttpUtil getUserAgentWithValue:userAgent] andSuccess:success andFailure:failure];
}

+ (void)System_GET_WithURLString:(NSString *)URLString
                      andSuccess:(WFSuccessAsyncHttpDataCompletion)success
                      andFailure:(WFFailureAsyncHttpDataCompletion)failure
{
    [self System_GET_WithURLString:URLString andUserAgent:nil andSuccess:success andFailure:failure];
}

#pragma mark - POST请求
+ (void)System_POST_WithURLString:(NSString *)URLString
                        andParams:(NSDictionary *)params
                       andSuccess:(WFSuccessAsyncHttpDataCompletion)success
                       andFailure:(WFFailureAsyncHttpDataCompletion)failure
{
    [self System_Request_WithURLString:URLString andParams:params andHeaders:nil andHttpMethod:kWFHttpRequestType_POST andSuccess:success andFailure:failure];
}

+ (void)System_POST_WithURLString:(NSString *)URLString
                        andParams:(NSDictionary *)params
                       andHeaders:(NSDictionary *)headers
                       andSuccess:(WFSuccessAsyncHttpDataCompletion)success
                       andFailure:(WFFailureAsyncHttpDataCompletion)failure
{
    [self System_Request_WithURLString:URLString andParams:params andHeaders:headers andHttpMethod:kWFHttpRequestType_POST andSuccess:success andFailure:failure];
}

+ (void)System_POST_WithURLString:(NSString *)URLString
                        andParams:(NSDictionary *)params
                     andUserAgent:(NSString *)userAgent
                       andSuccess:(WFSuccessAsyncHttpDataCompletion)success
                       andFailure:(WFFailureAsyncHttpDataCompletion)failure
{
    [self System_POST_WithURLString:URLString andParams:params andHeaders:[WFAsyncHttpUtil getUserAgentWithValue:userAgent] andSuccess:success andFailure:failure];
}

+ (void)System_POST_WithURLString:(NSString *)URLString
                       andSuccess:(WFSuccessAsyncHttpDataCompletion)success
                       andFailure:(WFFailureAsyncHttpDataCompletion)failure
{
    [self System_POST_WithURLString:URLString andParams:nil andSuccess:success andFailure:failure];
}


@end