//
//  HomeVC.swift
//  OpenAISwift
//
//  Created by Meet Patel on 26/01/23.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK:  Outlets and Variable Declarations
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var viewImages: UIView!
    
    //MARK: 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWithObjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:  Buttons Clicked Action
    @IBAction func btnChatClicked(_ sender: UIButton) {
        
        let chatVC = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func btnImagesClicked(_ sender: UIButton) {
        
        let viewPhotosVC = storyboard?.instantiateViewController(withIdentifier: "ViewPhotosVC") as! ViewPhotosVC
        self.navigationController?.pushViewController(viewPhotosVC, animated: true)
    }
    
    //MARK:  Functions
    @objc private func initWithObjects() {
        
        self.viewChat.setCornerRaius(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radious: 8)
        self.viewImages.setCornerRaius(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radious: 8)
    }
}
