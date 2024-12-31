//
//  SecondaryCarPlaySceneDelegate.mm
//  MiscellaneousCarPlay
//
//  Created by Jinwoo Kim on 12/31/24.
//

#import "SecondaryCarPlaySceneDelegate.h"
#import <MapKit/MapKit.h>

@interface SecondaryCarPlaySceneDelegate () <CPInstrumentClusterControllerDelegate>
@end

@implementation SecondaryCarPlaySceneDelegate

- (void)templateApplicationDashboardScene:(CPTemplateApplicationDashboardScene *)templateApplicationDashboardScene didConnectDashboardController:(CPDashboardController *)dashboardController toWindow:(UIWindow *)window {
    UIViewController *viewController = [UIViewController new];
    
    MKMapView *mapView = [MKMapView new];
    viewController.view = mapView;
    [mapView release];
    
    window.rootViewController = viewController;
    [viewController release];
    
    CPDashboardButton *button = [[CPDashboardButton alloc] initWithTitleVariants:@[@"Title"]
                                                                subtitleVariants:@[@"Subtitle"]
                                                                           image:[UIImage systemImageNamed:@"scribble"]
                                                                         handler:^(CPDashboardButton * _Nonnull barButton) {
        
    }];
    
    dashboardController.shortcutButtons = @[button];
    [button release];
}

- (void)templateApplicationDashboardScene:(CPTemplateApplicationDashboardScene *)templateApplicationDashboardScene didDisconnectDashboardController:(CPDashboardController *)dashboardController fromWindow:(UIWindow *)window {
    
}

- (void)templateApplicationInstrumentClusterScene:(CPTemplateApplicationInstrumentClusterScene *)templateApplicationInstrumentClusterScene didConnectInstrumentClusterController:(CPInstrumentClusterController *)instrumentClusterController {
    UIViewController *viewController = [UIViewController new];
    
    MKMapView *mapView = [MKMapView new];
    viewController.view = mapView;
    [mapView release];
    
    instrumentClusterController.instrumentClusterWindow.rootViewController = viewController;
    [viewController release];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"Test Test Test"];
    instrumentClusterController.attributedInactiveDescriptionVariants = @[string];
    [string release];
    instrumentClusterController.inactiveDescriptionVariants = @[@"Test Test Test"];
    
    instrumentClusterController.delegate = self;
}

- (void)instrumentClusterController:(CPInstrumentClusterController *)instrumentClusterController didChangeCompassSetting:(CPInstrumentClusterSetting)compassSetting {
    
}

- (void)instrumentClusterController:(CPInstrumentClusterController *)instrumentClusterController didChangeSpeedLimitSetting:(CPInstrumentClusterSetting)speedLimitSetting {
    
}

- (void)templateApplicationInstrumentClusterScene:(CPTemplateApplicationInstrumentClusterScene *)templateApplicationInstrumentClusterScene didDisconnectInstrumentClusterController:(CPInstrumentClusterController *)instrumentClusterController {
    
}

- (void)instrumentClusterControllerDidConnectWindow:(nonnull UIWindow *)instrumentClusterWindow { 
    
}

- (void)instrumentClusterControllerDidDisconnectWindow:(nonnull UIWindow *)instrumentClusterWindow { 
    
}

- (void)instrumentClusterControllerDidZoomIn:(CPInstrumentClusterController *)instrumentClusterController {
    
}

- (void)instrumentClusterControllerDidZoomOut:(CPInstrumentClusterController *)instrumentClusterController {
    
}

@end
