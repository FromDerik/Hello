//
//  SignUpViewController.swift
//  Hello
//
//  Created by Derik Malcolm on 5/29/19.
//  Copyright © 2019 Derik Malcolm. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = nil
        
        nameTextField.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        verifyPasswordTextField.delegate = self
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 52/255, green: 192/255, blue: 1, alpha: 1).cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = view.frame
        
        view.layer.insertSublayer(gradient, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func signUp() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let verify = verifyPasswordTextField.text, !verify.isEmpty else { return }
        
        guard password == verify else { return }
        
        let registerValues = ["name": name, "username": username, "email": email, "password": password, "verifyPassword": verify]
        
        Auth.auth.createUser(values: registerValues) { (result) in
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
        signUp()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            return false
        }
        
        if textField == nameTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            verifyPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signUp()
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

class UserToken: Codable {
    var id: Int
    var string: String
    var userID: Int
}

class User: Codable {
    var id: Int
    var name: String
    var username: String
    var email: String
    
    var token: UserToken?
}
