//
//  NotePreviewViewController.swift
//  SwapNote
//
//  Created by David Abraham on 1/22/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit

class NotePreviewViewController: UIViewController {

    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = note{
            navigationItem.title = note.name
        }
        
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
