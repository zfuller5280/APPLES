//
//  ViewController.swift
//  APPLES
//
//  Created by Steve Schaeffer on 7/2/16.
//  Copyright © 2016 Zach Fuller. All rights reserved.
//

import UIKit
import MobileCoreServices



class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate,UIPopoverPresentationControllerDelegate, locationInformation, Dimmable{
    
    var pickOption = ["Emergence", "Flower Set", "Blooming", "Fruit Set", "Seed Set", "Leaf Color Change","Abscission"]

    @IBOutlet weak var speciesTextField: TextField!
    @IBOutlet weak var bloomDateTextField: TextField!
    @IBOutlet weak var phenophaseTextField: TextField!
    @IBOutlet weak var locationTextField: TextField!
    @IBOutlet weak var commentsTextField: TextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    
    
    var newMedia: Bool?
    var uploadPicture: UIImage!
    
    let dimLevel: CGFloat = 0.45
    let dimSpeed: Double = 0.5
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverPresentationController?=nil
    
    var userName: NSString! = nil
    var passWord: NSString! = nil
    
    var logInStatus: Bool = false
    var requestStatus: Bool = false
    
    var latitude: String?
    var longitude: String?
    var cityLocation: String?
    var stateLocation: String?
    var countryLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speciesTextField.layer.cornerRadius = 4.0
        speciesTextField.layer.borderColor = UIColor.lightGray.cgColor
        speciesTextField.layer.borderWidth = 2.0
        
        bloomDateTextField.layer.cornerRadius = 4.0
        bloomDateTextField.layer.borderColor = UIColor.lightGray.cgColor
        bloomDateTextField.layer.borderWidth = 2.0
        
        phenophaseTextField.layer.cornerRadius = 4.0
        phenophaseTextField.layer.borderColor = UIColor.lightGray.cgColor
        phenophaseTextField.layer.borderWidth = 2.0
        
        locationTextField.layer.cornerRadius = 4.0
        locationTextField.layer.borderColor = UIColor.lightGray.cgColor
        locationTextField.layer.borderWidth = 2.0
        
        commentsTextField.layer.cornerRadius = 4.0
        commentsTextField.layer.borderColor = UIColor.lightGray.cgColor
        commentsTextField.layer.borderWidth = 2.0
        commentsTextField.padding.top = 12
        
        uploadPhotoBtn.layer.cornerRadius = 4.0
        uploadPhotoBtn.layer.borderWidth = 2.0
        uploadPhotoBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        speciesTextField.delegate = self
        bloomDateTextField.delegate = self
        phenophaseTextField.delegate = self
        locationTextField.delegate = self
        commentsTextField.delegate = self
        
