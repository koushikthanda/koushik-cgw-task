public with sharing class InvoiceController {
    
    @AuraEnabled
    public static Id createInvoiceAndLineItems(Map<String, string> inputData) {
        try {
            
            String accountId = (String)inputData.get('accountId');
            String invoiceDateStr = (String)inputData.get('invoiceDate');
            String dueDateStr = (String)inputData.get('dueDate');
        
        
            Date invoiceDate = parseDate(invoiceDateStr);
            Date dueDate = parseDate(dueDateStr);

           

        
            Invoice__c invoice = new Invoice__c();
            invoice.Account__c = accountId;
            invoice.Invoice_Date__c = invoiceDate;
            invoice.Due_Date__c = dueDate;
            insert invoice;
            
            return invoice.Id;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error creating Invoice and Line Items: ' + e.getMessage());
        }
    }
    

private static Date parseDate(String dateStr) {
    if (String.isNotBlank(dateStr)) {
        try {
            
            if (dateStr.contains('-')) {
                return Date.valueOf(dateStr);
            }
           
            List<String> dateParts = dateStr.split('/');
            if (dateParts.size() == 3) {
                String reformattedDateStr = dateParts[2] + '-' + dateParts[1] + '-' + dateParts[0];
                return Date.valueOf(reformattedDateStr);
            }
        } catch (Exception e) {
            throw new AuraHandledException('Invalid date format: ' + dateStr);
        }
    }
    throw new AuraHandledException('Date cannot be blank');
}

}