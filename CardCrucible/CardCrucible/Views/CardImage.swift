//
//  CardImage.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 7/14/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import SwiftUI

struct CardImage: View {
    let widthRatio: CGFloat = 250.0
    let heightRatio: CGFloat = 350.0
    var resizeRatio: CGFloat
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: resizeRatio*widthRatio, height: resizeRatio*heightRatio)
    }
}

struct CardImage_Previews: PreviewProvider {
    static var previews: some View {
        CardImage(resizeRatio: 0.5, imageName: "KD")
    }
}
