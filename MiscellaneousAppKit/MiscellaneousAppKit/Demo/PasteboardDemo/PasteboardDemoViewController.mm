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
#import "NSStringFromNSPasteboardAccessBehavior.h"
#import "PasteboardDemoSetStringView.h"
#import "allNSPasteboardTypes.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import "NSStringFromNSPasteboardContentsOptions.h"
#include <vector>
#include <ranges>
#import "PasteboardDemoWriteObjectsView.h"
#import "allNSPasteboardDetectionPatterns.h"
#import "allNSPasteboardMetadataTypes.h"
#import "PasteboardDemoDetectView.h"
#import "ActionResolver.h"
#import "PasteboardItemDemoView.h"

UT_EXPORT NSArray<UTType *> *_UTGetAllCoreTypesConstants(void);

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
        [self _makePasteboardItemConfigurationItemModel],
        [self _makeDetectPatternsForPatternsAtIndexItemModel],
        [self _makeDetectPatternsForPatternsItemModel],
        [self _makeDetectValuesForPatternsAtIndexItemModel],
        [self _makeDetectValuesForPatternsItemModel],
        [self _makeDetectMetadataForTypesAtIndexItemModel],
        [self _makeDetectMetadataForTypesItemModel],
        [self _writeImageItemModel],
        [self _makeWriteObjectsItemModel],
        [self _makePrepareForNewContentsWithOptionsItemModel],
        [self _makeTypesFilterableToItemModel],
        [self _makeTypesItemModel],
        [self _makeCanReadObjectForClassesOptionsItemModel],
        [self _makeCanReadItemWithDataConformingToTypesItemModel],
        [self _makeAvailableTypeFromArrayItemModel],
        [self _makeIndexOfPasteboardItemItemModel],
        [self _makeStringForTypeItemModel],
        [self _makeReadObjectsForClassesOptionsItemModel],
        [self _makeClearContentsItemModel],
        [self _makePasteboardItemsItemModel],
        [self _makeSetStringForTypeItemModel],
        [self _makeChangeCountItemModel],
        [self _makeAccessBehaviorItemModel],
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

- (ConfigurationItemModel *)_makeAccessBehaviorItemModel {
    NSPasteboard *pasteboard = self.pasteboard;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Access Behavior"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Access Behavior : %@", NSStringFromNSPasteboardAccessBehavior(pasteboard.accessBehavior)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeChangeCountItemModel {
    NSPasteboard *pasteboard = self.pasteboard;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Change Count"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Change Count : %ld", pasteboard.changeCount];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeSetStringForTypeItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Set String For Type"
                                            userInfo:nil
                                               label:@"Set String For Type"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
    }];
}

- (ConfigurationItemModel *)_makePasteboardItemsItemModel {
    NSPasteboard *pasteboard = self.pasteboard;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Pasteboard Items"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Pasteboard Items : %ld", pasteboard.pasteboardItems.count];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<NSPasteboardItem *> *pasteboardItems = pasteboard.pasteboardItems;
        NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithCapacity:pasteboardItems.count];
        for (NSPasteboardItem *item in pasteboardItems) {
            [titles addObject:item.description];
        }
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[] selectedDisplayTitle:nil];
        [titles release];
        return description;
    }];
}

- (ConfigurationItemModel *)_makeClearContentsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Clear Contents"
                                            userInfo:nil
                                               label:@"Clear Contents"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeReadObjectsForClassesOptionsItemModel {
    NSPasteboard *pasteboard = self.pasteboard;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Read Objects For Classes Options"
                                            userInfo:nil
                                               label:@"Read Objects For Classes Options"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<NSString *> *titles = [pasteboard readObjectsForClasses:@[[NSString class]] options:@{}];
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[] selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeStringForTypeItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"String For Type"
                                            userInfo:nil
                                               label:@"String For Type"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:allNSPasteboardTypes
                                                           selectedTitles:@[]
                                                     selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeIndexOfPasteboardItemItemModel {
    NSPasteboard *pasteboard = self.pasteboard;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Index Of Pasteboard Item"
                                            userInfo:nil
                                               label:@"Index Of Pasteboard Item"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<NSPasteboardItem *> *pasteboardItems = pasteboard.pasteboardItems;
        NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithCapacity:pasteboardItems.count];
        for (NSPasteboardItem *pasteboardItem in pasteboardItems) {
            NSString *title = [NSString stringWithFormat:@"%ld : %@", [pasteboard indexOfPasteboardItem:pasteboardItem], pasteboardItem];
            [titles addObject:title];
        }
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[] selectedDisplayTitle:nil];
        [titles release];
        return description;
    }];
}

