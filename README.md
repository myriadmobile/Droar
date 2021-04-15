<p align="center">
<img src="https://raw.githubusercontent.com/myriadmobile/Droar/master/Github/DroarLogo.png">
</p>

[![CI Status](http://img.shields.io/travis/myriadmobile/Droar.svg?style=flat)](https://travis-ci.org/myriadmobile/Droar)
[![Version](https://img.shields.io/cocoapods/v/Droar.svg?style=flat)](http://cocoapods.org/pods/Droar)
[![License](https://img.shields.io/cocoapods/l/Droar.svg?style=flat)](http://cocoapods.org/pods/Droar)
[![Platform](https://img.shields.io/cocoapods/p/Droar.svg?style=flat)](http://cocoapods.org/pods/Droar)

Droar is a modular, single-line installation debugging window.

## Overview

The idea behind Droar is simple: during app deployment stages, adding quick app configurations (switching between mock vs live, QA credential quick-login, changing http environments, etc) tend to get written and shipped straight inline with production code.  Droar solves this issue by adding quick configurations that are grouped into one place, and under a single tool.

<p align="center">
<img src="https://media.giphy.com/media/7FfNceqr7lhqyqsrW6/giphy.gif">
</p>

## Installation

Droar is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Droar"
```

## Start

To start Droar, add the following in the `didFinishLaunchingWithOptions` method of your app delegate:

```
import Droar

...
if nonProductionEnvironment {
    Droar.start()
}
```

To open, simply swipe starting from the far right side of the screen.

## Configuring

### Adding your own Knobs (table sections)

There are two ways to add knobs in Droar:

#### Static Knobs

Static knobs will always appear in Droar.  Simply conform a new or existing class to `DroarKnob`, and use `Droar.register(DroarKnob)` to register an instance of it.

#### Dynamic Knobs

Dynamic knobs are instances of `UIViewController` that conform to `DroarKnob`.  When Droar is appearing, it will search through the main window's view controller hierarchy and and find currently active/visible `UIViewController`'s, to see if they conform to `DroarKnob`.

There is no need to register your view controllers as static knobs.  Simply conform to `DroarKnob`, and Droar will pull information from them if Droar is opened on that screen.

If you conform a `UINavigationController`, `UITabBarViewController`, etc to `DroarKnob` (and it's currently visible/active), Droar will pull information both from it, as well as its active/visible view controller.

#### The `DroarKnob` Interface:

```
@objc public protocol DroarKnob {
    // Perform any setup before this knob loads (Register table cells, clear cached data, etc)
    @objc optional func droarKnobWillBeginLoading(tableView: UITableView?)
    
    // Title for this knob.  If title matches existing knob, they will be combined
    @objc func droarKnobTitle() -> String
    
    // The positioning and priorty for this knob
    @objc func droarKnobPosition() -> PositionInfo
    
    // The number of cells for this knob
    @objc func droarKnobNumberOfCells() -> Int
    
    // The cell at the specified index.  There are many pre-defined cells, just use Droar<#type#>Cell.create(), or create your own.
    @objc func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell
    
    // Indicates the cell was selected.  This will not be called if `UITableViewCell.selectionStyle == .none`
    @objc optional func droarKnobIndexSelected(tableView: UITableView, selectedIndex: Int)
}
```

### Activation Gesture

To configure the gesture that opens Droar, use the `setGestureType` method of `Droar`.

### Default Knobs
You can control which of the default sections are shown using the `registerDefaultKnobs` method of `Droar`.  If this isn't called, all default knobs will be displayed.

## Plugins

### [netfox-Droar](https://github.com/myriadmobile/netfox-Droar)
[netfox](https://github.com/kasketis/netfox) is a lightweight, one line setup, iOS / OSX network debugging library.


### [OHHTTPStubs-Droar](https://github.com/myriadmobile/OHHTTPStubs-Droar)
[OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs) is a library designed to stub your network requests very easily.
Since this plugin requires custom customization of OHHTTPStubs, it is dependent on a [fork of the OHHTPStubs](https://github.com/myriadmobile/OHHTTPStubs).

### [FBMemoryProfiler-Droar](https://github.com/myriadmobile/FBMemoryProfiler-Droar)
[FBMemoryProfiler](https://github.com/facebook/FBMemoryProfiler) is an iOS library providing developer tools for browsing objects in memory over time, using FBAllocationTracker and FBRetainCycleDetector.

## Writing a Plugin

Check out [the guide](PLUGINS.md) for creating a new Droar plugin.

## Author

Nathan Jangula, Myriad Mobile, developer@myriadmobile.com

## License

Droar is available under the MIT license. See the LICENSE file for more info.


