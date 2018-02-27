//
//  NoteViewController.swift
//  SwapNote
//
//  Created by David Abraham on 12/25/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit
import WebKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var note: Note?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let note = note{
            navigationItem.title = note.name
        }
        
        
        let path = Bundle.main.path(forResource: "LabChapter3", ofType: "pdf")
        let url = URL(fileURLWithPath: path!)
        let request = URLRequest(url: url)
        
        webView.load(request)
        
        // No Text on back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
