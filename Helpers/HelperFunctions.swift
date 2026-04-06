//
//  HelperFunctions.swift
//  SwearBy
//
//  Created by Colin Power on 3/4/23.
//

import Foundation
import SwiftUI


//MARK: Timestamps // https://stackoverflow.com/questions/35700281/date-format-in-swift
func convertTimestampToShortDate(timestamp: Int) -> String {
    
    let date = Date(timeIntervalSince1970: Double(timestamp))
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM d"
    let strDate = dateFormatter.string(from: date)
    
    return strDate
}

func convertTimestampToCustomDate(timestamp: Int, customDateFormat: String) -> String {
    
    let date = Date(timeIntervalSince1970: Double(timestamp))
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = customDateFormat
    let strDate = dateFormatter.string(from: date)
    
    return strDate
}

func checkIfTimestampInLastDay(lastTimestamp: Int) -> Bool {
    
    let date1 = Date(timeIntervalSince1970: Double(lastTimestamp))
    let date2 = Date(timeIntervalSince1970: Double(getTimestamp()))
    
    let sameDay = Calendar.current.isDate(date1, equalTo: date2, toGranularity: .day)

    return sameDay
}

func convertTimestampToMinOrHoursAgo(timestamp: Int) -> String {
    
    let t1 = timestamp
    let t2 = getTimestamp()
    
    let numSecondsAgo = t2 - t1
    
    if numSecondsAgo < 3600 {
        
        let numMinAgo = Double(Double(numSecondsAgo) / Double(60)).rounded(.towardZero)
        
        return String(Int(numMinAgo)) + " min"
    } else {
        
        let numHoursAgo = Double(Double(numSecondsAgo) / Double(3600)).rounded(.towardZero)
        return String(Int(numHoursAgo)) + "h"
    }
}

func convertUser2ObjectToUser2Snippet(user: Users) -> Struct_Posts_User {
    
    var snippet = EmptyVariables().empty_user_snippet
    
    snippet._ID = user.user_id
    snippet.name = user.info.name
    snippet.pic = user.info.pic
    snippet.isPublicAccount = user.settings.isPublicAccount
    snippet.socials.instagram = user.socials.instagram
    snippet.socials.tiktok = user.socials.tiktok
    snippet.socials.x = user.socials.x
    snippet.socials.ltk = user.socials.ltk
    snippet.socials.youtube = user.socials.youtube
    
    return snippet
}



func getTimestamp() -> Int {
    
    return Int(round(Date().timeIntervalSince1970))

}


func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle){
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}


//MARK: Formatting Strings
func makePhoneNumberPretty(phone_number: String) -> String {
    
    if phone_number.count >= 10 {
        
        let area_code = String(phone_number.prefix(3))
        
        let digit_three = phone_number.index(phone_number.startIndex, offsetBy: 3)
        let digit_six = phone_number.index(phone_number.startIndex, offsetBy: 6)
        let digit_ten = phone_number.index(phone_number.startIndex, offsetBy: 10)
        
        let range1 = digit_three..<digit_six
        let range2 = digit_six..<digit_ten
        
        let first_three = phone_number[range1]
        let last_four = phone_number[range2]
        
        return "(" + area_code + ") " + first_three + "-" + last_four
        
    } else {
        return phone_number
    }
    
    
}


//MARK: For the friend_profile
func getMutualFriendsList(user_list: [String], friend_list: [String]) -> [String] {
    
    var arr:[String] = []
    
    for i in 0..<user_list.count {
        
        if friend_list.contains(user_list[i]) {
            arr.append(user_list[i])
        }
    }
    
    return arr
}






//MARK: Other Functions
func emptyFunction() {
    
}

func getShareLink() -> String {
    
    return "https://apps.apple.com/us/app/swearby-app/id6446050386"
    //return "https://testflight.apple.com/join/uZLnwSJC"
    
}

//func convertUserObjectToUserSnippet(user: Users) -> User_Snippet {
//    
//    var snippet = EmptyVariables().empty_user_snippet
//    
//    snippet._ID = user.id ?? "NO_USER_ID_FOUND_IN_CONVERSION"
//    snippet.email = user.email
//    snippet.phone = user.phone
//    snippet.name = user.name
//    
//    return snippet
//}

