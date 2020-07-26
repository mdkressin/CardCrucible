//
//  DeckImage.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 7/23/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import SwiftUI

struct DeckImage: View {
    // MARK: Properties
    
    /* names of card back images */
    let blueBack = "blue_back"
    let redBack = "red_back"
    let purpleBack = "purple_back"
    let grayBack = "gray_back"
    let yellowBack = "yellow_back"
    let greenBack = "green_back"
    
    /* size ratios */
    let widthRatio: CGFloat = 236.0
    // x positional offset for deck size display
    let xDeckSizeOffset: CGFloat = -60
    let heightRatio: CGFloat = 350.0
    // y positional offset for deck size display
    let yDeckSizeOffset: CGFloat = 120
    // used to resize/scale ratios and positioning pf deck image
    var resizeRatio: CGFloat
    
    // the color of the back of the card to display
    var backColor: String
    
    // the name of the card back to display
    var imageName: String {
        get {
            switch backColor {
                case blueBack:
                    return backColor
                case grayBack:
                    return backColor
                case greenBack:
                    return backColor
                case purpleBack:
                    return backColor
                case redBack:
                    return backColor
                case yellowBack:
                    return backColor
                default:
                    fatalError("invalid image name for deck image")
            }
            
        }
    }
    
    // text color that matches card color
    var color: Color {
        get {
            switch backColor {
                case blueBack:
                    return Color.blue
                case grayBack:
                    return Color.black
                case greenBack:
                    return Color.green
                case purpleBack:
                    return Color.purple
                case redBack:
                    return Color.red
                case yellowBack:
                    return Color.orange
                default:
                    fatalError("invalid image name for deck image")
            }
        }
    }
    
    // the number of cards in the deck to display
    var deckSize: Int
    
    // MARK: View
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: resizeRatio*widthRatio, height: resizeRatio*heightRatio)
            Text(String(deckSize))
                .bold()
                .background(RoundedRectangle(cornerRadius: 4).stroke())
                .background(Color.white)
                .foregroundColor(color)
                .scaleEffect(1.5 * resizeRatio)
                .offset(x: xDeckSizeOffset * resizeRatio, y: yDeckSizeOffset * resizeRatio)
        }
    }
}

struct DeckImage_Previews: PreviewProvider {
    static var previews: some View {
        DeckImage(resizeRatio: 0.5, backColor: "blue_back", deckSize: 52)
    }
}
