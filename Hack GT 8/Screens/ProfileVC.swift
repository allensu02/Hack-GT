//
//  ProfileVC.swift
//  Hack GT 8
//
//  Created by Allen Su on 10/23/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class ProfileVC: UIViewController {

    var user: User!
    var userImageView: UIImageView!
    var userLabel: UILabel!
    var dobTitle: UILabel!
    var dobText: UILabel!
    var statusTitle: UILabel!
    var statusText: UILabel!
    var doseCardView: DoseCardView!
    var signOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUserImageView()
        configureUserLabel()
        configureDobTitle()
        configureDobText()
        configureStatusTitle()
        configureStatusText()
        configureDoseCardView()
        getUser()
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
                    self.dobText.text = "\(month)/\(day)/\(year)"
                }
            } else {
                print("Document does not exist")
            }
        }

        
    }
    
    func configureUserImageView() {
        userImageView = UIImageView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.image = UIImage(named: "UserIcon")
        view.addSubview(userImageView)
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 200),
            userImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureUserLabel() {
        userLabel = UILabel()
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.text = "\(user.firstName) \(user.lastName)"
        userLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        userLabel.textAlignment = .center
        view.addSubview(userLabel)
        
        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 15),
            userLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userLabel.widthAnchor.constraint(equalToConstant: 200),
            userLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureDobTitle() {
        dobTitle = UILabel()
        dobTitle.translatesAutoresizingMaskIntoConstraints = false
        dobTitle.text = "Date of Birth"
        dobTitle.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        view.addSubview(dobTitle)
        
        NSLayoutConstraint.activate([
            dobTitle.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 30),
            dobTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            dobTitle.widthAnchor.constraint(equalToConstant: 130),
            dobTitle.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureDobText() {
        dobText = UILabel()
        dobText.translatesAutoresizingMaskIntoConstraints = false
        dobText.text = "\(user.month)/\(user.day)/\(user.year)"
        dobText.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        dobText.textAlignment = .right
        view.addSubview(dobText)
        
        NSLayoutConstraint.activate([
            dobText.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 30),
            dobText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            dobText.widthAnchor.constraint(equalToConstant: 130),
            dobText.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureStatusTitle() {
        statusTitle = UILabel()
        statusTitle.translatesAutoresizingMaskIntoConstraints = false
        statusTitle.text = "Status"
        statusTitle.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        view.addSubview(statusTitle)
        
        NSLayoutConstraint.activate([
            statusTitle.topAnchor.constraint(equalTo: dobTitle.bottomAnchor, constant: 10),
            statusTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            statusTitle.widthAnchor.constraint(equalToConstant: 100),
            statusTitle.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureStatusText() {
        statusText = UILabel()
        statusText.translatesAutoresizingMaskIntoConstraints = false
        statusText.text = "Fully Vaccinated"
        statusText.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        statusText.textAlignment = .right
        view.addSubview(statusText)
        
        NSLayoutConstraint.activate([
            statusText.topAnchor.constraint(equalTo: dobText.bottomAnchor, constant: 10),
            statusText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            statusText.widthAnchor.constraint(equalToConstant: 200),
            statusText.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureDoseCardView() {
        doseCardView = DoseCardView()
        doseCardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doseCardView)
        NSLayoutConstraint.activate([
            doseCardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            doseCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doseCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doseCardView.heightAnchor.constraint(equalToConstant: 300)
        ])
        let dose = Dose(doseNum: "2nd Dose", productName: "Pfizer", lotNumber: "JIOEWE", date: "03/23/2003", site: "WFEIOJ", sideEffects: "None")
        doseCardView.updateComponents(thisDose: dose)
    }
}
