//
//  Copyright 2021 Readium Foundation. All rights reserved.
//  Use of this source code is governed by the BSD-style license
//  available in the top-level LICENSE file of the project.
//

import Foundation
import UIKit
import ReadiumStreamer
import ReadiumShared

public class ReadiumWrapper {
    var navController: UINavigationController! = nil
    
    var darkMode: Bool! = nil
    
    private let streamer: Streamer = Streamer(
        contentProtections: []
    )
    
    private var app: AppModule!

    
    public init(darkMode: Bool? = false) {
        app = try! AppModule();
        self.darkMode = darkMode
    }
    
    public func open(at: String, sender: UINavigationController) {
        let url = URL(fileURLWithPath: at)
        self.openPublication(at: url, allowUserInteraction: false, sender: sender)
            // Map on background because we will read the publication cover to create the
            // `Book`, which might take some CPU time.
            
            .map(on: .global(qos: .background)) { publication -> (Publication, Book) in
                let publication = publication
                let book = Book(publication: publication, url: url)
                return (publication, book)
            }
            .resolve { result in
                
                switch result {
                case .success((let publication, let book)):
                    self.showBook(publication: publication, book: book, uiNavController: sender)
                    
                case .cancelled:
                    print("cancelled")
                    
                case .failure(let error):
                    print(error)
                }
                
            }
    }
    
    private func showBook(publication: Publication, book: Book, uiNavController: UINavigationController) {
        do {
            app.reader.presentPublication(publication: publication, book: book, in: uiNavController)
        } catch {
            print("Show reader failed")
        }
    }
    
    
    private func openPublication(at url: URL, allowUserInteraction: Bool, sender: UIViewController?) -> Deferred<Publication, Error> {
        return deferred {
            self.streamer.open(asset: FileAsset(file: FileURL(url: url)!, mediaType: "application/epub"), allowUserInteraction: allowUserInteraction, sender: sender, completion: $0)
        }
        .eraseToAnyError()
    }
    
    internal func presentDRM(for publication: Publication, from viewController: UIViewController) {
        // NOT NEEDED
    }
    
    internal func presentAlert(_ title: String, message: String, from viewController: UIViewController) {
        // NOT NEEDED
    }
    
    internal func presentError(_ error: Error?, from viewController: UIViewController) {
        // NOT NEEDED
    }
}

private extension Book {
    
    /// Creates a new `Book` from a Readium `Publication` and its URL.
    init(publication: Publication, url: URL) {
        self.init(
            identifier: publication.metadata.identifier ?? url.lastPathComponent,
            title: publication.metadata.title!,
            authors: publication.metadata.authors
                            .map { $0.name }
                            .joined(separator: ", "),
            type: "application/epub",
            path: (url.isFileURL || url.scheme == nil) ? url.lastPathComponent : url.absoluteString
        )
    }
}

private class ReadiumWrapperViewController: EPUBViewController {
    public var darkMode = false
    
    override func viewDidLoad() {
        super .viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.close(sender:)))
        
        if (darkMode) {
//            userSettingNavigationController.appearanceDidChange(to: 2)
        } else {
//            userSettingNavigationController.appearanceDidChange(to: 0)
        }
    }
    
    @objc func close(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
enum ReadiumWrapperError: Error {
    case serverError(String)
}
