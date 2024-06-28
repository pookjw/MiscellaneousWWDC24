//
//  NSMenuItem+MAPopUpButton.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/28/24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMenuItem (MAPopUpButton)
- (NSPopUpButton *)MA_popupButton;
@end

NS_ASSUME_NONNULL_END
