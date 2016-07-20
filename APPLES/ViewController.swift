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
    
    let dimLevel: CGFloat = 0.45
    let dimSpeed: Double = 0.5
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverPresentationController?=nil
    
    
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
    
    func returnLocationInformation(info: String) {
        print(info)
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
