//
//  Utils.swift
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

import Foundation
import simd

import SwizzleIMD
import SmoothOperators

/// Clamps the given value to range `min...max`.
@usableFromInline func clamp(_ x: CGFloat, _ min: CGFloat, _ max: CGFloat) -> CGFloat {
    return Swift.min(Swift.max(x, min), max)
}

/// `CGFunctionReleaseInfoCallback` used to release the info object passed as argument to a CGFunction.
@usableFromInline func infoReleaseCallback(_ ptr: UnsafeMutableRawPointer?) {
    UnsafeRawPointer(ptr)
        .map(Unmanaged<AnyObject>.fromOpaque)?
        .release()
}

/// Converts HSV values to RGB.
/// - Note: Borrowed from [https://github.com/hughsk/glsl-hsv2rgb](https://github.com/hughsk/glsl-hsv2rgb)
@usableFromInline func hsbToRgb(hue: Double, sat: Double, bri: Double) -> SIMD4<Double> {
    hsbToRgb(.init(hue, sat, bri))
}

@usableFromInline func hsbToRgb(_ c: SIMD3<Double>) -> SIMD4<Double> {
    let K = SIMD4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0)
    let p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www)
    let o = c.z * mix(K.xxx, clamp(p - K.xxx, min: 0.0, max: 1.0), t: c.y)
    
    return .init(o, 1.0)
}
