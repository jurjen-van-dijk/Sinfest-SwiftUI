//
//  ImageManager.swift
//  Sinfest
//
//  Created by Jurjen van Dijk on 25/11/2019.
//  Copyright © 2019 frombeyond. All rights reserved.
//

import UIKit

struct SinImage {
    let path: String?
    let name: String?
    let thumb: UIImage?
}

class ImageManager {
    public static let notificationSinLoaded = NSNotification.Name(rawValue: "SinLoaded")

    static let shared = ImageManager()
    private let baseURL = "https://www.sinfest.net/btphp/comics/%@"
    
    
    func loadImageForDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        let dateName = formatter.string(from: date) + ".gif"
        loadImage(dateName)
        
    }
    
    func loadImage(_ dateName: String) {
        guard let url = URL(string: String(format: baseURL, dateName)) else {
            return
        }
        
        if let img = loadImageFromDiskWith(fileName: dateName) {
            NotificationCenter.default.post(name: ImageManager.notificationSinLoaded, object: img)
            return
        }

        DispatchQueue.main.async() { [weak self] in

            if let data = try? Data(contentsOf: url, options: .alwaysMapped) {
                if let image = UIImage.gifImageWithData(data) {
                    self?.saveImage(imageName: dateName, image: image)
                    NotificationCenter.default.post(name: ImageManager.notificationSinLoaded, object: image)
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

        let fileName = imageName
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

    func loadImageFromDiskWith(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }

        return nil
    }
    
    func listImagesFromDisk() -> [SinImage]? {

        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {

            var retVal = [SinImage]()
            let filemgr = FileManager.default
            guard let enumerator:FileManager.DirectoryEnumerator = filemgr.enumerator(atPath: dirPath) else {
                return nil
            }
            while let element = enumerator.nextObject() as? String {
                if element.hasSuffix("gif") {
                    let path = NSURL(fileURLWithPath: element)
                    if let name = path.deletingPathExtension?.lastPathComponent {
                        let totalPath = String(format: "%@/%@", paths[0], element)
                        let newImg = SinImage(path: totalPath, name: name, thumb: nil)
                        retVal.append(newImg)
                        print(element)
                    }
                }
            }
            return retVal
        }

        return nil
    }
    
}
