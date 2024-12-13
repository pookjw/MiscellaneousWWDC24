//
//  WatchConnectivityFileTransferView.h
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 12/13/24.
//

#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatchConnectivityFileTransferView : NSObject
@property (retain, nonatomic, readonly, direct) WCSessionFileTransfer *fileTransfer;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFileTransfer:(WCSessionFileTransfer *)fileTransfer __attribute__((objc_direct));
@end

NS_ASSUME_NONNULL_END
