global class CreateContactFromEmail implements Messaging.InboundEmailHandler{

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        String subToCompare = 'Create Contact';
        
        if(email.subject.equalsIgnoreCase(subToCompare)){
            // create contact
            Contact oContact = new Contact();
            //oContact.LastName = email.plainTextBody;
            oContact.FirstName = email.fromname.substring(0,email.fromname.indexOf(' '));
            oContact.LastName = email.fromname.substring(email.fromname.indexOf(' '));
            oContact.Email = envelope.fromAddress;
    
            insert oContact;
            //save attachments if any
            for(Messaging.InboundEmail.TextAttachment txtAttachment : email.textAttachments){
                Attachment attachment = new Attachment();
                attachment.name = txtAttachment.filename;
                attachment.body = Blob.valueOf(txtAttachment.body);
                attachment.ParentId = oContact.Id;
                insert attachment;
            }
        }
        
        result.success = true;
        return result;
    }
    
}