public with sharing class ConvertLeads {
    
    public class ConvertLeadRequest {
        @InvocableVariable
        public ID leadId;
        
        @InvocableVariable
        public Boolean createOpportunity;
    }
    
    @InvocableMethod   
    public static void leadAssign(List<ConvertLeadRequest> convertLeadRequests) {         
        LeadStatus cLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];    
        List<Database.LeadConvert> lc = new List<Database.LeadConvert>();    
        for(ConvertLeadRequest clr : convertLeadRequests) {                
            Database.LeadConvert leadConvert = new Database.LeadConvert();    
            leadConvert.setLeadId(clr.leadId);                               
            leadConvert.setConvertedStatus(cLeadStatus.MasterLabel);
            leadConvert.setDoNotCreateOpportunity(!clr.createOpportunity);
            lc.add(leadConvert);    
        }
        List<Database.LeadConvertResult> lcr = Database.convertLead(lc);  
    } 
}