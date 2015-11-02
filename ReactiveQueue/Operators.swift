//
//  Enqueue.swift
//  ReactiveQueue
//
//  Created by Tom Brow on 5/24/15.
//  Copyright (c) 2015 Tom Brow. All rights reserved.
//

import ReactiveCocoa

extension SignalProducerType where Error == NoError {
  public func enqueue() -> SignalProducer<Value, NoError> {
    let (poppers, poppersSink) = SignalProducer<Observer<Value, NoError>, NoError>.buffer(0)
    
    zipWith(poppers)
      .startWithNext { element, popper in
        popper.sendNext(element)
        popper.sendCompleted()
      }
    
    let poppersDisposable = ScopedDisposable(ActionDisposable {
      poppersSink.sendCompleted()
    })
    
    return SignalProducer { observer, _ in
      poppersSink.sendNext(observer)
      poppersDisposable
    }
  }

  public func popAll() -> SignalProducer<(Value, completion: () -> ()), NoError> {
    return SignalProducer<(Value, completion: () -> ()), NoError> { observer, disposable in
      let (completions, completionsSink) = SignalProducer<(), NoError>.buffer()
      let completionHandler = { completionsSink.sendNext(()) }
      
      disposable.addDisposable {
        completionsSink.sendCompleted()
      }
      
      completions
        .flatMap(.Concat) { _ in
          SignalProducer<Value, NoError> { innerObserver, _ in
            self.start(innerObserver)
          }
        }
        .startWithNext { element in
          observer.sendNext((element, completionHandler))
        }
      
      completionHandler()
    }
  }
}
