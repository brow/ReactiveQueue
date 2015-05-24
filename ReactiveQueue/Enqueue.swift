//
//  Enqueue.swift
//  ReactiveQueue
//
//  Created by Tom Brow on 5/24/15.
//  Copyright (c) 2015 Tom Brow. All rights reserved.
//

import ReactiveCocoa

public func enqueue<T>(elements: SignalProducer<T, NoError>) -> SignalProducer<T, NoError> {
  let (poppers, poppersSink) = Signal<SinkOf<Event<T, NoError>>, NoError>.pipe()
  
  elements
    |> zipWith(poppers)
    |> start(next: { element, popper in
      sendNext(popper, element)
      sendCompleted(popper)
    })
  
  let poppersDisposable = ScopedDisposable(ActionDisposable {
    sendCompleted(poppersSink)
  })
  
  return SignalProducer { observer, _ in
    sendNext(poppersSink, observer)
    poppersDisposable
  }
}