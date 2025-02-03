//
//  MyMenu.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/3/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyMenu : NSMenu
@property (retain, nonatomic, readonly) NSMenu *servicesMenu;
@property (retain, nonatomic, readonly) NSMenu *windowMenu;
@property (retain, nonatomic, readonly) NSMenu *helpMenu;
@end

NS_ASSUME_NONNULL_END
