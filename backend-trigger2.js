import { getFirestore } from 'firebase-admin/firestore'
import { getStorage } from 'firebase-admin/storage'
import { getAuth } from 'firebase-admin/auth'
import { onDocumentCreated } from "firebase-functions/v2/firestore";


import dotenv from "dotenv";
import { helper_fixUsers, updatePostsSchema, updateUsersSchema, helper_deleteSpecificPosts, moveUsersToArchive, movePostsToArchive} from "./helpers/firestore-helper2.js";

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


export const backendTrigger2 = onDocumentCreated(
    'backend_trigger2/{doc_id}',
    async (event) => {
        
    const snap = event.data;
    const context = event.context;

    // Get variables
    const doc = snap.data();
    const type = doc.type;

    // Handle scenario
    if (type == "FIX_USERS") {

        // get all posts and update with the product name

        await helper_fixUsers();

        return;

    } else if (type == "UPDATE_POSTS_SCHEMA") {

        await updatePostsSchema();

        return;

    } else if (type == "UPDATE_USERS_SCHEMA") {

        await updateUsersSchema();

        return;

    }
     else if (type == "delete_specific_posts") {


        await helper_deleteSpecificPosts();

        return;

    }

});


//export default backendTrigger2;




// else if (type == "ADD_PRODUCT_NAMES_TO_POSTS") {

//         // get all posts and update with the product name

//         await helper_addPostTitles("LpssRsmHN8e0OqLpXCfOO9i2Y7N2");

//         return;

//     } else if (type == "ADD_FOLLOWER_FOLLOWING_LIST_AND_SOCIAL_HANDLES") {

//         // get all users and update
        
//         await helper_updateFollowersAndSocials("LpssRsmHN8e0OqLpXCfOO9i2Y7N2");
//         helper_addLastNotificationSeenTimestamp
//         return;

//     } else if (type == "ADD_LAST_NOTIFICATION_SEEN_TIMESTAMP") {

//         // get all users and update
        
//         await helper_addLastNotificationSeenTimestamp();
        
//         return;

//     } else if (type == "fix_posts") {

//         // get all users and update
        
//         await helper_fixPosts();
        
//         return;

//     } else if (type == "fix_requests") {

//         // get all users and update
        
//         await helper_fixRequests();
        
//         return;

//     } else if (type == "fix_codes") {

//         // get all users and update
        
//         await helper_fixCodes();
        
//         return;

//     } else if (type == "fix_posts1") {

//         // get all users and update
        
//         await helper_UpdateFOLLOWERS();
        
//         return;

//     } 
//     else if (type == "fix_requests1") {

//         // get all users and update
        
//         await helper_UpdateFOLLOWERS_REQ();
        
//         return;

//     } 
//     else if (type == "fix_codes1") {

//         // get all users and update
        
//         await helper_UpdateFOLLOWERS_CODE();
        
//         return;

//     }
//     else if (type == "req_updateAccessList") {

//         // get all users and update
        
//         await requests_AddFollowersToAccessList();
        
//         return;

//     }
//     else if (type == "code_updateAccessList") {

//         // get all users and update
        
//         await codes_AddFollowersToAccessList();
        
//         return;

//     }
//     else if (type == "post_updateAccessList") {

//         // get all users and update
        
//         await posts_AddFollowersToAccessList();
        
//         return;

//     }