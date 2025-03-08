//
//  NSDictionary+MCCategory.h
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/8/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (MCCategory)
/*
 Input:
 {
     "color.colorSpace" = kCGColorSpaceExtendedSRGB;
     "color.components" =     (
         1,
         "0.5",
         "0.3",
         "0.1"
     );
     "frame.origin.x" = 1;
     "frame.origin.y" = 2;
     "frame.size.height" = 4;
     "frame.size.width" = 3;
     message = bar;
     name = foo;
 }
 
 Output:
 {
     color =     {
         colorSpace = kCGColorSpaceExtendedSRGB;
         components =         (
             1,
             "0.5",
             "0.3",
             "0.1"
         );
     };
     frame =     {
         origin =         {
             x = 1;
             y = 2;
         };
         size =         {
             height = 4;
             width = 3;
         };
     };
     message = bar;
     name = foo;
 }
 */
@property (nonatomic, readonly) NSDictionary *mc_nestedDictionary;
@end

NS_ASSUME_NONNULL_END
