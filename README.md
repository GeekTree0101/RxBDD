<img src="https://github.com/GeekTree0101/RxBDD/blob/master/resources/logo.png" />

![CI Status](https://travis-ci.com/GeekTree0101/RxBDD.svg?branch=master)
[![Version](https://img.shields.io/cocoapods/v/RxBDD.svg?style=flat)](https://cocoapods.org/pods/RxBDD)
[![License](https://img.shields.io/cocoapods/l/RxBDD.svg?style=flat)](https://cocoapods.org/pods/RxBDD)
[![Platform](https://img.shields.io/cocoapods/p/RxBDD.svg?style=flat)](https://cocoapods.org/pods/RxBDD)

## Example

> Basic Usege
```swift
RxBDD.init(inputObservable: #INPUT_OBSERVABLETYPE, // Relay or Subject
            outputType: #EXPECTED_OUTPUT_TYPE)
      .given(#INPUT_EVENTS) // [Recorded<Event<#INPUT_OBSERVABLETYPE_ELEMENT>>]
      .when(#OUTPUT_OBSERVABLE) // Observable<#EXPECTED_OUTPUT_TYPE>
      .then({ outputs in
           XCTAssertEqual(outputs,
                          #EXPECTED_EVENTS) // [Recorded<Event<#EXPECTED_OUTPUT_TYPE>>]
      })
```

> Share given events
```swift
let shared = RxBDD.init(inputObservable: #INPUT_OBSERVABLETYPE, // Relay or Subject
            outputType: #EXPECTED_OUTPUT_TYPE)
      .given(#INPUT_EVENTS) // [Recorded<Event<#INPUT_OBSERVABLETYPE_ELEMENT>>]
      .share()
      
shared.when(#OUTPUT_OBSERVABLE) // Observable<#EXPECTED_OUTPUT_TYPE>
      .then({ outputs in
           XCTAssertEqual(outputs,
                          #EXPECTED_EVENTS) // [Recorded<Event<#EXPECTED_OUTPUT_TYPE>>]
      })
      
shared.when(#OUTPUT_OBSERVABLE) // Observable<#EXPECTED_OUTPUT_TYPE>
      .then({ outputs in
           XCTAssertEqual(outputs,
                          #EXPECTED_EVENTS) // [Recorded<Event<#EXPECTED_OUTPUT_TYPE>>]
      })
```

> Description
```swift
    func testMultiplyWithRxBDD() {
        let integerInput = PublishSubject<Int>.init()
        let multiplyOutput: Observable<Int> = input.map({ $0 * $0 }).asObservable()
        
        let test = RxBDD.init(inputObservable: integerInput,
                              outputType: Int.self)
                   
        // Given: I have 10, 20, 30 Integer input events
        test.given([.next(100, 10),
                    .next(200, 20),
                    .next(300, 30)])  
                    
        // When: It should multiply input integer events
        test.when(output)
        
        // Then: It should have multiplied integer events
        test.then({ outputs in
                XCTAssertEqual(outputs,
                               [.next(100, 100),
                                .next(200, 400),
                                .next(300, 900)])
            })
    }
```



[More See](https://github.com/GeekTree0101/RxBDD/blob/master/Example/Tests/RxBDDTests.swift)


## Requirements
- Xcode, ~> 10.x
- Swift, 4.2 // 5.0 coming soon!
- RxSwift, ~> 4.0
- RxCocoa, ~> 4.0
- RxTest, ~> 4.0

## Installation

RxBDD is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
target 'YOUR_PROJECT_Example' do

  target 'YOUR_PROJECT_Tests' do
    pod 'RxBDD'
  end
end
```

## Author

Geektree0101, h2s1880@gmail.com

## License

RxBDD is available under the MIT license. See the LICENSE file for more info.
