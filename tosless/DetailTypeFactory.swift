//
//  DetailTypeFactory.swift
//  tosless
//
//  Created by Joshua Tint on 1/26/24.
//

import Foundation


struct DetailTypeFactory {
    
    static let detailTypes = [
        "121": DetailType(summary: "The terms can change any time without notice", explanation: "The details of this agreement can be changed or updated at any point", concernLevel: .bad(70)),
        "128": DetailType(summary: "Third-party cookies are used for advertising", explanation: "This service uses external cookies for reasons other than statistics or analytics", concernLevel: .bad(70)),
        "146": DetailType(summary: "You agree to defend, indemnify, and hold the service harmless in case of a claim related to your use of the service", explanation: "", concernLevel: .bad(10)),
        "148": DetailType(summary: "You're responsible for the security of your account", explanation: "You are responsible for protecting the confidentiality of your password and for maintaining the security of your account. Any activity occurring under your account is your responsibility, whether authorized by you or not.", concernLevel: .neutral),
        "152": DetailType(summary: "You have to be a certain age to use this service", explanation: "The service is intended for users who are at least a certain age. If you are younger than the age required then you are prohibited from using the service.", concernLevel: .neutral),
        "163": DetailType(summary: "The jurisdiction of the service is given", explanation: "Informatino about where the terms are governed is below.", concernLevel: .neutral),
        "170": DetailType(summary: "You have the right to leave this service at any time", explanation: "You can stop using this service and delete your account whenever you want, whyever you want, quickly and easily.", concernLevel: .good(15)),
        "183": DetailType(summary: "You maintain ownership of your content", explanation: "You own the content you post, and you don't need to waive any moral rights by posting owned content.", concernLevel: .good(50)),
        "188": DetailType(summary: "Your data is given to third parties", explanation: "Your personal data is or may be given to third parties essential to the service’s operation. This could be an external spam detection service for an internet forum.", concernLevel: .bad(35)),
        "193": DetailType(summary: "Your personal data is not sold", explanation: "This service makes an explicit promise not to sell users' \"personal data.\"", concernLevel: .good(25)),
        "195": DetailType(summary: "You can request access, correction and/or deletion of your data", explanation: "Users have the right to access personal data hold by the service, correct it and/or permanently delete it. This usually applies to European Union regulations.", concernLevel: .good(50)),
        "201": DetailType(summary: "Your account can be deleted without a reason or prior notice", explanation: "At any time, your account can be terminated without explanation or warning.", concernLevel: .bad(60)),
        "223": DetailType(summary: "You can opt out of promotional communications", explanation: "You can easily unsubscribe to promotional texts, emails, or other communications.", concernLevel: .good(10)),
        "227": DetailType(summary: "Information is provided about how your personal data is used", explanation: "The Privacy Policy explains the purposes for which data is collected and the way it is processed, used and shared.", concernLevel: .good(30)),
        "228": DetailType(summary: "Information is provided about what kind of data they collect", explanation: "The Privacy Policy describes in detail what kind of data is collected.", concernLevel: .good(30)),
        "233": DetailType(summary: "You are tracked even if you have a DNT header.", explanation: "Services should't track users whose browsers send a DNT header, but this service will regardless.", concernLevel: .neutral),
        "243": DetailType(summary: "Your personal data may be given away as part of a bankruptcy proceeding or other type of financial transaction", explanation: "If the service gets acquired or is involved in a merger, bankruptcy, reorganisation or sale, your personal data may be transferred or sold.", concernLevel: .bad(50)),
        "280": DetailType(summary: "You can't use the service for illegal purposes", explanation: "The user agrees not to commit any unlawful acts through the use of the website, including the posting of illegal content or messaging.", concernLevel: .neutral),
        "286": DetailType(summary: "You use this service at your own risk, 'as is'", explanation: "The service is provided 'as is': the only warranties at work are the ones in the agreement. This service does not provide any guarantees as to its usability or fitness for the users' purposes. Users agree to use it at their own risk, accepting any possible bugs, malfunctions or harm to their devices.", concernLevel: .neutral),
        "287": DetailType(summary: "The service isn't guaranteed to be uninterrupted, timely, secure or error-free", explanation: "The service provider expressly does not claim to provide uninterrupted, timely, secure or error-free service.", concernLevel: .neutral),
        "288": DetailType(summary: "The service isn't guaranteed to be accurate or reliable", explanation: "This service makes no warranty regarding the accuracy or reliability of any information that is given on its website or the results that may be obtained from the use of the service.", concernLevel: .neutral),
        "293": DetailType(summary: "This service has no liability for any damages resulting from any matter relating to the service", explanation: "The service assumes no liability for any damages the user incurs, including tangible (e.g. profits) and intangible losses (e.g. data), resulting from the use or inability to use the service or any other matter relating to the service.", concernLevel: .bad(10)),
        "294": DetailType(summary: "If one part of the agreement is invalid, other parts remain in effect", explanation: "If one part of the terms of service is unenforceable or invalid, that portion will be enforced to the fullest extent permitted by law and the remainder of the TOS will remain valid and in effect.", concernLevel: .neutral),
        "295": DetailType(summary: "Provisions are in effect, even if they're not enforced", explanation: "Even if the service does not or not always enforce all of the rules or provisions contained in its terms, they still apply. Users can at a later time still be held accountable for violating provisions that have not been enforced consistently.", concernLevel: .neutral),
        "323": DetailType(summary: "Tracking technologies are used", explanation: "Tracking technologies (such as web beacons, tracking pixels, device fingerprinting, etc.) are employed on users and/or the service assigns a unique ID to a browser or device to track its behaviour.", concernLevel: .bad(50)),
        "325": DetailType(summary: "Third-party cookies are used for statistics", explanation: "Cookies from third-party statistics or analytics software are used.", concernLevel: .bad(10)),
        "329": DetailType(summary: "The service will notify if the terms change", explanation: "The service may update the terms without notice, but if they significantly change the agreements in a manner that importantly and/or negatively affects the way the service is used, users will be notified.", concernLevel: .neutral),
        "331": DetailType(summary: "There is a date of the last update of the agreements", explanation: "The given text has a date that allows to know when it was last updated.", concernLevel: .neutral),
        "336": DetailType(summary: "Your personal data may be used for marketing purposes", explanation: "The service may use your personal data for marketing, such as sending you personalised offerings.", concernLevel: .bad(0)),
        "375": DetailType(summary: "Blocking first party cookies may limit your ability to use the service", explanation: "If you block first party cookies through your browser or an extension, the service's functionality could be impacted.", concernLevel: .neutral),
        "382": DetailType(summary: "Information is gathered about you through third parties", explanation: "This Service may employ, either identifiable or non-identifiable, data collection from third party sources about you.", concernLevel: .bad(50)),
        "399": DetailType(summary: "Your IP address is collected", explanation: "Your IP address is collected, which can be used to view your approximate location", concernLevel: .bad(10)),
        "403": DetailType(summary: "Using this service implies your consent to these terms", explanation: "Just by continuing to use this service, your agreement to the terms is implied.", concernLevel: .bad(50))
    ]
    
    static func getDetailType(fromLabel label: String) -> DetailType? {
        return detailTypes[label]
    }
}
