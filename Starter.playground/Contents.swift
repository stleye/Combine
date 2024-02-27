import Combine
import Foundation

var subscriptions = Set<AnyCancellable>()

public func example(of description: String,
                    action: () -> Void) {
  print("\n——— Example of:", description, "———")
  action()
}

example(of: "Publisher") {
    // 1
    let myNotification = Notification.Name("MyNotification")

    // 2
    let publisher = NotificationCenter.default
    .publisher(for: myNotification, object: nil)

    // 3
    let center = NotificationCenter.default

    // 4
    let observer = center.addObserver(
      forName: myNotification,
      object: nil,
      queue: nil) { notification in
        print("Notification received!")
    }

    // 5
    center.post(name: myNotification, object: nil)

    // 6
    center.removeObserver(observer)
}

example(of: "Subscriber") {
    let myNotification = Notification.Name("MyNotification")

    let publisher = NotificationCenter.default
        .publisher(for: myNotification, object: nil)

    let center = NotificationCenter.default
    
    let subscription = publisher
      .sink { _ in
        print("Notification received from a publisher!")
      }
    
    // 2
    center.post(name: myNotification, object: nil)
    // 3
    subscription.cancel()
}

example(of: "Just") {
  // 1
  let just = Just("Hello world!")
  
  // 2
  _ = just
    .sink(
      receiveCompletion: {
        print("Received completion", $0)
      },
      receiveValue: {
        print("Received value", $0)
    })
    
    _ = just
      .sink(
        receiveCompletion: {
          print("Received completion (another)", $0)
        },
        receiveValue: {
          print("Received value (another)", $0)
      })
}

example(of: "assign(to:on:)") {
  // 1
  class SomeObject {
    var value: String = "" {
      didSet {
        print(value)
      }
    }
  }
  
  // 2
  let object = SomeObject()
  
  // 3
  let publisher = ["Hello", "world!"].publisher
  
  // 4
  _ = publisher
    .assign(to: \.value, on: object)
}

example(of: "assign(to:)") {
  // 1
  class SomeObject {
    @Published var value = 0
  }
  
  let object = SomeObject()
  
  // 2
  object.$value
    .sink {
      print($0)
    }
  
  // 3
  (0..<10).publisher
    .assign(to: &object.$value)
}

example(of: "Custom Subscriber") {
    // 1
    let publisher = (1...6).publisher

    // 2
    final class IntSubscriber: Subscriber {
        // 3
        typealias Input = Int
        typealias Failure = Never

        // 4
        func receive(subscription: Subscription) {
            subscription.request(.max(3))
        }

        // 5
        func receive(_ input: Int) -> Subscribers.Demand {
            print("Received value", input)
            return .none
        }

        // 6
        func receive(completion: Subscribers.Completion<Never>) {
            print("Received completion", completion)
        }
    }
    
    let subscriber = IntSubscriber()
    publisher.subscribe(subscriber)

}

example(of: "Future") {
    
    func futureIncrement(integer: Int, afterDelay delay: TimeInterval) -> Future<Int, Never> {
        Future<Int, Never> { promise in
            print("Original")
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                promise(.success(integer + 1))
            }
        }
    }

    // 1
    let future = futureIncrement(integer: 1, afterDelay: 3)

    // 2
    future
      .sink(receiveCompletion: { print($0) },
            receiveValue: { print($0) })
      .store(in: &subscriptions)
    
    future
      .sink(receiveCompletion: { print("Second", $0) },
            receiveValue: { print("Second", $0) })
      .store(in: &subscriptions)

}
