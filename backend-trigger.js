import { getFirestore } from 'firebase-admin/firestore'
import { getStorage } from 'firebase-admin/storage'
import { getAuth } from 'firebase-admin/auth'
import { onDocumentCreated } from "firebase-functions/v2/firestore";

import dotenv from "dotenv";

import { getUser, deleteMyPosts, deleteMyRequests, deleteMyCodes, deleteMyComments, deleteMyMessages, cleanseUserDoc } from "./helpers/firestore-helper.js"

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


export const backendTrigger = onDocumentCreated(
    'backend_trigger/{doc_id}',
    async (event) => {
        
    const snap = event.data;
    const context = event.context;

    // Get variables
    const doc = snap.data();
    const type = doc.type;
    const g_id = doc.group_id;
    const user1 = doc.user1;
    const user2 = doc.user2;

    // Handle scenario
    if (type == "DELETE_ACCOUNT") {
        
        // mark all posts from user "deleted" timestamp and overwrite user info
        await deleteMyPosts(user1);
        await deleteMyRequests(user1);
        await deleteMyCodes(user1);

        // mark all messages from user "deleted user" and overwrite user info
        await deleteMyMessages(user1);

        // mark all comments from user "deleted" timestamp and overwrite user info
        await deleteMyComments(user1);

        // delete profile picture from storage if it exists  
        const storage = getStorage();
        const db = getFirestore();
        const auth = getAuth();
        
        await storage.bucket().file("user/" + user1 + ".png").exists()
            .then((exists) => {
                    if (exists[0]) {
                        console.log("File exists");
                        return storage.bucket().file("user/" + user1 + ".png").delete();
                    } else {
                        console.log("File does not exist");
                    }
                })

        // delete user info from users collection
        const user_doc = await getUser(user1);
        await cleanseUserDoc(user_doc);

        // delete account from auth
        await auth.deleteUser(user1);

        console.log("Deleted user " + user1);
        console.log(user_doc);

        return;

    } 

});

//export default backendTrigger;






// // delete profile picture from storage if it exists
// const storage = getStorage();

// // Create a reference under which you want to list
// const user_png_path = "user/" + user1 + ".png"
// const listRef = ref(storage, user_png_path);

// // Find all the prefixes and items.
// listAll(listRef)
// .then((res) => {
//     // res.prefixes.forEach((folderRef) => {
//     // // All the prefixes under listRef.
//     // // You may call listAll() recursively on them.
//     // });
//     res.items.forEach((itemRef) => {
//         deleteObject(itemRef).then(() => {
//             // File deleted successfully
//             print("DELETED PNG FOR USER");
//           }).catch((error) => {
//             print("ISSUE DELETING PNG");
//           });
//     });
// }).catch((error) => {
//     print(error);
//     print("SOME ERROR OCCURRED");
//     print("OR THERE WAS NO FILE AVAILABLE FOR THIS USER!");
//     // Uh-oh, an error occurred!
// });




// // Check whether a New Friend accepted your pending Friend Request
// const new_friend_user_id = checkForNewFriendUserID(doc_before, doc_after);


// #region sendAcceptedFriendRequestNotification(user1, user2)

        // Accepting friend request means someone moves from:
            // "Friends_Added" -> "Friends_List"
            // i.e. Colin's UUID moves from Catherine's "Friends_Added" to Catherine's "Friends_List"

        // User 2 is the one who sent the request
        // User 1 is the one who accepted it
        // User 2 should get a notification that User 1 accepted their request

// const sendAcceptedFriendRequestNotificationToDeviceToken = (user1_doc, user2_doc) => {

//     const user_receiving_notification_doc = user2_doc;
//     const user_who_accepted_friend_request_doc = user1_doc;

//     if ((user_receiving_notification_doc == null) || (user_who_accepted_friend_request_doc == null)) {
//         console.log("ONE OR BOTH USERS ARE NULL");
//         return "";

//     } else {

//         console.log("FOUND USERS")

//         if ((user_receiving_notification_doc.device_token != "") && (user_receiving_notification_doc.device_token != "NO_DEVICE_TOKEN")) {

//             const device_token = user_receiving_notification_doc.device_token.toString();

//             return device_token;

//         } else {
//             console.log("NO DEVICE TOKEN FOUND FOR THIS USER");
//             return "";
//         }
//     }


// };
// #endregion