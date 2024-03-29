Public class ConvertLeads {
    
    Public class ConvertLeadRequest {
        @InvocableVariable
        public ID leadId;
        
        @InvocableVariable
        public Boolean createOpportunity;
    }
    
    @InvocableMethod(label='Convert Leads' description='converts the specified leads')   
    public static void LeadAssign(List<ConvertLeadRequest> ConvertLeadRequests) {         
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];    
        List<Database.LeadConvert> lc = new List<Database.LeadConvert>();    
        for(ConvertLeadRequest clr : ConvertLeadRequests) {                
            Database.LeadConvert Leadconvert = new Database.LeadConvert();    
            Leadconvert.setLeadId(clr.leadId);                               
            Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
            Leadconvert.setDoNotCreateOpportunity(!clr.createOpportunity);
            lc.add(Leadconvert);    
        }
        List<Database.LeadConvertResult> lcr = Database.convertLead(lc);  
    } 
}