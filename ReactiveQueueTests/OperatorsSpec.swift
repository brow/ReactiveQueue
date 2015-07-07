//
//  OperatorsSpec.swift
//  ReactiveQueue
//
//  Created by Tom Brow on 7/6/15.
//  Copyright (c) 2015 Tom Brow. All rights reserved.
//

import Quick
import Nimble
import ReactiveQueue
import ReactiveCocoa
import Result

class OperatorsSpec: QuickSpec {
  override func spec() {
    describe("enqueue") {
      it("should return a SignalProducer that pops one value per start") {
        let queue = SignalProducer(values: [1, 2]) |> enqueue
        var saved: Int? = nil
        let save: Int -> () = { saved = $0 }
        
        queue.start(next: save)
        expect(saved) == 1
        
        queue.start(next: save)
        expect(saved) == 2
        
        queue.start(next: save)
        expect(saved) == 2
      }
    }
    
    describe("popAll") {
      it("should return a signal that sends each time the previous value's callback is called") {
        var latestElement: Int?
        var latestCompletion: (() -> ())?
        
        SignalProducer(values: [1, 2])
          |> enqueue
          |> popAll
          |> start(next: { element, completion in
            latestElement = element
            latestCompletion = completion
          })
        
        expect(latestElement) == 1
        
        latestCompletion!()
        expect(latestElement) == 2
      }
    }
  }
}