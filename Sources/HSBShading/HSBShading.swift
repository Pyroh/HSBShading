//
//  HSBShading.swift
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

public enum HSBShading {
    /// Draws a hue axial shading.
    /// - Parameters:
    ///   - ctx: The `CGContext` to draw the shading to.
    ///   - colorSpace: The color space in which color values are expressed.
    ///   - start: The starting point of the axis, in the shading's target coordinate space.
    ///   - end: The ending point of the axis, in the shading's target coordinate space.
    ///   - saturation: The saturaton component to use for the shading.
    ///   - brigthness: The brightness component to use for the shading.
    ///   - alpha: The alpha component to use for the shading.
    ///   - hueRange: The range in which interpolate the shading's hue component.
    ///   - extendStart: Specifies whether to extend the shading beyond the starting point of the axis.
    ///   - extendEnd: Specifies whether to extend the shading beyond the ending point of the axis.
    @inlinable
    public static func drawAxialHueShading(to ctx: CGContext, colorSpace: CGColorSpace,
                                           start: CGPoint, end: CGPoint,
                                           saturation: CGFloat = 1.0, brightness: CGFloat = 1.0,
                                           alpha: CGFloat = 1.0, hueRange: ClosedRange<CGFloat> = 0...1,
                                           extendStart: Bool = true, extendEnd: Bool = true) {
        assert(colorSpace.model == .rgb, "The color space model must be RGB.")
        let saturation = clamp(saturation, 0, 1)
        let brightness = clamp(brightness, 0, 1)
        let alpha = clamp(alpha, 0, 1)
        let hueRange = hueRange.clamped(to: 0...1)
        let domain = [hueRange.lowerBound, hueRange.upperBound]
        
        let comps = ConstantComponents(c1: saturation, c2: brightness, aa: alpha)
        let unmanagedComps = Unmanaged.passRetained(comps)
        defer { unmanagedComps.release() }
        
        guard
            let f = HSBShading.createFunctionFor(HueRampEvaluation, with: unmanagedComps.toOpaque(), domain: domain),
            let shading = CGShading(axialSpace: colorSpace, start: start, end: end, function: f, extendStart: extendStart, extendEnd: extendEnd)
        else { return assertionFailure("Unable to draw the shading.") }
        
        ctx.drawShading(shading)
    }

    /// Draws a saturation axial shading.
    /// - Parameters:
    ///   - ctx: The `CGContext` to draw the shading to.
    ///   - colorSpace: The color space in which color values are expressed.
    ///   - start: The starting point of the axis, in the shading's target coordinate space.
    ///   - end: The ending point of the axis, in the shading's target coordinate space.
    ///   - hue: The hue component to use for the shading.
    ///   - brightness: The brightness component to use for the shading.
    ///   - alpha: The alpha component to use for the shading.
    ///   - saturationRange: The range in which interpolate the shading's saturation component.
    ///   - extendStart: Specifies whether to extend the shading beyond the starting point of the axis.
    ///   - extendEnd: Specifies whether to extend the shading beyond the ending point of the axis.
    @inlinable
    public static func drawAxialSaturationShading(to ctx: CGContext, colorSpace: CGColorSpace,
                                                  start: CGPoint, end: CGPoint,
                                                  hue: CGFloat = 1.0, brightness: CGFloat = 1.0,
                                                  alpha: CGFloat = 1.0, saturationRange: ClosedRange<CGFloat> = 0...1,
                                                  extendStart: Bool = true, extendEnd: Bool = true) {
        assert(colorSpace.model == .rgb, "The color space model must be RGB.")
        let hue = clamp(hue, 0, 1)
        let brightness = clamp(brightness, 0, 1)
        let alpha = clamp(alpha, 0, 1)
        let saturationRange = saturationRange.clamped(to: 0...1)
        let domain = [saturationRange.lowerBound, saturationRange.upperBound]
        
        let comps = ConstantComponents(c1: hue, c2: brightness, aa: alpha)
        let unmanagedComps = Unmanaged.passRetained(comps)
        defer { unmanagedComps.release() }
        
        guard
            let f = HSBShading.createFunctionFor(SatRampEvaluation, with: unmanagedComps.toOpaque(), domain: domain),
            let shading = CGShading(axialSpace: colorSpace, start: start, end: end, function: f, extendStart: extendStart, extendEnd: extendEnd)
        else { return assertionFailure("Unable to draw the shading.") }
        
        ctx.drawShading(shading)
    }
    
