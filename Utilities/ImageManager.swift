//
//  ImageManager.swift
//  Sinfest
//
//  Created by Jurjen van Dijk on 25/11/2019.
//  Copyright © 2019 frombeyond. All rights reserved.
//

import SwiftUI

struct SinImage {
    var path: String
    let name: String
    let image: Image
}

class SinList: ObservableObject {
    @Published var sinsLoading: Bool = false
    @Published var sins = [SinImage]()
}

// swiftlint:disable line_length
class ImageManager: ObservableObject {
    @Published var sinList = SinList()

    static let shared = ImageManager()
    private let baseURL = "https://www.sinfest.net/btphp/comics/%@"

    var loaded = 0

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveProcessedImage(_:)), name: notificationSinLoaded, object: nil   )
    }

    // MARK: - Image storing/loading
    func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let fileName = imageName + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }

    func loadImage(_ dateName: String) {
        let localName = dateName + ".jpg"
        if loadImageFromDiskWith(fileName: localName) != nil {
            NotificationCenter.default.post(name: notificationSinLoaded, object: dateName)
            return
        }
        let remoteName = dateName + ".gif"
        guard let url = URL(string: String(format: baseURL, remoteName)) else {
            return
        }
        print("Load ", url.absoluteString)
        //DispatchQueue.main.async { [weak self] in

            if let data = try? Data(contentsOf: url, options: .alwaysMapped) {
                if let image = UIImage.gifImageWithData(data) {
                    saveImage(imageName: dateName, image: image)
                    NotificationCenter.default.post(name: notificationSinLoaded, object: dateName)
                } else {
                    print("ERROR")
                }
            } else {
               print("ERROR")
           }
        //}
    }

    func loadImageFromDiskWith(fileName: String) -> Image? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            if let image = UIImage(contentsOfFile: imageUrl.path) {
                return Image(uiImage: image)
            }
        }
        return nil
    }

    // MARK: - Cache management, list loader
//    func appendToTopOfList(_ backlog: Int) {
//        let lastSin = sinList.sins.first
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.calendar = Calendar.current
//        formatter.timeZone = TimeZone.current
//        formatter.locale = Locale.current
//        if let date = formatter.date(from: lastSin?.name ?? "2019-12-01") {
//            let startDate = date.addingTimeInterval( TimeInterval(-(cnt * 86400)) )
//            loadForDateAndPrevious(startDate: date, backlog: backlog)
//        }
//    }

    func appendToBottomOfList(_ backlog: Int) {
        let lastSin = sinList.sins.last
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        if let date = formatter.date(from: lastSin?.name ?? "2019-12-01") {
            loadForDateAndPrevious(startDate: date, backlog: backlog)
        }
    }

    func loadCurrentAndPrevious(_ backlog: Int) {
        loadForDateAndPrevious(startDate: Date(), backlog: backlog)
    }

    func loadForDateAndPrevious(startDate: Date, backlog: Int) {
        sinList.sinsLoading = true
        loaded = backlog
        for cnt in 0..<backlog {
            let date = startDate.addingTimeInterval( TimeInterval(-(cnt * 86400)) )
            print("date ", date)
            let dateName = dateToString(date: date)
            DispatchQueue.global(qos: .utility).async {
                ImageManager.shared.loadImage(dateName)
            }
        }
    }

    func dateToString( date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        let dateName = formatter.string(from: date)
        return dateName
    }

    func listImagesFromDisk() -> [SinImage] {

        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        var retVal = [SinImage]()
        if let dirPath = paths.first {

            let filemgr = FileManager.default
            guard let enumerator: FileManager.DirectoryEnumerator = filemgr.enumerator(atPath: dirPath) else {
                return retVal
            }
            while let element = enumerator.nextObject() as? String {
                if element.hasSuffix("jpg") {
                    let path = NSURL(fileURLWithPath: element)
                    if let name = path.deletingPathExtension?.lastPathComponent {
                        let totalPath = String(format: "%@/%@", paths[0], element)
                        if let img = loadImageFromDiskWith(fileName: element) {
                            let newImg = SinImage(path: totalPath, name: name, image: img)
                            retVal.append(newImg)
                            print("this ", element)
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.sinList.sins = retVal.sorted(by: { $0.name > $1.name })
            self.sinList.sinsLoading = false
        }
        return retVal
    }

    // MARK: - Loader listener
    @objc func receiveProcessedImage(_ notification: Notification) {

        loaded -= 1
        print("loaded ", loaded)
        if loaded <= 0 {
            print("loaded %d -> POST")
            NotificationCenter.default.post(name: notificationLoadSins, object: nil)
        }
    }

}
