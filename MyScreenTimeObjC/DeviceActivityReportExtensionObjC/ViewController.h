//
//  ViewController.h
//  DeviceActivityReportExtensionObjC
//
//  Created by Jinwoo Kim on 4/26/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController
@property (retain, nonatomic, nullable) NSXPCConnection *connection;
@end

NS_ASSUME_NONNULL_END
