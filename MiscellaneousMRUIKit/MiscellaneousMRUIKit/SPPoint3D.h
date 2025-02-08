//
//  SPPoint3D.h
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/9/25.
//

#import <UIKit/UIKit.h>

struct SPPoint3D {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};

static inline SPPoint3D SPPoint3DMake(CGFloat x, CGFloat y, CGFloat z) {
    SPPoint3D point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}

UIKIT_EXTERN NSString * _NSStringFromSPPoint3D(SPPoint3D *);
UIKIT_EXTERN SPPoint3D _SPPoint3DFromString(NSString *);
//UIKIT_EXTERN const SPPoint3D SPPoint3DZero;
