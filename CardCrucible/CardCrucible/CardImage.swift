//
//  CardImage.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 7/14/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import SwiftUI

struct CardImage: View {
    let widthRatio = 250.0
    let heightRatio = 350.0
    var body: some View {
        Image("KD")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(0.5*widthRatio), height: CGFloat(0.5*heightRatio))
    }
}

struct CardImage_Previews: PreviewProvider {
    static var previews: some View {
        CardImage()
    }
}