    /// Draws a brightness axial shading.
    /// - Parameters:
    ///   - ctx: The `CGContext` to draw the shading to.
    ///   - colorSpace: The color space in which color values are expressed.
    ///   - start: The starting point of the axis, in the shading's target coordinate space.
    ///   - end: The ending point of the axis, in the shading's target coordinate space.
    ///   - hue: The hue component to use for the shading.
    ///   - saturation: The saturation component to use for the shading.
    ///   - alpha: The alpha component to use for the shading.
    ///   - brightnessRange: The range in which interpolate the shading's brightness component.
    ///   - extendStart: Specifies whether to extend the shading beyond the starting point of the axis.
    ///   - extendEnd: Specifies whether to extend the shading beyond the ending point of the axis.
    @inlinable
    public static func drawAxialBrightnessShading(to ctx: CGContext, colorSpace: CGColorSpace,
                                                  start: CGPoint, end: CGPoint,
                                                  hue: CGFloat = 1.0, saturation: CGFloat = 1.0,
                                                  alpha: CGFloat = 1.0, brightnessRange: ClosedRange<CGFloat> = 0...1,
                                                  extendStart: Bool = true, extendEnd: Bool = true) {
        assert(colorSpace.model == .rgb, "The color space model must be RGB.")
        let hue = clamp(hue, 0, 1)
        let saturation = clamp(saturation, 0, 1)
        let alpha = clamp(alpha, 0, 1)
        let brightnessRange = brightnessRange.clamped(to: 0...1)
        let domain = [brightnessRange.lowerBound, brightnessRange.upperBound]
        
        let comps = ConstantComponents(c1: hue, c2: saturation, aa: alpha)
        let unmanagedComps = Unmanaged.passRetained(comps)
        defer { unmanagedComps.release() }
        
        guard
            let f = HSBShading.createFunctionFor(BriRampEvaluation, with: unmanagedComps.toOpaque(), domain: domain),
            let shading = CGShading(axialSpace: colorSpace, start: start, end: end, function: f, extendStart: extendStart, extendEnd: extendEnd)
        else { return assertionFailure("Unable to draw the shading.") }
        
        ctx.drawShading(shading)
    }
    
    
    /// Draws a radial hue shading.
    /// - Parameters:
    ///   - ctx: The `CGContext` to draw the shading to.
    ///   - colorSpace: The color space in which color values are expressed.
    ///   - start: The center of the starting circle.
    ///   - startRadius: The radius of the starting circle.
    ///   - end: The center of the ending circle.
    ///   - endRadius: The radius of the ending circle.
    ///   - saturation: The saturaton component to use for the shading.
    ///   - brightness: The brightness component to use for the shading.
    ///   - alpha: The alpha component to use for the shading.
    ///   - hueRange: The range in which interpolate the shading's hue component.
    ///   - extendStart: Specifies whether to extend the shading beyond the starting point of the axis.
    ///   - extendEnd: Specifies whether to extend the shading beyond the ending point of the axis.
    @inlinable
    public static func drawRadialHueShading(to ctx: CGContext, colorSpace: CGColorSpace,
                                            start: CGPoint, startRadius: CGFloat,
                                            end: CGPoint, endRadius: CGFloat,
                                            saturation: CGFloat = 1.0, brightness: CGFloat = 1.0,
                                            alpha: CGFloat = 1.0, hueRange: ClosedRange<CGFloat> = 0...1,
                                            extendStart: Bool = false, extendEnd: Bool = false) {
        let saturation = clamp(saturation, 0, 1)
        let brightness = clamp(brightness, 0, 1)
        let alpha = clamp(alpha, 0, 1)
        let hueRange = hueRange.clamped(to: 0...1)
        let domain = [hueRange.lowerBound, hueRange.upperBound]
        
        let comps = ConstantComponents(c1: saturation, c2: brightness, aa: alpha)
        let unmanagedComps = Unmanaged.passRetained(comps)
        defer { unmanagedComps.release() }
        
        guard
            let f = HSBShading.createFunctionFor(HueRampEvaluation, with: unmanagedComps.toOpaque(), domain: domain),
            let shading = CGShading(radialSpace: colorSpace, start: start, startRadius: startRadius, end: end, endRadius: endRadius, function: f, extendStart: extendStart, extendEnd: extendEnd)
        else { fatalError("Unkown error") }
        
        ctx.drawShading(shading)
    }
    
    
    /// Draws a radial hue shading.
    /// - Parameters:
    ///   - ctx: The `CGContext` to draw the shading to.
    ///   - colorSpace: The color space in which color values are expressed.
    ///   - center: The center of both the starting and ending circles.
    ///   - startRadius: The radius of the starting circle.
    ///   - endRadius: The radius of the ending circle.
    ///   - saturation: The saturaton component to use for the shading.
    ///   - brightness: The brightness component to use for the shading.
    ///   - alpha: The alpha component to use for the shading.
    ///   - hueRange: The range in which interpolate the shading's hue component.
    ///   - extendStart: Specifies whether to extend the shading beyond the starting point of the axis.
    ///   - extendEnd: Specifies whether to extend the shading beyond the ending point of the axis.
    @inlinable
    public static func drawRadialHueShading(to ctx: CGContext, colorSpace: CGColorSpace,
                                            center: CGPoint, startRadius: CGFloat, endRadius: CGFloat,
                                            saturation: CGFloat = 1.0, brightness: CGFloat = 1.0,
                                            alpha: CGFloat = 1.0, hueRange: ClosedRange<CGFloat> = 0...1,
                                            extendStart: Bool = false, extendEnd: Bool = false) {
        let saturation = clamp(saturation, 0, 1)
        let brightness = clamp(brightness, 0, 1)
        let alpha = clamp(alpha, 0, 1)
        let hueRange = hueRange.clamped(to: 0...1)
        let domain = [hueRange.lowerBound, hueRange.upperBound]
        
        let comps = ConstantComponents(c1: saturation, c2: brightness, aa: alpha)
        let unmanagedComps = Unmanaged.passRetained(comps)
        defer { unmanagedComps.release() }
        
        guard
            let f = HSBShading.createFunctionFor(HueRampEvaluation, with: unmanagedComps.toOpaque(), domain: domain),
            let shading = CGShading(radialSpace: colorSpace, start: center, startRadius: startRadius, end: center, endRadius: endRadius, function: f, extendStart: extendStart, extendEnd: extendEnd)
        else { fatalError("Unkown error") }
        
        ctx.drawShading(shading)
    }
    
    
    /// Draws a radial saturation shading.
    /// - Parameters:
    ///   - ctx: The `CGContext` to draw the shading to.
    ///   - colorSpace: The color space in which color values are expressed.
    ///   - start: The center of the starting circle.
    ///   - startRadius: The radius of the starting circle.
    ///   - end: The center of the ending circle.
    ///   - endRadius: The radius of the ending circle.
    ///   - hue: The hue component to use for the shading.
    ///   - brightness: The brightness component to use for the shading.
    ///   - alpha: The alpha component to use for the shading.
    ///   - saturationRange: The range in which interpolate the shading's saturation component.
    ///   - extendStart: Specifies whether to extend the shading beyond the starting point of the axis.
    ///   - extendEnd: Specifies whether to extend the shading beyond the ending point of the axis.
    @inlinable
    public static func drawRadialSaturationShading(to ctx: CGContext, colorSpace: CGColorSpace,
                                                   start: CGPoint, startRadius: CGFloat,
                                                   end: CGPoint, endRadius: CGFloat,
                                                   hue: CGFloat = 1.0, brightness: CGFloat = 1.0,
                                                   alpha: CGFloat = 1.0, saturationRange: ClosedRange<CGFloat> = 0...1,
                                                   extendStart: Bool = false, extendEnd: Bool = false) {
        let hue = clamp(hue, 0, 1)
        let brightness = clamp(brightness, 0, 1)
        let alpha = clamp(alpha, 0, 1)
        let saturationRange = saturationRange.clamped(to: 0...1)
        let domain = [saturationRange.lowerBound, saturationRange.upperBound]
        
        let comps = ConstantComponents(c1: hue, c2: brightness, aa: alpha)
        let unmanagedComps = Unmanaged.passRetained(comps)
        defer { unmanagedComps.release() }
        
        guard
            let f = HSBShading.createFunctionFor(SatRampEvaluation, with: unmanagedComps.toOpaque(), domain: domain),
            let shading = CGShading(radialSpace: colorSpace, start: start, startRadius: startRadius, end: end, endRadius: endRadius, function: f, extendStart: extendStart, extendEnd: extendEnd)
        else { fatalError("Unknown error") }
        
        ctx.drawShading(shading)
    }
    
