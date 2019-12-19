//
//  SettingsView.swift
//  Sinfest
//
//  Created by Jurjen van Dijk on 05/12/2019.
//  Copyright © 2019 frombeyond. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State var onOff: Binding< Bool >
    var body: some View {
        Form {
            Section(header: Text("Images")) {
                VStack {
                    HStack {
                        Toggle(isOn: self.onOff) {
                            Text("Newest on top")
                        }
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(onOff: .constant(false))
    }
}
