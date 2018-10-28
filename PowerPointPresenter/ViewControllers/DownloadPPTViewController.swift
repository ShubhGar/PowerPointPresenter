//
//  DownloadPPTViewController.swift
//  PowerPointPresenter
//
//  Created by Shubham Garg on 26/10/18.
//  Copyright © 2018 Shubham Garg. All rights reserved.
//

import UIKit

class DownloadPPTViewController: UIViewController {
     // MARK: Outlets
    @IBOutlet weak var pptNameTf: UITextField!
    @IBOutlet weak var pptURLTA: UITextView!
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pptURLTA.layer.cornerRadius = 5.0
        pptURLTA.clipsToBounds = true
    }
    
    // MARK: Action
    @IBAction func downloadPPT(_ sender: Any) {
        guard let urlString = pptURLTA.text, let url = URL(string: urlString) else {
            let alert = UIAlertController(title: "nil",
                                          message: "Please Enter a valid url.",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .cancel)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                //  in case of failure to download your data you need to present alert to the user and update the UI from the main thread
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let alert = UIAlertController(title: "Alert", message: error?.localizedDescription ?? "Failed to download the ppt!!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
                return
            }
            // write the downloaded data to a temporary folder or to the document directory if you want to keep the pdf for later usage
            do {
//                try data.write(to: self.tempURL, options: .atomic)   // atomic option overwrites it if needed
//                // you neeed to check if the downloaded data is a valid pdf
//                // and present your controller from the main thread
//                DispatchQueue.main.async {
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                    if self.tempURL.typeIdentifier == "com.adobe.pdf" {
//                        self.present(self.preview, animated: true)
//                    } else {
//                        print("the data downloaded it is not a valid pdf file")
//                    }
//                }
            } catch {
                print(error)
                return
            }
            
            }.resume()
        
    }
    
}