    /// Draws a radial saturation shading.
    /// - Parameters:
    ///   - ctx: The `CGContext` to draw the shading to.
    ///   - colorSpace: The color space in which color values are expressed.
    ///   - center: The center of both the starting and ending circles.
    ///   - startRadius: The radius of the starting circle.
    ///   - endRadius: The radius of the ending circle.
    ///   - hue: The hue component to use for the shading.
    ///   - brightness: The brightness component to use for the shading.
    ///   - alpha: The alpha component to use for the shading.
    ///   - saturationRange: The range in which interpolate the shading's saturation component.
    ///   - extendStart: Specifies whether to extend the shading beyond the starting point of the axis.
    ///   - extendEnd: Specifies whether to extend the shading beyond the ending point of the axis.
    @inlinable
    public static func drawRadialSaturationShading(to ctx: CGContext, colorSpace: CGColorSpace,
                                                   center: CGPoint, startRadius: CGFloat, endRadius: CGFloat,
                                                   hue: CGFloat = 1.0, brightness: CGFloat = 1.0,
                                                   alpha: CGFloat = 1.0, saturationRange: ClosedRange<CGFloat> = 0...1,
                                                   extendStart: Bool = false, extendEnd: Bool = false) {
        let hue = clamp(hue, 0, 1)
        let brightness = clamp(brightness, 0, 1)
        let alpha = clamp(alpha, 0, 1)
        let saturationRange = saturationRange.clamped(to: 0...1)
        let domain = [saturationRange.lowerBound, saturationRange.upperBound]
        
        let comps = ConstantComponents(c1: hue, c2: brightness, aa: alpha)
        let unmanagedComps = Unmanaged.passRetained(comps)
        defer { unmanagedComps.release() }
        
        guard
            let f = HSBShading.createFunctionFor(SatRampEvaluation, with: unmanagedComps.toOpaque(), domain: domain),
            let shading = CGShading(radialSpace: colorSpace, start: center, startRadius: startRadius, end: center, endRadius: endRadius, function: f, extendStart: extendStart, extendEnd: extendEnd)
        else { fatalError("Unknown error") }
        
        ctx.drawShading(shading)
    }
    
