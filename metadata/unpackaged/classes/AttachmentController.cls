public with sharing class AttachmentController 
{
    @AuraEnabled
    public static void updatePicturePath(String recId)
    {
        
        ContentDocumentLink docLink;
        ContentVersion ver;

        //In Lightning Experience, Attachments are stored in ContentDocuments
        if(Schema.sObjectType.ContentDocumentLink.isAccessible())
        {
            docLink = [ SELECT ContentDocumentId
                               FROM ContentDocumentLink
                               WHERE LinkedEntityId = :recId order by Id desc Limit 1];
        }

        //ContentVersion Id uniquely identifies the attachment
        if(Schema.sObjectType.ContentVersion.isAccessible())
        {
		    ver = [SELECT Id FROM ContentVersion Where ContentDocumentId = :docLink.ContentDocumentId];
        }
        
        if(Schema.sObjectType.Speaker__c.isAccessible())
        {
            //Update the Picture_Path field with the url of the image
            Speaker__c speaker = [SELECT Id FROM Speaker__c WHERE Id = :recId];
            if (Schema.sObjectType.Speaker__c.fields.Picture_Path__c.isCreateable() || Schema.sObjectType.Speaker__c.fields.Picture_Path__c.isUpdateable()) 
            {
                speaker.Picture_Path__c = '/sfc/servlet.shepherd/version/download/'+ ver.Id;
                upsert speaker;
            }
        }
    }

}