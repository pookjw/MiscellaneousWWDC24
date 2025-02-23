//
//  PasteboardItemDemoView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import "PasteboardItemDemoView.h"
#import "ConfigurationView.h"
#import "allNSPasteboardTypes.h"
#import "allNSPasteboardMetadataTypes.h"
#import "allNSPasteboardDetectionPatterns.h"

@interface PasteboardItemDemoView () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_pasteboardItem) NSPasteboardItem *pasteboardItem;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@end

@implementation PasteboardItemDemoView
@synthesize pasteboardItem = _pasteboardItem;
@synthesize configurationView = _configurationView;

- (instancetype)initWithFrame:(NSRect)frameRect pasteboardItem:(NSPasteboardItem *)pasteboardItem {
    if (self = [super initWithFrame:frameRect]) {
        _pasteboardItem = [pasteboardItem retain];
        
        ConfigurationView *configurationView = self.configurationView;
        configurationView.frame = self.bounds;
        configurationView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:configurationView];
        
        [self _reload];
    }
    
    return self;
}

- (void)dealloc {
    [_pasteboardItem release];
    [_configurationView release];
    [super dealloc];
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    
    _configurationView = configurationView;
    return configurationView;
}

- (void)_reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    
    NSMutableArray<ConfigurationItemModel *> *itemModels = [NSMutableArray new];
    
    [itemModels addObject: [self _makeTypesItemModel]];
    
    if ([self.pasteboardItem.types containsObject:NSPasteboardTypeString]) {
        [itemModels addObject:[self _makeStringItemModel]];
    }
    
    [itemModels addObjectsFromArray:@[
        [self _makeAvailableTypeFromArrayItemModel],
        [self _makeDetectMetadataForTypesItemModel],
        [self _makeDetectPatternsForPatternsItemModel],
        [self _makeDetectValuesForPatternsItemModel]
    ]];
    
    [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:[NSNull null]];
    [itemModels release];
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:NO];
    [snapshot release];
}

- (ConfigurationItemModel *)_makeTypesItemModel {
    NSPasteboardItem *pasteboardItem = self.pasteboardItem;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Types"
                                            userInfo:nil
                                               label:@"Types"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:pasteboardItem.types selectedTitles:@[] selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeStringItemModel {
    NSPasteboardItem *pasteboardItem = self.pasteboardItem;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"String"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"String : %@", [pasteboardItem stringForType:NSPasteboardTypeString]];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Menu"];
    }];
}

- (ConfigurationItemModel *)_makeAvailableTypeFromArrayItemModel {
    NSPasteboardItem *pasteboardItem = self.pasteboardItem;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Available Type From Array"
                                            userInfo:nil
                                               label:@"Available Type From Array"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<NSPasteboardType> *types = allNSPasteboardTypes;
        NSMutableArray<NSString *> *availableTitles = [NSMutableArray new];
        NSMutableArray<NSString *> *unavailableTitles = [NSMutableArray new];
        for (NSPasteboardType type in types) {
            NSPasteboardType _Nullable result = [pasteboardItem availableTypeFromArray:@[type]];
            BOOL available = [result isEqualToString:type];
            NSString *title = [NSString stringWithFormat:@"%@ : %@", available ? @"Available" : @"Not Available", type];
            
            if (available) {
                [availableTitles addObject:title];
            } else {
                [unavailableTitles addObject:title];
            }
        }
        
        NSArray<NSString *> *titles = [availableTitles arrayByAddingObjectsFromArray:unavailableTitles];
        [availableTitles release];
        [unavailableTitles release];
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[] selectedDisplayTitle:nil];
        return description;
    }];
}



