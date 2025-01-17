//
//  AuthenticationChallengeResponsable.swift
//  TUSKit
//
//  Created by zhongfu on 2021/8/19.
//

import Foundation

//// Protocol indicates that an authentication challenge could be handled.
public protocol AuthenticationChallengeResponsible: AnyObject {

    /// Called when a session level authentication challenge is received.
    /// This method provide a chance to handle and response to the authentication
    /// challenge before downloading could start.
    ///
    /// - Parameters:
    ///   - uploader: The uploader which receives this challenge.
    ///   - challenge: An object that contains the request for authentication.
    ///   - completionHandler: A handler that your delegate method must call.
    ///
    /// - Note: This method is a forward from `URLSessionDelegate.urlSession(:didReceiveChallenge:completionHandler:)`.
    ///         Please refer to the document of it in `URLSessionDelegate`.
    func uploader(
        _ client: TUSClient,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)

    /// Called when a task level authentication challenge is received.
    /// This method provide a chance to handle and response to the authentication
    /// challenge before downloading could start.
    ///
    /// - Parameters:
    ///   - downloader: The uploader which receives this challenge.
    ///   - task: The task whose request requires authentication.
    ///   - challenge: An object that contains the request for authentication.
    ///   - completionHandler: A handler that your delegate method must call.
    func uploader(
        _ client: TUSClient,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
}

extension AuthenticationChallengeResponsible {

    public func uploader(
        _ client: TUSClient,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let trustedHosts = client.trustedHosts, trustedHosts.contains(challenge.protectionSpace.host) {
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential, credential)
                return
            }
        }

        completionHandler(.performDefaultHandling, nil)
    }

    public func uploader(
        _ client: TUSClient,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        completionHandler(.performDefaultHandling, nil)
    }

}
