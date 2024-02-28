import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "Create a Blackjack card dealer") {
    let dealtHand = PassthroughSubject<Hand, HandError>()
    
    func deal(_ cardCount: UInt) {
        var deck = cards
        var cardsRemaining = 52
        var hand = Hand()
        
        for _ in 0 ..< cardCount {
            let randomIndex = Int.random(in: 0 ..< cardsRemaining)
            hand.append(deck[randomIndex])
            deck.remove(at: randomIndex)
            cardsRemaining -= 1
        }
        
        if hand.points > 21 {
            dealtHand.send(completion: .failure(HandError.busted))
        } else {
            dealtHand.send(hand)
        }
        
    }
    
    dealtHand
        .sink(
            receiveCompletion: {
                if case let .failure(error) = $0 {
                    print(error)
                } else {
                    print("Finished")
                }
            },
            receiveValue: { hand in
                print("\(hand.cardString) - \(hand.points)")
            }
        )
        .store(in: &subscriptions)
    
    deal(3)
    deal(3)
    deal(3)
    deal(3)
    
}

