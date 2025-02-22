//
//  PasteboardDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import "PasteboardDemoViewController.h"
#import "ConfigurationView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface PasteboardDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_pasteboard) NSPasteboard *pasteboard;
@end

@implementation PasteboardDemoViewController
@synthesize configurationView = _configurationView;
@synthesize pasteboard = _pasteboard;

- (void)dealloc {
    [_configurationView release];
    [_pasteboard release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ConfigurationView *configurationView = self.configurationView;
    configurationView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    configurationView.frame = self.view.bounds;
    [self.view addSubview:configurationView];
    
    [self _reload];
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    configurationView.showBlendedBackground = YES;
    
    _configurationView = configurationView;
    return configurationView;
}

- (NSPasteboard *)_pasteboard {
    if (auto pasteboard = _pasteboard) return pasteboard;
    
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
    
    _pasteboard = [pasteboard retain];
    return pasteboard;
}

- (void)_reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:@[
        [self _makeNameItemModel]
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:NO];
    [snapshot release];
}

- (ConfigurationItemModel *)_makeNameItemModel {
    NSPasteboard *pasteboard = self.pasteboard;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Name"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Name : %@", pasteboard.name];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    NSString *identifier = itemModel.identifier;
    
    abort();
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    
}

@end
