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
    @Published var dataIsLoaded: Bool = false
    @Published var sins = [SinImage]()
}

extension SinList: Identifiable {
    
}

var sinList = SinList()

class ImageManager: ObservableObject {

    static let shared = ImageManager()
    private let baseURL = "https://www.sinfest.net/btphp/comics/%@"
    
    
    static func loadCurrentAndPrevious(_ backlog: Int) {
        for c in 0..<backlog {
            DispatchQueue.global(qos: .utility).async {
                let date = Date().addingTimeInterval( TimeInterval(-(c * 86400)) )
                print("date; %@", date)
                ImageManager.shared.loadImageForDate(date)
            }
        }
    }
    
    func appendToList(_ backlog: Int) {
        let lastSin = sinList.sins.last
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        if let date = formatter.date(from: lastSin?.name ?? "2019-12-01") {
            loadForDateAndPrevious(startDate: date, backlog: 10)
        }
    }
    
    func loadForDateAndPrevious(startDate: Date, backlog: Int) {
        for c in 0..<backlog {
            DispatchQueue.global(qos: .utility).async {
                let date = startDate.addingTimeInterval( TimeInterval(-(c * 86400)) )
                print("date ", date)
                ImageManager.shared.loadImageForDate(date)
                if c == backlog - 1 {
                    NotificationCenter.default.post(name: notificationLoadSins, object: nil)
                }
            }
        }
    }
    
    func loadImageForDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        let dateName = formatter.string(from: date)
        loadImage(dateName)
        
    }
    
    func loadImage(_ dateName: String) {

        let localName = dateName + ".jpg"
        if let img = loadImageFromDiskWith(fileName: localName) {
            NotificationCenter.default.post(name: notificationSinLoaded, object: img)
            return
        }
        let remoteName = dateName + ".gif"
        guard let url = URL(string: String(format: baseURL, remoteName)) else {
            return
        }
        DispatchQueue.main.async() { [weak self] in

            if let data = try? Data(contentsOf: url, options: .alwaysMapped) {
                if let image = UIImage.gifImageWithData(data) {
                    self?.saveImage(imageName: dateName, image: image)
                    NotificationCenter.default.post(name: notificationSinLoaded, object: image)
                } else {
                    print("ERROR")
                }
            }
        }
    }
    
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
    
    func listImagesFromDisk() -> [SinImage] {
        
        DispatchQueue.main.async {
            sinList.dataIsLoaded = false
        }
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        var retVal = [SinImage]()
        if let dirPath = paths.first {


            let filemgr = FileManager.default
            guard let enumerator:FileManager.DirectoryEnumerator = filemgr.enumerator(atPath: dirPath) else {
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
                            print(element)
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            sinList.sins = retVal.sorted(by: { $0.name > $1.name })
            sinList.dataIsLoaded = true
        }
        return retVal
    }
    
}
