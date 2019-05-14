//
//  RxBDD.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import RxSwift
import RxCocoa
import RxTest

public final class RxBDD<Input, Output> {
    
    private enum BDDStep: String {
        case given
        case when
        case then
    }
    
    private var scheduler = TestScheduler.init(initialClock: 0)
    private var outputTestableObserver: TestableObserver<Output>!
    
    private let inputTestSubject = PublishSubject<Input>()
    private let disposeBag = DisposeBag()
    private var givenStoredEvents: [Recorded<Event<Input>>] = []
    
    private var isShared: Bool = false
    private var nextExpectedStep: BDDStep = .given
    
    convenience public init(inputObservable: PublishRelay<Input>,
                            outputType: Output.Type) {
        self.init(outputType: outputType)
        inputTestSubject.bind(to: inputObservable).disposed(by: disposeBag)
    }
    
    convenience public init(inputObservable: BehaviorRelay<Input>,
                            outputType: Output.Type) {
        self.init(outputType: outputType)
        inputTestSubject.bind(to: inputObservable).disposed(by: disposeBag)
    }
    
    convenience public init(inputObservable: PublishSubject<Input>,
                            outputType: Output.Type) {
        self.init(outputType: outputType)
        inputTestSubject.bind(to: inputObservable).disposed(by: disposeBag)
    }
    
    convenience public init(inputObservable: BehaviorSubject<Input>,
                            outputType: Output.Type) {
        self.init(outputType: outputType)
        inputTestSubject.bind(to: inputObservable).disposed(by: disposeBag)
    }
    
    public init(outputType: Output.Type) {
        self.outputTestableObserver = scheduler.createObserver(outputType)
    }
    
    @discardableResult
    public func share() -> RxBDD {
        self.isShared = true
        return self
    }
    
    @discardableResult
    public func given(_ events: [Recorded<Event<Input>>]) -> RxBDD {
        guard self.isValidStep(.given) else { return self }
        self.givenStoredEvents = events
        return self
    }
    
    @discardableResult
    public func when(_ output: Observable<Output>) -> RxBDD {
        guard self.isValidStep(.when) else { return self }
        self.scheduler = TestScheduler.init(initialClock: 0)
        self.outputTestableObserver = scheduler.createObserver(Output.self)
        output.bind(to: outputTestableObserver).disposed(by: disposeBag)
        return self
    }
    
    public func then(_ output: ([Recorded<Event<Output>>]) -> ()) {
        guard self.isValidStep(.then) else { return }
        self.scheduler.createColdObservable(self.givenStoredEvents)
            .bind(to: inputTestSubject)
            .disposed(by: disposeBag)
        self.scheduler.start()
        output(outputTestableObserver.events)
    }
    
    private func isValidStep(_ expectedStep: BDDStep) -> Bool {
        guard self.nextExpectedStep == expectedStep else {
            // next step invalidation fatal error, if you wanna share given evnets
            // you have to call share: method after call given: method :)
            fatalError("next step must be \(expectedStep.rawValue)")
        }
        
        switch expectedStep {
        case .given:
            self.nextExpectedStep = .when
        case .when:
            self.nextExpectedStep = .then
        case .then:
            self.nextExpectedStep = self.isShared ? .when: .given
        }
        
        return true
    }
}
