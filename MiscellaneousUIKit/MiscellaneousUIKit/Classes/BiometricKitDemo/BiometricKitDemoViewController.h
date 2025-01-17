//
//  BiometricKitDemoViewController.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 1/5/25.
//

#import <TargetConditionals.h>

#if TARGET_OS_IOS && !TARGET_OS_SIMULATOR

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BiometricKitDemoViewController : UICollectionViewController

@end

NS_ASSUME_NONNULL_END

#endif
