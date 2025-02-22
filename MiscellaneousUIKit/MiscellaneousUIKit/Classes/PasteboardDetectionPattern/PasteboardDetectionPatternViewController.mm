//
//  PasteboardDetectionPatternViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import "PasteboardDetectionPatternViewController.h"
#import "UIMenuElement+CP_NumberOfLines.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <DataDetection/DataDetection.h>

@interface PasteboardDetectionPatternViewController ()

@end

@implementation PasteboardDetectionPatternViewController

- (void)loadView {
    UIButton *button = [UIButton new];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Menu";
    button.configuration = configuration;
    
    button.menu = [self _makeMenu];
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    button.showsMenuAsPrimaryAction = YES;
    
    self.view = button;
    [button release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didChangePasteboard:) name:UIPasteboardChangedNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didRemovePasteboard:) name:UIPasteboardRemovedNotification object:nil];
}

- (void)_didChangePasteboard:(NSNotification *)notification {
    NSLog(@"%@", notification);
}

- (void)_didRemovePasteboard:(NSNotification *)notification {
    NSLog(@"%@", notification);
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSArray<UIPasteboardDetectionPattern> *allDetectionPatterns = @[
            UIPasteboardDetectionPatternCalendarEvent,
            UIPasteboardDetectionPatternEmailAddress,
            UIPasteboardDetectionPatternFlightNumber,
            UIPasteboardDetectionPatternLink,
            UIPasteboardDetectionPatternMoneyAmount,
            UIPasteboardDetectionPatternNumber,
            UIPasteboardDetectionPatternPhoneNumber,
            UIPasteboardDetectionPatternPostalAddress,
            UIPasteboardDetectionPatternProbableWebSearch,
            UIPasteboardDetectionPatternProbableWebURL,
            UIPasteboardDetectionPatternShipmentTrackingNumber
        ];
        
        NSMutableArray<__kindof UIMenuElement *> *elements = [NSMutableArray new];
        
        {
            NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:allDetectionPatterns.count];
            for (UIPasteboardDetectionPattern pattern in allDetectionPatterns) {
                UIAction *action = [UIAction actionWithTitle:pattern image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    [UIPasteboard.generalPasteboard detectPatternsForPatterns:[NSSet setWithObject:pattern] completionHandler:^(NSSet<UIPasteboardDetectionPattern> * _Nullable patterns, NSError * _Nullable error) {
                        assert(error == nil);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Values" message:patterns.description preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }]];
                            [weakSelf presentViewController:alertController animated:YES completion:nil];
                        });
                    }];
                }];
                
                action.cp_overrideNumberOfTitleLines = 0;
                [actions addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:NSStringFromSelector(@selector(detectPatternsForPatterns:completionHandler:)) children:actions];
            [actions release];
            [elements addObject:menu];
        }
        
        {
            NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:allDetectionPatterns.count];
            for (UIPasteboardDetectionPattern pattern in allDetectionPatterns) {
                UIAction *action = [UIAction actionWithTitle:pattern image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    [UIPasteboard.generalPasteboard detectPatternsForPatterns:[NSSet setWithObject:pattern] inItemSet:nil completionHandler:^(NSArray<NSSet<UIPasteboardDetectionPattern> *> * _Nullable patterns, NSError * _Nullable error) {
                        assert(error == nil);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Values" message:patterns.description preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }]];
                            [weakSelf presentViewController:alertController animated:YES completion:nil];
                        });
                    }];
                }];
                
                action.cp_overrideNumberOfTitleLines = 0;
                [actions addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:NSStringFromSelector(@selector(detectPatternsForPatterns:inItemSet:completionHandler:)) children:actions];
            [actions release];
            [elements addObject:menu];
        }
        
        {
            NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:allDetectionPatterns.count];
            for (UIPasteboardDetectionPattern pattern in allDetectionPatterns) {
                UIAction *action = [UIAction actionWithTitle:pattern image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    [UIPasteboard.generalPasteboard detectValuesForPatterns:[NSSet setWithObject:pattern] completionHandler:^(NSDictionary<UIPasteboardDetectionPattern,id> * _Nullable values, NSError * _Nullable error) {
                        assert(error == nil);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Values" message:values.description preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }]];
                            [weakSelf presentViewController:alertController animated:YES completion:nil];
                        });
                    }];
                }];
                
                action.cp_overrideNumberOfTitleLines = 0;
                [actions addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:NSStringFromSelector(@selector(detectValuesForPatterns:completionHandler:)) children:actions];
            [actions release];
            [elements addObject:menu];
        }
        
        {
            NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:allDetectionPatterns.count];
            for (UIPasteboardDetectionPattern pattern in allDetectionPatterns) {
                UIAction *action = [UIAction actionWithTitle:pattern image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    [UIPasteboard.generalPasteboard detectValuesForPatterns:[NSSet setWithObject:pattern] inItemSet:nil completionHandler:^(NSArray<NSDictionary<UIPasteboardDetectionPattern,id> *> * _Nullable values, NSError * _Nullable error) {
                        assert(error == nil);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Values" message:values.description preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }]];
                            [weakSelf presentViewController:alertController animated:YES completion:nil];
                        });
                    }];
                }];
                
                action.cp_overrideNumberOfTitleLines = 0;
                [actions addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:NSStringFromSelector(@selector(detectValuesForPatterns:inItemSet:completionHandler:)) children:actions];
            [actions release];
            [elements addObject:menu];
        }
        
        {
            UIAction *copyWebURLsAction = [UIAction actionWithTitle:@"Set Web URLs" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                [UIPasteboard.generalPasteboard setURLs:@[
                    [NSURL URLWithString:@"https://www.apple.com"],
                    [NSURL URLWithString:@"https://www.google.com"]
                ]];
            }];
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Copy Value" children:@[copyWebURLsAction]];
            [elements addObject:menu];
        }
        
        {
            UIAction *testAction = [UIAction actionWithTitle:@"Test" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:[NSUUID UUID].UUIDString create:YES];
                assert(pasteboard.numberOfItems == 0);
                assert(pasteboard.changeCount == 1);
                
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                
                [pasteboard setItems:@[
                    @{
                        UTTypeURL.identifier: [NSURL URLWithString:@"https://www.apple.com"],
                        UTTypeUTF8PlainText.identifier: @"080-1234-5678"
                    },
                    @{
                        UTTypeUTF8PlainText.identifier: @"$29.12",
                        UIPasteboardTypeListColor[0]: UIColor.blackColor
                    }
                ]
                             options:@{
                    UIPasteboardOptionExpirationDate: NSDate.distantFuture,
                    UIPasteboardOptionLocalOnly: @(YES)
                }];
                
                [pasteboard addItems:@[
                    @{
                        UTTypeUTF8PlainText.identifier: @"123"
                    },
                    @{
                        UTTypeUTF8PlainText.identifier: @"456"
                    }
                ]];
                
                assert(pasteboard.numberOfItems == 4);
                assert([pasteboard.string isEqualToString:@"080-1234-5678"]);
                assert(([pasteboard.strings isEqualToArray:@[@"080-1234-5678", @"$29.12", @"123", @"456"]]));
                assert(([pasteboard.URLs isEqualToArray:@[[NSURL URLWithString:@"https://www.apple.com"]]]));
                assert(([pasteboard.colors isEqualToArray:@[UIColor.blackColor]]));
                assert(pasteboard.hasColors);
                assert(!pasteboard.hasImages);
                assert(pasteboard.hasStrings);
                assert(pasteboard.hasURLs);
                assert(pasteboard.changeCount == 3);
                
                [pasteboard detectPatternsForPatterns:[NSSet setWithObject:UIPasteboardDetectionPatternPhoneNumber] completionHandler:^(NSSet<UIPasteboardDetectionPattern> * _Nullable patterns, NSError * _Nullable error) {
                    assert(error == nil);
                    assert([patterns containsObject:UIPasteboardDetectionPatternPhoneNumber]);
                    dispatch_semaphore_signal(semaphore);
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                
                [pasteboard detectPatternsForPatterns:[NSSet setWithObjects:UIPasteboardDetectionPatternPhoneNumber, UIPasteboardDetectionPatternMoneyAmount, nil] inItemSet:nil completionHandler:^(NSArray<NSSet<NSString *> *> * _Nullable patterns, NSError * _Nullable error) {
                    assert(error == nil);
                    assert([patterns[0] containsObject:UIPasteboardDetectionPatternPhoneNumber]);
                    assert([patterns[1] containsObject:UIPasteboardDetectionPatternMoneyAmount]);
                    dispatch_semaphore_signal(semaphore);
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                
                [pasteboard detectValuesForPatterns:[NSSet setWithObject:UIPasteboardDetectionPatternPhoneNumber] completionHandler:^(NSDictionary<UIPasteboardDetectionPattern,id> * _Nullable values, NSError * _Nullable error) {
                    assert(error == nil);
                    assert(([static_cast<DDMatchPhoneNumber *>(values[UIPasteboardDetectionPatternPhoneNumber][0]).phoneNumber isEqualToString:@"080-1234-5678"]));
                    dispatch_semaphore_signal(semaphore);
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                
                [pasteboard detectValuesForPatterns:[NSSet setWithObjects:UIPasteboardDetectionPatternPhoneNumber, UIPasteboardDetectionPatternMoneyAmount, nil] inItemSet:nil completionHandler:^(NSArray<NSDictionary<UIPasteboardDetectionPattern,id> *> * _Nullable values, NSError * _Nullable error) {
                    assert(error == nil);
                    assert(([static_cast<DDMatchPhoneNumber *>(values[0][UIPasteboardDetectionPatternPhoneNumber][0]).phoneNumber isEqualToString:@"080-1234-5678"]));
                    assert(static_cast<DDMatchMoneyAmount *>(values[1][UIPasteboardDetectionPatternMoneyAmount][0]).amount == 29.12);
                    assert([static_cast<DDMatchMoneyAmount *>(values[1][UIPasteboardDetectionPatternMoneyAmount][0]).currency isEqualToString:@"USD"]);
                    dispatch_semaphore_signal(semaphore);
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                
                [pasteboard setItems:@[
                    @{
                        UTTypeUTF8PlainText.identifier: @"ABC"
                    },
                    @{
                        UTTypeUTF8PlainText.identifier: @"Air"
                    }
                ]
                             options:@{
                    UIPasteboardOptionExpirationDate: NSDate.distantFuture,
                    UIPasteboardOptionLocalOnly: @(YES)
                }];
                assert(pasteboard.numberOfItems == 2);
                assert(([pasteboard.strings isEqualToArray:@[@"ABC", @"Air"]]));
                assert(!pasteboard.hasColors);
                assert(!pasteboard.hasImages);
                assert(pasteboard.hasStrings);
                assert(!pasteboard.hasURLs);
                assert(pasteboard.changeCount == 4);
                
                pasteboard.image = [UIImage systemImageNamed:@"apple.intelligence"];
                assert(pasteboard.numberOfItems == 1);
                assert([[pasteboard valueForPasteboardType:@"com.apple.uikit.image"] isKindOfClass:[UIImage class]]);
                assert([[pasteboard valueForPasteboardType:@"public.jpeg"] isKindOfClass:[NSData class]]);
                assert([[pasteboard valueForPasteboardType:@"public.png"] isKindOfClass:[NSData class]]);
                assert(pasteboard.changeCount == 5);
                
                dispatch_release(semaphore);
            }];
            [elements addObject:testAction];
        }
        
        completion(elements);
        [elements release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
