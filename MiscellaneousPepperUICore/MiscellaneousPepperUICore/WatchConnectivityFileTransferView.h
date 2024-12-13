//
//  WatchConnectivityFileTransferView.h
//  MiscellaneousPepperUICore
//
//  Created by Jinwoo Kim on 12/13/24.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatchConnectivityFileTransferView : UIView
@property (retain, nonatomic, readonly) WCSessionFileTransfer *fileTransfer;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFileTransfer:(WCSessionFileTransfer *)fileTransfer;
@end

NS_ASSUME_NONNULL_END
