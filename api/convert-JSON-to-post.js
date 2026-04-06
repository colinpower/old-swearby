import admin from "firebase-admin";

export async function convertJSONtoPost(o) {

    // JSON will come in { "post": { ... }, "user_id": "..." }

    var new_post = {
        "_ID": o.post._ID,
        "_STATUS": o.post._STATUS,
        "access": {
            "group": o.post.access.group,
            "list": o.post.access.list,
            "is_private_account": o.post.access.is_private_account
        },
        "bookmark_IDs": o.post.bookmark_IDs,
        "description": o.post.description,
        "photos": o.post.photos,
        "product_ID": o.post.product_ID,
        "product_hostname": o.post.product_hostname,
        "product_link_clicks": o.post.product_link_clicks,
        "product_name": o.post.product_name,
        "settings": {
            "is_anonymous": o.post.settings.is_anonymous,
        },
        "timestamp": {
            "archived": o.post.timestamp.archived,
            "created": o.post.timestamp.created,
            "deleted": o.post.timestamp.deleted,
            "expired": o.post.timestamp.expired
        },
        "title": o.post.title,
        "user": {
            "_ID": o.post.user._ID,
            "email": o.post.user.email,
            "name": {
                "first": o.post.user.name.first,
                "first_last": o.post.user.name.first_last,
                "last": o.post.user.name.last
            },
            "phone": o.post.user.phone
        }
    };

    return new_post;
};