public class WeatherService {

    public static void fetchWeather(String city, Id jobId) {
        
        // Step 1 - Build the API URL
        String apiKey = '3c05a73dfbf6692ba87b9a837c10d265';
        String endpoint = 'https://api.openweathermap.org/data/2.5/weather?q=' 
                          + city + '&appid=' + apiKey + '&units=metric';
        
        // Step 2 - Create HTTP Request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        
        // Step 3 - Send the Request
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Step 4 - Debug the raw response (important!)
        System.debug('Status Code: ' + res.getStatusCode());
        System.debug('Response Body: ' + res.getBody());
        
        // Step 5 - Parse JSON if successful
        if (res.getStatusCode() == 200) {
            
            Map<String, Object> result = 
                (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            
            // Extract main block (temperature)
            Map<String, Object> main = 
                (Map<String, Object>) result.get('main');
            
            // Extract weather block (condition/description)
            List<Object> weatherList = 
                (List<Object>) result.get('weather');
            Map<String, Object> weather = 
                (Map<String, Object>) weatherList[0];
            
            // Debug each field individually
            System.debug('Temperature: ' + main.get('temp'));
            System.debug('Condition: ' + weather.get('description'));
            
            // Step 6 - Update Job record
            Job__c job = new Job__c();
            job.Id = jobId;
            job.Temperature__c = Decimal.valueOf(String.valueOf(main.get('temp')));
            job.Weather_Condition__c = (String) weather.get('description');
            job.Weather_Fetched_On__c = DateTime.now();
            update job;
            
            System.debug('Job updated successfully!');
            
        } else {
            System.debug('API call failed! Status: ' + res.getStatusCode());
        }
    }
}