func getBrandNameBrandURLProductName(product_url: String, product_name: String) -> [String] {
    
    var converted_url = URL(string: product_url)                                     // e.g. might be https://shop.lululemon.com/p/men-joggers/Abc-Jogger/_/pro ...
    var domain = converted_url?.host ?? "No Domain"                                 // e.g. might be www.shop.lululemon.com or just shop.lululemon.com
    
    if domain.prefix(4) == "www." {
        
        let removed_www_index = domain.index(domain.startIndex, offsetBy: 4)
        let end_index = domain.index(domain.startIndex, offsetBy: domain.count)
        let range = removed_www_index..<end_index
        
        domain = String(domain[range])                                              // e.g. should be shop.lululemon.com or lululemon.com
    }
    
    
    var brand_name = ""
    
    let inputChar: Character = "."                                                  // need to remove the .com / .net / .us etc... as well as any leading prefix like "shop." in shop.lululemon.com
                         
    let num_of_periods = domain.components(separatedBy: ".").count-1                // check if a period appears twice (e.g. shop.lululemon.com, but not lululemon.com)
    print("num of periods \(num_of_periods)")
    
    if num_of_periods == 0 {
        
        brand_name = domain                                                         // if none, then you've got the brand name already (though this shouldn't really happen?
        
    } else {
        
        // Remove .com (e.g. shop.lululemon.com -> lululemon.com)
        if let index_last = domain.lastIndex(of: inputChar) {                       // get index of the .com / .net / .us ...
            
            brand_name = String(domain[..<index_last])                              // remove the .com / .net / .us
            print("brand name minus .com \(brand_name)")
        } else {
            
            brand_name = domain                                                     // fallback if error
            print("brand name NOT minus .com \(brand_name)")
        }
        
        // Then remove prefix if it exists (e.g. shop.lululemon -> lululemon)
        if let index_period = brand_name.firstIndex(of: inputChar) {
            
            let index_start = brand_name.index(index_period, offsetBy: 1)
            let index_end = brand_name.index(brand_name.startIndex, offsetBy: brand_name.count)
            let range_middle = index_start..<index_end
            
            brand_name = String(brand_name[range_middle])
            print("brand name minus prefix \(brand_name)")
            
        }
        
        print("final brand name \(brand_name)")
    }
    
    var confirmed_product_name = ""
    
    // product_name often ends with the brand name... like ABC Pants | Lululemon
    // Check the last segment of the product_name to see if it's the same as the brand_name
    print(product_name)
    print(brand_name)
    
    if (product_name.isEmpty || (product_name.count < brand_name.count)) {
        confirmed_product_name = product_name           // PRODUCT NAME IS EMPTY -> OTHERWISE IT WILL CRASH ON .startIndex BELOW
    } else {
        let product_start_index = product_name.index(product_name.startIndex, offsetBy: product_name.count - brand_name.count)
        let product_end_index = product_name.index(product_name.startIndex, offsetBy: product_name.count)
        let product_range = product_start_index..<product_end_index
        
        let brand_name_from_product_name = String(product_name[product_range])
        print("brand name in product name \(brand_name_from_product_name)")
        
        if brand_name_from_product_name.lowercased() == brand_name.lowercased() {                   // if it ends with Lululemon, remove it (e.g. "ABC Pants | Lululemon" -> "ABC Pants | ")
            
            confirmed_product_name = String(product_name[..<product_start_index])
            
            let characterSet = CharacterSet.alphanumerics                                           // Then remove the non alphanumeric characters at the end, if any (e.g. "ABC Pants | " -> "ABC Pants")
            
            for i in 0..<confirmed_product_name.count {
                // flip the string
                let flipped = confirmed_product_name.reversed()
                
                // get i'th character in the flpped string
                let index = flipped.index(flipped.startIndex, offsetBy: i)
                
                // check if this character is alphanumeric
                let alphanums = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
                if alphanums.contains(String(flipped[index])) {
                    
                    let end_alphanums_index = confirmed_product_name.index(confirmed_product_name.startIndex, offsetBy: confirmed_product_name.count - i)
                    confirmed_product_name = String(confirmed_product_name[..<end_alphanums_index])
                    break
                    
                }
            }
            
        } else {
            
            confirmed_product_name = product_name
        }
    }
    
    return [domain, brand_name.capitalized, confirmed_product_name]
    
}


func convertURLToHostname(url: String) -> String {
    
    if url.isEmpty {
        return ""
    } else {
        
        var converted_url = URL(string: url)                                     // e.g. might be https://shop.lululemon.com/p/men-joggers/Abc-Jogger/_/pro ...
        
        var hostname = converted_url?.host ?? url                                // e.g. might be www.shop.lululemon.com or just shop.lululemon.com
        
        if hostname.prefix(4) == "www." {
            
            let removed_www_index = hostname.index(hostname.startIndex, offsetBy: 4)
            let end_index = hostname.index(hostname.startIndex, offsetBy: hostname.count)
            let range = removed_www_index..<end_index
            
            hostname = String(hostname[range])                                              // e.g. should be shop.lululemon.com or lululemon.com
        }
        
        return hostname
    }
}

//func convertURLToPathURL(url: String) -> String {
//    
//    var converted_url = URL(string: url)                                     // e.g. might be https://shop.lululemon.com/p/men-joggers/Abc-Jogger/_/pro ...
//    var pathComponent = converted_url?.lastPathComponent ?? "No Path"
//    
//    var hostname = convertURLToHostname(url: url)
//    
//    let inputChar: Character = "?"
//    
//    if let index_last = pathComponent.firstIndex(of: inputChar) {                       // get index of the ?param1=abc
//        
//        pathComponent = String(pathComponent[..<index_last])
//        
//    }
//    
//    return hostname + pathComponent
//}