- (ConfigurationItemModel *)_makeDetectMetadataForTypesItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Detect Metadata For Patterns"
                                            userInfo:nil
                                               label:@"Detect Metadata For Patterns"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:allNSPasteboardMetadataTypes selectedTitles:@[] selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeDetectPatternsForPatternsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Detect Patterns For Patterns"
                                            userInfo:nil
                                               label:@"Detect Patterns For Patterns"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:allNSPasteboardDetectionPatterns selectedTitles:@[] selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeDetectValuesForPatternsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Detect Values For Patterns"
                                            userInfo:nil
                                               label:@"Detect Values For Patterns"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:allNSPasteboardDetectionPatterns selectedTitles:@[] selectedDisplayTitle:nil];
    }];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    NSString *identifier = itemModel.identifier;
    NSPasteboardItem *pasteboardItem = self.pasteboardItem;
    __block auto unretainedSelf = self;
    
    if ([identifier isEqualToString:@"String"]) {
        assert([pasteboardItem.types containsObject:NSPasteboardTypeString]);
        
        NSAlert *alert = [NSAlert new];
        
        alert.messageText = @"Edit String";
        
        NSTextField *accessoryView = [NSTextField new];
        accessoryView.stringValue = [pasteboardItem stringForType:NSPasteboardTypeString];
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        
        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
            [pasteboardItem setString:accessoryView.stringValue forType:NSPasteboardTypeString];
            [configurationView reconfigureItemModelsWithIdentifiers:@[@"String"]];
        }];
        [accessoryView release];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Available Type From Array"]) {
        return NO;
    } else if ([identifier isEqualToString:@"Detect Metadata For Patterns"]) {
        NSPasteboardMetadataType type = static_cast<NSPasteboardMetadataType>(newValue);
        
        [pasteboardItem detectMetadataForTypes:[NSSet setWithObject:type] completionHandler:^(NSDictionary<NSPasteboardMetadataType,id> * _Nullable detectedMetadata, NSError * _Nullable error) {
            assert(error == nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAlert *alert = [NSAlert new];
                alert.messageText = @"Detected Metadata";
                
                if (detectedMetadata != nil) {
                    alert.informativeText = detectedMetadata.description;
                } else {
                    alert.informativeText = @"nil";
                }
                
                [alert beginSheetModalForWindow:unretainedSelf.window completionHandler:^(NSModalResponse returnCode) {
                    
                }];
                [alert release];
            });
        }];
        
        return NO;
    } else if ([identifier isEqualToString:@"Detect Values For Patterns"]) {
        NSPasteboardDetectionPattern pattern = static_cast<NSPasteboardDetectionPattern>(newValue);
        
        [pasteboardItem detectValuesForPatterns:[NSSet setWithObject:pattern] completionHandler:^(NSDictionary<NSPasteboardDetectionPattern,id> * _Nullable detectedValues, NSError * _Nullable error) {
            assert(error == nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAlert *alert = [NSAlert new];
                alert.messageText = @"Detected Values";
                
                if (detectedValues != nil) {
                    alert.informativeText = detectedValues.description;
                } else {
                    alert.informativeText = @"nil";
                }
                
                [alert beginSheetModalForWindow:unretainedSelf.window completionHandler:^(NSModalResponse returnCode) {
                    
                }];
                [alert release];
            });
        }];
        
        return NO;
    } else if ([identifier isEqualToString:@"Detect Patterns For Patterns"]) {
        NSPasteboardDetectionPattern pattern = static_cast<NSPasteboardDetectionPattern>(newValue);
        
        [pasteboardItem detectPatternsForPatterns:[NSSet setWithObject:pattern] completionHandler:^(NSSet<NSPasteboardDetectionPattern> * _Nullable detectedPatterns, NSError * _Nullable error) {
            assert(error == nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAlert *alert = [NSAlert new];
                alert.messageText = @"Detected Patterns";
                
                if (detectedPatterns != nil) {
                    alert.informativeText = detectedPatterns.description;
                } else {
                    alert.informativeText = @"nil";
                }
                
                [alert beginSheetModalForWindow:unretainedSelf.window completionHandler:^(NSModalResponse returnCode) {
                    
                }];
                [alert release];
            });
        }];
        
        return NO;
    } else {
        abort();
    }
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
