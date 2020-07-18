//
//  RegisterController.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 5/6/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import LBTATools
import Alamofire
import JGProgressHUD




class RegisterController: LBTAFormController {
    
    let logoView = UIImageView(image: #imageLiteral(resourceName: "logo12"), contentMode: .scaleAspectFit)
    
    let logoLabel = UILabel(text: "NEPGRAM", font: .systemFont(ofSize: 32, weight: .medium), textColor: .black, numberOfLines: 0)
    
    let nameTextField = IndentedTextField(placeholder: "Name", padding: 24, cornerRadius: 25, keyboardType: .default, backgroundColor: .white, isSecureTextEntry: false)
    
    let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25, keyboardType: .emailAddress, backgroundColor: .white, isSecureTextEntry: false)
    
    let passwordField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25, keyboardType: .default, backgroundColor: .white, isSecureTextEntry: true)
    
    lazy var signUpButton = UIButton(title: "SIGN UP", titleColor: .white, font: .boldSystemFont(ofSize: 18), target: self, action: #selector(handleSignUpButton))
    
    lazy var goToLoginButton = UIButton(title: "Have an account? Login", titleColor: .black, target: self, action: #selector(handleAlreadyHaveAnAccount))
    
    
    @objc func handleSignUpButton() {
        
        print("Signing up...")
        signUpButton.bouncButton()
        
        //for progressHUD
        let hud = JGProgressHUD(style: .dark)
                hud.vibrancyEnabled = true
                hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.5)
                hud.textLabel.text = "Loading..."
                hud.layoutMargins = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
                
                hud.show(in: self.view)
                
               
        
        guard let name = nameTextField.text else {
            return
        }
        
        guard let email = emailTextField.text else {
            return
        }
        
        guard  let password = passwordField.text else {
            return
        }
        
    
        
        let url  = "http://localhost:1337/api/v1/entrance/signup"
        let params = ["fullName": name, "emailAddress": email, "password": password]
        
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding()).validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                

                print("Signing up with response data...")
                
                if dataResponse.error != nil {
                    
                    if  dataResponse.response?.statusCode == 409 {
                        
                        print("email already exists")
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                                                              UIView.animate(withDuration: 0.3) {
                                                               hud.indicatorView = nil
                                                               hud.textLabel.font = UIFont.systemFont(ofSize: 30.0)
                                                               hud.textLabel.text = "Email Already exists"
                                                               hud.position = .bottomCenter
                                                               hud.dismiss(afterDelay: 2, animated: true)
                                                              }
                                        }
                    } else {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                                              UIView.animate(withDuration: 0.3) {
                                               hud.indicatorView = nil
                                               hud.textLabel.font = UIFont.systemFont(ofSize: 30.0)
                                               hud.textLabel.text = "Please fill the credentials properly"
                                               hud.position = .bottomCenter
                                               hud.dismiss(afterDelay: 2, animated: true)
                                              }
                        }
                        
                    }
                   
                    
                    return
                    
                } else {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                        UIView.animate(withDuration: 0.3) {
                            hud.indicatorView = nil
                            hud.textLabel.font = UIFont.systemFont(ofSize: 30.0)
                            hud.textLabel.text = "Done"
                            hud.position = .bottomCenter
                        }
                    }
                    print("Sign Up sucessfull")
                    self.dismiss(animated: true)
                    
                }
                
                
                
                
        }
        
        
        
    }
    
    
    @objc func handleAlreadyHaveAnAccount(){
        
        self.dismiss(animated: true)
        present(LoginController(), animated: true)
        
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
               
                view.backgroundColor = .init(white: 0.95, alpha: 1)
               
               emailTextField.autocapitalizationType = .none
               
               signUpButton.backgroundColor = .init(red: 0/0, green: 74/255, blue: 173/255, alpha: 1)
               signUpButton.layer.cornerRadius = 25
               
               
               navigationController?.navigationBar.isHidden = true
               
                let formView = UIView()
               formView.stack(
                   formView.stack(formView.hstack(logoView.withSize(.init(width: 200, height: 200)), alignment: .center).padLeft(12).padRight(12), alignment: .center),
                   UIView().withHeight(12),
                   formView.stack(logoLabel.withSize(.init(width: 170, height: 80)), alignment: .center).padLeft(20),
                   nameTextField.withHeight(50),
                   emailTextField.withHeight(50),
                   passwordField.withHeight(50),
                   signUpButton.withHeight(50),
                   goToLoginButton,
                   UIView().withHeight(80),
                   spacing: 16).withMargins(.init(top: 48, left: 32, bottom: 0, right: 32))
               
               formContainerStackView.padBottom(-54)
               formContainerStackView.addArrangedSubview(formView)
    }
}
