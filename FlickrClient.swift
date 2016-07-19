//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Sean Perez on 7/18/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    
    var images = [String]()
    static let sharedInstance = FlickrClient()
    
    func taskForGet(pinLatitude: NSNumber, pinLongitude: NSNumber, completionHandler: (success: Bool, pictures: [String]?, errorString: String?) -> Void) {
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.BoundingBox: bboxString(pinLatitude, pinLongitude: pinLatitude),
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback]
        displayImagesFromFlickrBySearch(methodParameters) { (success, pictures, errorString) in
            if success {
                completionHandler(success: true, pictures: pictures, errorString: nil)
            } else {
                completionHandler(success: false, pictures: nil, errorString: errorString)
            }
        }
    }
    
    func bboxString(pinLatitude: NSNumber, pinLongitude: NSNumber) -> String {
        let minimumLon = max(Double(pinLongitude) - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
        let minimumLat = max(Double(pinLatitude) - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
        let maximumLon = min(Double(pinLongitude) + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
        let maximumLat = min(Double(pinLatitude) + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }
    
    func displayImagesFromFlickrBySearch(parameters: [String:AnyObject], completionHandler: (success: Bool, pictures: [String], errorString: String?) -> Void) -> NSURLSessionDataTask {
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: flickrURLFromParameters(parameters))
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func displayError(error: String) {
                print(error)
            }
            
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }

            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
   
            guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String where stat == Constants.FlickrResponseValues.OKStatus else {
                displayError("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                displayError("Cannot find keys '\(Constants.FlickrResponseKeys.Photos)' in \(parsedResult)")
                return
            }
            
            guard let photosArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                displayError("Cannot find key '\(Constants.FlickrResponseKeys.Photo)' in \(photosDictionary)")
                return
            }
            
            for x in 0...20 {
                let photoDictionary = photosArray[x] as [String: AnyObject]
                
                guard let imageUrlString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String else {
                    displayError("Cannot find key '\(Constants.FlickrResponseKeys.MediumURL)' in \(photoDictionary)")
                    return
                }
                self.images.append(imageUrlString)
            }
            completionHandler(success: true, pictures: self.images, errorString: nil)
        }
        task.resume()
        return task
    }
    
    private func flickrURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        let components = NSURLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.URL!
    }
}