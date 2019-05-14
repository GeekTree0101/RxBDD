//
//  RxBDDTests.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxBDD

class RxBDDTests: XCTestCase {
    
    func testPublishSubjectInput() {
        let input = PublishSubject<String>.init()
        let output: Observable<String> = input.map({ $0 + "!" }).asObservable()
        
        RxBDD.init(inputObservable: input,
                   outputType: String.self)
            .given([.next(100, "a"),
                    .next(200, "b"),
                    .next(300, "c")])
            .when(output)
            .then({ outputs in
                XCTAssertEqual(outputs,
                               [.next(100, "a!"),
                                .next(200, "b!"),
                                .next(300, "c!")])
            })
    }
    
    func testPublishRelayInput() {
        let input = PublishRelay<String>.init()
        let output: Observable<String> = input.map({ $0 + "!" }).asObservable()
        
        RxBDD.init(inputObservable: input,
                   outputType: String.self)
            .given([.next(100, "a"),
                    .next(200, "b"),
                    .next(300, "c")])
            .when(output)
            .then({ outputs in
                XCTAssertEqual(outputs,
                               [.next(100, "a!"),
                                .next(200, "b!"),
                                .next(300, "c!")])
            })
    }
    
    func testBehaviorSubjectInput() {
        let input = BehaviorSubject<String>.init(value: "a")
        let output: Observable<String> = input.map({ $0 + "!" }).asObservable()
        
        RxBDD.init(inputObservable: input,
                   outputType: String.self)
            .given([.next(100, "b"),
                    .next(200, "c"),
                    .next(300, "d")])
            .when(output)
            .then({ outputs in
                XCTAssertEqual(outputs,
                               [.next(0, "a!"),
                                .next(100, "b!"),
                                .next(200, "c!"),
                                .next(300, "d!")])
            })
    }
    
    func testBehaviorRelayInput() {
        let input = BehaviorRelay<String>.init(value: "a")
        let output: Observable<String> = input.map({ $0 + "!" }).asObservable()
        
        RxBDD.init(inputObservable: input,
                   outputType: String.self)
            .given([.next(100, "b"),
                    .next(200, "c"),
                    .next(300, "d")])
            .when(output)
            .then({ outputs in
                XCTAssertEqual(outputs,
                               [.next(0, "a!"),
                                .next(100, "b!"),
                                .next(200, "c!"),
                                .next(300, "d!")])
            })
    }
    
    func testSharedGivenEvents() {
        
        let input = PublishSubject<String>.init()
        let output: Observable<String> = input.map({ $0 + "!" }).asObservable()
        
        let sharedTest = RxBDD.init(inputObservable: input,
                                    outputType: String.self)
            .given([.next(100, "a"),
                    .next(200, "b"),
                    .next(300, "c")])
            .share()
        
        sharedTest
            .when(output)
            .then({ outputs in
                XCTAssertEqual(outputs,
                               [.next(100, "a!"),
                                .next(200, "b!"),
                                .next(300, "c!")])
            })
        
        
        sharedTest
            .when(output.enumerated().filter({ $0.index % 2 == 0 }).map({ $0.element }))
            .then({ outputs in
                XCTAssertEqual(outputs,
                               [.next(100, "a!"),
                                .next(300, "c!")])
            })
        
    }
}
