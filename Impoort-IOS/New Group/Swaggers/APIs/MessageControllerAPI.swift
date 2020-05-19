//
// MessageControllerAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class MessageControllerAPI {
    /**
     iki kullanıcı arasındaki mesajların hepsini döner
     
     - parameter receiverId: (path) receiverId 
     - parameter senderId: (path) senderId 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getAllMessageWithReceiverUserUsingGET(receiverId: String, senderId: String, completion: @escaping ((_ data: [Message]?,_ error: Error?) -> Void)) {
        getAllMessageWithReceiverUserUsingGETWithRequestBuilder(receiverId: receiverId, senderId: senderId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     iki kullanıcı arasındaki mesajların hepsini döner
     - GET /api/v1/messages/allMessage/{senderId}/{receiverId}
     - examples: [{output=none}]
     
     - parameter receiverId: (path) receiverId 
     - parameter senderId: (path) senderId 

     - returns: RequestBuilder<[Message]> 
     */
    open class func getAllMessageWithReceiverUserUsingGETWithRequestBuilder(receiverId: String, senderId: String) -> RequestBuilder<[Message]> {
        var path = "/api/v1/messages/allMessage/{senderId}/{receiverId}"
        let receiverIdPreEscape = "\(receiverId)"
        let receiverIdPostEscape = receiverIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{receiverId}", with: receiverIdPostEscape, options: .literal, range: nil)
        let senderIdPreEscape = "\(senderId)"
        let senderIdPostEscape = senderIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{senderId}", with: senderIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[Message]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     bir kullanıcının diğer kullanıcı ile 
     
     - parameter userId: (path) userId 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getUserMessagesUsersUsingGET(userId: String, completion: @escaping ((_ data: [UserMessageDTO]?,_ error: Error?) -> Void)) {
        getUserMessagesUsersUsingGETWithRequestBuilder(userId: userId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     bir kullanıcının diğer kullanıcı ile 
     - GET /api/v1/messages/inbox/{userId}
     - examples: [{output=none}]
     
     - parameter userId: (path) userId 

     - returns: RequestBuilder<[UserMessageDTO]> 
     */
    open class func getUserMessagesUsersUsingGETWithRequestBuilder(userId: String) -> RequestBuilder<[UserMessageDTO]> {
        var path = "/api/v1/messages/inbox/{userId}"
        let userIdPreEscape = "\(userId)"
        let userIdPostEscape = userIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{userId}", with: userIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[UserMessageDTO]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     bir kullanıcıya mesaj göndermek için
     
     - parameter message: (body) message 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func sendNewMessageToReceiverUsingPOST(message: Message, completion: @escaping ((_ data: Message?,_ error: Error?) -> Void)) {
        sendNewMessageToReceiverUsingPOSTWithRequestBuilder(message: message).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     bir kullanıcıya mesaj göndermek için
     - POST /api/v1/messages/sendMessage
     - examples: [{output=none}]
     
     - parameter message: (body) message 

     - returns: RequestBuilder<Message> 
     */
    open class func sendNewMessageToReceiverUsingPOSTWithRequestBuilder(message: Message) -> RequestBuilder<Message> {
        let path = "/api/v1/messages/sendMessage"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: message)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Message>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
