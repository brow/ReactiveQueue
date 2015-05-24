//
//  QueueSpec.swift
//  ReactiveQueue
//
//  Created by Tom Brow on 5/21/15.
//  Copyright (c) 2015 Tom Brow. All rights reserved.
//

import Quick
import Nimble
import ReactiveQueue
import ReactiveCocoa
import Result

class QueueSpec: QuickSpec {
  override func spec() {
    it("should pop elements in FIFO order") {
      let it = Queue<Int>()
      it.enqueue(1)
      it.enqueue(2)
      
      var popped: Int? = nil
      it.pop { popped = $0 }
      expect(popped) == 1
      
      it.pop { popped = $0 }
      expect(popped) == 2
    }
    
    it("should serve poppers in FIFO order") {
      let it = Queue<Int>()
      var popped = Array<String>()
      
      it.pop { _ in popped.append("a") }
      it.pop { _ in popped.append("b") }
      
      expect(popped) == []
      
      it.enqueue(1)
      it.enqueue(2)
      
      expect(popped) == ["a", "b"]
    }
  }
}
