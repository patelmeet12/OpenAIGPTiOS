//
//  ChatTextTableViewCell.swift
//  OpenAISwift
//
//  Created by Meet Patel on 17/01/2023.
//

import UIKit

class ChatIncomingTextTableViewCell: UITableViewCell {
    
    //MARK:-  Outlets and Variable Declarations
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    //MARK:- 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewMessage.layoutIfNeeded()
        viewMessage.setCornerRaius(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radious: 4)
    }
    
    //MARK:-  Buttons Clicked Action
    
    //MARK:-  Functions
    func configureCell(message: String, time: String) {
        
        self.lblMessage.text = message
        self.lblTime.text = time
    }
}

class ChatOutgoingTextTableViewCell: UITableViewCell {
    
    //MARK:-  Outlets and Variable Declarations
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    //MARK:- 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewMessage.layoutIfNeeded()
        viewMessage.setCornerRaius(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radious: 4)
    }
    
    //MARK:-  Buttons Clicked Action

    
    //MARK:-  Functions
    func configureCell(message: String, time: String) {
        
        self.lblMessage.text = message
        self.lblTime.text = time
    }
}

