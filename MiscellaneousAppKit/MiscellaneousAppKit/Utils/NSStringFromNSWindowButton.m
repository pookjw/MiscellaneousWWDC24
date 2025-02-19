//
//  NSStringFromNSWindowButton.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/19/25.
//

#import "NSStringFromNSWindowButton.h"

NSString * NSStringFromNSWindowButton(NSWindowButton button) {
    switch (button) {
        case NSWindowCloseButton:
            return @"Close";
        case NSWindowMiniaturizeButton:
            return @"Miniaturize";
        case NSWindowZoomButton:
            return @"Zoom";
        case NSWindowToolbarButton:
            return @"Toolbar";
        case NSWindowDocumentIconButton:
            return @"Document Icon";
        case NSWindowDocumentVersionsButton:
            return @"Document Versions";
        default:
            abort();
    }
}

NSWindowButton NSWindowButtonFromString(NSString *string) {
    if ([string isEqualToString:@"Close"]) {
        return NSWindowCloseButton;
    } else if ([string isEqualToString:@"Miniaturize"]) {
        return NSWindowMiniaturizeButton;
    } else if ([string isEqualToString:@"Zoom"]) {
        return NSWindowZoomButton;
    } else if ([string isEqualToString:@"Toolbar"]) {
        return NSWindowToolbarButton;
    } else if ([string isEqualToString:@"Document Icon"]) {
        return NSWindowDocumentIconButton;
    } else if ([string isEqualToString:@"Document Versions"]) {
        return NSWindowDocumentVersionsButton;
    } else {
        abort();
    }
}

NSWindowButton * allNSWindowButtons(NSUInteger * _Nullable count) {
    static NSWindowButton allButtons[] = {
        NSWindowCloseButton,
        NSWindowMiniaturizeButton,
        NSWindowZoomButton,
        NSWindowToolbarButton,
        NSWindowDocumentIconButton,
        NSWindowDocumentVersionsButton
    };
    
    if (count != NULL) {
        *count = sizeof(allButtons) / sizeof(NSWindowButton);
    }
    
    return allButtons;
}
