//
//  EvaluationFunctions.swift
//
//  HSBShading
//
//  MIT License
//
//  Copyright (c) 2022 Pierre Tacchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import CoreGraphics

/// The evaluation function for hue shading.
@usableFromInline func HueRampEvaluation(info: UnsafeMutableRawPointer?,
                                         in progress: UnsafePointer<CGFloat>,
                                         out: UnsafeMutablePointer<CGFloat>) -> Void {
    
    guard
        let comps = UnsafeRawPointer(info).map(Unmanaged<ConstantComponents>.fromOpaque(_:))?.takeUnretainedValue()
    else { fatalError("Cannot retrieve info data.") }
    
    let rgb = hsbToRgb(hue: progress.pointee, sat: comps.c1, bri: comps.c2)
    
    out[0] = rgb.r
    out[1] = rgb.g
    out[2] = rgb.b
    out[3] = comps.aa
}

/// The evaluation function for saturation shading.
@usableFromInline func SatRampEvaluation(info: UnsafeMutableRawPointer?,
                                         in progress: UnsafePointer<CGFloat>,
                                         out: UnsafeMutablePointer<CGFloat>) -> Void {
    guard
        let comps = UnsafeRawPointer(info).map(Unmanaged<ConstantComponents>.fromOpaque(_:))?.takeUnretainedValue()
    else { fatalError("Cannot retrieve info data.") }
    
    let rgb = hsbToRgb(hue: comps.c1, sat: progress.pointee, bri: comps.c2)
    
    out[0] = rgb.r
    out[1] = rgb.g
    out[2] = rgb.b
    out[3] = comps.aa
}

/// The evaluation function for brightness shading.
@usableFromInline func BriRampEvaluation(info: UnsafeMutableRawPointer?,
                                         in progress: UnsafePointer<CGFloat>,
                                         out: UnsafeMutablePointer<CGFloat>) -> Void {
    guard
        let comps = UnsafeRawPointer(info).map(Unmanaged<ConstantComponents>.fromOpaque(_:))?.takeUnretainedValue()
    else { fatalError("Cannot retrieve info data.") }
    
    let rgb = hsbToRgb(hue: comps.c1, sat: comps.c2, bri: progress.pointee)
    
    out[0] = rgb.r
    out[1] = rgb.g
    out[2] = rgb.b
    out[3] = comps.aa
}
