//
//  HomeVC.swift
//  Hack GT 8
//
//  Created by Allen Su on 10/23/21.
//

import UIKit
import QRCode
import FirebaseAuth
import FirebaseFirestore

class HomeVC: UIViewController {
    
    var dataString: String! = ""
    var backgroundImageView: UIImageView!
    var cardView: UIView!
    var qrCodeImageView: UIImageView!
    var nameLabel: UILabel!
    var birthdayLabel: UILabel!
    var user: User!
    var token: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let item = UITabBarItem()
        item.title = "QR Code"
        item.image = UIImage(systemName: "qrcode")
        self.tabBarItem = item
        configureBackgroundImageView()
        configureCardView()
        getSessionID()
        configureBirthdayLabel()
        configureNameLabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
            self.configureQRCodeImageView()
            
            self.getQRString()
        }
        getUser()
        
    }
    
    func getSessionID() {
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                return;
            }
            self.token = idToken!
            print("token: \(self.token)")
        }
    }
    
    func configureBackgroundImageView() {
        backgroundImageView = UIImageView(image: gradientBackground)
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureCardView() {
        cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 8.0
        cardView.layer.shadowOpacity = 0.5
        
        view.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            cardView.heightAnchor.constraint(equalToConstant: 550),
            cardView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func getUser() {
        let myUser = Auth.auth().currentUser
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(myUser!.uid)
        
        var firstName = ""
        var lastName = ""
        var year = ""
        var month = ""
        var day = ""
        var uid = ""

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                firstName = document.data()!["firstName"] as! String
                lastName = document.data()!["lastName"] as! String
                year = document.data()!["year"] as! String
                month = document.data()!["month"] as! String
                day = document.data()!["day"] as! String
                uid = document.data()!["uid"] as! String
                DispatchQueue.main.async {
                    self.nameLabel.text = "\(firstName) \(lastName)"
                    self.birthdayLabel.text = "\(month)/\(day)/\(year)"
                }
            } else {
                print("Document does not exist")
            }
        }

        
    }
    
    func getQRString() {
        let session = URLSession.shared
        let urlString = "https://chain-the-passport.uk.r.appspot.com/qr_metadata?id_token=\(token!)"
        guard let url = URL(string: urlString) else { return }
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if error != nil {
                return
            }
            self.dataString = String(data: data!, encoding: .utf8)
            let qrCode = self.generateQRCode(from: self.dataString!)
            if (qrCode == nil) {
            } else {
                DispatchQueue.main.async {
                    self.qrCodeImageView.image = qrCode
                }
            }
        })
        task.resume()
    }
    
    func configureQRCodeImageView() {
        qrCodeImageView = UIImageView()
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(qrCodeImageView)
        NSLayoutConstraint.activate([
            qrCodeImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 40),
            qrCodeImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            qrCodeImageView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.6),
            qrCodeImageView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.6)
        ])
    }
    
    func configureBirthdayLabel() {
        birthdayLabel = UILabel()
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        //birthdayLabel.text = "\(user.month)/\(user.day)/\(user.year)"
        birthdayLabel.textAlignment = .center
        cardView.addSubview(birthdayLabel)
        
        NSLayoutConstraint.activate([
            birthdayLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -30),
            birthdayLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            birthdayLabel.widthAnchor.constraint(equalToConstant: 150),
            birthdayLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureNameLabel() {
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        nameLabel.textAlignment = .center
        cardView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: birthdayLabel.topAnchor, constant: -10),
            nameLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 250),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
}
