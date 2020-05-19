//
// CompanyAndExperienceControllerAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class CompanyAndExperienceControllerAPI {
    /**
     kullanıcıların yeni deneyim eklemesi için kullanılır parametre olarak experience listesi gelir
     
     - parameter experiences: (body) experiences 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func newExperiencesUsingPOST(experiences: [Experience], completion: @escaping ((_ data: [JSONValue]?,_ error: Error?) -> Void)) {
        newExperiencesUsingPOSTWithRequestBuilder(experiences: experiences).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     kullanıcıların yeni deneyim eklemesi için kullanılır parametre olarak experience listesi gelir
     - POST /api/v1/experience
     - examples: [{output=none}]
     
     - parameter experiences: (body) experiences 

     - returns: RequestBuilder<[JSONValue]> 
     */
    open class func newExperiencesUsingPOSTWithRequestBuilder(experiences: [Experience]) -> RequestBuilder<[JSONValue]> {
        let path = "/api/v1/experience"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: experiences)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[JSONValue]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     kullanıcı adı company name olan userType'ı STARTUP olan kullanıcıların yani şirketlerin listesini döner
     
     - parameter companyName: (query) companyName 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func searchCompanyUsingGET(companyName: String, completion: @escaping ((_ data: [JSONValue]?,_ error: Error?) -> Void)) {
        searchCompanyUsingGETWithRequestBuilder(companyName: companyName).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     kullanıcı adı company name olan userType'ı STARTUP olan kullanıcıların yani şirketlerin listesini döner
     - GET /api/v1/company
     - examples: [{output=none}]
     
     - parameter companyName: (query) companyName 

     - returns: RequestBuilder<[JSONValue]> 
     */
    open class func searchCompanyUsingGETWithRequestBuilder(companyName: String) -> RequestBuilder<[JSONValue]> {
        let path = "/api/v1/company"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "companyName": companyName
        ])

        let requestBuilder: RequestBuilder<[JSONValue]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     kullanıcıların deneyimlerini güncellemesi için kullanılır 
     
     - parameter experiences: (body) experiences 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func updateExperiencesUsingPUT(experiences: [Experience], completion: @escaping ((_ data: [JSONValue]?,_ error: Error?) -> Void)) {
        updateExperiencesUsingPUTWithRequestBuilder(experiences: experiences).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     kullanıcıların deneyimlerini güncellemesi için kullanılır 
     - PUT /api/v1/experience
     - examples: [{output=none}]
     
     - parameter experiences: (body) experiences 

     - returns: RequestBuilder<[JSONValue]> 
     */
    open class func updateExperiencesUsingPUTWithRequestBuilder(experiences: [Experience]) -> RequestBuilder<[JSONValue]> {
        let path = "/api/v1/experience"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: experiences)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[JSONValue]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