func getLivePath(url: String) -> String {
    
    if url != "" {
        let live_path:String = convertURLToPathURL(url: url)
        let live_path_formatted:String = live_path.replacingOccurrences(of: "/", with: "\\", options: NSString.CompareOptions.literal, range:nil)
        
//        if let f = live_path_formatted.last {
//            if f ==
//        }
        
        return live_path_formatted
    } else {
        return ""
    }
}

func getLiveUserTimestamp(users_vm: UsersVM, temp_live_id: String) -> String {
    if users_vm.one_user.user_id != "" {
        return users_vm.one_user.user_id + "<>" + String(getTimestamp())
    } else {
        return temp_live_id + "<>" + String(getTimestamp())
    }
}


func filterNonLiveUsers(userTimestamps: [String]) -> [[String]] {
    
    let tstamp = getTimestamp()
    var stillLiveTimestamps:[String] = []
    var stillLiveUserIDs:[String] = []
    
    userTimestamps.forEach { ut in                      // loop thru the user_timestamps
        
        let temp = ut.components(separatedBy: "<>")
        
        if temp.count == 2 {                            // confirm it was split by a <>
            if let temp_int = Int(temp[1]) {            // grab the second value (the timestamp)
                if temp_int > tstamp - 300 {            // check if timestamp is greater than (more recent than) 5 min ago
                    stillLiveTimestamps.append(ut)                // if so, add it to the array
                    stillLiveUserIDs.append(temp[0])
                }
            }
        }
    }
    return [stillLiveUserIDs, stillLiveTimestamps]
}


func getURLPrefix(url: String) -> String {
    
    var hostname = convertURLToHostname(url: url)           // grab hostname like shop.lululemon.com
    
    let index = url.range(of: hostname)!.lowerBound         // find the start index of the hostname in the full url
    
    var prefix = url[..<index]                   // grab the beginning of the url (https://www.)
    
    return String(prefix)
    
}


func convertURLToPathURL(url: String) -> String {
    
    var hostname = convertURLToHostname(url: url)           // grab hostname like shop.lululemon.com
    
    if hostname.isEmpty {
        return ""
    } else if hostname.contains("youtube") {
        
        let index = url.range(of: hostname)!.lowerBound         // find the start index of the hostname in the full url
        
        var hostname_and_path = url[index...]                   // remove the beginning of the url (https://www.)
        
        let inputChar: Character = "&"                          // find any & that's in the url
        
        if let index_last = hostname_and_path.firstIndex(of: inputChar) {                       // get index of the ?param1=abc
            
            hostname_and_path = hostname_and_path[..<index_last]
            
        }
        
        return String(hostname_and_path)
        
    } else {
        
        let index = url.range(of: hostname)!.lowerBound         // find the start index of the hostname in the full url
        
        var hostname_and_path = url[index...]                   // remove the beginning of the url (https://www.)
        
        let inputChar: Character = "?"                          // find any ? that's in the url
        
        if let index_last = hostname_and_path.firstIndex(of: inputChar) {                       // get index of the ?param1=abc
            
            hostname_and_path = hostname_and_path[..<index_last]
            
        }
        
        // CHECK FOR A TRAILING SLASH
        if let s = hostname_and_path.last {
            
            if s == "/" {
                hostname_and_path.removeLast()
            }
        }
        
        return String(hostname_and_path)
    }
}






//MARK: TO BE DELETED -----------
func convertMyReferralCodeSubtitle(commission_type: String, commission_value: String, offer_type: String, offer_value: String) -> [Any] {
    
    let icon:String = getIconForReferralSubtitles(type: commission_type, value: commission_value)[0] as! String
    let icon_color:Color = getIconForReferralSubtitles(type: commission_type, value: commission_value)[1] as? Color ?? Color.black
    let commission_string:String = getIconForReferralSubtitles(type: commission_type, value: commission_value)[2] as! String
    
    let offer_icon:String = getIconForReferralSubtitles(type: offer_type, value: offer_value)[0] as! String
    let offer_icon_color:Color = getIconForReferralSubtitles(type: offer_type, value: offer_value)[1] as? Color ?? Color.black
    let offer_string:String = getIconForReferralSubtitles(type: offer_type, value: offer_value)[3] as! String
    
    return [icon, icon_color, commission_string, offer_icon, offer_icon_color, offer_string]
}

func getIconForReferralSubtitles(type: String, value: String) -> [Any] {
    
    switch type {
    case "Cash":
        return ["banknote", Color.green, "Get $\(value)", "Give $\(value)"]
    case "Gift Card":
        return ["giftcard", Color.orange, "Get $\(value)", "Give $\(value)"]
    case "Discount ($)":
        return ["dollarsign.square", Color.indigo, "Get $\(value)", "Give $\(value)"]
    case "Discount (%)":
        return ["percent", Color.blue, "Get \(value)%", "Give \(value)%"]
    case "Points":
        return ["circle", Color.yellow, "Get \(value) pts", "Give \(value) pts"]
    default:
        return ["", Color.gray, "", ""]
        
    }
}
