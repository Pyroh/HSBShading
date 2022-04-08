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

/// Converts HSB values to RGB.
/// - Note: Shamelessly stolen from http://tamivox.org/darlene/rgb_hsb/index.html
@usableFromInline func hsbToRgb(hue: CGFloat, sat: CGFloat, bri: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
    guard sat > 0 else { return (bri, bri, bri) }
    let hue = hue < 1 ? hue : 0
    
    let pro = bri * sat
    let dim = bri - pro
    let mul = hue * 6
    
    switch mul {
    case 0: return (bri, dim, dim)
    case ..<1: return (bri, dim + pro * mul, dim)
    case 1: return (bri, bri, dim)
    case ..<2: return (dim + pro * (2 - mul), bri, dim)
    case 2: return (dim, bri, dim)
    case ..<3: return (dim, bri, dim + pro * (mul - 2))
    case 3: return (dim, bri, bri)
    case ..<4: return (dim, dim + pro * (4 - mul), bri)
    case 4: return (dim, dim, bri)
    case ..<5: return (dim + pro * (mul - 4), dim, bri)
    case 5: return (bri, dim, bri)
    default: return (bri, dim, dim + pro * (6 - mul))
    }
}
