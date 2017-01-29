//
//  ReachabilityCopy.h
//  ReachabilityCopy
//
//  Created by Kentaro Miura on 2017/01/24.
//
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


// connect type
typedef enum : NSUInteger {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN,
} NetworkStatus;

#pragma mark IPv6 Support

extern NSString *kReachabilityChangedNotification;

@interface ReachabilityCopy : NSObject

// ホストネームを取得する
+ (instancetype)reachabilityWithHostName:(NSString*)hostName;

// IPアドレスを取得する
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

// デフォルトルートの利用可能をチェックする
+ (instancetype)reachabilityForInternetConnection;

#pragma mark reachabilityForLocalWiFI

- (BOOL)startNotifier;
- (void)stopNotifier;

// ステータスを返す（enumで設定した値）
- (NetworkStatus)currentRechabilityStatus;

- (BOOL)connectionRequired;

@end
