![](https://raw.githubusercontent.com/myriadmobile/Droar/master/Github/DroarLogo.png)


[![CI Status](http://img.shields.io/travis/myriadmobile/Droar.svg?style=flat)](https://travis-ci.org/myriadmobile/Droar)
[![Version](https://img.shields.io/cocoapods/v/Droar.svg?style=flat)](http://cocoapods.org/pods/Droar)
[![License](https://img.shields.io/cocoapods/l/Droar.svg?style=flat)](http://cocoapods.org/pods/Droar)
[![Platform](https://img.shields.io/cocoapods/p/Droar.svg?style=flat)](http://cocoapods.org/pods/Droar)

Droar is a modular, single-line installation debugging window.

## Overview

The idea behind Droar is simple: during app deployment stages, adding quick app configurations (switching between mock vs live, QA credential quick-login, changing http environments, etc) tend get code straight into production.  Droar solves this issue by adding quick configurations that are grouped into one place, and under a single

![Droar](https://media.giphy.com/media/7FfNceqr7lhqyqsrW6/giphy.gif)

## Installation

Droar is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Droar"
```

## Start

To start Droar, add the following line in the `didFinishLaunchingWithOptions` method of your app delegate:

```swift
import Droar
...
Droar.start()
```

to open, simply swipe starting from the far right side of the screen.

## Configuring

To configure the gesture recognizer, use the `setGestureReconizer` method of `Droar`.

There are 3 different ways configure the "knobs" (table sections) shown:

### Registering default knobs:
This can be done using the `registerDefaultKnobs` method of `Droar`.  If this isn't called, all default knobs will be displayed.
    
### Registering a static knob:
Static knobs will always be shown in Droar.  They can be added using the `register` method of `Droar`.

### Dynamic view controller knobs:
When Droar is opened, it will search through the application's view controller heirarchy to find the currently active view controller(s), and pull knob info if the view controller conforms to `DroarKnob`.  This is useful for a per-screen customization of Droar.

## Plugins

[Netfox](https://github.com/myriadmobile/netfox-Droar)

## Author

Nathan Jangula, Myriad Mobile, developer@myriadmobile.com

## License

Droar is available under the MIT license. See the LICENSE file for more info.
