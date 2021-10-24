//
//  LoginVC.swift
//  Hack GT 8
//
//  Created by Allen Su on 10/23/21.
//

import UIKit
import TextFieldEffects
import FirebaseAuth
import FirebaseFirestore
class LoginVC: UIViewController {

    var logoImageView: UIImageView!
    var cardView: UIView!
    var emailTextField: HoshiTextField!
    var passwordTextField: HoshiTextField!
    var forgotPassword: UIButton!
    var signInButton: UIButton!
    var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCardView()
        configureEmailTextField()
        configurePasswordTextField()
        configureForgotPassword()
        configureSignIn()
        configureSignUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        clearTextFields()
        view.endEditing(true)
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    func configureCardView() {
        cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 8
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 8.0
        cardView.layer.shadowOpacity = 0.5
        
        view.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            cardView.heightAnchor.constraint(equalToConstant: 400),
            cardView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureEmailTextField() {
        emailTextField = configureTextField(text: "Email")
        //delete this
        emailTextField.text = ""
        emailTextField.autocapitalizationType = .none
        cardView.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func configurePasswordTextField() {
        passwordTextField = configureTextField(text: "Password")
        //delete this
        passwordTextField.text = ""
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        cardView.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configureForgotPassword() {
        forgotPassword = UIButton()
        forgotPassword.translatesAutoresizingMaskIntoConstraints = false
        forgotPassword.setTitle("Forgot Password", for: .normal)
        forgotPassword.setTitleColor(.black, for: .normal)
        forgotPassword.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        forgotPassword.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        cardView.addSubview(forgotPassword)
        
        NSLayoutConstraint.activate([
            forgotPassword.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            forgotPassword.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            forgotPassword.widthAnchor.constraint(equalToConstant: 120),
            forgotPassword.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func forgotPasswordTapped() {
        print("forgot password")
    }
    
    func configureSignIn() {
        signInButton = UIButton(frame: CGRect(x: 20, y: 240, width: 290, height: 50))
        
        //signInButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signInButton.layoutIfNeeded()
        let green = UIColor(red: 0.70, green: 0.94, blue: 0.62, alpha: 1.00)
        let cyan = UIColor(red: 0.56, green: 0.97, blue: 0.87, alpha: 1.00)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        signInButton.applyGradient(colours: [green, cyan])
        signInButton.layoutIfNeeded()
        signInButton.layer.cornerRadius = 20
        signInButton.clipsToBounds = true
        signInButton.layer.shadowColor = UIColor.lightGray.cgColor
        signInButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        signInButton.layer.shadowRadius = 4.0
        signInButton.layer.shadowOpacity = 0.5
        
    }
    
    @objc func signInTapped() {
        view.endEditing(true)
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if (error != nil) {
                print("wrong password")
            } else {
                
                self.navigationController?.present(self.setUpTabBarController(), animated: true)
            }
        }
    }
    
    func setUpTabBarController() -> UITabBarController {
        let homeVC = HomeVC()
        let myUser = self.getUser()
        homeVC.user = myUser
        let scanVC = ScanVC()
        let profileVC = ProfileVC()
        profileVC.user = myUser
        let tabBarController = UITabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.viewControllers = [homeVC, scanVC, profileVC]
        
        let homeItem = UITabBarItem()
        homeItem.title = "QR Code"
        homeItem.image = UIImage(systemName: "qrcode")
        homeVC.tabBarItem = homeItem
        
        let scanItem = UITabBarItem()
        scanItem.title = "Scan"
        scanItem.image = UIImage(systemName: "qrcode.viewfinder")
        scanVC.tabBarItem = scanItem
        
        let profileItem = UITabBarItem()
        profileItem.title = "Profile"
        profileItem.image = UIImage(systemName: "person")
        profileVC.tabBarItem = profileItem
        
        return tabBarController
        
    }
    
    func getUser() -> User {
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
            } else {
                print("Document does not exist")
            }
        }
        let thisUser = User(firstName: firstName, lastName: lastName, uid: uid, year: year, month: month, day: day)
        return thisUser
        
    }
    func configureSignUp() {
        signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        signUpButton.setTitleColor(.cyan, for: .normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        cardView.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: forgotPassword.bottomAnchor, constant: 70),
            signUpButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 100),
            signUpButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func signUpTapped() {
        let signUpVC = SignUpVC()
        self.navigationController?.present(signUpVC, animated: true)
    }
    
    func configureTextField(text: String) -> HoshiTextField{
        
        let textField = HoshiTextField()
        textField.borderInactiveColor = .lightGray
        textField.borderActiveColor = .green
        textField.placeholder = text
        textField.placeholderFontScale = 0.8
        textField.autocorrectionType = .no
        textField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        return textField
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}
