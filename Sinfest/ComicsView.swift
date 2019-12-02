//
//  ComicsView.swift
//  Sinfest
//
//  Created by Jurjen van Dijk on 26/11/2019.
//  Copyright © 2019 frombeyond. All rights reserved.
//

import SwiftUI

struct ComicsView: View {
    @ObservedObject var sins = sinList
    
    var body: some View {

//        GeometryReader { geometry in
//            if geometry.frame(in: CoordinateSpace.global) {
//                ImageManager.shared.appendToList(10)
//            }
//            List( self.sins.sins, id: \.name) { sin in
//                //NavigationLink(
//                //  destination: ContentView()) {
//                    SinRow(sin: sin)
//                //    }
//            }
//            Rectangle().onAppear { print("Reached end of scroll view")  }
//
//        }
        List {
            ForEach(self.sins.sins, id: \.name ) { sin in
                SinRow(sin: sin)
            }
            Rectangle()
                .onAppear { ImageManager.shared.appendToList(10) }
        }
    }
}

struct ComicsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsView()
    }
}
