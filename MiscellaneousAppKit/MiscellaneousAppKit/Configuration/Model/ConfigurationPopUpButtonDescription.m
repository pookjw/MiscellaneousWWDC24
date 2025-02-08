//
//  ConfigurationPopUpButtonDescription.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import "ConfigurationPopUpButtonDescription.h"

@implementation ConfigurationPopUpButtonDescription

+ (ConfigurationPopUpButtonDescription *)descriptionWithTitles:(NSArray<NSString *> *)titles selectedTitles:(NSArray<NSString *> *)selectedTitles selectedDisplayTitle:(NSString *)selectedDisplayTitle {
    return [[[ConfigurationPopUpButtonDescription alloc] initWithTitles:titles selectedTitles:selectedTitles selectedDisplayTitle:selectedDisplayTitle] autorelease];
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles selectedTitles:(NSArray<NSString *> *)selectedTitles selectedDisplayTitle:(NSString *)selectedDisplayTitle {
    if (selectedTitles.count > 0) {
        if (selectedDisplayTitle == nil) {
            abort();
        } else if (![selectedTitles containsObject:selectedDisplayTitle]) {
            abort();
        }
        
        for (NSString *selectedTitle in selectedTitles) {
            assert(![selectedTitle isEqualToString:@"None"]);
        }
    } else {
        if (selectedDisplayTitle != nil) {
            abort();
        }
    }
    
    if (self = [super init]) {
        _titles = [titles copy];
        _selectedTitles = [selectedTitles copy];
        _selectedDisplayTitle = [selectedDisplayTitle copy];
    }
    
    return self;
}

- (void)dealloc {
    [_titles release];
    [_selectedTitles release];
    [_selectedDisplayTitle release];
    [super dealloc];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [self retain];
}

@end
