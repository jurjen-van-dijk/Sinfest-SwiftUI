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
        LoadingView(isShowing: .constant(sins.sinsLoading)) {
            List {
                ForEach(self.sins.sins, id: \.name ) { sin in
                    SinRow(sin: sin)
                }
                Rectangle()
                    .foregroundColor(.clear)
                    .onAppear { ImageManager.shared.appendToList(10) }
            }
        }
    }
}

struct ComicsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsView()
    }
}
