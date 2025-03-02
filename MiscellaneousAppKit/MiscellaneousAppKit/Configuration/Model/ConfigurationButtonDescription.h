//
//  ConfigurationButtonDescription.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/14/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

NS_REFINED_FOR_SWIFT
@interface ConfigurationButtonDescription : NSObject <NSCopying>
@property (copy, nonatomic, readonly) NSString *title;
@property (assign, nonatomic, readonly) BOOL showsMenuAsPrimaryAction;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (ConfigurationButtonDescription *)descriptionWithTitle:(NSString *)title;
+ (ConfigurationButtonDescription *)descriptionWithTitle:(NSString *)title menu:(NSMenu *)menu showsMenuAsPrimaryAction:(BOOL)showsMenuAsPrimaryAction;
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title menu:(NSMenu *)menu showsMenuAsPrimaryAction:(BOOL)showsMenuAsPrimaryAction;
@end

NS_ASSUME_NONNULL_END
