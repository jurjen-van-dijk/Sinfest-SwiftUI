//
//  ComicsView.swift
//  Sinfest
//
//  Created by Jurjen van Dijk on 26/11/2019.
//  Copyright © 2019 frombeyond. All rights reserved.
//

import SwiftUI

struct ComicsView: View {
    @State var sortAsc: Bool
    @ObservedObject var sins = ImageManager.shared.sinList

    var body: some View {

        LoadingView(isShowing: .constant(self.sins.sinsLoading)) {

        RefreshableNavigationView(title: "", action: {
                                    ImageManager.shared.appendToBottomOfList(50, sortAsc: self.sortAsc)

                }, content: {
                    ForEach(self.sins.sins, id: \.name ) { sin in
                        SinRow(sin: sin)
                    }
                })
            }
        .onAppear {
             _ = ImageManager.shared.listImagesFromDisk(self.sortAsc)
        }
    }
}

struct ComicsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsView(sortAsc: false)
    }
}
