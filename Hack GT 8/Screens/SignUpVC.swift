//
//  ViewController.swift
//  Hack GT 8
//
//  Created by Allen Su on 10/22/21.
//

import UIKit
import TextFieldEffects
import FirebaseAuth
import Firebase

class SignUpVC: UIViewController {

    var firstNameTextField: HoshiTextField!
    var lastNameTextField: HoshiTextField!
    var yearTextField: HoshiTextField!
    var monthTextField: HoshiTextField!
    var dayTextField: HoshiTextField!
    var emailTextField: HoshiTextField!
    var passwordTextField: HoshiTextField!
    var dateTextField: HoshiTextField!
    var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureVC()
        configureFNTextField()
        configureLNTextField()
        configureYearTextField()
        configureMonthTextField()
        configureDayTextField()
        configureEmailTextField()
        configurePasswordTextField()
        configureSignUpButton()
    }
    
    func configureVC() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func signUpTapped() {
        
        view.endEditing(true)
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let year = yearTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let month = monthTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let day = dayTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Create the user
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            // Check for errors
            if err != nil {
                print(err)
            }
            else {
                // User was created successfully, now store the first name and last name
                let db = Firestore.firestore()
                db.collection("users").document(result!.user.uid).setData(["firstName":firstName, "lastName":lastName, "uid": result!.user.uid , "year": year, "month": month, "day": day]) { (error) in
                    if error != nil {
                        print(error)
                    }
                }

            }
        }
    }
    
    func configureFNTextField() {
        firstNameTextField = configureTextField(text: "First Name")
        
        NSLayoutConstraint.activate([
            firstNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            firstNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 50),
            firstNameTextField.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configureLNTextField() {
        lastNameTextField = configureTextField(text: "Last Name")
        
        NSLayoutConstraint.activate([
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20),
            lastNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 50),
            lastNameTextField.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configureYearTextField() {
        yearTextField = configureTextField(text: "Year")
        
        NSLayoutConstraint.activate([
            yearTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 20),
            yearTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yearTextField.heightAnchor.constraint(equalToConstant: 50),
            yearTextField.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configureMonthTextField() {
        monthTextField = configureTextField(text: "Month")
        
        NSLayoutConstraint.activate([
            monthTextField.topAnchor.constraint(equalTo: yearTextField.bottomAnchor, constant: 20),
            monthTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            monthTextField.heightAnchor.constraint(equalToConstant: 50),
            monthTextField.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configureDayTextField() {
        dayTextField = configureTextField(text: "Day")
        
        NSLayoutConstraint.activate([
            dayTextField.topAnchor.constraint(equalTo: monthTextField.bottomAnchor, constant: 20),
            dayTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dayTextField.heightAnchor.constraint(equalToConstant: 50),
            dayTextField.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configureEmailTextField() {
        emailTextField = configureTextField(text: "Email")
        emailTextField.autocapitalizationType = .none
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: dayTextField.bottomAnchor, constant: 20),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configurePasswordTextField() {
        passwordTextField = configureTextField(text: "Password")
        passwordTextField.isSecureTextEntry = true
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configureSignUpButton() {
        signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpButton)
        signUpButton.backgroundColor = .lightGray
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        signUpButton.setTitle("sign up", for: .normal)
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.widthAnchor.constraint(equalToConstant: 300)
        ])
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
}

