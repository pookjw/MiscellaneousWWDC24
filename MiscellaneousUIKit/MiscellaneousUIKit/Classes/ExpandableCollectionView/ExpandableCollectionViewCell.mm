//
//  ExpandableCollectionViewCell.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 1/11/25.
//

#import "ExpandableCollectionViewCell.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <execinfo.h>
#import <dlfcn.h>

@interface ExpandableCollectionViewCell ()
@property (retain, nonatomic, getter=_itemIdentifier, setter=_setItemIdentifier:) id itemIdentifier;
@property (assign, nonatomic, getter=_defaultIndentationLevel, setter=_setDefaultIndentationLevel:) NSInteger defaultIndentationLevel;
@property (assign, nonatomic, getter=_expanded, setter=_setExpanded:) BOOL _expanded;
@property (weak, nonatomic, setter=_setParentFocusItem:) id<UIFocusItem> _parentFocusItem;
@property (copy, nonatomic, setter=_setDisclosureActionHandler:) BOOL (^_disclosureActionHandler)(NSUInteger one, id itemIdentifier);
@end

@implementation ExpandableCollectionViewCell
@synthesize label = _label;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.label];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("_addBoundsMatchingConstraintsForView:"), self.label);
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_didTriggerTapGestureRecognizer:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
    }
    
    return self;
}

- (void)dealloc {
    [_label release];
    [_itemIdentifier release];
    [__disclosureActionHandler release];
    [super dealloc];
}

- (BOOL)isKindOfClass:(Class)aClass {
    void *buffer[2];
    int count = backtrace(buffer, 2);
    
    if (count < 2) {
        return [super isKindOfClass:aClass];
    }
    
    void *addr = buffer[1];
    struct dl_info info;
    assert(dladdr(addr, &info));
    
    IMP targetIMP = class_getMethodImplementation(objc_lookUpClass("_UIDiffableDataSourceSectionController"), sel_registerName("_configureCell:forItem:inSnapshot:"));
    
    if (info.dli_saddr == targetIMP) {
        return YES;
    } else {
        return [super isKindOfClass:aClass];
    }
}

- (UILabel *)label {
    if (auto label = _label) return label;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = NO;
    
    _label = [label retain];
    return [label autorelease];
}

- (void)_didTriggerTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    if (auto disclosureActionHandler = self._disclosureActionHandler) {
        disclosureActionHandler(1, self.itemIdentifier);
    }
}

@end
