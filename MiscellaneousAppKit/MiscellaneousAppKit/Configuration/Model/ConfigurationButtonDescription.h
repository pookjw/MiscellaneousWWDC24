//
//  ConfigurationButtonDescription.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/14/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfigurationButtonDescription : NSObject <NSCopying>
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly, nullable) NSMenu *menu;
@property (assign, nonatomic, readonly) BOOL showsMenuAsPrimaryAction;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (ConfigurationButtonDescription *)descriptionWithTitle:(NSString *)title;
+ (ConfigurationButtonDescription *)descriptionWithTitle:(NSString *)title menu:(NSMenu *)menu showsMenuAsPrimaryAction:(BOOL)showsMenuAsPrimaryAction;
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title menu:(NSMenu *)menu showsMenuAsPrimaryAction:(BOOL)showsMenuAsPrimaryAction;
@end

NS_ASSUME_NONNULL_END
