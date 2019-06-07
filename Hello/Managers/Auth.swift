//
//  Auth.swift
//  Hello
//
//  Created by Derik Malcolm on 5/31/19.
//  Copyright © 2019 Derik Malcolm. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum AuthError: Error {
    case failedToFetchUser
    case failedToSaveUser
}

class Auth {
    
    var currentUser: User?
    private var currentUserKeychainName = "currentUser"
    
    static let auth = Auth()
    
    private init() {
        guard let data = KeychainWrapper.standard.data(forKey: currentUserKeychainName) else { return }
        guard let user = try? JSONDecoder().decode(User.self, from: data) else { return }
        self.currentUser = user
    }
    
    func createUser(values: [String: String], _ completionHandler: @escaping (Result<User, Error>) -> Void ) {
        guard let url = URL(string: "http://fromderik.dev/users/register") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let registerData = try JSONEncoder().encode(values)
            request.httpBody = registerData
        } catch let error {
            completionHandler(.failure(error))
        }
        
        let session = URLSession.shared.dataTask(with: request) { (data, res, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            self.login(name: values["email"]!, password: values["password"]!, completionHandler)
        }
        
        session.resume()
    }
    
    func login(name: String, password: String, _ completionHandler: @escaping (Result<User, Error>) -> Void) {
        if currentUser != nil {
            logout()
        }
        
        let loginDict = ["name": name, "password": password]
        
        guard let url = URL(string: "http://fromderik.dev/users/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let loginData = try JSONEncoder().encode(loginDict)
            request.httpBody = loginData
        } catch let error {
            completionHandler(.failure(error))
        }
        
        let session = URLSession.shared.dataTask(with: request) { (data, res, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(AuthError.failedToFetchUser))
                return
            }
            
            do {
                if !KeychainWrapper.standard.set(data, forKey: self.currentUserKeychainName) {
                    completionHandler(.failure(AuthError.failedToSaveUser))
                }
                
                let user = try JSONDecoder().decode(User.self, from: data)
            
                self.currentUser = user
            
                completionHandler(.success(user))
            } catch let error {
                completionHandler(.failure(error))
            }
        }
        
        session.resume()
    }
    
    func logout() {
        
    }
    
}
