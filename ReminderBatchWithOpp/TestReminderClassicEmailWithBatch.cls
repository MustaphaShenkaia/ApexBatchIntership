@isTest
public class TestReminderClassicEmailWithBatch {
	
     @testSetup
    static void setup() {
        
        Opportunity opp1 = new Opportunity(); 
        	opp1.Name = 'Opp1';  
            opp1.CloseDate = Date.newInstance(2023, 9, 10); 
        	opp1.StageName = 'Proposal'; 
        insert opp1; 
        
        Opportunity opp2 = new Opportunity(); 
        	opp2.Name = 'Opp2';  
            opp2.CloseDate = Date.newInstance(2023, 9, 11); 
        	opp2.StageName = 'Proposal'; 
        insert opp2;  
    }
    
    @isTest 
    static void reminderEmail() {
        
        Test.startTest();
        
            ReminderClassicEmailWithBatch batch = new ReminderClassicEmailWithBatch(); 
            Database.executeBatch(batch); 
        
        Test.stopTest();
        
        Date today = Date.today();
        Date targetDate = Date.today().addDays(3); 
        
        List<Opportunity> opps = [
            SELECT Id, Name, CloseDate, OwnerId, Owner.Name, Owner.Email
                FROM Opportunity
                    WHERE IsClosed = false AND CloseDate >= :today AND CloseDate <= :targetDate
        ];    
        System.assertEquals(2, opps.size());       
        
    }
}