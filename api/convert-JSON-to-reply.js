import admin from "firebase-admin";

export async function convertJSONtoReply(o) {

    // JSON will come in { "reply": { ... }, "user_id": "..." }

    var new_reply = {
        "_ID": o.post._ID        
    };

    return new_reply;
};