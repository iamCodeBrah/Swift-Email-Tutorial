//
//  SmtpEmailController.swift
//  Swift-Email-Tutorial
//
//  Created by YouTube on 2022-11-03.
//

import UIKit

class SmtpEmailController: UIViewController {
    
    let fromEmail = "YOUR EMAIL HERE" // YOUR EMAIL HERE
    let fromName = "YOUR NAME HERE" // YOUR NAME HERE
    let toEmail = "PUT EMAIL HERE" // PUT EMAIL HERE
    
    let emailSubject = "My email title"
    let emailBody = "Hello this is my email\n\nIt is multi-line\n123\nFrom\nCodebrah"

    let images: [UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPurple
        
        let smtpSession = self.createSMTPSession()
        let messageBuilder = self.createMessage()
        
        for image in images {
            let attachment = self.createSMTPAttachment(with: image)
            messageBuilder.addAttachment(attachment)
        }
        
        self.sendSMTPMessage(with: smtpSession, and: messageBuilder)
    }
    
    private func createSMTPSession() -> MCOSMTPSession {
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.port = 465
        smtpSession.username = self.fromEmail
        smtpSession.password = "PUT PASSWORD HERE" // TODO: - PUT PASSWORD HERE
        smtpSession.connectionType = .TLS
        smtpSession.authType = .saslPlain
        smtpSession.isCheckCertificateEnabled = false
        smtpSession.timeout = 60
        return smtpSession
    }
    
    private func createMessage() -> MCOMessageBuilder {
        let builder = MCOMessageBuilder()
        builder.header.from = MCOAddress(displayName: self.fromName, mailbox: self.fromEmail)
        builder.header.to = [MCOAddress(mailbox: self.toEmail)!]
        builder.header.subject = self.emailSubject
        builder.textBody = self.emailBody // TODO: - try textbody
        return builder
    }
    
    private func createSMTPAttachment(with image: UIImage) -> MCOAttachment {
        let fileName = Int.random(in: 0...500000).description + ".jpeg"
        let jpegData = image.jpegData(compressionQuality: 1)
        let attachment = MCOAttachment(data: jpegData, filename: fileName)
        attachment?.mimeType = "image/jpg"
        return attachment!
    }
    
    private func sendSMTPMessage(with smtpSession: MCOSMTPSession, and builder: MCOMessageBuilder) {
        
        smtpSession.connectionLogger = { connectionID, type, data in
            print("DEBUG PRINT:", connectionID!)
            print("DEBUG PRINT:", type)
            print("DEBUG PRINT:", data!)

            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        
        let builderData = builder.data()
        
        smtpSession.sendOperation(with: builderData).start { error in
            if error != nil {
                NSLog("Error sending email: \(String(describing: error))")
            } else {
                NSLog("Email sent!")
            }
        }
    }
    
}
