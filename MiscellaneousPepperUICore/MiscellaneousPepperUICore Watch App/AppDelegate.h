//
//  AppDelegate.h
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/1/24.
//

#import <WatchKit/WatchKit.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface AppDelegate : NSObject
@property (retain, nonatomic, readonly) id extensionConnection;
@end

NS_ASSUME_NONNULL_END
