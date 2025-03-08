//
//  CanvasViewController.h
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <UIKit/UIKit.h>
#import <MyCanvasData/MyCanvasData.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface CanvasViewController : UIViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithCanvas:(MCCanvas *)canvas;
@end

NS_ASSUME_NONNULL_END
