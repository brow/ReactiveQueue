//
//  Queue.swift
//  ReactiveQueue
//
//  Created by Tom Brow on 5/13/15.
//  Copyright (c) 2015 Tom Brow. All rights reserved.
//

import ReactiveCocoa

public class Queue<T> {
  public init() {
    let (elements, elementsSink) = SignalProducer<T, NoError>.buffer(0)
    self.elementsSink = elementsSink
    self.queue = elements.enqueue()
  }

  public func enqueue(element: T) {
    sendNext(elementsSink, element)
  }
  
  public func pop(then: T -> ()) {
    queue.startWithNext(then)
  }
  
  // MARK: private 
  
  private let elementsSink: Event<T, NoError>.Sink
  private let queue: SignalProducer<T, NoError>
  
  deinit {
    sendCompleted(elementsSink)
  }
}
