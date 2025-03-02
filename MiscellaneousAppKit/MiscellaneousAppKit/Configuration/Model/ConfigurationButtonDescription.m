//
//  ConfigurationButtonDescription.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/14/25.
//

#import "ConfigurationButtonDescription.h"
#import "ConfigurationButtonDescription+Private.h"

@interface ConfigurationButtonDescription ()
@property (copy, nonatomic, readonly, nullable) NSMenu *menu;
@end

@implementation ConfigurationButtonDescription

+ (ConfigurationButtonDescription *)descriptionWithTitle:(NSString *)title {
    return [[[ConfigurationButtonDescription alloc] initWithTitle:title] autorelease];
}

+ (ConfigurationButtonDescription *)descriptionWithTitle:(NSString *)title menu:(NSMenu *)menu showsMenuAsPrimaryAction:(BOOL)showsMenuAsPrimaryAction {
    return [[[ConfigurationButtonDescription alloc] initWithTitle:title menu:menu showsMenuAsPrimaryAction:showsMenuAsPrimaryAction] autorelease];
}

- (instancetype)initWithTitle:(NSString *)title {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    return [self initWithTitle:title menu:nil showsMenuAsPrimaryAction:NO];
#pragma clang diagnostic pop
}

- (instancetype)initWithTitle:(NSString *)title menu:(NSMenu *)menu showsMenuAsPrimaryAction:(BOOL)showsMenuAsPrimaryAction {
    if (self = [super init]) {
        _title = [title copy];
        _menu = [menu copy];
        _showsMenuAsPrimaryAction = showsMenuAsPrimaryAction;
    }
    
    return self;
}

- (void)dealloc {
    [_title release];
    [_menu release];
    [super dealloc];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [self retain];
}

@end
