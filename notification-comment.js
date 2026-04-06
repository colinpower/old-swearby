import admin from "firebase-admin";
import functions from "firebase-functions";
import dotenv from "dotenv";
import apn from "apn";
import { getUser, getPost, getRequest, getComment } from "./helpers/firestore-helper.js"

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


const sendCommentNotification = functions.firestore
  .document('comments/{doc_id}')
  .onCreate(async (snap, context) => {

    const doc = snap.data();

    // Comment Info
    const sender_name = doc.user.name.first;    // "John"
    const sender_id = doc.user._ID;             // UUID123
    const text = doc.text;                      // "Hey what's up?"

    // Comment Type
    const replying_to_id = doc.linked_to.comment_id;  // UUIDCOMMENT123
    const post_id = doc.linked_to.post_id;      // UUIDPOST123
    const request_id = doc.linked_to.request_id;// UUIDREQUEST123


    // Recipient Device Token & Message Body
    var recipient_device_token = "";
    var noti_body = "";
    

    // Get Device Token & Message Body
    if (replying_to_id != "") {       // If it's a reply
        
        // Get parent comment
        const parent_comment = await getComment(replying_to_id);

        // Get user
        if (parent_comment != null) {
            
            const user_doc = await getUser(parent_comment.user._ID);

            if (user_doc != null) {

                // Get device token if the user isn't the same as the sender
                if (user_doc._ID != sender_id) {

                    recipient_device_token = user_doc.device_token.toString();
                    noti_body = sender_name + " replied to your comment: " + text;

                } else {
                    console.log("REPLYING TO SELF.. DON'T SEND NOTIFICATION")
                    return;
                }

            } else {
                return;
            }

        } else {
            return;
        }

    } else if (post_id != "") {     // If it's a comment on a post
        
        // Get post
        const post_doc = await getPost(post_id);

        // Get user
        if (post_doc != null) {
            
            const user_doc = await getUser(post_doc.user._ID);

            if (user_doc != null) {

                // Get device token if the user isn't the same as the sender
                if (user_doc._ID != sender_id) {

                    recipient_device_token = user_doc.device_token.toString();
                    noti_body = sender_name + " commented on your post: " + text;

                } else {
                    console.log("REPLYING TO OWN POST.. DON'T SEND NOTIFICATION")
                    return;
                }

            } else {
                return;
            }

        } else {
            return;
        }


    } else if (request_id != "") {     // If it's a comment on a request
        
        // Get post
        const request_doc = await getRequest(request_id);

        // Get user
        if (request_doc != null) {
            
            const user_doc = await getUser(request_doc.user._ID);

            if (user_doc != null) {

                // Get device token if the user isn't the same as the sender
                if (user_doc._ID != sender_id) {

                    recipient_device_token = user_doc.device_token.toString();
                    noti_body = sender_name + " commented on your request: " + text;

                } else {
                    console.log("REPLYING TO OWN REQUEST.. DON'T SEND NOTIFICATION")
                    return;
                }

            } else {
                return;
            }

        } else {
            return;
        }


    } else {
        return;
    }
    
    // Create notification
    var apnProvider = new apn.Provider(options);
    let notification = new apn.Notification();

    // Notification Info                                                  // REMOVED SUBTITLE: notification.subtitle = noti_subtitle;
    notification.title = "SwearBy";
    notification.body = noti_body;
    notification.badge = 1;                                            // TODO: Increment badge count by 1  
    notification.topic = "UncommonInc.SwearBy";


    if ((recipient_device_token != "") && (recipient_device_token != "NO_DEVICE_TOKEN")) {

        //let device_token = recipient_device_token           //.toString();

        const result = await apnProvider.send(notification, recipient_device_token);
    
        console.log("sent:", result.sent.length);
        console.log("sent data:", result.sent);
        console.log("failed:", result.failed.length);
        console.log(result.failed);

        return apnProvider.shutdown();

        // apnProvider.send(notification, device_token).then((result) => {
        //     console.log(result.sent);
        //     console.log("SENT COMMENT NOTI TO THIS DEVICE TOKEN");
        //     console.log(device_token);
        //     return;
        // }).catch((error) => {
        //     console.error(error);
        //     console.log(result.failed);
        //     return;
        // });
        
    } else {
        console.log("NO DEVICE TOKEN FOR THIS USER");
        return;
    }
    
});

export default sendCommentNotification;



// // #region createUsersDocument(user)
// const getRecipientForCommentReply() = async (user) => {


//     //create their first loyalty program
//     const object = {
//         device_token: "",
//         email: user.email,
//         email_verified: user.emailVerified,
//         friend_requests: [],
//         friends_list: [],
//         friends_added: [],
//         friends_invited: [],
//         name: {
//             first: "",
//             first_last: "",
//             last: "",
//         },
//         phone: "",
//         phone_verified: false,
//         timestamp: getTimestamp(),
//         user_id: user.uid
//     };

//     return admin.firestore().collection("users").doc(user.uid).set(object);
// };
// // #endregion





// // #region createNotificationBody(msg_type, is_dm, sender_name, group_name, text)

// const createNotificationBody = (msg_type, is_dm, sender_name, group_name, text) => {

//     var noti_body = "";
//     var noti_body_suffix = "";

//     if (msg_type == "") {                                                       // NOTE: If it's a message
//         if (is_dm) {
//             noti_body += sender_name + ": " + text;                             // "John: Hey what's up?"
//         } else {
//             noti_body += sender_name + " to " + group_name + ": " + text;       // "John to John and Jane: Hey what's up?"
//         }
//     } else {                                                                    // NOTE: If it's a request, post, code, or product

//         if (is_dm) {                                                            
//             noti_body += sender_name + " DM'd you ";                             // Start with: "John DM'd you "
//         } else {
//             noti_body += sender_name + " sent ";                                 // Start with: "John sent "
//             noti_body_suffix += " to " + group_name;                             // End with: " to John and Jane"
//         }

//         if (msg_type == "REQUEST") {
//             noti_body += "a request";                                           // "John sent a request"
//         } else if (msg_type == "POST") {
//             noti_body += "something they swear by";                             // "John sent something they swear by"
//         } else if (msg_type == "CODE") {
//             noti_body += "a referral code";                                     // "John sent a referral code"
//         } else if (msg_type == "PRODUCT") {
//             noti_body += "a product";                                           // "John sent a product"
//         }
        
//         noti_body += noti_body_suffix;                                          // "John sent a request to John and Jane"

//     }
  
//     return noti_body;

// };
// // #endregion

// // #region Unused Sample Code for APNS package


//     // var note = new apn.Notification();
//     // note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
//     // note.badge = 3;
//     // note.sound = "ping.aiff";
//     // note.alert = "\uD83D\uDCE7 \u2709 You have a new message";
//     // note.payload = {'messageFrom': 'John Appleseed'};
//     // note.topic = "<your-app-bundle-id>";


//     // apnProvider.send(note, deviceToken).then( (result) => {
//     //     // see documentation for an explanation of result
//     //   });


//     // return apnProvider.send(notification, deviceTokens).then((result) => {
//     //     console.log(result.sent);
//     //     return;
//     // }).catch((error) => {
//     //     console.error(error);
//     //     console.log(result.failed);
//     //     return;
//     // });

// // #endregion