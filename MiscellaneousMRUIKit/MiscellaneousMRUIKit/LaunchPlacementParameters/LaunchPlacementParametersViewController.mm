//
//  LaunchPlacementParametersViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 6/29/24.
//

#import "LaunchPlacementParametersViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

struct MRUISize3D {
    CGFloat width;
    CGFloat height;
    CGFloat depth;
};

static inline MRUISize3D MRUISize3DMake(CGFloat width, CGFloat height, CGFloat depth) {
    MRUISize3D size3D;
    size3D.width = width;
    size3D.height = height;
    size3D.depth = depth;
    return size3D;
}

@interface LaunchPlacementParametersViewController ()
@property (retain, nonatomic) UIButton *button;
@end

@implementation LaunchPlacementParametersViewController
@synthesize button = _button;

- (void)dealloc {
    [_button release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.button;
}

- (UIButton *)button {
    if (auto button = _button) return button;
    
    UIWindowSceneActivationAction *primaryAction = [UIWindowSceneActivationAction actionWithIdentifier:nil alternateAction:nil configurationProvider:^UIWindowSceneActivationConfiguration * _Nullable(__kindof UIWindowSceneActivationAction * _Nonnull action) {
        UIButton *sender = static_cast<UIButton *>(action.sender);
        UIWindowScene *windowScene = sender.window.windowScene;
        
        // FBSScene
        id fbsScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(windowScene, sel_registerName("_scene"));
        
        NSStream *identifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(fbsScene, sel_registerName("identifier"));
        
        NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"LaunchPlacementParameters"];
        
        UIWindowSceneActivationConfiguration *configuration = [[UIWindowSceneActivationConfiguration alloc] initWithUserActivity:userActivity];
        
        UIWindowSceneActivationRequestOptions *options = [UIWindowSceneActivationRequestOptions new];
        
        // MRUILaunchPlacementParameters
        id mrui_placementParameters = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(options, sel_registerName("mrui_placementParameters"));
        
        // RSSNeighboringPlacementPosition
        id preferredLaunchPosition = reinterpret_cast<id (*)(Class, SEL, id, NSInteger)>(objc_msgSend)(objc_lookUpClass("RSSPlacementPosition"), sel_registerName("positionRelativeToSceneWithIdentifier:relation:"), identifier, 2);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placementParameters, sel_registerName("setPreferredLaunchPosition:"), preferredLaunchPosition);
        
        NSValue *preferredLaunchSize3D = reinterpret_cast<id (*)(Class, SEL, MRUISize3D)>(objc_msgSend)(NSValue.class, sel_registerName("valueWithMRUISize3D:"), MRUISize3DMake(300., 300., 0.));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placementParameters, sel_registerName("setPreferredLaunchSize3D:"), preferredLaunchSize3D);
        
        configuration.options = options;
        [options release];
        
        return [configuration autorelease];
    }];
    
    UIButton *button = [UIButton systemButtonWithPrimaryAction:primaryAction];
    
    _button = [button retain];
    return button;
}

@end
