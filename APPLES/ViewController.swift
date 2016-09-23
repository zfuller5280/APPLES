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
    var latitude: String?
    var longitude: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        speciesTextField.layer.cornerRadius = 4.0
        speciesTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        speciesTextField.layer.borderWidth = 2.0
        
        bloomDateTextField.layer.cornerRadius = 4.0
        bloomDateTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        bloomDateTextField.layer.borderWidth = 2.0
        
        phenophaseTextField.layer.cornerRadius = 4.0
        phenophaseTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        phenophaseTextField.layer.borderWidth = 2.0
        
        locationTextField.layer.cornerRadius = 4.0
        locationTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        locationTextField.layer.borderWidth = 2.0
        
        commentsTextField.layer.cornerRadius = 4.0
        commentsTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        commentsTextField.layer.borderWidth = 2.0
        commentsTextField.padding.top = 12
        
        uploadPhotoBtn.layer.cornerRadius = 4.0
        uploadPhotoBtn.layer.borderWidth = 2.0
        uploadPhotoBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        speciesTextField.delegate = self
        bloomDateTextField.delegate = self
        phenophaseTextField.delegate = self
        locationTextField.delegate = self
        commentsTextField.delegate = self
        
        speciesTextField.backgroundColor = UIColor.whiteColor()
        bloomDateTextField.backgroundColor = UIColor.whiteColor()
        phenophaseTextField.backgroundColor = UIColor.whiteColor()
        locationTextField.backgroundColor = UIColor.whiteColor()
        commentsTextField.backgroundColor = UIColor.whiteColor()
        
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        
        
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.tappedToolBarBtn))
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(ViewController.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Myriad Pro", size: 12)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "Pick a Date"
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        bloomDateTextField.inputAccessoryView = toolBar
        
        let phenoToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        phenoToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        phenoToolBar.barStyle = UIBarStyle.BlackTranslucent
        phenoToolBar.tintColor = UIColor.whiteColor()
        phenoToolBar.backgroundColor = UIColor.blackColor()
        
        let phenoDoneBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(ViewController.donePressed))
        let phenoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/2, height: self.view.frame.size.height))
        phenoLabel.font = UIFont(name: "Myriad Pro", size: 12)
        phenoLabel.backgroundColor = UIColor.clearColor()
        phenoLabel.textColor = UIColor.whiteColor()
        phenoLabel.text = "Pick a Phenophase"
        let phenoTextBtn = UIBarButtonItem(customView: phenoLabel)
        phenoToolBar.setItems([phenoTextBtn,flexSpace,phenoDoneBarBtn], animated: true)
        phenophaseTextField.inputAccessoryView = phenoToolBar
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        //pickerView.selectRow(0, inComponent: 0, animated: true)
        phenophaseTextField.inputView = pickerView
        
        
    }
    
    func donePressed(sender: UIBarButtonItem) {

        phenophaseTextField.resignFirstResponder()
        bloomDateTextField.resignFirstResponder()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }

    func tappedToolBarBtn(sender: UIBarButtonItem) {
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateformatter.timeStyle = NSDateFormatterStyle.NoStyle
        bloomDateTextField.text = dateformatter.stringFromDate(NSDate())
        bloomDateTextField.resignFirstResponder()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        phenophaseTextField.text = pickOption[row]
    }

    func openCamera(button: UIButton)
    {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
            newMedia = true
        }
    }
    
    func openGallary(button: UIButton)
    {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        imagePickerController.modalPresentationStyle = .Popover
        let presentationController = imagePickerController.popoverPresentationController
        
        
        presentationController?.sourceView = button
        presentationController?.sourceRect = button.bounds
        presentationController?.permittedArrowDirections = .Any
        
        self.presentViewController(imagePickerController, animated: true) {}
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
        self.uploadPicture = info[UIImagePickerControllerOriginalImage] as? UIImage


    }
    
    @IBAction func textFieldEditing(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    @IBAction func locationFieldEditing(sender: UITextField) {
        let dummyView = UIView(frame: CGRectMake(100,100,100,100))
        dummyView.backgroundColor = UIColor.clearColor()
        locationTextField.inputView = dummyView
        
        let mapVC = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewController") as! MapViewController!
        self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        mapVC.delegate = self
        self.presentViewController(mapVC!, animated: true, completion: nil)
        
       //locationTextField.enabled = true
    }
    
    func returnLocationInformation(info: String, latitude: String, longitude: String) {
        print(info)
        self.latitude = latitude
        self.longitude = longitude
        NSLog(latitude)
        self.locationTextField.text = info
    }
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        bloomDateTextField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    

    
    @IBAction func uploadBtnClicked(sender: AnyObject) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openCamera(self.uploadButton)
        }
        let gallaryAction = UIAlertAction(title: "Library", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openGallary(self.uploadButton)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            
            alert.popoverPresentationController?.sourceView = self.uploadButton.imageView
            alert.popoverPresentationController?.sourceRect = self.uploadButton.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .Any
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        dim(.In, alpha: dimLevel, speed: dimSpeed)
    }
    
    @IBAction func unwindFromSecondary(segue: UIStoryboardSegue) {
        dim(.Out, speed: dimSpeed)
    }
    
    @IBAction func submitBtnClicked(sender: AnyObject) {
        if self.logInStatus == false{
            var usernameTextField: UITextField?
            var passwordTextField: UITextField?
            
            let alertController = UIAlertController(
                title: "Log in",
                message: "Please enter your information",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let loginAction = UIAlertAction(
            title: "Submit Data", style: UIAlertActionStyle.Default) {
                (action) -> Void in
                
                if let userNameField = usernameTextField?.text {
                    self.userName = userNameField
                } else {
                    print("No Username entered")
                }
                
                if let passWordField = passwordTextField?.text {
                    self.passWord = passWordField
                } else {
                    print("No password entered")
                }
                
                // Check if username and password are blank
                if ( self.userName.isEqualToString("") || self.passWord.isEqualToString("") ) {
                    
                    let errorController = UIAlertController(title: "Error!", message: "Please enter a username and password",preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    errorController.addAction(defaultAction)
                    self.presentViewController(errorController, animated: true, completion: nil)
                    
                    
                }
                    
                else{
                    let url_to_request: String = ("http://www.psuapples.org/applesConnect.php")
                    let post_to_send = "userName=\(self.userName)&passWord=\(self.passWord)"
                    self.check_username(url_to_request, post_to_send: post_to_send)
                    
                }
                
            }
            
            alertController.addTextFieldWithConfigurationHandler {
                (txtUsername) -> Void in
                usernameTextField = txtUsername
                usernameTextField!.placeholder = "Your username here..."
            }
            
            alertController.addTextFieldWithConfigurationHandler {
                (txtPassword) -> Void in
                passwordTextField = txtPassword
                passwordTextField!.secureTextEntry = true
                passwordTextField!.placeholder = "Your password here..."
            }
            
            alertController.addAction(loginAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
        if self.logInStatus == true{
            submit_data(self.userName as String)
        }
        

        
    }
    
    func submit_data(userName: String){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        NSLog("\(self.bloomDateTextField.text)")
        let date = dateFormatter.dateFromString(self.bloomDateTextField.text!)
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date!)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: "User: \(userName)", message: "Post data?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("OK Pressed")
            let url = NSURL(string: "http://www.psuapples.org/applesPostData.php")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            
            let boundary = self.generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            if (self.uploadPicture == nil)
            {
                NSLog("No Picture")
                return
            }
            
            let image_data = UIImagePNGRepresentation(self.uploadPicture!)
            
            
            if(image_data == nil)
            {
                NSLog("No Picture Data")
                return
            }
            
            let body = NSMutableData()
            
            let fname = "test.png"
            let mimetype = "image/png"
            
            //define the data post parameter
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"userName\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(userName)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"species\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(self.speciesTextField.text!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)

            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"year\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(year)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"month\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(month)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"day\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(day)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"phenophase\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(self.phenophaseTextField.text!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"comments\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(self.commentsTextField.text!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"latitude\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(Float(self.latitude!)!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)

            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"longitude\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("\(Float(self.longitude!)!)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)

            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(image_data!)
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            
            request.HTTPBody = body
            
            
            let session = NSURLSession.sharedSession()
            
            
            let task = session.dataTaskWithRequest(request) {
                (
                let data, let response, let error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print("error")
                    return
                }
                
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
                
            }
            
            task.resume()

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func check_username(url_to_request: String, post_to_send: String)
    {
        let url:NSURL = NSURL(string: url_to_request)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        
        let data = post_to_send.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print("error")
                    return
                }
                
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
                if dataString == "Matched"{
                    self.logInStatus = true
                    self.submit_data(self.userName as String)
                }
                else{
                    self.logInStatus = false
                    dispatch_async(dispatch_get_main_queue(), {
                        let errorController = UIAlertController(title: "Error!", message: "Incorrect username and password",preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        errorController.addAction(defaultAction)
                        self.presentViewController(errorController, animated: true, completion: nil)
                    })

                }
            }
        );
        
        task.resume()
        
    }
    
}

class TextField: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
