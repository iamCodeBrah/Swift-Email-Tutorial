//
//  MailComposeController.swift
//  Swift-Email-Tutorial
//
//  Created by YouTube on 2022-11-03.
//

import UIKit
import MessageUI

class MailComposeController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let emailSubject = "My email title"
    let emailBody = "Hello this is my email\n\nIt is multi-line\n123\nFrom\nCodebrah"
    
    let toEmails = ["PUT EMAILS HERE"] // PUT EMAILS HERE
    let fromEmail = "YOUR EMAIL HERE" // YOUR EMAIL HERE
    
    let images: [UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        
        self.showMailComposer(emailSubject, emailBody, toEmails, fromEmail, images)
    }
    
    private func showMailComposer(
        _ subject: String,
        _ body: String,
        _ toEmails: [String],
        _ fromEmail: String,
        _ images: [UIImage]
    ) {
        guard MFMailComposeViewController.canSendMail() else {
            print("canSendMail Failure"); return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setSubject(subject)
        composer.setMessageBody(body, isHTML: false)
        composer.setToRecipients(toEmails)
        composer.setPreferredSendingEmailAddress(fromEmail)
        
        for image in images {
            let fileName = Int.random(in: 0...500000).description + ".jpeg"
            let imageData = image.jpegData(compressionQuality: 1)!
            composer.addAttachmentData(imageData, mimeType: "image/jpg", fileName: fileName)
        }
        
        present(composer, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            print("DEBUG PRINT:", "didFinishWithError", error)
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
}



