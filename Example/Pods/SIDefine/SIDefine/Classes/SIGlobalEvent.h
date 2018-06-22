//
//  SIGlobalEvent.h
//  SuperId
//
//  Created by Ye Tao on 2017/3/23.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#ifndef SIGlobalEvent_h
#define SIGlobalEvent_h

#define kSILoginSuccessMessage @"kSILoginSuccessMessage"

#define kSIAutoLoginMessage @"kSIAutoLoginMessage"

#define kSIUpdateUserInfoSuccessMessage @"kSIUpdateUserInfoSuccessMessage"

#define kSIOfflineMessage @"kSIOfflineMessage"

#define kSILogoutSuccessMessage @"kSILogoutSuccessMessage"

#define kSIEventMessage @"kSIEventMessage"

#define kSISchemeMessage @"kSISchemeMessage"

#define kSIRequestStatusMessage @"SIRequestStatus"

typedef NS_ENUM(NSUInteger, SIEventType) {
    SIEventTypeLogin,
    SIEventTypeLogout,
    SIEventType403,
    SIEventTypeOffline,
    SIEventTypeF2B,
    SIEventTypeB2F,
};

@protocol SIEventTypeProtocol <NSObject>

- (void)handlerWithEvent:(SIEventType)event;

@end

#endif /* SIGlobalEvent_h */
