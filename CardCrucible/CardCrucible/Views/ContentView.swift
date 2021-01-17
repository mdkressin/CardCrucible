//
//  ContentView.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 3/28/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var counter = 0
    var body: some View {
        
        VStack {
            Text("Card Crucible")
                .font(.title)
                .bold()
            NavigationView {
                VStack {
                    NavigationLink(destination: DeckImage(resizeRatio: 1, backColor: "blue", deckSize: 52)) {
                        Text("War")
                    }
                }
                .navigationBarTitle("Choose your game")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

