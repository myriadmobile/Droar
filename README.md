# Droar

[![CI Status](http://img.shields.io/travis/myriadmobile/Droar.svg?style=flat)](https://travis-ci.org/myriadmobile/Droar)
[![Version](https://img.shields.io/cocoapods/v/Droar.svg?style=flat)](http://cocoapods.org/pods/Droar)
[![License](https://img.shields.io/cocoapods/l/Droar.svg?style=flat)](http://cocoapods.org/pods/Droar)
[![Platform](https://img.shields.io/cocoapods/p/Droar.svg?style=flat)](http://cocoapods.org/pods/Droar)

## Installation

Droar is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Droar"
```

## Start

To start Droar, add the following line in the `didFinishLaunchingWithOptions` method of your app delegate:

```ruby
import Droar
...
Droar.start()
```

to open, simply triple-tap the screen to open Droar.

## Configuring

To configure the gesture recognizer, use the `setGestureReconizer` method of `Droar`.

There are 3 different ways configure the "knobs" (table sections) shown:

### Registering default knobs:
This can be done using the `registerDefaultKnobs` method of `Droar`.  If this isn't called, all default sections will be displayed.
    
### Registering a static knob:
Static knobs will always be shown in Droar.  They can be added using the `register` method of `Droar`.

### Dynamic view controller knobs:
When Droar is opened, it will search through the application's view controller heirarchy to find the currently active view controller(s), and pull knob info if the view controller conforms to `DroarKnob`.  This is useful for a per-screen customization of Droar.

## Author

Myriad Mobile, developer@myriadmobile.com

## License

Droar is available under the MIT license. See the LICENSE file for more info.
