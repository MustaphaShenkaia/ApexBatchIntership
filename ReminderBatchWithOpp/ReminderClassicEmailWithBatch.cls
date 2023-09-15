global class ReminderClassicEmailWithBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        Date today = Date.today();
        Date targetDate = Date.today().addDays(3); 
        
        return Database.getQueryLocator([
            SELECT Id, Name, CloseDate, OwnerId, Owner.Name, Owner.Email
                FROM Opportunity
                    WHERE IsClosed = false AND CloseDate >= :today AND CloseDate <= :targetDate
        ]);
		
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        // Her bir fırsat için e-posta gönderme işlemini gerçekleştirin
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        if(scope.size() > 0) {
            
             for (Opportunity opp : scope) {
            
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                EmailTemplate emailTemplate = [Select Id from EmailTemplate where Name = 'ReminderOpp'];
                
                 //-----------------------------------------------     
                        
                email.setSaveAsActivity(false);
                
                email.setTargetObjectId(opp.Owner.Id);  // Only User, Contact, Lead, or Person objects 
                email.setWhatId(opp.Id);  // User'a gönderirken kullanılmaz               
                
                email.setTemplateId(emailTemplate.Id); 
                
                 //-----------------------------------------------
                 /*
                email.setToAddresses(new String[] { opp.Owner.Email });
                                           
                email.setSubject( opp.Owner.Name + ' Opportunity required action!' ); 
                                
                String htmlBody = '<html><body> <h3> Hello ' + opp.Owner.Name + ' </h3> <p> <b>' + opp.Name + 
                    '</b> Opportunity has to be closed before <b> ' + opp.CloseDate + 
                    '</b>.  </p> <p> Please finalize your sales process. </p> </body></html>';
				email.setHtmlBody(htmlBody);
                 */
    			//-----------------------------------------------
    			
                emailsToSend.add(email);
            }
        
        }
        
        // E-posta iletilerini gönderin
        List<Messaging.SendEmailResult> sendResults = Messaging.sendEmail(emailsToSend);
        
        
        // E-posta gönderme sonuçlarını işleyebilirsiniz
        for (Messaging.SendEmailResult result : sendResults) {
            if (result.isSuccess()) {
                // E-posta başarıyla gönderildi
            } else {
                // E-posta gönderme hatası, sonuçları işleyin
                for (Messaging.SendEmailError error : result.getErrors()) {
                    System.debug('E-posta gönderme hatası: ' + error);
                }
            }
        }
    	
    
    }

    global void finish(Database.BatchableContext BC) {
    }
}

/*
ReminderClassicEmailWithBatch obj = new ReminderClassicEmailWithBatch();
Database.executeBatch(obj);
*/