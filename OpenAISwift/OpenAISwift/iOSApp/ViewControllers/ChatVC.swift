//
//  ChatVC.swift
//  OpenAISwift
//
//  Created by Meet Patel on 17/01/2023.
//

import UIKit

class ChatVC: UIViewController {
    
    //MARK:  Outlets and Variable Declarations
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var viewSendMessage: UIView!
    @IBOutlet weak var viewSendMessageBottom: NSLayoutConstraint!
    @IBOutlet weak var btnSendMessage: UIButton!
    
//    private struct ChatGPT {
//
//        let question: String
//        let answer: String
//    }
    
    private struct ChatGPT {
        
        let questionAnswer: String
        let isSend: Bool
    }
    
    private var arrOfQuestionAnswer = [ChatGPT]()
    
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
    @IBAction func btnSendClicked(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if !(txtMessage.isempty()) {
            
            self.ProgressShow()
            self.sendMessage(question: txtMessage.text?.trime() ?? "", isSend: true)
            
            OpenAIManager.shared.processPrompt(prompt: self.txtMessage.text?.trime() ?? "") { reponse in
                
                self.ProgressHide()
                self.sendMessage(question: reponse, isSend: false)
            }
        } else {

            self.showAlertWithOkButton(message: "Please type a message to continue.")
        }
    }
    
    //MARK:  Functions
    @objc private func initWithObjects() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.viewSendMessage.setCornerRaius(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radious: 8)
    }
    
    private func sendMessage(question: String, isSend: Bool) {
        
        self.arrOfQuestionAnswer.append(ChatGPT(questionAnswer: question, isSend: isSend))
        self.reloadTable()
        
        // Clear TextView
        self.txtMessage.text = ""
        self.btnSendMessage.isEnabled = false
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.viewSendMessageBottom.constant =  16
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.view.layoutIfNeeded()
                if #available(iOS 11.0, *) {
                    self.viewSendMessageBottom.constant = (keyboardHeight - (APPDEL.window?.safeAreaInsets.bottom ?? 0) - -16)
                    DispatchQueue.main.async {
                        self.reloadTable()
                    }
                } else {
                    self.viewSendMessageBottom.constant = (keyboardHeight - 0)
                    tblChat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    private func reloadTable() {
        
        self.tblChat.reloadData()
        if self.arrOfQuestionAnswer.count > 0 {
            self.tblChat.scrollToRow(at: IndexPath(row: arrOfQuestionAnswer.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
}

//MARK:  UITableViewDelegate Methods
extension ChatVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK:  UITableViewDataSource Methods
extension ChatVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOfQuestionAnswer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //indexPath.row % 2 == 0
        if self.arrOfQuestionAnswer[indexPath.row].isSend == true {
            
            //Outgoing
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatOutgoingTextTableViewCell") as! ChatOutgoingTextTableViewCell
            
            let question = arrOfQuestionAnswer[indexPath.row].questionAnswer
            let currentTime = Date.getCurrentDateTime(format: "h:mm a")
            cell.configureCell(message: question, time: currentTime)
            
            return cell
        } else {
            
            //Incoming
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatIncomingTextTableViewCell") as! ChatIncomingTextTableViewCell
            
            let answer = arrOfQuestionAnswer[indexPath.row].questionAnswer
            let currentTime = Date.getCurrentDateTime(format: "h:mm a")
            cell.configureCell(message: answer, time: currentTime)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        guard let indexPath = configuration.identifier as? IndexPath, let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        
        return UITargetedPreview(view: cell, parameters: parameters)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let font = self.arrOfQuestionAnswer[indexPath.row].questionAnswer
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { _ -> UIMenu? in
            
            let copyAction = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc"), identifier: nil) { _ in
                
                UIPasteboard.general.string = font
            }
            
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                
                let textToShare = [font]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                self.present(activityViewController, animated: true, completion: nil)
            }
            
//            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
//
//                self.arrOfQuestionAnswer.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//            }
            
            let menu = UIMenu(title: Constant.kAppName, image: nil, identifier: nil, options: [], children: [copyAction, shareAction])
            return menu
        }
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        guard let indexPath = configuration.identifier as? IndexPath, let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        
        return UITargetedPreview(view: cell, parameters: parameters)
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        animator.addCompletion {
            if let viewController = animator.previewViewController {
                self.show(viewController, sender: self)
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//        let viewFooter = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
//        viewFooter.backgroundColor = .clear
//        viewFooter.transform = CGAffineTransform(scaleX: 1, y: 1)
//
//        var strDate = "Jan 18, 2023"
//
//        let dateCurrent = Date()
//        let strCurrent = dateCurrent.toStringWith(formate: "dd-MM-YYYY")
//
//        if strCurrent == strDate {
//            strDate = strDate.replacingOccurrences(of: strCurrent, with: "Today")
//        }
//
//        let dateYesterday = Date.yesterday
//        let strYesterday = dateYesterday.toStringWith(formate: "dd-MM-YYYY")
//        if strYesterday == strDate{
//            strDate = strDate.replacingOccurrences(of: strYesterday, with: "Yesterday")
//        }
//
//        let labelWidth = strDate.width(withConstrainedHeigh: 47, font: UIFont(name: "HelveticaNeue-UltraLight", size: 14) ?? UIFont())
//
//        let lbl = UILabel(frame: CGRect(x: viewFooter.center.x, y: 0, width: labelWidth + 28, height: 30))
//        lbl.font = UIFont(name: "HelveticaNeue-UltraLight", size: 12)
//        lbl.center = viewFooter.center
//        lbl.textAlignment = .center
//        lbl.backgroundColor = .white
//        lbl.clipsToBounds = true
//        lbl.layer.cornerRadius = lbl.frame.height / 2.0
//        lbl.text = strDate
//        viewFooter.addSubview(lbl)
//        return viewFooter
//    }
}

//MARK:  UITextFieldDelegate Methods
extension ChatVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        default:
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedText = textField.getUpadatedText(string: string, range: range)
        
        switch textField {
        case txtMessage:
            
            let isEnabled = updatedText == "" ? false:true
            self.btnSendMessage.isEnabled = isEnabled
            
        default:
            break
        }
        
        return true
    }
}