    /// Draws a radial brightness shading.
    /// - Parameters:
    ///   - ctx: The `CGContext` to draw the shading to.
    ///   - colorSpace: The color space in which color values are expressed.
    ///   - start: The center of the starting circle.
    ///   - startRadius: The radius of the starting circle.
    ///   - end: The center of the ending circle.
    ///   - endRadius: The radius of the ending circle.
    ///   - hue: The hue component to use for the shading.
    ///   - saturation: The saturation component to use for the shading.
    ///   - alpha: The alpha component to use for the shading.
    ///   - brightnessRange: The range in which interpolate the shading's brightness component.
    ///   - extendStart: Specifies whether to extend the shading beyond the starting point of the axis.
    ///   - extendEnd: Specifies whether to extend the shading beyond the ending point of the axis.
    @inlinable
    public static func drawRadialBrightnessShading(to ctx: CGContext, colorSpace: CGColorSpace,
                                                   start: CGPoint, startRadius: CGFloat,
                                                   end: CGPoint, endRadius: CGFloat,
                                                   hue: CGFloat = 1.0, saturation: CGFloat = 1.0,
                                                   alpha: CGFloat = 1.0, brightnessRange: ClosedRange<CGFloat> = 0...1,
                                                   extendStart: Bool = false, extendEnd: Bool = false) {
        let hue = clamp(hue, 0, 1)
        let saturation = clamp(saturation, 0, 1)
        let alpha = clamp(alpha, 0, 1)
        let brightnessRange = brightnessRange.clamped(to: 0...1)
        let domain = [brightnessRange.lowerBound, brightnessRange.upperBound]
        
        let comps = ConstantComponents(c1: hue, c2: saturation, aa: alpha)
        let unmanagedComps = Unmanaged.passRetained(comps)
        defer { unmanagedComps.release() }
        
        guard
            let f = HSBShading.createFunctionFor(BriRampEvaluation, with: unmanagedComps.toOpaque(), domain: domain),
            let shading = CGShading(radialSpace: colorSpace, start: start, startRadius: startRadius, end: end, endRadius: endRadius, function: f, extendStart: extendStart, extendEnd: extendEnd)
        else { fatalError("Unknown error") }
        
        ctx.drawShading(shading)
    }
    
