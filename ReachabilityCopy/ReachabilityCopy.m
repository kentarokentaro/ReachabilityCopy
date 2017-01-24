//
//  ReachabilityCopy.m
//  ReachabilityCopy
//
//  Created by Kentaro Miura on 2017/01/24.
//
//

#import "ReachabilityCopy.h"

@implementation ReachabilityCopy

// ホストネームを取得する
+ (instancetype)reachabilityWithHostName:(NSString*)hostName
{
    ReachabilityCopy* returnValue = NULL;
    return returnValue;
}

// IPアドレスを取得する
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress
{
    ReachabilityCopy* returnValue = NULL;
    return returnValue;
}

// デフォルトルートの利用可能をチェックする
+ (instancetype)reachabilityForInternetConnection
{
    return NULL;
}

#pragma mark reachabilityForLocalWiFI

- (BOOL)startNotifier
{
    BOOL returnValue = NO;
    return returnValue;
}

- (void)stopNotifier
{
}

// ステータスを返す（enumで設定した値）
- (NetworkStatus)currentRechabilityStatus
{
    NetworkStatus returnValue = NotReachable;
    return returnValue;
}

- (BOOL)connectionRequiered
{
    return NO;
}

@end
