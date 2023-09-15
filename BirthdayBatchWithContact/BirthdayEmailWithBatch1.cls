global class BirthdayEmailWithBatch1 implements Database.Batchable<SObject>, Schedulable  {
    // Database.Stateful
        
        global Database.QueryLocator start(Database.BatchableContext BC) {
            
            return Database.getQueryLocator([SELECT Id, Name, FirstName, LastName, Email, Birthdate FROM Contact WHERE Email != null and Birthdate != null]);
        }
        
    
        
        global void execute(Database.BatchableContext BC, List<Contact> scope) {
           
            List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
    
            //---------------
            for (Contact con : scope) {
                
                if(con.Birthdate.day() == Date.today().day()   &&   con.Birthdate.month() == Date.today().month()) {
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
                  
                    email.setSubject('Happy Birthdate ' + con.FirstName + ' ' + con.LastName + '!'); 
                    
                    email.setPlainTextBody('As Silverline family, we wish you a very happy birthday and send you best wishes for much happiness in your life!');
                        
                    
                    email.setToAddresses(new String[] {con.Email});
        
                    emailsToSend.add(email);
                }
            }
            //---------------
    
           
            List<Messaging.SendEmailResult> sendResults = Messaging.sendEmail(emailsToSend);
            
        /*
            // E-posta gönderme sonuçlarını işleyebilirsiniz
            for (Messaging.SendEmailResult result : sendResults) {
                if (!result.isSuccess()) {
                    for (Messaging.SendEmailError error : result.getErrors()) {
                        System.debug('E-posta gönderme hatası: ' + error);
                    }
                } 
            }
        */
        
        }
    
        
        global void finish(Database.BatchableContext BC) {
            System.debug('The Process is successfully!'); 
        }
        
        public void execute(SchedulableContext context) { 
            
            BirthdayEmailWithBatch1 b = new BirthdayEmailWithBatch1(); 
              Database.executeBatch(b);
        
        }
    
    }
    
    /*
    BirthdayEmailWithBatch batch = new BirthdayEmailWithBatch(); 
    Database.executeBatch(batch); 
    -> Apex Jobs
    
     E-posta gönderme sonuçlarını işleyebilirsiniz
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
        
        
    */