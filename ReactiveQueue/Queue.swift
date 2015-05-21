//
//  Queue.swift
//  ReactiveQueue
//
//  Created by Tom Brow on 5/13/15.
//  Copyright (c) 2015 Tom Brow. All rights reserved.
//

import ReactiveCocoa

public struct Queue<T>: SinkType {
  public let pop: SignalProducer<T, NoError>
  
  public init() {
    let (elements, elementsSink) = Signal<T, NoError>.pipe()
    let (poppers, poppersSink) = Signal<SinkOf<Event<T, NoError>>, NoError>.pipe()
    
    self.elementsSink = elementsSink
    
    pop = SignalProducer { observer, disposable in
      sendNext(poppersSink, observer)
      return
    }
    
    elements
      |> zipWith(poppers)
      |> observe(next: { item, popper in
        sendNext(popper, item)
        sendCompleted(popper)
      })
  }
  
  // MARK: SinkType
  
  public func put(x: T) {
    sendNext(elementsSink, x)
  }
  
  // MARK: private
  
  private let elementsSink: SinkOf<Event<T, NoError>>
}