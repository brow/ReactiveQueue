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
      it.put(1)
      it.put(2)
      expect(first(it.pop)?.value) == 1
      expect(first(it.pop)?.value) == 2
    }
    
  }
}
