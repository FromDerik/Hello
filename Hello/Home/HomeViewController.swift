//
//  HomeViewController.swift
//  Hello
//
//  Created by Derik Malcolm on 6/1/19.
//  Copyright © 2019 Derik Malcolm. All rights reserved.
//

import UIKit

struct Post: Codable {
    var id: Int
    var userID: Int
    var post: String
    var date: String
}

class HomeViewCell: UICollectionViewCell {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var postLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        
        addSubview(postLabel)
        postLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 12).isActive = true
        postLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        postLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        postLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeViewController: UICollectionViewController {
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: "cellId")
        
        loadPosts()
    }
    
    func loadPosts() {
        guard let url = URL(string: "http://fromderik.dev/posts") else { return }
        guard let token = Auth.auth.currentUser?.token else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token.string)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared.dataTask(with: request) { (data, res, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                self.posts = posts
            } catch let error {
                print(error)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        session.resume()
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! HomeViewCell
        let post = posts[indexPath.item]
        cell.nameLabel.text = String(post.id)
        cell.usernameLabel.text = "\(post.userID)・\(post.date)"
        cell.postLabel.text = post.post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}
