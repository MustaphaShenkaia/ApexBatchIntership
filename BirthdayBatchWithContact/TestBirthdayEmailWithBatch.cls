@isTest
public class TestBirthdayEmailWithBatch {
	
    @testSetup
    static void setup() {
        
        Contact con1 = new Contact(); 
        	con1.FirstName = 'George'; 
        	con1.LastName = 'Hagi'; 
        	con1.Email = 'senkaya20@gmail.com'; 
        	con1.Birthdate = Date.newInstance(2016, 9, 6);  
        insert con1; 
        
        Contact con2 = new Contact(); 
        	con2.FirstName = 'Jay Jay'; 
        	con2.LastName = 'Okacha'; 
        	con2.Email = 'senkaya20@gmail.com'; 
        	con2.Birthdate = Date.newInstance(2016, 9, 8);  
        insert con2; 
    }
    
    @isTest 
    static void testBirthdayEmail() {
        
        Test.startTest();
            BirthdayEmailWithBatch batch = new BirthdayEmailWithBatch(); 
            Database.executeBatch(batch); 
        
            String cronString = '0 0 12 * * ?'; 
            BirthdayEmailWithBatch1 job = new BirthdayEmailWithBatch1();
            System.schedule('Update Cases to New', cronString, job);
        
        Test.stopTest();
        /*
        List<Contact> cc = [SELECT Id, Name, FirstName, LastName, Email, Birthdate FROM Contact WHERE Email != null and Birthdate != null LIMIT 1];         
        
        for(Contact c : cc) {
            if(c.FirstName != null) {
                System.assertEquals('George', c.FirstName); 
            }
        }     
        */
        List<Contact> cc = [SELECT Id, Name, FirstName, LastName, Email, Birthdate FROM Contact WHERE Email != null and Birthdate != null];    
        System.assertEquals(2, cc.size());       
     
    }
}