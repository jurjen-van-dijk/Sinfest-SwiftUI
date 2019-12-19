//
//  ContentView.swift
//  Sinfest
//
//  Created by Jurjen van Dijk on 25/11/2019.
//  Copyright © 2019 frombeyond. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var model: Model
    @State private var showingAlert = false
    @State private var sortAsc = false
    let versionText = "Sinfest Reader for iOS, version 1.0"

    var body: some View {
        NavigationView {
            VStack {
                Text("Sinfest Viewer")
                    .font(.title)
                Image("percy_pooch")
                NavigationLink("To the comics", destination: ComicsView(sortAsc: self.sortAsc))
            }

            .navigationBarTitle("Sinfest", displayMode: .inline)
            .navigationBarItems(leading:

               Button(action: {
                   self.showingAlert = true
               }, label: {
                   Text("About")
               })
               .alert(isPresented: $showingAlert) {
                   Alert(title: Text("About"), message: Text(versionText), dismissButton: .default(Text("OK")))
               },
                trailing:
                NavigationLink("Settings", destination: SettingsView(onOff: $sortAsc))
                )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
