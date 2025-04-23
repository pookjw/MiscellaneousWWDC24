//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration
//
//  Created by Jinwoo Kim on 4/22/25.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
final class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        ShieldConfiguration(backgroundBlurStyle: .dark, backgroundColor: .clear, icon: UIImage(systemName: "apple.intelligence"), title: ShieldConfiguration.Label(text: "Text", color: .systemPink), subtitle: ShieldConfiguration.Label(text: "Subtitle", color: .systemRed), primaryButtonLabel: ShieldConfiguration.Label(text: "Primary", color: .brown), primaryButtonBackgroundColor: .green, secondaryButtonLabel: ShieldConfiguration.Label(text: "Secondary", color: .brown))
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}
