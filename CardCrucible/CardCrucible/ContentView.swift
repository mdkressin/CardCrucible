//
//  ContentView.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 3/28/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Card Crucible")
                .font(.title)
                .bold()
            CardImage(resizeRatio: 0.5, imageName: "KH")
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum ViewError: Error {
    case invalidImageName
}
