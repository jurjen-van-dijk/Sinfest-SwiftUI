//
//  SinRow.swift
//  Sinfest
//
//  Created by Jurjen van Dijk on 27/11/2019.
//  Copyright © 2019 frombeyond. All rights reserved.
//

import SwiftUI

struct SinRow: View {
    @State private var showingAlert = false

    var sin: SinImage
    var body: some View {
        VStack {
            Text(sin.name).font(.footnote)
            sin.image.resizable().aspectRatio(contentMode: .fit)
//                .gesture(
//                    LongPressGesture(minimumDuration: 1).onEnded { _ in
//                            self.showingAlert = true
//                    }
//
//            )
        }
//        .alert(isPresented: $showingAlert) {
//            Alert(title: Text("About"), message: Text("Hallo"), dismissButton: .default(Text("OK")))
//        }
    }
}

// swiftlint:disable line_length
struct SinRow_Previews: PreviewProvider {
    static var previews: some View {
        SinRow(sin: SinImage(path: "/Users/jurjenvandijk/Library/Developer/CoreSimulator/Devices/25AC8385-919F-4A0B-99EE-D282ABD8E170/data/Containers/Data/Application/422FA949-DE98-4A8B-8855-B3F89B97D4D3/Documents/2019-11-22.jpg", name: "2019-11-22", image: Image("example")))
    }
}
