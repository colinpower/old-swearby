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
    
    // 1. Received friend request               // DONE
    // 2. New Friend accepted your request      // DONE
    
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

    
const sendFriendRequestNotification = functions.firestore
    .document('users/{doc_id}')
    .onUpdate(async (change, context) => {
  
        const doc_before = change.before.data();
        const doc_after = change.after.data();
        
        // Check for a Friend Request you received
        const new_friend_request_user_id = checkForNewFriendRequestUserID(doc_before, doc_after);

        if (new_friend_request_user_id != "") {

            const user_who_sent_request_doc = await getUser(new_friend_request_user_id);
            const user_receiving_notification_doc = await getUser(doc_after.user_id);

            if ((user_who_sent_request_doc == null) || (user_receiving_notification_doc == null)) {
                console.log("ONE OR BOTH USERS ARE NULL");
                return;

            } else {
    
                console.log("FOUND USERS")
    
                if ((user_receiving_notification_doc.device_token != "") && (user_receiving_notification_doc.device_token != "NO_DEVICE_TOKEN")) {
    
                    const device_token = user_receiving_notification_doc.device_token.toString();

                    // Create notification
                    var apnProvider = new apn.Provider(options);
                    let notification = new apn.Notification();

                    // Notification Info                                                  // REMOVED SUBTITLE: notification.subtitle = noti_subtitle;
                    notification.title = "SwearBy";
                    notification.body = user_who_sent_request_doc.name.first + " sent you a friend request";
                    notification.badge = 1;                                            // TODO: Increment badge count by 1  
                    notification.topic = "UncommonInc.SwearBy";

                    // Send Notification
                    const result = await apnProvider.send(notification, device_token);
                    console.log("sent:", result.sent.length);
                    console.log("sent data:", result.sent);
                    console.log("failed:", result.failed.length);
                    console.log(result.failed);

                    // Shutdown
                    return apnProvider.shutdown();

                } else {
                    console.log("NO DEVICE TOKEN FOUND FOR THIS USER");
                    return;
                }
            }

        } else {
            return;
        }
  });
  
export default sendFriendRequestNotification;



// #region checkForNewFriendRequestUserID(doc_before, doc_after)

        // Receiving friend request means someone moves from:
            // NOTHING -> "Friend_Requests"
            // i.e. Colin's UUID appears suddenly in Catherine's "Friend_Requests"

const checkForNewFriendRequestUserID = (doc_before, doc_after) => {

    if (doc_before.friend_requests.length < doc_after.friend_requests.length) {

        const arr1 = doc_before.friend_requests;
        const arr2 = doc_after.friend_requests;

        const difference = arr2.filter(x => !arr1.includes(x));

        console.log("We found a new friend request for this user id: " + difference)

        return difference[0];

    } else {
        return "";
    }
};
// #endregion