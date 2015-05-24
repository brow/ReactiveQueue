# ReactiveQueue 
ReactiveQueue is a non-blocking queue implemented in
[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa). It uses
`SignalProducer` as the primary representation of a queue.

```swift
let queue = SignalProducer(values: [1, 2]) |> enqueue
 
// Pop
queue.start(next: println) // => 1

// Pop another
queue.start(next: println) // => 2
```

The framework also provides a wrapper, `Queue`, that exposes the traditional,
imperative queue interface:

```swift
let queue = Queue<Int>()
queue.enqueue(1)
queue.enqueue(2)
queue.pop(println) // => 1
queue.pop(println) // => 2
```

ReactiveQueue can be installed in an Xcode project using
[Carthage](https://github.com/Carthage/Carthage).

