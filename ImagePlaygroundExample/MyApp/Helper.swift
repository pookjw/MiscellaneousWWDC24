//
//  Helper.swift
//  MyApp
//
//  Created by Jinwoo Kim on 2/25/25.
//

import Foundation
import ImagePlayground
import CoreGraphics

@_expose(Cxx)
public nonisolated func getDataFromGPImageAndFormat(_ object: AnyObject) -> NSData {
    let data = Mirror(reflecting: object).descendant("data") as! Data
    return data as NSData
}

@_expose(Cxx)
public nonisolated func getCGImageFromGPImageAndFormat(_ object: AnyObject) -> CGImage {
    let mirror = Mirror(reflecting: object)
    
    let format = mirror.descendant("format")!
    let formatMirror = Mirror(reflecting: format)
    let width = formatMirror.descendant("width") as! Int
    let height = formatMirror.descendant("height") as! Int
    let bitsPerComponent = formatMirror.descendant("bitsPerComponent") as! Int
    let bitsPerPixel = formatMirror.descendant("bitsPerPixel") as! Int
    let bytesPerRow = formatMirror.descendant("bytesPerRow") as! Int
    let bitmapInfo = formatMirror.descendant("bitmapInfo") as! CGBitmapInfo
    let colorSpace = formatMirror.descendant("colorSpace") as! CGColorSpace
    
    let data = mirror.descendant("data") as! Data
//    let orientation = mirror.descendant("orientation") as! CGImagePropertyOrientation
    
    let dataProvider = CGDataProvider(data: data as CFData)!
    
    return CGImage(
        width: width,
        height: height,
        bitsPerComponent: bitsPerComponent,
        bitsPerPixel: bitsPerPixel,
        bytesPerRow: bytesPerRow,
        space: colorSpace,
        bitmapInfo: bitmapInfo,
        provider: dataProvider,
        decode: nil,
        shouldInterpolate: false,
        intent: .defaultIntent
    )!
}
