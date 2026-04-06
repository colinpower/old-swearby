import admin from "firebase-admin";
import functions from "firebase-functions";
import dotenv from "dotenv";
import apn from "apn";
import { getUser, getDMGroup } from "./helpers/firestore-helper.js"

// Config
dotenv.config();

var options = {
    token: {
      key: process.env.APNS_KEY,
      keyId: process.env.KEY_ID,
      teamId: process.env.TEAM_ID
    },
    production: true
};

// NOTES: 
    // 1. there are different tokens for production and development, so testing in xcode will not allow noti's to fire (unless you set apns to development)
    // 2. apnProvider needs to be shut down at the end of each usage

// Need to send notifications for:
    
    // 1. New friend request
    // 2. Friend accepted request
    
    // 3. New message in group        // DONE
    // 4. New post in group           // DONE
    // 5. New request in group        // DONE
    // 6. New code in group           // DONE
    // 7. New product in group        // TODO: NOT YET STARTED... MUST SUPPORT!
                                // "Kristen DM'd you a product from Sephora"
                                // "Kristen sent a product from Sephora to JOCK"

    // 7. New comment on your post      // DONE
    // 8. New comment on your request   // DONE
    // 9. New reply to your comment     // DONE
    
    // 10. Someone liked your comment   // TODO: NOT YET STARTED...
    // 11. Someone liked your message   // TODO: NOT YET STARTED...  


const sendChatNotification = functions.firestore
  .document('messages/{doc_id}')
  .onCreate(async (snap, context) => {

    const doc = snap.data();

    // Message Info
    const sender_name = doc.user.name.first;    // "John"
    const sender_id = doc.user._ID;             // UUID123
    const text = doc.text;                      // "Hey what's up?"
    const msg_type = doc.linked_to.type;        // REQUEST, POST, "", CODE, PRODUCT   (if empty, it's a message)
    
    // Get Group
    const group_id = doc.access.group;          // UUID123 or UUID123<DM>UUID456    (Note: NEVER will be "Friends")
    const group_doc = await getDMGroup(group_id);

    // Group Info 
    const group_name = group_doc.name;                                    // No name if DM. Else "John and Jane"    
    const is_dm = group_id.includes("<DM>");                              // true or false
    const group_member_ids = group_doc.member_ids;                        // [user_id1, user_id2, ...]

    
    // Create notification
    var apnProvider = new apn.Provider(options);
    let notification = new apn.Notification();

    // Notification Info                                                  // REMOVED SUBTITLE: notification.subtitle = noti_subtitle;
    notification.title = "SwearBy";
    notification.body = createNotificationBody(msg_type, is_dm, sender_name, group_name, text);
    notification.badge = 1;                                            // TODO: Increment badge count by 1  
    notification.topic = "UncommonInc.SwearBy";


    // Get device tokens for each member of the chat
    var deviceTokens = [];

    for (let i = 0; i < group_member_ids.length; i++) {

        // Ignore if the user is the sender
        if ((group_member_ids[i] == sender_id)) { 
            console.log("IGNORING THIS USER ID: " + group_member_ids[i] + " BECAUSE IT'S THE SAME AS THE SENDER ID: " + sender_id);
            continue; 
        }
        
        // Get user's device token and send message
        var user_doc = await getUser(group_member_ids[i])
        
        if (user_doc == null) {
            console.log("USER IS NULL");
            continue;
        } else {

            console.log("FOUND A USER")
            console.log(user_doc);

            if ((user_doc.device_token != "") && (user_doc.device_token != "NO_DEVICE_TOKEN")) {

                deviceTokens.push(user_doc.device_token.toString());

            } else {
                console.log("NO DEVICE TOKEN FOUND FOR THIS USER");
                continue;
            }
        }
    };

    //console.log("found this user's device token: " + user_doc.device_token.toString());
    //let device_token = user_doc.device_token.toString();

    const result = await apnProvider.send(notification, deviceTokens);
    
    console.log("sent:", result.sent.length);
    console.log("sent data:", result.sent);
    console.log("failed:", result.failed.length);
    console.log(result.failed);


    // console.log()
    // .then((result) => {
    //     console.log(result.sent);
    //     console.log("SENT TO THIS DEVICE TOKEN");
    //     console.log(device_token);
    //     //return;
    // }).catch((error) => {
    //     console.error(error);
    //     console.log(result.failed);
    //     //return;
    // });


    return apnProvider.shutdown();
    
});

export default sendChatNotification;


// #region createNotificationBody(msg_type, is_dm, sender_name, group_name, text)

const createNotificationBody = (msg_type, is_dm, sender_name, group_name, text) => {

    var noti_body = "";
    var noti_body_suffix = "";

    if (msg_type == "") {                                                       // NOTE: If it's a message
        if (is_dm) {
            noti_body += sender_name + ": " + text;                             // "John: Hey what's up?"
            return noti_body;
        } else {
            noti_body += sender_name + " to " + group_name + ": " + text;       // "John to John and Jane: Hey what's up?"
            return noti_body;
        }
    } else {                                                                    // NOTE: If it's a request, post, code, or product

        if (is_dm) {                                                            
            noti_body += sender_name + " DM'd you ";                             // Start with: "John DM'd you "
        } else {
            noti_body += sender_name + " sent ";                                 // Start with: "John sent "
            noti_body_suffix += " to " + group_name;                             // End with: " to John and Jane"
        }

        if (msg_type == "REQUEST") {
            noti_body += "a request";                                           // "John sent a request"
        } else if (msg_type == "POST") {
            noti_body += "something they swear by";                             // "John sent something they swear by"
        } else if (msg_type == "CODE") {
            noti_body += "a referral code";                                     // "John sent a referral code"
        } else if (msg_type == "PRODUCT") {
            noti_body += "a product";                                           // "John sent a product"
        }
        
        noti_body += noti_body_suffix;                                          // "John sent a request to John and Jane"

        return noti_body;

    }
  
    

};
// #endregion

// #region Unused Sample Code for APNS package


    // var note = new apn.Notification();
    // note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
    // note.badge = 3;
    // note.sound = "ping.aiff";
    // note.alert = "\uD83D\uDCE7 \u2709 You have a new message";
    // note.payload = {'messageFrom': 'John Appleseed'};
    // note.topic = "<your-app-bundle-id>";


    // apnProvider.send(note, deviceToken).then( (result) => {
    //     // see documentation for an explanation of result
    //   });


    // return apnProvider.send(notification, deviceTokens).then((result) => {
    //     console.log(result.sent);
    //     return;
    // }).catch((error) => {
    //     console.error(error);
    //     console.log(result.failed);
    //     return;
    // });

// #endregion