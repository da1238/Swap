//
//  LikeButton.swift
//  SwapNote
//
//  Created by David Abraham on 3/26/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit

class LikeButton: UIButton {
    
    var isLiked = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton(){
//        layer.borderWidth = 2
//        layer.borderColor = UIColor(red:0.00, green:0.80, blue:0.61, alpha:1.0).cgColor
//        layer.cornerRadius = frame.size.height/2
//
//        setTitleColor(UIColor(red:0.00, green:0.80, blue:0.61, alpha:1.0), for: .normal)
        addTarget(self, action: #selector(LikeButton.buttonPressed), for: .touchUpInside)
    }

    @objc func buttonPressed(){
        activateButton(bool: !isLiked)
    }
    
    func activateButton(bool: Bool){
        isLiked = bool
        
//        let color = bool ? UIColor(red:0.00, green:0.80, blue:0.61, alpha:1.0) : .clear
        let title = bool ? "Like" : "Unlike"
//        let titleColor = bool ? .white : UIColor(red:0.00, green:0.80, blue:0.61, alpha:1.0)
        
        setTitle(title, for: .normal)
//        setTitleColor(titleColor, for: .normal)
//        backgroundColor = color
        
        
    }
}
