//
//  CAPoint3D.h
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/9/25.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/*
 -[NSValue(CAPoint3DAdditions) CAPoint3DValue]
 +[NSValue(CAPoint3DAdditions) valueWithCAPoint3D:]
 */

struct CAPoint3D {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};
typedef struct CAPoint3D CAPoint3D;

CG_INLINE CAPoint3D CAPoint3DMake(CGFloat x, CGFloat y, CGFloat z) {
    CAPoint3D point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}

CG_EXTERN bool CAPoint3DEqualToPoint(CAPoint3D, CAPoint3D);
UIKIT_EXTERN NSString * _NSStringFromCAPoint3D(CAPoint3D);
UIKIT_EXTERN CAPoint3D _CAPoint3DFromString(NSString *);
