//
//  allNSPasteboardDetectionPatterns.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import "allNSPasteboardDetectionPatterns.h"

NSArray<NSPasteboardDetectionPattern> * const allNSPasteboardDetectionPatterns = @[
    NSPasteboardDetectionPatternProbableWebURL,
    NSPasteboardDetectionPatternProbableWebSearch,
    NSPasteboardDetectionPatternNumber,
    NSPasteboardDetectionPatternLink,
    NSPasteboardDetectionPatternPhoneNumber,
    NSPasteboardDetectionPatternEmailAddress,
    NSPasteboardDetectionPatternPostalAddress,
    NSPasteboardDetectionPatternCalendarEvent,
    NSPasteboardDetectionPatternShipmentTrackingNumber,
    NSPasteboardDetectionPatternFlightNumber,
    NSPasteboardDetectionPatternMoneyAmount
];
