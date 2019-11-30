//
//  ContentView.swift
//  Sinfest
//
//  Created by Jurjen van Dijk on 25/11/2019.
//  Copyright © 2019 frombeyond. All rights reserved.
//

import SwiftUI

class Worker {
    func doSomething() {
        print("hallo")
        ImageManager.shared.loadImageForDate(Date())
        sinList = ImageManager.shared.listImagesFromDisk()
    }
}

let worker = Worker()
var sinList: [SinImage]?


struct ContentView: View {
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            
            VStack {
                Text("Sinfest Viewer")
                    .font(.title)
                Image("percy_pooch")
                Button(action: {
                    
                    worker.doSomething()

                }) {
                    Text("Show details")
                }

            }
            .navigationBarTitle("Sinfest", displayMode: .inline)
            .navigationBarItems(leading:
               Button(action: {
                   self.showingAlert = true
               }) {
                   Text("About")
               }
               .alert(isPresented: $showingAlert) {
                   Alert(title: Text("About"), message: Text("Sinfest Reader for iOS, version 1.0"), dismissButton: .default(Text("OK")))
               },
                trailing:
                 Button("To the comics") {
                     print("Help tapped!")
                 })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}