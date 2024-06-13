//
//  CustomDocument.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomDocument : UIDocument
@property (retain, readonly, nonatomic) NSData *data;
@end

NS_ASSUME_NONNULL_END
