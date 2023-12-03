![HandyRouterLogo](https://github.com/Leonard0803/HandyRouter/assets/16741243/c3306179-dab3-4dc1-a59f-52b7ee0e3f25)

[![Version](https://img.shields.io/cocoapods/v/HandyRouter.svg?style=flat)](https://cocoapods.org/pods/HandyRouter)
[![codecov](https://codecov.io/github/Leonard0803/HandyRouter/graph/badge.svg?token=O4GAADWBK6)](https://codecov.io/github/Leonard0803/HandyRouter)
[![License](https://img.shields.io/cocoapods/l/HandyRouter.svg?style=flat)](https://cocoapods.org/pods/HandyRouter)
[![Platform](https://img.shields.io/cocoapods/p/HandyRouter.svg?style=flat)](https://cocoapods.org/pods/HandyRouter)

- [Features](#features)
  - [Handle Deeplinks Quickly!](#handle-deeplinks-quickly)
  - [About Parameters](#about-parameters)
    - [· Support Both String And Array Typs In Parameters](#-support-both-string-and-array-typs-in-parameters)
  - [About Route options](#about-route-options)
    - [· Treating Host As Path](#-treating-host-as-path)
  - [About Module Names](#about-module-names)
    - [· Support Multiple Path Components](#-support-multiple-path-components)
    - [· Support Wildcard in Module Name](#-support-wildcard-in-module-name)
    - [· Support defining optional names in the module name](#-support-defining-optional-names-in-the-module-name)
  - [About Scheme](#about-scheme)
  - [About Fragment](#about-fragment)
  - [About Unmatch Handler](#about-unmatch-handler)
- [Example](#example)
- [Installation](#installation)
- [Author](#author)
- [License](#license)

# Features

- [x] Handle redirection for Deeplinks / Universal Links.
- [x] Centrally manage ViewController navigation within each module as a unit.

## Handle Deeplinks Quickly!
Below is a quick demo on how to handle the link `https://www.example.com/Module/A`

``` swift
// Define a Jumper to handle the specific module
enum RouteJumper: String, Jumper {
    
    case A, B
    
    static var module: String {
        return "Module"
    }

     static func jump(to page: RouteJumper, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        switch page {
        case .A:
            print("jump to pageA")
            return true
        case .B:
            print("jump to pageB")
            return true
        }
    }
}

// then register the Jumper
Router.shared.register(jumper: RouteJumper.self)

// handle link
let urlA = "https://www.example.com/Module/A"
let hasHandled_A = Router.shared.route(to: urlA) // true

let urlB = "https://www.example.com/Module/B"
let hasHandled_B = Router.shared.route(to: urlB) // true

let urlC = "https://www.example.com/Module/C"
let hasHandled_C = Router.shared.route(to: urlC) // false, because C hasn't been defined in RouteJumper
```

## About Parameters
### · Support Both String And Array Typs In Parameters
 a quick demo on how to handle the link\
`https://www.example.com/Module/A?arrayTypeDemo=1&arrayTypeDemo=2&stringTypeDemo=A`
```swift 
// define key
extension Dictionary where Key == ParameterKey {
    func toArrayValue() -> [String] {
        if let array = self[.arrayTypeDemo] as? [String] {
            return array
        }
        return []
    }
    func toStringValue() -> String {
        if let string = self[.stringTypeDemo] as? String {
            return string
        }
        return ""
    }
}

extension ParameterKey {
    static let arrayTypeDemo: ParameterKey = "arrayTypeDemo"
    static let stringTypeDemo: ParameterKey = "stringTypeDemo"
}

// define Jumper
enum RouteJumper: String, Jumper {
    
    case A
    
    static var module: String {
        return "Module"
    }

     static func jump(to page: RouteJumper, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        switch page {
        case .A:
            print(parameters.toArrayValue()) // ["1", "2"]
            print(parameters.toStringValue()) // A
            return true
        }
    }
}

// register
Router.shared.register(jumper: RouteJumper.self)

// handle link
let url = "https://www.example.com/Module/A?arrayTypeDemo=1&arrayTypeDemo=2&stringTypeDemo=A"
let hasHandled = Router.shared.route(to: url) // true
```

## About Route options
### · Treating Host As Path
Sometimes the link may not contain the host, like this `handyrouter://Module/A`, in this situation, we should set `RouteOption` as `treatHostAsPathComponent`
``` swift

// define
enum RouteJumper: String, Jumper {
    
    case A, B
    
    static var module: String {
        return "Module"
    }

    static func jump(to page: RouteJumper, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        switch page {
        case .A:
            return true
        case .B:
            return true
        }
    }
}

// add .treatHostAsPathComponent to RouteOptionSet when you register the jumper
Router.shared.register(jumper: RouteJumper.self,option: [.treatHostAsPathComponent])

// handle link
let urlA = "https://Module/A"
let hasHandled_A = Router.shared.route(to: urlA) // true

let urlB = "https://Module/B"
let hasHandled_B = Router.shared.route(to: urlB) // true

let urlC = "https:///Module/C"
let hasHandled_C = Router.shared.route(to: urlC) // false, because C hasn't been defined in RouteJumper
```

## About Module Names
### · Support Multiple Path Components
The module name can be composed of multiple path components
```swift
// define
enum RouteJumper: String, Jumper {
    // ...
    case A = "PageA", B = "PageB"
    
    static var module: String {
        return "This/is/your/Module/Name"
    }
    // ...
}

// register
Router.shared.register(jumper: RouteJumper.self,option: [.treatHostAsPathComponent])

// handle link
let urlA = "https://This/is/your/Module/Name/PageA"
let hasHandled_A = Router.shared.route(to: urlA) // true

let urlB = "https://This/is/your/Module/Name/PageB"
let hasHandled_B = Router.shared.route(to: urlB) // true

```

### · Support Wildcard in Module Name
⚠️ Be cautious when employing this method for adaptation, as it may sometimes match links you didn't intend to match.\
The wildcard will match all subsequent paths
```swift
// define
enum RouteJumper: String, Jumper {
    // ...
    case A = "PageA", B = "PageB"
    
    static var module: String {
        return "wildcardDemo/*"
    }
    // ...
}

// register
Router.shared.register(jumper: RouteJumper.self,option: [.treatHostAsPathComponent])

// handle link
let urlA = "https://wildcardDemo/PageA"
let hasHandled_A = Router.shared.route(to: urlA) // true

let urlB = "https://wildcardDemo/The/wildcard/will/match/all/subsequent/paths/PageB"
let hasHandled_B = Router.shared.route(to: urlB) // true
```

### · Support defining optional names in the module name
⚠️ Be cautious when employing this method for adaptation, as it may sometimes match links you didn't intend to match \
Use parentheses to enclose optional paths in the module name. Doing so allows a successful match regardless of whether the link includes that optional path.
```swift
// define
enum RouteJumper: String, Jumper {
    // ...
    case A = "PageA", B = "PageB"
    
    static var module: String {
        return "my/(optional)/module"
    }
    // ...
}

// register
Router.shared.register(jumper: RouteJumper.self,option: [.treatHostAsPathComponent])

// handle link
let urlA = "https://my/optional/module/PageA"
let hasHandled_A = Router.shared.route(to: urlA) // true

let urlB = "https://my/module/PageB"
let hasHandled_B = Router.shared.route(to: urlB) // true
```

## About Scheme
If you omit the scheme specification during Jumper registration, it will, by default, match all schemes.
```swift
// define
enum RouteJumper: String, Jumper {
    
    case A
    
    static var module: String {
        return "Module"
    }

    // ...
}

// register
Router.shared.register(jumper: RouteJumper.self,option: [.treatHostAsPathComponent])

// handle link
let urlA = "schemeA://Module/A"
let hasHandled_A = Router.shared.route(to: urlA) // true

let urlB = "schemeB://Module/A"
let hasHandled_B = Router.shared.route(to: urlB) // true
```

If you define the scheme during Jumper registration, it won't match if the scheme is not consistent.
```swift
// ...

// register
Router.shared.register(jumper: RouteJumper.self, scheme: "schemeA", option: [.treatHostAsPathComponent])

// handle link
let urlA = "schemeA://Module/A"
let hasHandled_A = Router.shared.route(to: urlA) // true

let urlB = "schemeB://Module/A"
let hasHandled_B = Router.shared.route(to: urlB) // false

```

## About Fragment
Fragment should be considered as a part of `page`
```swift
// define
enum RouteJumper: String, Jumper {
    
    case A = "A#fragment"
    
    static var module: String {
        return "Module"
    }

     static func jump(to page: RouteJumper, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        switch page {
        case .A:
            print(page.rawValue) // A#fragment
            return true
        }
    }
}

// register
Router.shared.register(jumper: RouteJumper.self)

// handle link
let url = "https://www.example.com/Module/A#fragment"
let hasHandled = Router.shared.route(to: url) // true
```

However, when a fragment appears in the form of a parameter, it will be interpreted as a `parameter`.
```swift
// define
enum RouteJumper: String, Jumper {
    
    case A = "A"
    
    static var module: String {
        return "Module"
    }

     static func jump(to page: RouteJumper, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        switch page {
        case .A:
            print(parameters["key1"]) // Optional("value1")
            print(parameters["key2"]) // Optional("value2")
            return true
        }
    }
}

// register
Router.shared.register(jumper: RouteJumper.self)

// handle link
let url = "https://www.example.com/Module/A#key1=value1&key2=value2"
let hasHandled = Router.shared.route(to: url) // true
```


## About Unmatch Handler

In the following case, no Jumper has been registered for `schemeB`.
Consequently, when calling `schemeB://Module/B`, Router cannot find a match, leading to the invocation of the `defaultRoute` unmatchHandler.

```swift
// register
Router.shared.register(jumper: RouteJumper.self, scheme: "schemeA", option: [.treatHostAsPathComponent])

// config unmatchHandler
Router.shared.defaultRoute.unmatchHandler = { route, resource, parameters in
    print(route.scheme, resource, parameters)
}

// handle link
let urlA = "schemeA://Module/A"
let hasHandled_A = Router.shared.route(to: urlA) // true

let urlB = "schemeB://Module/B"
let hasHandled_B = Router.shared.route(to: urlB) // false
```

# Example

You can find an example app [here](https://github.com/Leonard0803/HandyRouter/tree/main/Example).


# Installation

HandyRouter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HandyRouter'
```

# Author

Shelley, aionyiruma@163.com

# License

HandyRouter is available under the MIT license. See the LICENSE file for more info.
