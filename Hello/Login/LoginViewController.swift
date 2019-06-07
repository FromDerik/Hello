//
//  LoginViewController.swift
//  Hello
//
//  Created by Derik Malcolm on 5/31/19.
//  Copyright © 2019 Derik Malcolm. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = nil
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 52/255, green: 192/255, blue: 1, alpha: 1).cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = view.frame
        
        view.layer.insertSublayer(gradient, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func login() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        Auth.auth.login(name: name, password: password) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                DispatchQueue.main.async {
                    guard let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else { return }
                    self.present(mainVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        self.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        login()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            return false
        }
        
        if textField == nameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            login()
        }
        
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height - (view.frame.height - scrollView.frame.maxY)
        self.scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        //        let scrollViewBounds = scrollView.bounds
        //        let containerViewBounds = contentView.bounds
        //
        //        var scrollViewInsets = UIEdgeInsets.zero
        //        scrollViewInsets.top = scrollViewBounds.size.height / 2
        //        scrollViewInsets.top -= containerViewBounds.size.height / 2
        //
        //        scrollViewInsets.bottom = scrollViewBounds.size.height / 2
        //        scrollViewInsets.bottom -= containerViewBounds.size.height / 2
        //
        //        scrollView.contentInset = scrollViewInsets
    }
}
