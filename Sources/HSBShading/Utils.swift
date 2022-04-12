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

/// Converts HSB values to RGB.
/// - Note: Borrowed from http://tamivox.org/darlene/rgb_hsb/index.html
@usableFromInline func hsbToRgb(hue: CGFloat, sat: CGFloat, bri: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
    guard sat > 0 else { return (bri, bri, bri) }
    let hue = hue < 1 ? hue : 0
    
    let pro = bri * sat
    let dim = bri - pro
    let mul = hue * 6
    
    switch mul {
    case 0: return (bri, dim, dim) // I
    case ..<1: return (bri, dim + pro * mul, dim) // II
    case 1: return (bri, bri, dim) // III
    case ..<2: return (dim + pro * (2 - mul), bri, dim) // IV
    case 2: return (dim, bri, dim) // V
    case ..<3: return (dim, bri, dim + pro * (mul - 2)) // VI
    case 3: return (dim, bri, bri) // VII
    case ..<4: return (dim, dim + pro * (4 - mul), bri) // VIII
    case 4: return (dim, dim, bri) // IX
    case ..<5: return (dim + pro * (mul - 4), dim, bri) // X
    case 5: return (bri, dim, bri) // XI
    default: return (bri, dim, dim + pro * (6 - mul)) // XII
    }
}
