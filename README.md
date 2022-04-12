<img src="https://raw.githubusercontent.com/Pyroh/HSBShading/main/res/HSBShading.png" width="420px"/>

`HSBShading` draws hue, saturation and brightness shadings to a `CGContext`. Those shadings can be axial or radial.

## Installation
As a Swift Package you can add HSBShading as a dependency in your project's *Package.swift* file :

```swift
dependencies: [
// Dependencies declare other packages that this package depends on.
...
    .package(url: "https://github.com/Pyroh/HSBShading", .upToNextMajor(from: "0.1.0")),
...
],
```
Then `import HSBShading` wherever needed.

Or copy the code into your own code. Whatever suits you. Don't forget about the license and to wash your hands.

## Usage
### Drawing an axial **hue** shading
```Swift
class AxialHueShadingView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        ...
        
        let cs = /* An RGB color space */
        let ctx = /* The CGContext */
        let start = /* The starting point of the shading */
        let end = /* The ending point of the shading */
        
        HSBShading.drawAxialHueShading(to: ctx, colorSpace: cs, start: start, end: end)
        
        ...
    }
}
```

Result:  

<img src="https://raw.githubusercontent.com/Pyroh/HSBShading/main/res/axial_hue.png" width="336px"/>

### Drawing an axial **saturation** shading
```Swift
class AxialSaturationShadingView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        ...
        
        /* Set variables */
        
        HSBShading.drawAxialSaturationShading(to: ctx, colorSpace: cs, start: start, end: end)
        
        ...
    }
}
```

Result:  

<img src="https://raw.githubusercontent.com/Pyroh/HSBShading/main/res/axial_sat.png" width="336px"/>

### Drawing an axial **brightness** shading
```Swift
class AxialBrightnessShadingView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        ...
        
        /* Set variables */
        
        HSBShading.drawAxialBrightnessShading(to: ctx, colorSpace: cs, start: start, end: end)
        
        ...
    }
}
```

Result:  

<img src="https://raw.githubusercontent.com/Pyroh/HSBShading/main/res/axial_bri.png" width="336px"/>

### Drawing a radial **hue** shading
```Swift
class RadialHueShadingView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        ...
    
        let cs = /* An RGB color space */
        let ctx = /* The CGContext */
        let start = /* The center of the starting circle */
        let end = /* The center of the ending circle */
        let startRadius = /* The radius of the starting circle */
        let endRadius = /* The radius of the ending circle */
        
        HSBShading.drawRadialHueShading(to: ctx, colorSpace: cs, start: end, startRadius: endRadius, end: start, endRadius: startRadius)
        
        ...
    }
}
```

Result:  

<img src="https://raw.githubusercontent.com/Pyroh/HSBShading/main/res/radial_hue.png"  width="342px"/>

### Drawing a radial **saturation** shading
```Swift
class RadialSaturationShadingView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        ...
    
        /* Set variables */
        
        HSBShading.drawRadialSaturationShading(to: ctx, colorSpace: cs, start: end, startRadius: endRadius, end: start, endRadius: startRadius)
        
        ...
    }
}
```

Result:  

<img src="https://raw.githubusercontent.com/Pyroh/HSBShading/main/res/radial_sat.png"  width="342px"/>

### Drawing a radial **brightness** shading
```Swift
class RadialBrightnessShadingView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        ...
    
        /* Set variables */
        
        HSBShading.drawRadialBrightnessShading(to: ctx, colorSpace: cs, start: end, startRadius: endRadius, end: start, endRadius: startRadius)
        
        ...
    }
}
```

Result:  

<img src="https://raw.githubusercontent.com/Pyroh/HSBShading/main/res/radial_bri.png"  width="342px"/>

## License
**Copyright (c) 2022 Pierre Tacchi**

> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.

> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.
