//
//  SinRow.swift
//  Sinfest
//
//  Created by Jurjen van Dijk on 27/11/2019.
//  Copyright © 2019 frombeyond. All rights reserved.
//

import SwiftUI

struct SinRow: View {
    
    var sin: SinImage
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SinRow_Previews: PreviewProvider {
    static var previews: some View {
        SinRow(sin: SinImage(path: "", name: "", thumb: nil))
    }
}
