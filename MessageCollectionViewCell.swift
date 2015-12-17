//
//  MessageCollectionViewCell.swift
//  Mess
//
//  Created by Sean Murphy on 12/2/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit

@IBDesignable
class MessageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var messageDateLabel: UILabel!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var decryptButtonOverlayLabel: UIButton!
   

}