    /// Draws a radial brightness shading.
    /// - Parameters:
    ///   - ctx: The `CGContext` to draw the shading to.
    ///   - colorSpace: The color space in which color values are expressed.
    ///   - center: The center of both the starting and ending circles.
    ///   - startRadius: The radius of the starting circle.
    ///   - endRadius: The radius of the ending circle.
    ///   - hue: The hue component to use for the shading.
    ///   - saturation: The saturation component to use for the shading.
    ///   - alpha: The alpha component to use for the shading.
    ///   - brightnessRange: The range in which interpolate the shading's brightness component.
    ///   - extendStart: Specifies whether to extend the shading beyond the starting point of the axis.
    ///   - extendEnd: Specifies whether to extend the shading beyond the ending point of the axis.
    @inlinable
    public static func drawRadialBrightnessShading(to ctx: CGContext, colorSpace: CGColorSpace,
                                                   center: CGPoint, startRadius: CGFloat, endRadius: CGFloat,
                                                   hue: CGFloat = 1.0, saturation: CGFloat = 1.0,
                                                   alpha: CGFloat = 1.0, brightnessRange: ClosedRange<CGFloat> = 0...1,
                                                   extendStart: Bool = false, extendEnd: Bool = false) {
        let hue = clamp(hue, 0, 1)
        let saturation = clamp(saturation, 0, 1)
        let alpha = clamp(alpha, 0, 1)
        let brightnessRange = brightnessRange.clamped(to: 0...1)
        let domain = [brightnessRange.lowerBound, brightnessRange.upperBound]
        
        let comps = ConstantComponents(c1: hue, c2: saturation, aa: alpha)
        let unmanagedComps = Unmanaged.passRetained(comps)
        defer { unmanagedComps.release() }
        
        guard
            let f = HSBShading.createFunctionFor(BriRampEvaluation, with: unmanagedComps.toOpaque(), domain: domain),
            let shading = CGShading(radialSpace: colorSpace, start: center, startRadius: startRadius, end: center, endRadius: endRadius, function: f, extendStart: extendStart, extendEnd: extendEnd)
        else { fatalError("Unknown error") }
        
        ctx.drawShading(shading)
    }
    
    /// Creates the `CGFuntion` to pass to a `CGShading`.
    /// - Parameters:
    ///   - callback: The evaluation function.
    ///   - comps: The info passed to the evaluation function.
    /// - Returns: The resulting `CGFunction`.
    @usableFromInline
    static func createFunctionFor(_ callback: @escaping CGFunctionEvaluateCallback,
                                  with comps: UnsafeMutableRawPointer,
                                  domain: [CGFloat] = [0, 1]) -> CGFunction? {
        withUnsafePointer(to: CGFunctionCallbacks(version: 0, evaluate: callback, releaseInfo: nil)) {
            CGFunction(info: comps,
                       domainDimension: 1, domain: domain,
                       rangeDimension: 4, range: [0, 1, 0, 1, 0, 1, 0, 1],
                       callbacks: $0)
        }
    }
}
