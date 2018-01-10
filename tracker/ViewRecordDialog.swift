//
//  ViewRecordDialog.swift
//  tracker
//
//  Created by Joseph Liu on 6/12/17.
//  Copyright © 2017 Joseph Liu. All rights reserved.
//

import UIKit

class ViewRecordDialog: UIViewController{
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var messageLabel: UILabel!
	
	var titleText : String = ""
	var messageText : String = ""
	var numberOfLines: Int = -1
	
	var completionHandler: () -> Void = {}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		definesPresentationContext = true
		providesPresentationContextTransitionStyle = true
		modalPresentationStyle = .overFullScreen
		modalTransitionStyle = .crossDissolve
	}
	
	override func viewDidLoad() {
		titleLabel.text = titleText
		messageLabel.text = messageText
		if(numberOfLines > 0){
			messageLabel.numberOfLines = numberOfLines
		}
	}
	
	func setTitle(title: String){
		titleText = title
	}
	
	func setMessage(message: String){
		messageText = message
	}
	
	func setMessage(message: String, numberOfLines: Int){
		messageText = message
		self.numberOfLines = numberOfLines
	}
	
	func setCompletion(completion: @escaping ()-> Void){
		completionHandler = completion
	}
	
	@IBAction func cancelButtonPressed(){
		dismiss(animated: true, completion: nil)
		completionHandler()
	}
	
	@IBAction func shareButtonPressed(){
		let text = "\(titleText): \(messageText)"
		let textToShare = [text]
		let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
		
		// exclude some activity types from the list (optional)
		activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, UIActivityType.postToTwitter ]
		
		// present the view controller
		self.present(activityViewController, animated: true, completion: nil)
	}
}
