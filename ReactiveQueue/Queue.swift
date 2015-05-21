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
    
    pop = SignalProducer { observer, _ in sendNext(poppersSink, observer) }
    
    elements
      |> zipWith(poppers)
      |> observe(next: { element, popper in
        sendNext(popper, element)
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