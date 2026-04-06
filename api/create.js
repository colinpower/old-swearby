import admin from "firebase-admin";

// Receive the object as { post: { } }
export async function create_post(o) {

    const p = o.post;

    var post = {
        "_ID": p._ID,
        "_STATUS": p._STATUS,
        "access": {
            "group": p.access.group,
            "list": (p.access.list == null) ? [] : p.access.list,
            "is_private_account": p.access.is_private_account
        },
        "image_url": p.image_url,
        "isSwornBy": p.isSwornBy,
        "likes": [],
        "override_url": p.override_url,
        "photo": (p.photos == null) ? [] : p.photos,
        "poll": {
            "prompt": p.poll.prompt,
            "text1": p.poll.text1,
            "text2": p.poll.text2,
            "text3": p.poll.text3,
            "text4": p.poll.text4,
            "votes1": (p.poll.prompt == "") ? [] : p.poll.votes1,
            "votes2": (p.poll.prompt == "") ? [] : p.poll.votes2,
            "votes3": (p.poll.prompt == "") ? [] : p.poll.votes3,
            "votes4": (p.poll.prompt == "") ? [] : p.poll.votes4,
            "expiration": p.poll.expiration
        },
        "referral": {
            "code": p.referral.code,
            "link": p.referral.link,
            "commission_value": p.referral.commission_value,
            "commission_type": p.referral.commission_type,
            "offer_value": p.referral.offer_value,
            "offer_type": p.referral.offer_type,
            "for_new_customers_only": p.referral.for_new_customers_only,
            "minimum_spend": p.referral.minimum_spend,
            "expiration": p.referral.expiration
        },
        "replies": [],
        "title": p.title,
        "text": p.text,
        "timestamp": {
            "created": p.timestamp.created,
            "deleted": p.timestamp.deleted,
            "archived": p.timestamp.archived,
            "expired": p.timestamp.expired,
            "updated": p.timestamp.updated
        },
        "url": {
            "host": p.url.host,
            "path": p.url.path,
            "prefix": p.url.prefix,
            "full": p.url.full,
            "original": p.url.original,
            "type": p.url.type,
            "page_title": p.url.page_title,
            "site_title": p.url.site_title,
            "site_favicon": p.url.site_favicon,
            "site_id": p.url.site_id
        },
        "user": {
            "_ID": p.user._ID,
            "name": {
                "first": p.user.name.first,
                "last": p.user.name.last,
                "first_last": p.user.name.first_last
            },
            "email": p.user.email,
            "phone": p.user.phone
        }
    };

    return admin.firestore().collection("posts").doc(p._ID).set(post);
};




// Receive the object as { reply: { } }
export async function create_reply(o) {

    const r = o.reply;

    var reply = {
        "product": {
            "name": o.shareViewProduct.name,
            "url": o.shareViewProduct.url,
            "image": o.shareViewProduct.image,
            "brand": {
                "icon": o.shareViewProduct.brand.icon,
                "name": o.shareViewProduct.brand.name,
                "url": o.shareViewProduct.brand.url
            }
        }
    };

    return admin.firestore().collection("replies").doc(r._ID).set(reply);
};