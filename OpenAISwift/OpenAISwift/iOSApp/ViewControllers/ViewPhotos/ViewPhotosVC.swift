//
//  ViewPhotosVC.swift
//  OpenAISwift
//
//  Created by Meet Patel on 26/01/23.
//

import UIKit

class ViewPhotosVC: UIViewController {
    
    //MARK:  Outlets and Variable Declarations
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    var arrOfImages = [ImageURL]()
    
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
    @IBAction func btnBackClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendClicked(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if !(txtSearch.isempty()) {
            
            self.showHud()
            OpenAIManager.shared.fetchImageForPrompt(prompt: self.txtSearch.text?.trime() ?? "") { url in
                
                DispatchQueue.main.async {
                    
                    self.arrOfImages = url
                    self.collectionViewPhotos.reloadData()
                    self.hideHud()
                }
            }
        } else {

            self.showAlertWithOkButton(message: "Please type a message to continue.")
        }
    }
    
    //MARK:  Functions
    @objc private func initWithObjects() {
        
        self.viewSearch.setCornerRaius(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radious: 8)
    }
}

//MARK:  UICollectionViewDelegateFlowLayout Methods
extension ViewPhotosVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            
        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            cell.transform = .identity
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width / 2
        return CGSize(width: width, height: width)
    }
}

//MARK:  UICollectionViewDataSource Methods
extension ViewPhotosVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrOfImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewPhotosCollectionViewCell", for: indexPath) as! ViewPhotosCollectionViewCell
        
        let url = arrOfImages[indexPath.row].url
        cell.imgPhoto.loadImageUsingCache(withUrl: url)
        
        return cell
    }
}

//MARK:  UICollectionViewDelegate Methods
extension ViewPhotosVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
