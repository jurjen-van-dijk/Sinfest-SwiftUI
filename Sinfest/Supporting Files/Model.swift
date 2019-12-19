//
//  Model.swift
//  Sinfest
//
//  Created by Jurjen van Dijk on 03/12/2019.
//  Copyright © 2019 frombeyond. All rights reserved.
//

import SwiftUI

class Model: ObservableObject {
    @Published var landscape: Bool = false
    @Published var inTransition: Bool = false

    init(isLandscape: Bool) {
        self.landscape = isLandscape // Initial value
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onViewWillTransition(notification:)),
                                               name: .onViewWillTransition,
                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(onViewDidTransition(notification:)),
//                                               name: .onViewDidLayoutSubviews,
//                                               object: nil)
    }

    @objc func onViewWillTransition(notification: Notification) {
        guard let size = notification.userInfo?["size"] as? CGSize else { return }
        inTransition = true
        landscape = size.width > size.height
    }
    @objc func onViewDidTransition(notification: Notification) {
        inTransition = false
    }
}
