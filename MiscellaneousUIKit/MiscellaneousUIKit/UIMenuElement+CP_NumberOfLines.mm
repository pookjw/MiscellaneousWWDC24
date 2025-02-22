//
//  UIMenuElement+CP_NumberOfLines.mm
//  CamPresentation
//
//  Created by Jinwoo Kim on 9/18/24.
//

#import "UIMenuElement+CP_NumberOfLines.h"
#import <objc/message.h>
#import <objc/runtime.h>

namespace cp_UIContextMenuListView {
namespace _configureCell_inCollectionView_atIndexPath_forElement_section_size {
void (*original)(id, SEL, id, id, id, id, NSInteger);
void custom(__kindof UIView *self, SEL _cmd, __kindof UICollectionViewCell *cell, UICollectionView *collectionView, NSIndexPath *indexPath, __kindof UIMenuElement *element, NSInteger size) {
    original(self, _cmd, cell, collectionView, indexPath, element, size);
    
    NSInteger overrideNumberOfTitleLines = element.cp_overrideNumberOfTitleLines;
    if (overrideNumberOfTitleLines != NSNotFound) {
        __kindof UIView *actionView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(cell, sel_registerName("actionView"));
        
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(actionView, sel_registerName("setOverrideNumberOfTitleLines:"), overrideNumberOfTitleLines);
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(actionView, sel_registerName("_updateTitleLabelNumberOfLines"));
    }
    
    NSInteger overrideNumberOfSubtitleLines = element.cp_overrideNumberOfSubtitleLines;
    if (overrideNumberOfSubtitleLines != NSNotFound) {
        __kindof UIView *actionView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(cell, sel_registerName("actionView"));
        
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(actionView, sel_registerName("setOverrideNumberOfSubtitleLines:"), overrideNumberOfSubtitleLines);
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(actionView, sel_registerName("_updateSubtitleLabelNumberOfLines"));
    }
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("_UIContextMenuListView"), sel_registerName("_configureCell:inCollectionView:atIndexPath:forElement:section:size:"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}
}

namespace cp_UIContextMenuListView {
namespace _dataSourceForCollectionView {
void *didHook = &didHook;

id (*original)(id, SEL, id);

UICollectionViewDiffableDataSource *custom(__kindof UIView *self, SEL _cmd, UICollectionView *collectionView) {
    UICollectionViewDiffableDataSource *dataSource = original(self, _cmd, collectionView);
    
    if (static_cast<NSNumber *>(objc_getAssociatedObject(dataSource, didHook)).boolValue) {
        return dataSource;
    }
    
    objc_setAssociatedObject(dataSource, didHook, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    id impl = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(dataSource, sel_registerName("impl"));
    
    UICollectionViewDiffableDataSourceCellProvider originalCellProvider = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(impl, sel_registerName("collectionViewCellProvider"));
    
    UICollectionViewDiffableDataSourceCellProvider customCellProvider = ^ UICollectionViewCell * (UICollectionView *collectionView, NSIndexPath *indexPath, __kindof UIMenuElement *itemIdentifier) {
        UICollectionViewCell *cell = originalCellProvider(collectionView, indexPath, itemIdentifier);
        return cell;
    };
    
    id copy = [customCellProvider copy];
    assert(object_setInstanceVariable(impl, "_collectionViewCellProvider", reinterpret_cast<void *>(copy)) != nullptr);
    [copy release];
    
    // https://x.com/_silgen_name/status/1845851075573923842
//    [originalCellProvider release];
    
    return dataSource;
}

void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("_UIContextMenuListView"), sel_registerName("_dataSourceForCollectionView:"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}
}

namespace cp_UIMenuElement {
namespace copyWithZone {
id (*original)(id, SEL, NSZone *);
id custom(UIMenuElement *self, SEL _cmd, NSZone *zone) {
    auto copy = static_cast<__kindof UIMenuElement *>(original(self, _cmd, zone));
    copy.cp_overrideNumberOfTitleLines = self.cp_overrideNumberOfTitleLines;
    copy.cp_overrideNumberOfSubtitleLines = self.cp_overrideNumberOfSubtitleLines;
    return copy;
}
void swizzle() {
    Method method = class_getInstanceMethod(UIMenuElement.class, @selector(copyWithZone:));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace _immutableCopy {
id (*original)(id, SEL);
id custom(UIMenuElement *self, SEL _cmd) {
    auto copy = static_cast<__kindof UIMenuElement *>(original(self, _cmd));
    copy.cp_overrideNumberOfTitleLines = self.cp_overrideNumberOfTitleLines;
    copy.cp_overrideNumberOfSubtitleLines = self.cp_overrideNumberOfSubtitleLines;
    return copy;
}
void swizzle() {
    Method method = class_getInstanceMethod(UIMenuElement.class, sel_registerName("_immutableCopy"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}
}

namespace cp_UIAction {
namespace _immutableCopy {
id (*original)(id, SEL);
id custom(UIMenuElement *self, SEL _cmd) {
    auto copy = static_cast<UIAction *>(original(self, _cmd));
    copy.cp_overrideNumberOfTitleLines = self.cp_overrideNumberOfTitleLines;
    copy.cp_overrideNumberOfSubtitleLines = self.cp_overrideNumberOfSubtitleLines;
    return copy;
}
void swizzle() {
    Method method = class_getInstanceMethod(UIAction.class, sel_registerName("_immutableCopy"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}
}

/*
 -[UIMenu _immutableCopySharingLeafObservers:] 
 -[UIMenu _mutableCopy]
 -[UIMenu _copyWithOptions:]
 */

namespace cp_UIMenu {

namespace _immutableCopySharingLeafObservers {
id (*original)(id, SEL, BOOL);
id custom(UIMenu *self, SEL _cmd, BOOL x2) {
    auto copy = static_cast<__kindof UIMenuElement *>(original(self, _cmd, x2));
    copy.cp_overrideNumberOfTitleLines = self.cp_overrideNumberOfTitleLines;
    copy.cp_overrideNumberOfSubtitleLines = self.cp_overrideNumberOfSubtitleLines;
    return copy;
}
void swizzle() {
    Method method = class_getInstanceMethod(UIMenu.class, sel_registerName("_immutableCopySharingLeafObservers:"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace _mutableCopy {
id (*original)(id, SEL);
id custom(UIMenu *self, SEL _cmd) {
    auto copy = static_cast<__kindof UIMenuElement *>(original(self, _cmd));
    copy.cp_overrideNumberOfTitleLines = self.cp_overrideNumberOfTitleLines;
    copy.cp_overrideNumberOfSubtitleLines = self.cp_overrideNumberOfSubtitleLines;
    return copy;
}
void swizzle() {
    Method method = class_getInstanceMethod(UIMenu.class, sel_registerName("_mutableCopy"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace _copyWithOptions {
id (*original)(id, SEL, UIMenuOptions);
id custom(UIMenu *self, SEL _cmd, UIMenuOptions options) {
    auto copy = static_cast<__kindof UIMenuElement *>(original(self, _cmd, options));
    copy.cp_overrideNumberOfTitleLines = self.cp_overrideNumberOfTitleLines;
    copy.cp_overrideNumberOfSubtitleLines = self.cp_overrideNumberOfSubtitleLines;
    return copy;
}
void swizzle() {
    Method method = class_getInstanceMethod(UIMenu.class, sel_registerName("_copyWithOptions:"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace menuByReplacingChildren {
UIMenu * (*original)(id, SEL, id);
UIMenu * custom(UIMenu *self, SEL _cmd, NSArray<__kindof UIMenuElement *> *children) {
    auto result = original(self, _cmd, children);
    result.cp_overrideNumberOfTitleLines = self.cp_overrideNumberOfTitleLines;
    result.cp_overrideNumberOfSubtitleLines = self.cp_overrideNumberOfSubtitleLines;
    return result;
}
void swizzle() {
    Method method = class_getInstanceMethod(UIMenu.class, sel_registerName("menuByReplacingChildren:"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

}

@implementation UIMenuElement (CP_NumberOfLines)

+ (void)load {
    /*
     -[_UIContextMenuListView _configureCell:inCollectionView:atIndexPath:forElement:section:size:]
     -[UIMenuElement copyWithZone:]
     -[UIMenuElement _immutableCopy]
     */
    cp_UIContextMenuListView::_configureCell_inCollectionView_atIndexPath_forElement_section_size::swizzle();
//    cp_UIContextMenuListView::_dataSourceForCollectionView::swizzle();
    cp_UIMenuElement::copyWithZone::swizzle();
    cp_UIMenuElement::_immutableCopy::swizzle();
    cp_UIAction::_immutableCopy::swizzle();
    cp_UIMenu::_immutableCopySharingLeafObservers::swizzle();
    cp_UIMenu::_mutableCopy::swizzle();
    cp_UIMenu::_copyWithOptions::swizzle();
    cp_UIMenu::menuByReplacingChildren::swizzle();
}

+ (void *)cp_overrideNumberOfTitleLines {
    static void *key = &key;
    return key;
}

+ (void *)cp_overrideNumberOfSubtitleLinesKey {
    static void *key = &key;
    return key;
}

- (NSInteger)cp_overrideNumberOfTitleLines {
    NSNumber * _Nullable number = objc_getAssociatedObject(self, [UIMenuElement cp_overrideNumberOfTitleLines]);
    
    if (number == nil) {
        return NSNotFound;
    }
    
    return number.integerValue;
}

- (void)cp_setOverrideNumberOfTitleLines:(NSInteger)cp_overrideNumberOfTitleLines {
    objc_setAssociatedObject(self, [UIMenuElement cp_overrideNumberOfTitleLines], @(cp_overrideNumberOfTitleLines), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)cp_overrideNumberOfSubtitleLines {
    NSNumber * _Nullable number = objc_getAssociatedObject(self, [UIMenuElement cp_overrideNumberOfSubtitleLinesKey]);
    
    if (number == nil) {
        return NSNotFound;
    }
    
    return number.integerValue;
}

- (void)cp_setOverrideNumberOfSubtitleLines:(NSInteger)cp_overrideNumberOfSubtitleLines {
    objc_setAssociatedObject(self, [UIMenuElement cp_overrideNumberOfSubtitleLinesKey], @(cp_overrideNumberOfSubtitleLines), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
