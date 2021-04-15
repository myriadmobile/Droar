## Plugin Creation

Creating a plugin requires a separate cocoapod with a dependency on Droar.  Follow [this guide](https://guides.cocoapods.org/making/using-pod-lib-create.html) to create the new plugin.

> Use the syntax `<coupled_project>-Droar` for the cocoapod's name

## Modifying the .podspec

Modify your .podspec to include an appropriate summary and description, as well as any dependencies you'll need.  You can reference [netfox-Droar's .podspec](https://github.com/myriadmobile/netfox-Droar/blob/master/netfox-Droar.podspec) as a simple example.

## Loading your plugin

Droar automatically manages any plugins registered to it, however your code must register to be a "Knob" (See [README](README.md)).  There are two ways to do this:

### 1) Codeless installation

Create a new Objective-C "loader" class to perform the loading.  Override Obj-C's static `load` method to hook into the runtime, and register your knob:

```
#import "example_DroarLoader.h"
#import <Droar/Droar-Swift.h>
#import <example_Droar/example_Droar-Swift.h>

@implementation example_DroarLoader

+ (void)load {
    SEL selector = NSSelectorFromString(@"sharedInstance");
    if ([example_Droar respondsToSelector:selector])
    {
        [Droar register:[netfox_Droar performSelector:selector]];
    }
}

@end
```

Check out [netfox-Droar](https://github.com/myriadmobile/netfox-Droar/tree/master/netfox-Droar/Classes) as an example.

Registering this way won't require your user to write any code.  They'll simply register your plugin in their .podfile and carry on!

> I'm using selectors because I wanted the knob's initializer and `sharedInstance` to be private, to ensure no users will misuse it.

### 2) Have consumers of your cocoapod register it manually

Simply provide access to an intializer or `sharedInstance` of your DroarKnob to register themselves, or else write a function that will register the knob for them.

> Make sure to include how to install in your plugin's README!

## Write your plugin

Write your plugin to behave how you'd like.  Check out [netfox-Droar's knob](https://github.com/myriadmobile/netfox-Droar/blob/master/netfox-Droar/Classes/netfox-Droar.swift) as an example.

> You can learn more about `DroarKnob`s in [Droar's README](https://github.com/myriadmobile/Droar#the-droarknob-interface)