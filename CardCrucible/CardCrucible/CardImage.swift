//
//  CardImage.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 7/14/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import SwiftUI

struct CardImage: View {
    var body: some View {
        Image("KD")
            .clipShape(Rectangle())
            .overlay(Rectangle().stroke(Color.white, lineWidth: 4))
        .shadow(radius: 10)
    }
}

struct CardImage_Previews: PreviewProvider {
    static var previews: some View {
        CardImage()
    }
}
