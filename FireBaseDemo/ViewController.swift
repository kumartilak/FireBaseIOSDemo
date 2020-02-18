//
//  ViewController.swift
//  FireBaseDemo
//
//  Created by tilak kumar on 07/01/19.
//  Copyright © 2019 tilak kumar. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var senderTextFld: UITextField!
    @IBOutlet weak var messageTxtFld: UITextField!
    
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let db = Database.database().reference()
        db.setValue("Hello Firebase")
    }

    @IBAction func sendAction(_ sender: UIButton) {
        
        let sender = senderTextFld.text
        let msg = messageTxtFld.text
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary: NSDictionary = ["Sender": sender!, "MessageBody": msg!]

        messagesDB.childByAutoId().setValue(messageDictionary) { [unowned self]
            (error, ref) in

            if error != nil {
                print(error!)
            }
            else {
                print("Message saved successfully!")
                
                self.senderTextFld.text = ""
                self.messageTxtFld.text = ""
            }
        }
    }
    
    @IBAction func retrieveAction(_ sender: UIButton) {
        let messagesDB = Database.database().reference().child("Messages")
        messagesDB.observe(.childAdded) { [unowned self] snapshot in
            
            let snapshotValue = snapshot.value as! NSDictionary
            let text = snapshotValue["MessageBody"] as! String
            let sender = snapshotValue["Sender"] as! String
            
            self.senderTextFld.text = sender
            self.messageTxtFld.text = text
        }
    }
    
    @IBAction func createUserAction(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: userNameTxtFld.text!, password: passwordTxtFld.text!) { [unowned self] (result, error) in
            if error != nil {
                print(error!)
            }
            else {
                print("Registration successfull!")
                self.userNameTxtFld.text = ""
                self.passwordTxtFld.text = ""
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: userNameTxtFld.text!, password: passwordTxtFld.text!) { [unowned self] (result, error) in
            if error != nil {
                print(error!)
            }
            else {
                print("Login successfull!")
                self.userNameTxtFld.text = ""
                self.passwordTxtFld.text = ""
                self.logoutButton.isEnabled = true
            }
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("Error on logout: \(error)")
        }
    }
}

