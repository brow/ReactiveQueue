//
//  Enqueue.swift
//  ReactiveQueue
//
//  Created by Tom Brow on 5/24/15.
//  Copyright (c) 2015 Tom Brow. All rights reserved.
//

import ReactiveCocoa

extension SignalProducerType where E == NoError {
  public func enqueue() -> SignalProducer<T, NoError> {
    let (poppers, poppersSink) = SignalProducer<Event<T, NoError>.Sink, NoError>.buffer(0)
    
    zipWith(poppers)
      .startWithNext { element, popper in
        sendNext(popper, element)
        sendCompleted(popper)
      }
    
    let poppersDisposable = ScopedDisposable(ActionDisposable {
      sendCompleted(poppersSink)
    })
    
    return SignalProducer { observer, _ in
      sendNext(poppersSink, observer)
      poppersDisposable
    }
  }

  public func popAll() -> SignalProducer<(T, completion: () -> ()), NoError> {
    return SignalProducer<(T, completion: () -> ()), NoError> { observer, disposable in
      let (completions, completionsSink) = SignalProducer<(), NoError>.buffer()
      let completionHandler = { sendNext(completionsSink, ()) }
      
      disposable.addDisposable {
        sendCompleted(completionsSink)
      }
      
      completions
        .flatMap(.Concat) { _ in
          SignalProducer<T, NoError> { innerObserver, _ in
            start(innerObserver)
          }
        }
        .startWithNext { element in
          sendNext(observer, (element, completionHandler))
        }
      
      completionHandler()
    }
  }
}
