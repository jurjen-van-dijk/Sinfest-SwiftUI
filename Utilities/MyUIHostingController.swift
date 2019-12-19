//
//  MyUIHostingController.swift
//  Sinfest
//
//  Created by Jurjen van Dijk on 03/12/2019.
//  Copyright © 2019 frombeyond. All rights reserved.
//

import SwiftUI

extension Notification.Name {
    static let onViewWillTransition = Notification.Name("MainUIHostingController_viewWillTransition")
    static let onViewDidLayoutSubviews = Notification.Name("MainUIHostingController_viewDidLayoutSubviews")
}

class MyUIHostingController<Content>: UIHostingController<Content> where Content: View {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        NotificationCenter.default.post(name: .onViewWillTransition, object: nil, userInfo: ["size": size])
        super.viewWillTransition(to: size, with: coordinator)
    }
    override func viewDidLayoutSubviews() {
        NotificationCenter.default.post(name: .onViewDidLayoutSubviews, object: nil, userInfo: nil)
        super.viewDidLayoutSubviews()
    }

}
