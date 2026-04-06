// import crypto from "crypto-js";

export function getTimestamp() {

    const current_timestamp_milliseconds = new Date().getTime();
    const timestamp = Math.round(current_timestamp_milliseconds / 1000);

    return timestamp;
};

export function convertTimestampToShortDate(timestamp) {

    const date = new Date(timestamp * 1000);
    const month = date.getMonth() + 1;
    const day = date.getDate();

    return `${month} ${day}`;
}

// export function createUUID() {
//     return "10000000-1000-4000-8000-100000000000".replace(/[018]/g, c =>
//       (+c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> +c / 4).toString(16)
//     );
// }