//
//  Note.swift
//  SwapNote
//
//  Created by David Abraham on 12/25/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit
import FirebaseFirestore

class Note {

    var downloaded: Bool
    var fileDownloaded: Bool
    var documentRef: DocumentReference
    var remoteURL: String?
    var localURL: String?
    var name: String?
    var image: UIImage?
    var rating: Int
    
    init(documentRef: DocumentReference, downloadContent: Bool) {
        self.downloaded = false
        self.fileDownloaded = false
        self.documentRef = documentRef
        self.rating = 4
        
        if downloadContent {
            downloadNote()
        }
    }
    
    func downloadNote() {
        self.documentRef.getDocument(completion: {(document, error) in
            if let document = document {
                let data = document.data()
                let name: String = data!["name"] as! String
//                let remoteURL: String = data!["url"] as! String
                self.downloaded = true
//                self.remoteURL = remoteURL
                self.name = name
//                self.downloadFile()
            } else {}
        })
    }
}
    
//    func downloadFile() {
//        let transferManager = AWSS3TransferManager.default()
//
//        let downloadRequest: AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()!
//        downloadRequest.bucket = "swapnotes"
//        downloadRequest.key = remoteURL
//
//        let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteURL!)
//        downloadRequest.downloadingFileURL = downloadingFileURL
//
//        transferManager.download(downloadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
//
//            if task.error != nil {
//                print(task.error)
//            } else {
//                //                let downloadOutput = task.result
//                self.image = UIImage(contentsOfFile: downloadingFileURL.path)
//            }
//
//            return nil
//        })
//    }


extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
