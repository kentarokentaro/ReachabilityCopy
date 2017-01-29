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
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    if(reachability != NULL)
    {
        returnValue = [self new];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
        }
        else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}

// IPアドレスを取得する
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, hostAddress);
    
    ReachabilityCopy* returnValue = NULL;
    
    if (reachability != NULL)
    {
        returnValue = [self new];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
        }
        else {
            CFRelease(reachability);
        }
    }
    
    return returnValue;
}

// デフォルトルートの利用可能をチェックする
+ (instancetype)reachabilityForInternetConnection
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self reachabilityWithAddress:(const struct sockaddr *) &zeroAddress];
}

#pragma mark reachabilityForLocalWiFI

#pragma mark - Start and stop notifier
- (BOOL)startNotifier
{
    BOOL returnValue = NO;
    SCNetworkReachabilityContext context = {0, (__bridge void*)(self), NULL, NULL, NULL};
    
    if (SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context))
    {
        if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {
            returnValue = YES;
        }
    }
    
    return returnValue;
}

- (void)stopNotifier
{
    if (_reachabilityRef != NULL) {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

- (void)dealloc
{
    [self stopNotifier];
    if (_reachabilityRef != NULL)
    {
        CFRelease(_reachabilityRef);
    }
}

#pragma mark - Network Flag Handling

- (NetworkStatus)networkStatusForFlags:(SCNetworkConnectionFlags)flags
{
    PrintReachabilityFlags(flags, "networkStatusForFlags");
    
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        return NotReachable;
    }
    
    NetworkStatus returnValue = NotReachable;
    
    // Wifi
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        returnValue = ReachableViaWiFi;
    }
    
    // Wifi
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) ==0 ) {
            returnValue = ReachableViaWiFi;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        returnValue = ReachableViaWWAN;
    }
    
    
    return returnValue;
}

- (BOOL)connectionRequired
{
    NSAssert(_reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
    }
    return NO;
}

// ステータスを返す（enumで設定した値）
- (NetworkStatus)currentRechabilityStatus
{
    NSAssert(_reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
    NetworkStatus returnValue = NotReachable;
    SCNetworkConnectionFlags flags;
    
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        returnValue = [self networkStatusForFlags:flags];
    }
    
    return returnValue;
}

@end
