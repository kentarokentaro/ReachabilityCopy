//
//  ReachabilityCopy.m
//  ReachabilityCopy
//
//  Created by Kentaro Miura on 2017/01/24.
//
//

#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>

#import <CoreFoundation/CoreFoundation.h>

#import "ReachabilityCopy.h"

#pragma mark IPv6 Support

NSString *kReachabilityChangedNotification = @"kNetworkReachabilityChangedNotification";

#pragma mark - Supporting functions

#define kShouldPrintReachabilityFlags 1

static void PrintReachabilityFlags(SCNetworkReachabilityFlags flags, const char* comment)
{
#if kShouldPrintReachabilityFlags
    
    NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
          (flags & kSCNetworkReachabilityFlagsIsWWAN)				? 'W' : '-',
          (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
          
          (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
          (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
          (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
          comment
          );

#endif
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unsede ( target, flags )
    NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
    NSCAssert([(__bridge NSObject*) info isKindOfClass: [ReachabilityCopy class]],@"info was wrong class in ReachabilityCallback" );
    
    ReachabilityCopy* noteObject = (__bridge ReachabilityCopy *)info;
    [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:noteObject];
}

#pragma mark - Reachabilibty implementation

@implementation ReachabilityCopy
{
    // ネットワークアドレスまたはネットワーク名のハンドル
    SCNetworkReachabilityRef _reachabilityRef;
}

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
