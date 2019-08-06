//
//  ContentView.swift
//  Counter
//
//  Created by Phuc Le Dien on 8/1/19.
//  Copyright © 2019 Dwarves Foundation. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @ObjectBinding var state: AppState

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView(state: state)) {
                    Text("Counter demo")
                }
                NavigationLink(destination: FavoritePrimesView(state: state)) {
                    Text("Favorites primes")
                }
            }
            .navigationBarTitle("State management")
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(state: AppState())
    }
}
#endif

struct CounterView: View {
    @ObjectBinding var state: AppState
    @State var isShowModal = false
    @State var alertNthPrime: Int?
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { self.state.count -= 1 }) {
                    Text("-")
                }
                
                Text("\(self.state.count)")
                    .color(state.count.isPrime() ? .green : .red)
                
                Button(action: { self.state.count += 1 }) {
                    Text("+")
                }
            }
            Button(action: { self.isShowModal = true }) {
                Text("Is this prime?")
            }
            
            Button(action: {
                nthPrime(self.state.count) { prime in
                    self.alertNthPrime = prime
                }
            }) {
                Text("What is the \(ordinal(self.state.count)) prime?")
            }
        }
        .font(.title)
        .navigationBarTitle(Text("Counter demo"), displayMode: .inline)
        .presentation(
            self.isShowModal
                ? Modal(IsPrimeModalView(state: state),onDismiss: { self.isShowModal = false })
                : nil
        )
            .presentation(self.$alertNthPrime) { n in
                Alert(title: Text("The \(ordinal(self.state.count)) prime is \(n)"), dismissButton: Alert.Button.default(Text("Ok")))
        }
    }
    
    private func ordinal(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(for: n) ?? ""
    }
}

struct IsPrimeModalView: View {
    @ObjectBinding var state: AppState
    
    var body: some View {
        VStack {
            if self.state.count.isPrime() {
                Text("\(self.state.count) is prime 🎉")
                if self.state.favoritePrimes.contains(self.state.count) {
                    Button(action: { self.state.favoritePrimes.removeAll(where: { $0 == self.state.count }) }) {
                        Text("Remove from favorite primes")
                    }
                } else {
                    Button(action: { self.state.favoritePrimes.append(self.state.count) }) {
                        Text("Save to favorite primes")
                    }
                }
            } else {
                Text("\(self.state.count) is not prime :(")
            }
        }
    }
}


struct FavoritePrimesView: View {
    @ObjectBinding var state: AppState
    
    var body: some View {
        List {
            ForEach(self.state.favoritePrimes) { prime in
                Text("\(prime)")
            }
            .onDelete { indexSet in
                for index in indexSet {
                    self.state.favoritePrimes.remove(at: index)
                }
            }
        }
            .navigationBarTitle(Text("Favorite Primes"))
    }
}