        speciesTextField.backgroundColor = UIColor.white
        bloomDateTextField.backgroundColor = UIColor.white
        phenophaseTextField.backgroundColor = UIColor.white
        locationTextField.backgroundColor = UIColor.white
        commentsTextField.backgroundColor = UIColor.white
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.tappedToolBarBtn))
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewController.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Myriad Pro", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Pick a Date"
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        bloomDateTextField.inputAccessoryView = toolBar
        
        let phenoToolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        phenoToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        phenoToolBar.barStyle = UIBarStyle.blackTranslucent
        phenoToolBar.tintColor = UIColor.white
        phenoToolBar.backgroundColor = UIColor.black
        
        let phenoDoneBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewController.donePressed))
        let phenoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/2, height: self.view.frame.size.height))
        phenoLabel.font = UIFont(name: "Myriad Pro", size: 12)
        phenoLabel.backgroundColor = UIColor.clear
        phenoLabel.textColor = UIColor.white
        phenoLabel.text = "Pick a Phenophase"
        let phenoTextBtn = UIBarButtonItem(customView: phenoLabel)
        phenoToolBar.setItems([phenoTextBtn,flexSpace,phenoDoneBarBtn], animated: true)
        phenophaseTextField.inputAccessoryView = phenoToolBar
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.selectRow(0, inComponent: 0, animated: true)
        phenophaseTextField.inputView = pickerView
        phenophaseTextField.text = ""

        
    }
    
    func donePressed(_ sender: UIBarButtonItem) {

        phenophaseTextField.resignFirstResponder()
        bloomDateTextField.resignFirstResponder()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }

    func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.timeStyle = DateFormatter.Style.none
        
        bloomDateTextField.text = dateformatter.string(from: Date())
        bloomDateTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        phenophaseTextField.text = pickOption[row]
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if phenophaseTextField.text == ""{
            if textField == self.phenophaseTextField {
                phenophaseTextField.text = pickOption[0]
            }
            
        }
 
        return true
    }

    func openCamera(_ button: UIButton)
    {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true,
                                       completion: nil)
            newMedia = true
        }
    }
    
    func openGallary(_ button: UIButton)
    {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        imagePickerController.modalPresentationStyle = .popover
        let presentationController = imagePickerController.popoverPresentationController
        
        
        presentationController?.sourceView = button
        presentationController?.sourceRect = button.bounds
        presentationController?.permittedArrowDirections = .any
        
        self.present(imagePickerController, animated: true) {}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker .dismiss(animated: true, completion: nil)
        self.uploadPicture = info[UIImagePickerControllerOriginalImage] as? UIImage


    }
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.timeStyle = DateFormatter.Style.none
        bloomDateTextField.text = dateformatter.string(from: Date())
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    
    @IBAction func locationFieldEditing(_ sender: UITextField) {
        let dummyView = UIView(frame: CGRect(x: 100,y: 100,width: 100,height: 100))
        dummyView.backgroundColor = UIColor.clear
        locationTextField.inputView = dummyView
        
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController!
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        mapVC?.delegate = self
        self.present(mapVC!, animated: true, completion: nil)
        
       //locationTextField.enabled = true
    }
    
    func returnLocationInformation(_ info: String, latitude: String, longitude: String) {
        print(info)
        self.latitude = latitude
        self.longitude = longitude
        NSLog(latitude)
        self.locationTextField.text = info
        let locationTextArray = info.characters.split{$0 == ","}.map(String.init)
        self.cityLocation = locationTextArray[0]
        self.stateLocation = locationTextArray[1]
        self.countryLocation = locationTextArray[2]
    }
    
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        bloomDateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    

    
    @IBAction func uploadBtnClicked(_ sender: AnyObject) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera(self.uploadButton)
        }
        let gallaryAction = UIAlertAction(title: "Library", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary(self.uploadButton)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
            alert.popoverPresentationController?.sourceView = self.uploadButton.imageView
            alert.popoverPresentationController?.sourceRect = self.uploadButton.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .any
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dim(.in, alpha: dimLevel, speed: dimSpeed)
    }
    
    @IBAction func unwindFromSecondary(_ segue: UIStoryboardSegue) {
        dim(.out, speed: dimSpeed)
    }
    
    @IBAction func submitBtnClicked(_ sender: AnyObject) {
        if self.logInStatus == false{
            var usernameTextField: UITextField?
            var passwordTextField: UITextField?
            
            let alertController = UIAlertController(
                title: "Log in",
                message: "Please enter your information",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let loginAction = UIAlertAction(
            title: "Submit Data", style: UIAlertActionStyle.default) {
                (action) -> Void in
                
                if let userNameField = usernameTextField?.text {
                    self.userName = userNameField as NSString!
                } else {
                    print("No Username entered")
                }
                
                if let passWordField = passwordTextField?.text {
                    self.passWord = passWordField as NSString!
                } else {
                    print("No password entered")
                }
                
                // Check if username and password are blank
                if ( self.userName.isEqual(to: "") || self.passWord.isEqual(to: "") ) {
                    
                    let errorController = UIAlertController(title: "Error!", message: "Please enter a username and password",preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    errorController.addAction(defaultAction)

                    self.present(errorController, animated: true, completion: nil)
                    
                    
                }
                    
                else{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.bringSubview(toFront: appDelegate.activityIndicator)
                    appDelegate.activityIndicator.startAnimating()
                    
                    let url_to_request: String = ("http://www.applesproject.org/applesProjectConnect.php")
                    let post_to_send = "userName=\(self.userName!)&passWord=\(self.passWord!)"
                    self.check_username(url_to_request, post_to_send: post_to_send)
                    DispatchQueue.main.async(execute: { // This makes the code run on the main thread
                        appDelegate.activityIndicator.stopAnimating()
                    })
                    
                }
                
            }
            
            alertController.addTextField {
                (txtUsername) -> Void in
                usernameTextField = txtUsername
                usernameTextField!.placeholder = "Your username here..."
            }
            
            alertController.addTextField {
                (txtPassword) -> Void in
                passwordTextField = txtPassword
                passwordTextField!.isSecureTextEntry = true
                passwordTextField!.placeholder = "Your password here..."
            }

            alertController.addAction(loginAction)
            self.present(alertController, animated: true, completion:{
                alertController.view.superview!.subviews[1].isUserInteractionEnabled = true
                alertController.view.superview!.subviews[1].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            })
            
        }
        
        if self.logInStatus == true{
            submit_data(self.userName as String)
        }
        

        
    }
    
    func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func submit_data(_ userName: String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        NSLog("\(self.bloomDateTextField.text)")
        let date = dateFormatter.date(from: self.bloomDateTextField.text!)
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date!)
        
        let year =  components.year!
        let month = components.month!
        let day = components.day!
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: nil, message: nil , preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.bringSubview(toFront: appDelegate.activityIndicator)
            appDelegate.activityIndicator.startAnimating()
            
            let url = URL(string: "http://www.applesproject.org/applesProjectPostData.php")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            let boundary = self.generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            if (self.uploadPicture == nil)
            {
                NSLog("No Picture")
                return
            }
            
            let image_data = UIImageJPEGRepresentation(self.uploadPicture!, 0.8)
            
            
            if(image_data == nil)
            {
                NSLog("No Picture Data")
                return
            }


            let body = NSMutableData()
            
            let fname = "test.png"
            let mimetype = "image/png"
            
            //define the data post parameter
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"userName\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(userName)\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"species\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(self.speciesTextField.text!)\r\n".data(using: String.Encoding.utf8)!)

            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"year\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(year)\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"month\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(month)\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"day\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(day)\r\n".data(using: String.Encoding.utf8)!)
    
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"phenophase\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(self.phenophaseTextField.text!)\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"comments\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(self.commentsTextField.text!)\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"latitude\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(Float(self.latitude!)!)\r\n".data(using: String.Encoding.utf8)!)

            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"longitude\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(Float(self.longitude!)!)\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"city\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(self.cityLocation!)\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"state\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(self.stateLocation!)\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"country\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(self.countryLocation!)\r\n".data(using: String.Encoding.utf8)!)

            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image_data!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            
            
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
            request.httpBody = body as Data
            
            
            let session = URLSession.shared
            
            
            let task = session.dataTask(with: request, completionHandler: {
                (
                data, response, error) in
                
                guard let _:Data = data, let _:URLResponse = response, error == nil else {
                    print("error")
                    return
                }

                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(dataString!)
                if dataString! == "Success"{

                    print(dataString!)
                    self.requestStatus = true
                    if self.requestStatus == true{
                        let alert = UIAlertController(title: "Success!", message: "Your data was uploaded to APPLES", preferredStyle: UIAlertControllerStyle.alert)
                        DispatchQueue.main.async(execute: { // This makes the code run on the main thread
                            appDelegate.activityIndicator.stopAnimating()
                        })
                        alert.addAction(UIKit.UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else{
                    
                    let alert = UIAlertController(title: "Error!", message: "Your data was not uploaded, please try again...", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIKit.UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

            }) 
            
            task.resume()
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        let imageView = UIImageView(frame: CGRect(x: 140, y: 110, width: 120, height: 120))
        imageView.image = self.uploadPicture
        alertController.view.addSubview(imageView)
        
        //let alertMessage = UIAlertController(title: "My Title", message: "My Message", preferredStyle: .Alert)
        
        let image = UIImage(named: "myImage")
        //let action = UIAlertAction(title: "Submit", style: .Default, handler: nil)
        okAction.setValue(image, forKey: "image")
        //alertMessage .addAction(okAction)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let messageText = NSMutableAttributedString(
            string: "User Name: \(self.userName!)\nSpecies: \(self.speciesTextField.text!)\nPhenophase: \(self.phenophaseTextField.text!)\nLocation: \(self.cityLocation!)\nImage: \n\n\n\n\n\n\n",
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 14)!,
                NSForegroundColorAttributeName : UIColor.black
            ]
        )
        
        let titleText = NSMutableAttributedString(
            string: "Preview:",
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName : UIFont(name: "MyriadPro-BlackIt", size: 18)!,
                NSForegroundColorAttributeName : UIColor.black
            ]
        )
        
        alertController.setValue(titleText, forKey: "attributedTitle")
        alertController.setValue(messageText, forKey: "attributedMessage")
        
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        


        
    }
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func check_username(_ url_to_request: String, post_to_send: String)
    {
        let url:URL = URL(string: url_to_request)!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        let data = post_to_send.data(using: String.Encoding.utf8)
        
        let task = session.uploadTask(with: request as URLRequest, from: data, completionHandler:
            {(data,response,error) in
                
                guard let _:Data = data, let _:URLResponse = response, error == nil else {
                    print("error")
                    return
                }
                
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(dataString!)
                if dataString == "Matched"{
                    self.logInStatus = true
                    self.submit_data(self.userName as String)
                }
                else{
                    self.logInStatus = false
                    DispatchQueue.main.async(execute: {
                        let errorController = UIAlertController(title: "Error!", message: "Incorrect username and password",preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        errorController.addAction(defaultAction)
                        self.present(errorController, animated: true, completion: nil)
                    })

                }
            }
        );
        
        task.resume()
        
    }
    
}

class TextField: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
