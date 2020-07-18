//
//  LoginController.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 5/5/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import LBTATools
import Alamofire
import JGProgressHUD


class LoginController: LBTAFormController {
    
    let logoView = UIImageView(image: #imageLiteral(resourceName: "logo12"), contentMode: .scaleAspectFit)
    
    let logoLabel = UILabel(text: "NEPGRAM", font: .systemFont(ofSize: 32, weight: .medium), textColor: .black, numberOfLines: 0)
    
    let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25, keyboardType: .emailAddress, backgroundColor: .white, isSecureTextEntry: false)
    
    let passwordField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25, keyboardType: .default, backgroundColor: .white, isSecureTextEntry: true)
    
    lazy var loginButton = UIButton(title: "LOGIN", titleColor: .white, font: .boldSystemFont(ofSize: 18), target: self, action: #selector(handleLogin))
    
    let errorLabel = UILabel(text: "Your login credentials were incorrect, please try again.", font: .systemFont(ofSize: 14), textColor: .red, numberOfLines: 0)
    
    lazy var goToRegisterButton = UIButton(title: "Don't have an account? Sign up!", titleColor: .black, target: self, action: #selector(handleRegister))
    
    
    
    @objc func handleLogin(){
        
        print("Logging in...")
        loginButton.bouncButton()
        
        //for progressHUD
        let hud = JGProgressHUD(style: .dark)
                hud.vibrancyEnabled = true
                hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.5)
                hud.textLabel.text = "Loading..."
                hud.layoutMargins = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
                
                hud.show(in: self.view)
                
               
        
        
        
        guard let email = emailTextField.text else {
            return
        }
        
        guard  let password = passwordField.text else {
            return
        }
        
        errorLabel.isHidden = true
        
        let url  =  Service.shared.baseUrl + "/api/v1/entrance/login"
        let params = ["emailAddress": email, "password": password]
        
        AF.request(url, method: .put, parameters: params, encoding: URLEncoding()).validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                

                print("Login button pressed")
                
                if let _ = dataResponse.error {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                                       UIView.animate(withDuration: 0.3) {
                                            hud.indicatorView = nil
                                           hud.textLabel.font = UIFont.systemFont(ofSize: 30.0)
                                           hud.textLabel.text = "Login Credentials Invalid"
                                           hud.position = .bottomCenter
                                        hud.dismiss(afterDelay: 2, animated: true)
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
                    print("sucessfully logged in user.")
                    self.dismiss(animated: true)
                    
                }
                
                
                
                
        }
        
        
        
    }
    
    @objc func handleRegister(){
        
        print("opening Register Account...")
        goToRegisterButton.bouncButton()
        let navController = UINavigationController(rootViewController: RegisterController())
        present(navController, animated: true)
        
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        
        emailTextField.autocapitalizationType = .none
        
        loginButton.backgroundColor = .init(red: 0/0, green: 74/255, blue: 173/255, alpha: 1)
        loginButton.layer.cornerRadius = 25
        
        
        navigationController?.navigationBar.isHidden = true
        
        errorLabel.isHidden = true
        
        
        
        
        let formView = UIView()
        formView.stack(
            formView.stack(formView.hstack(logoView.withSize(.init(width: 200, height: 200)), alignment: .center).padLeft(12).padRight(12), alignment: .center),
            UIView().withHeight(12),
            formView.stack(logoLabel.withSize(.init(width: 170, height: 80)), alignment: .center).padLeft(20),
            emailTextField.withHeight(50),
            passwordField.withHeight(50),
            loginButton.withHeight(50),
            errorLabel,
            goToRegisterButton,
            UIView().withHeight(80),
            spacing: 16).withMargins(.init(top: 48, left: 32, bottom: 0, right: 32))
        
        formContainerStackView.padBottom(-54)
        formContainerStackView.addArrangedSubview(formView)
        
       
        
        
    }
    
    
    
}
