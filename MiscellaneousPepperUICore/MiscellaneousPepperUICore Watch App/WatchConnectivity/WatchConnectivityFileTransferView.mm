//
//  WatchConnectivityFileTransferView.m
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 12/13/24.
//

#import "WatchConnectivityFileTransferView.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

__attribute__((objc_direct_members))
@interface WatchConnectivityFileTransferView ()
@property (retain, nonatomic, readonly) id _stackView;
@property (retain, nonatomic, readonly) id _progressView;
@property (retain, nonatomic, readonly) id _cancelButton;
@end

@implementation WatchConnectivityFileTransferView

+ (void)load {
    [self class];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] allocWithZone:zone];
}

+ (Class)class {
    static Class isa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _isa = objc_allocateClassPair(objc_lookUpClass("UIView"), "_WatchConnectivityFileTransferView", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_isa, @selector(dealloc), dealloc, NULL));
        
        assert(class_addIvar(_isa, "_fileTransfer", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_isa, "__stackView", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_isa, "__progressView", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_isa, "__cancelButton", sizeof(id), sizeof(id), @encode(id)));
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (instancetype)initWithFileTransfer:(WCSessionFileTransfer *)fileTransfer {
    objc_super superInfo = { self, [self class] };
    self = reinterpret_cast<id (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, @selector(init));
    
    if (self) {
        assert(object_setInstanceVariable(self, "_fileTransfer", reinterpret_cast<void *>([fileTransfer retain])));
        
        id stackView = self._stackView;
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("addSubview:"), stackView);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("_addBoundsMatchingConstraintsForView:"), stackView);
    }
    
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _fileTransfer;
    object_getInstanceVariable(self, "_fileTransfer", reinterpret_cast<void **>(&_fileTransfer));
    [_fileTransfer release];
    
    id __stackView;
    object_getInstanceVariable(self, "__stackView", reinterpret_cast<void **>(&__stackView));
    [__stackView release];
    
    id __progressView;
    object_getInstanceVariable(self, "__progressView", reinterpret_cast<void **>(&__progressView));
    [__progressView release];
    
    id __cancelButton;
    object_getInstanceVariable(self, "__cancelButton", reinterpret_cast<void **>(&__cancelButton));
    [__cancelButton release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (WCSessionFileTransfer *)fileTransfer __attribute__((objc_direct)) {
    id _fileTransfer;
    object_getInstanceVariable(self, "_fileTransfer", reinterpret_cast<void **>(&_fileTransfer));
    return _fileTransfer;
}

- (id)_stackView {
    id __stackView;
    object_getInstanceVariable(self, "__stackView", reinterpret_cast<void **>(&__stackView));
    
    if (__stackView == nil) {
        __stackView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIStackView") alloc], sel_registerName("initWithArrangedSubviews:"), @[
            self._progressView,
            self._cancelButton
        ]);
        
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(__stackView, sel_registerName("setSpacing:"), FLT_MIN); // UIStackViewSpacingUseSystem
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(__stackView, sel_registerName("setAxis:"), 0); // UILayoutConstraintAxisHorizontal
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(__stackView, sel_registerName("setAlignment:"), 0); // UIStackViewAlignmentFill
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(__stackView, sel_registerName("setDistribution:"), 0); // UIStackViewDistributionFill
        
        object_setInstanceVariable(self, "__stackView", reinterpret_cast<void *>([[__stackView retain] autorelease]));
    }
    
    return __stackView;
}

- (id)_progressView {
    id __progressView;
    object_getInstanceVariable(self, "__progressView", reinterpret_cast<void **>(&__progressView));
    
    if (__progressView == nil) {
        __progressView = reinterpret_cast<id (*)(id, SEL, NSInteger)>(objc_msgSend)([objc_lookUpClass("UIProgressView") alloc], sel_registerName("initWithProgressViewStyle:"), 1); // UIProgressViewStyleBar
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(__progressView, sel_registerName("setObservedProgress:"), self.fileTransfer.progress);
        
        object_setInstanceVariable(self, "__progressView", reinterpret_cast<void *>([[__progressView retain] autorelease]));
    }
    
    return __progressView;
}

- (id)_cancelButton {
    id __cancelButton;
    object_getInstanceVariable(self, "__cancelButton", reinterpret_cast<void **>(&__cancelButton));
    
    if (__cancelButton == nil) {
        WCSessionFileTransfer *fileTransfer = self.fileTransfer;
        
        id primaryAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), nil, [UIImage systemImageNamed:@"xmark"], nil, ^(id action) {
            [fileTransfer cancel];
        });
        
        __cancelButton = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("PUICButton"), sel_registerName("systemButtonWithPrimaryAction:"), primaryAction);
        object_setInstanceVariable(self, "__cancelButton", reinterpret_cast<void *>([__cancelButton retain]));
    }
    
    return __cancelButton;
}

@end
