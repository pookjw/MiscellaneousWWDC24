//
//  CanvasViewController.mm
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "CanvasViewController.h"
#import <PencilKit/PencilKit.h>
#import "NSStringFromPKCanvasViewDrawingPolicy.h"
#include <ranges>
#include <vector>

/*
 -[PKTiledCanvasView _drawingEnded:estimatesTimeout:completion:]
 -[PKTiledView canvasViewDidEndDrawing:]
 */

__attribute__((objc_direct_members))
@interface CanvasViewController () <PKCanvasViewDelegate, PKToolPickerDelegate, PKToolPickerObserver>
@property (retain, nonatomic, readonly, getter=_canvas) MCCanvas *canvas;
@property (retain, nonatomic, readonly, getter=_canvasView) PKCanvasView *canvasView;
@property (retain, nonatomic, readonly, getter=_toolPicker) PKToolPicker *toolPicker;
@property (retain, nonatomic, readonly, getter=_doneBarButtonItem) UIBarButtonItem *doneBarButtonItem;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation CanvasViewController
@synthesize canvasView = _canvasView;
@synthesize toolPicker = _toolPicker;
@synthesize doneBarButtonItem = _doneBarButtonItem;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (instancetype)initWithCanvas:(MCCanvas *)canvas {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _canvas = [canvas retain];
    }
    
    return self;
}

- (void)dealloc {
    [_canvas release];
    [_canvasView release];
    [_toolPicker release];
    [_doneBarButtonItem release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.canvasView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.trailingItemGroups = @[
        [UIBarButtonItemGroup fixedGroupWithRepresentativeItem:nil items:@[
            self.menuBarButtonItem,
            self.doneBarButtonItem
        ]]
    ];
    
    navigationItem.style = UINavigationItemStyleEditor;
    
    [self.canvas.managedObjectContext performBlock:^{
        PKDrawing *drawing = self.canvas.drawing;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.canvasView.drawing = drawing;
        });
    }];
    
    [self.toolPicker setVisible:YES forFirstResponder:self.canvasView];
    [self.canvasView becomeFirstResponder];
}

- (PKCanvasView *)_canvasView {
    if (auto canvasView = _canvasView) return canvasView;
    
    PKCanvasView *canvasView = [PKCanvasView new];
    canvasView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    canvasView.delegate = self;
    
    _canvasView = canvasView;
    return canvasView;
}

- (PKToolPicker *)_toolPicker {
    if (auto toolPicker = _toolPicker) return toolPicker;
    
    PKToolPicker *toolPicker = [PKToolPicker new];
    toolPicker.delegate = self;
    [toolPicker addObserver:self];
    
    _toolPicker = toolPicker;
    return toolPicker;
}

- (UIBarButtonItem *)_doneBarButtonItem {
    if (auto doneBarButtonItem = _doneBarButtonItem) return doneBarButtonItem;
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_didTriggerDoneBarButtonItem:)];
    
    _doneBarButtonItem = doneBarButtonItem;
    return doneBarButtonItem;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.3.horizontal"] menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return [menuBarButtonItem autorelease];
}

- (UIMenu *)_makeMenu {
    PKCanvasView *canvasView = self.canvasView;
    
    UIMenu *canvasMenu;
    {
        NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
        
        {
            NSUInteger count;
            const PKCanvasViewDrawingPolicy *allPolicies = allPKCanvasViewDrawingPolicies(&count);
            
            auto actionsVector = std::views::iota(allPolicies, allPolicies + count)
            | std::views::transform([canvasView](const PKCanvasViewDrawingPolicy *ptr) {
                UIAction *action = [UIAction actionWithTitle:NSStringFromPKCanvasViewDrawingPolicy(*ptr)
                                                       image:nil
                                                  identifier:nil
                                                     handler:^(__kindof UIAction * _Nonnull action) {
                    canvasView.drawingPolicy = *ptr;
                }];
                
                action.state = (canvasView.drawingPolicy == *ptr) ? UIMenuElementStateOn : UIMenuElementStateOff;
                
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVector.data() count:actionsVector.size()];
            UIMenu *menu = [UIMenu menuWithTitle:@"Drawing Policy" children:actions];
            [actions release];
            [children addObject:menu];
        }
        
        canvasMenu = [UIMenu menuWithTitle:@"Canvas View" children:children];
        [children release];
    }
    
    UIMenu *menu = [UIMenu menuWithChildren:@[
        canvasMenu
    ]];
    
    return menu;
}

- (void)canvasViewDrawingDidChange:(PKCanvasView *)canvasView {
    PKDrawing *drawing = canvasView.drawing;
    
    MCCanvas *canvas = self.canvas;
    NSManagedObjectContext *managedObjectContext = canvas.managedObjectContext;
    
    [managedObjectContext performBlock:^{
        canvas.lastEditedDate = [NSDate now];
        canvas.drawing = drawing;
        NSError * _Nullable error = nil;
        [managedObjectContext save:&error];
        assert(error == nil);
    }];
}

- (void)canvasViewDidFinishRendering:(PKCanvasView *)canvasView {
    NSLog(@"%s", __func__);
}

- (void)canvasViewDidBeginUsingTool:(PKCanvasView *)canvasView {
    NSLog(@"%s", __func__);
}

- (void)canvasViewDidEndUsingTool:(PKCanvasView *)canvasView {
    NSLog(@"%s", __func__);
}

- (void)_didTriggerDoneBarButtonItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toolPickerSelectedToolItemDidChange:(PKToolPicker *)toolPicker {
    __kindof PKToolPickerItem *selectedToolItem = toolPicker.selectedToolItem;
    
    __kindof PKTool *tool;
    if ([selectedToolItem isKindOfClass:[PKToolPickerInkingItem class]]) {
        tool = static_cast<PKToolPickerInkingItem *>(selectedToolItem).inkingTool;
    } else if ([selectedToolItem isKindOfClass:[PKToolPickerEraserItem class]]) {
        tool = static_cast<PKToolPickerEraserItem *>(selectedToolItem).eraserTool;
    } else if ([selectedToolItem isKindOfClass:[PKToolPickerLassoItem class]]) {
        tool = static_cast<PKToolPickerLassoItem *>(selectedToolItem).lassoTool;
    } else {
        abort();
    }
    
    self.canvasView.tool = tool;
}

@end