- (ConfigurationItemModel *)_makeAvailableTypeFromArrayItemModel {
    NSPasteboard *pasteboard = self.pasteboard;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Available Type From Array"
                                            userInfo:nil
                                               label:@"Available Type From Array"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<NSPasteboardType> *types = allNSPasteboardTypes;
        NSMutableArray<NSString *> *availableTitles = [NSMutableArray new];
        NSMutableArray<NSString *> *unavailableTitles = [NSMutableArray new];
        for (NSPasteboardType type in types) {
            NSPasteboardType _Nullable result = [pasteboard availableTypeFromArray:@[type]];
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

- (ConfigurationItemModel *)_makeCanReadItemWithDataConformingToTypesItemModel {
    NSPasteboard *pasteboard = self.pasteboard;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Can Read Item With Data Conforming To Types"
                                            userInfo:nil
                                               label:@"Can Read Item With Data Conforming To Types"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<UTType *> *allTypes = _UTGetAllCoreTypesConstants();
        NSMutableArray<NSString *> *availableTitles = [NSMutableArray new];
        NSMutableArray<NSString *> *unavailableTitles = [NSMutableArray new];
        for (UTType *type in allTypes) {
            BOOL available = [pasteboard canReadItemWithDataConformingToTypes:@[type.identifier]];
            NSString *title = [NSString stringWithFormat:@"%@ : %@", available ? @"Available" : @"Not Available", type.identifier];
            
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

- (ConfigurationItemModel *)_makeCanReadObjectForClassesOptionsItemModel {
    NSPasteboard *pasteboard = self.pasteboard;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Can Read Object For Classes Options"
                                            userInfo:nil
                                               label:@"Can Read Object For Classes Options"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<Class> *classes = @[
            [NSString class],
            [NSNumber class]
        ];
        
        NSMutableArray<NSString *> *availableTitles = [NSMutableArray new];
        NSMutableArray<NSString *> *unavailableTitles = [NSMutableArray new];
        for (Class _class in classes) {
            BOOL available = [pasteboard canReadObjectForClasses:@[_class] options:nil];
            NSString *title = [NSString stringWithFormat:@"%@ : %@", available ? @"Available" : @"Not Available", NSStringFromClass(_class)];
            
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

- (ConfigurationItemModel *)_makeTypesItemModel {
    NSPasteboard *pasteboard = self.pasteboard;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Types"
                                            userInfo:nil
                                               label:@"Types"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:pasteboard.types selectedTitles:@[] selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeTypesFilterableToItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Types Filterable To"
                                            userInfo:nil
                                               label:@"Types Filterable To"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:allNSPasteboardTypes selectedTitles:@[] selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makePrepareForNewContentsWithOptionsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Prepare For New Contents With Options"
                                            userInfo:nil
                                               label:@"Prepare For New Contents With Options"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSPasteboardContentsOptions *allOptions = allNSPasteboardContentsOptions(&count);
        
        auto titlesVector = std::views::iota(allOptions, allOptions + count)
        | std::views::transform([](const NSPasteboardContentsOptions *ptr) {
            return NSStringFromNSPasteboardContentsOptions(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVector.data() count:titlesVector.size()]
                                                           selectedTitles:@[]
                                                     selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeWriteObjectsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Write Objects"
                                            userInfo:nil
                                               label:@"Write Objects"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_writeImageItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Write Image"
                                            userInfo:nil
                                               label:@"Write Image"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
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

- (ConfigurationItemModel *)_makeDetectMetadataForTypesAtIndexItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Detect Metadata For Patterns At Index (Private)"
                                            userInfo:nil
                                               label:@"Detect Metadata For Patterns At Index (Private)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
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

- (ConfigurationItemModel *)_makeDetectPatternsForPatternsAtIndexItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Detect Patterns For Patterns At Index (Private)"
                                            userInfo:nil
                                               label:@"Detect Patterns For Patterns At Index (Private)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
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

- (ConfigurationItemModel *)_makeDetectValuesForPatternsAtIndexItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Detect Values For Patterns At Index (Private)"
                                            userInfo:nil
                                               label:@"Detect Values For Patterns At Index (Private)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
    }];
}

- (ConfigurationItemModel *)_makePasteboardItemConfigurationItemModel {
    NSPasteboard *pasteboard = self.pasteboard;
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Pasteboard Item Configuration"
                                            userInfo:nil
                                               label:@"Pasteboard Item Configuration"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        for (NSPasteboardItem *item in pasteboard.pasteboardItems) {
            NSMenuItem *menuItem = [NSMenuItem new];
            menuItem.title = item.description;
            
            ActionResolver *resolver = [ActionResolver resolver:^(id  _Nonnull sender) {
                NSAlert *alert = [NSAlert new];
                
                alert.messageText = @"Item Configuration";
                
                PasteboardItemDemoView *accessoryView = [[PasteboardItemDemoView alloc] initWithFrame:NSZeroRect pasteboardItem:item];
                accessoryView.frame = NSMakeRect(0., 0., 400., 400.);
                alert.accessoryView = accessoryView;
                [accessoryView release];
                
                [alert beginSheetModalForWindow:unretainedSelf.view.window completionHandler:^(NSModalResponse returnCode) {
                    
                }];
                [alert release];
            }];
            [resolver setupMenuItem:menuItem];
            
            [menu addItem:menuItem];
            [menuItem release];
        }
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (void)_reconfigureVariableItemModels {
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[
        @"Change Count",
        @"Pasteboard Items",
        @"Index Of Pasteboard Item",
        @"Available Type From Array",
        @"Read Objects For Classes Options",
        @"Can Read Item With Data Conforming To Types",
        @"Can Read Object For Classes Options",
        @"Types",
        @"Pasteboard Item Configuration"
    ]];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    NSString *identifier = itemModel.identifier;
    NSPasteboard *pasteboard = self.pasteboard;
    __block auto unretainedSelf = self;
    
    if ([identifier isEqualToString:@"Set String For Type"]) {
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Set String";
        
        PasteboardDemoSetStringView *accessoryView = [PasteboardDemoSetStringView new];
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            assert([pasteboard setString:accessoryView.string forType:accessoryView.pasteboardType]);
            [unretainedSelf _reconfigureVariableItemModels];
        }];
        
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Pasteboard Items"]) {
        return NO;
    } else if ([identifier isEqualToString:@"Clear Contents"]) {
        [pasteboard clearContents];
        [unretainedSelf _reconfigureVariableItemModels];
        return NO;
    } else if ([identifier isEqualToString:@"Read Objects For Classes Options"]) {
        return NO;
    } else if ([identifier isEqualToString:@"String For Type"]) {
        NSPasteboardType type = static_cast<NSPasteboardType>(newValue);
        NSString *string = [pasteboard stringForType:type];
        if (string == nil) string = @"nil";
        
        NSAlert *alert = [NSAlert new];
        alert.messageText = [NSString stringWithFormat:@"String for %@", type];
        alert.informativeText = string;
        
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Index Of Pasteboard Item"]) {
        return NO;
    } else if ([identifier isEqualToString:@"Available Type From Array"]) {
        return NO;
    } else if ([identifier isEqualToString:@"Can Read Item With Data Conforming To Types"]) {
        return NO;
    } else if ([identifier isEqualToString:@"Can Read Object For Classes Options"]) {
        return NO;
    } else if ([identifier isEqualToString:@"Types"]) {
        return NO;
    } else if ([identifier isEqualToString:@"Types Filterable To"]) {
        NSPasteboardType type = static_cast<NSPasteboardType>(newValue);
        NSArray<NSString *> *types = [[pasteboard class] typesFilterableTo:type];
        
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Data Types";
        alert.informativeText = types.description;
        
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        [pasteboard prepareForNewContentsWithOptions:NSPasteboardContentsCurrentHostOnly];
        return NO;
    } else if ([identifier isEqualToString:@"Prepare For New Contents With Options"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSPasteboardContentsOptions option = NSPasteboardContentsOptionsFromString(title);
        [pasteboard prepareForNewContentsWithOptions:option];
        return NO;
    } else if ([identifier isEqualToString:@"Write Objects"]) {
        NSAlert *alert = [NSAlert new];
        
        alert.messageText = @"Strings";
        
        PasteboardDemoWriteObjectsView *accessoryView = [PasteboardDemoWriteObjectsView new];
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            BOOL success = [pasteboard writeObjects:accessoryView.strings];
            assert(success);
            [unretainedSelf _reconfigureVariableItemModels];
        }];
        [accessoryView release];
        [alert release];
        
        [self _reconfigureVariableItemModels];
        return NO;
    } else if ([identifier isEqualToString:@"Write Image"]) {
        [pasteboard writeObjects:@[[NSImage imageWithSystemSymbolName:@"apple.intelligence" accessibilityDescription:nil]]];
        [self _reconfigureVariableItemModels];
        return NO;
    } else if ([identifier isEqualToString:@"Detect Metadata For Patterns"]) {
        NSPasteboardMetadataType type = static_cast<NSPasteboardMetadataType>(newValue);
        
        [pasteboard detectMetadataForTypes:[NSSet setWithObject:type] completionHandler:^(NSDictionary<NSPasteboardMetadataType,id> * _Nullable detectedMetadata, NSError * _Nullable error) {
            assert(error == nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAlert *alert = [NSAlert new];
                alert.messageText = @"Detected Metadata";
                
                if (detectedMetadata != nil) {
                    alert.informativeText = detectedMetadata.description;
                } else {
                    alert.informativeText = @"nil";
                }
                
                [alert beginSheetModalForWindow:unretainedSelf.view.window completionHandler:^(NSModalResponse returnCode) {
                    
                }];
                [alert release];
            });
        }];
        
        return NO;
    } else if ([identifier isEqualToString:@"Detect Metadata For Patterns At Index (Private)"]) {
        NSAlert *alert = [NSAlert new];
        
        PasteboardDemoDetectView *accessoryView = [[PasteboardDemoDetectView alloc] initWithFrame:NSZeroRect pasteboard:pasteboard type:PasteboardDemoDetectTypeMetadata];
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            NSInteger selectedPasteboardItemIndex = accessoryView.selectedPasteboardItemIndex;
            if (selectedPasteboardItemIndex == NSNotFound) {
                NSLog(@"Unexpected");
                return;
            }
            
            NSSet<NSString *> *selectedTypes = accessoryView.selectedTypes;
            if (selectedTypes.count == 0) {
                NSLog(@"Unexpected");
                return;
            }
            
            reinterpret_cast<void (*)(id, SEL, id, NSUInteger, id)>(objc_msgSend)(pasteboard, sel_registerName("_detectMetadataForTypes:atIndex:completionHandler:"), selectedTypes, selectedPasteboardItemIndex, ^(NSDictionary<NSPasteboardMetadataType,id> * _Nullable detectedMetadata, NSError * _Nullable error) {
                assert(error == nil);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSAlert *alert = [NSAlert new];
                    alert.messageText = @"Detected Metadata";
                    
                    if (detectedMetadata != nil) {
                        alert.informativeText = detectedMetadata.description;
                    } else {
                        alert.informativeText = @"nil";
                    }
                    
                    [alert beginSheetModalForWindow:unretainedSelf.view.window completionHandler:^(NSModalResponse returnCode) {
                        
                    }];
                    [alert release];
                });
            });
        }];
        [accessoryView release];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Detect Values For Patterns"]) {
        NSPasteboardDetectionPattern pattern = static_cast<NSPasteboardDetectionPattern>(newValue);
        
        [pasteboard detectValuesForPatterns:[NSSet setWithObject:pattern] completionHandler:^(NSDictionary<NSPasteboardDetectionPattern,id> * _Nullable detectedValues, NSError * _Nullable error) {
            assert(error == nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAlert *alert = [NSAlert new];
                alert.messageText = @"Detected Values";
                
                if (detectedValues != nil) {
                    alert.informativeText = detectedValues.description;
                } else {
                    alert.informativeText = @"nil";
                }
                
                [alert beginSheetModalForWindow:unretainedSelf.view.window completionHandler:^(NSModalResponse returnCode) {
                    
                }];
                [alert release];
            });
        }];
        
        return NO;
    } else if ([identifier isEqualToString:@"Detect Values For Patterns At Index (Private)"]) {
        NSAlert *alert = [NSAlert new];
        
        PasteboardDemoDetectView *accessoryView = [[PasteboardDemoDetectView alloc] initWithFrame:NSZeroRect pasteboard:pasteboard type:PasteboardDemoDetectTypeValues];
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            NSInteger selectedPasteboardItemIndex = accessoryView.selectedPasteboardItemIndex;
            if (selectedPasteboardItemIndex == NSNotFound) {
                NSLog(@"Unexpected");
                return;
            }
            
            NSSet<NSString *> *selectedTypes = accessoryView.selectedTypes;
            if (selectedTypes.count == 0) {
                NSLog(@"Unexpected");
                return;
            }
            
            reinterpret_cast<void (*)(id, SEL, id, NSUInteger, id)>(objc_msgSend)(pasteboard, sel_registerName("_detectValuesForPatterns:atIndex:completionHandler:"), selectedTypes, selectedPasteboardItemIndex, ^(NSDictionary<NSPasteboardDetectionPattern,id> * _Nullable detectedValues, NSError * _Nullable error) {
                assert(error == nil);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSAlert *alert = [NSAlert new];
                    alert.messageText = @"Detected Values";
                    
                    if (detectedValues != nil) {
                        alert.informativeText = detectedValues.description;
                    } else {
                        alert.informativeText = @"nil";
                    }
                    
                    [alert beginSheetModalForWindow:unretainedSelf.view.window completionHandler:^(NSModalResponse returnCode) {
                        
                    }];
                    [alert release];
                });
            });
        }];
        [accessoryView release];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Detect Patterns For Patterns"]) {
        NSPasteboardDetectionPattern pattern = static_cast<NSPasteboardDetectionPattern>(newValue);
        
        [pasteboard detectPatternsForPatterns:[NSSet setWithObject:pattern] completionHandler:^(NSSet<NSPasteboardDetectionPattern> * _Nullable detectedPatterns, NSError * _Nullable error) {
            assert(error == nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAlert *alert = [NSAlert new];
                alert.messageText = @"Detected Patterns";
                
                if (detectedPatterns != nil) {
                    alert.informativeText = detectedPatterns.description;
                } else {
                    alert.informativeText = @"nil";
                }
                
                [alert beginSheetModalForWindow:unretainedSelf.view.window completionHandler:^(NSModalResponse returnCode) {
                    
                }];
                [alert release];
            });
        }];
        
        return NO;
    } else if ([identifier isEqualToString:@"Detect Patterns For Patterns At Index (Private)"]) {
        NSAlert *alert = [NSAlert new];
        
        PasteboardDemoDetectView *accessoryView = [[PasteboardDemoDetectView alloc] initWithFrame:NSZeroRect pasteboard:pasteboard type:PasteboardDemoDetectTypePatterns];
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            NSInteger selectedPasteboardItemIndex = accessoryView.selectedPasteboardItemIndex;
            if (selectedPasteboardItemIndex == NSNotFound) {
                NSLog(@"Unexpected");
                return;
            }
            
            NSSet<NSString *> *selectedTypes = accessoryView.selectedTypes;
            if (selectedTypes.count == 0) {
                NSLog(@"Unexpected");
                return;
            }
            
            reinterpret_cast<void (*)(id, SEL, id, NSUInteger, id)>(objc_msgSend)(pasteboard, sel_registerName("_detectPatternsForPatterns:atIndex:completionHandler:"), selectedTypes, selectedPasteboardItemIndex, ^(NSSet<NSPasteboardDetectionPattern> * _Nullable detectedPatterns, NSError * _Nullable error) {
                assert(error == nil);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSAlert *alert = [NSAlert new];
                    alert.messageText = @"Detected Patterns";
                    
                    if (detectedPatterns != nil) {
                        alert.informativeText = detectedPatterns.description;
                    } else {
                        alert.informativeText = @"nil";
                    }
                    
                    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                        
                    }];
                    [alert release];
                });
            });
        }];
        [accessoryView release];
        [alert release];
        
        return NO;
    } else {
        abort();
    }
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
