import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { FieldValue } from '@google-cloud/firestore';


admin.initializeApp(
    functions.config().firebase
);


const db = admin.firestore();
const fcm = admin.messaging();



export const sendAccountInformationChangeNotification = functions.firestore
    .document('users/{userId}/sent_notifications/{notification}')
    .onCreate(async (snapshot, context) => {

        console.log("sendAccountInformationChangeNotification() Called");


        const userId = snapshot.get('userId');
        const userName = snapshot.get('userName');
        const accountName = snapshot.get('accountName');
        const newAccount = snapshot.get('newAccount');
        const followedBy: string[] = snapshot.get('followedBy');
        console.log(`userId:      ${userId}`);
        console.log(`userName:    ${userName}`);
        console.log(`accountName: ${accountName}`);
        console.log(`newAccount:  ${newAccount}`);
        console.log(`followedBy:  ${followedBy}`);


        const usersToNotifyFuture: Promise<FirebaseFirestore.DocumentSnapshot<FirebaseFirestore.DocumentData>>[]
            = followedBy.map((id, _) => db.collection('users').doc(id).get())

        console.log(`usersToNotifyFuture:  ${usersToNotifyFuture.length}`);
        const usersData: FirebaseFirestore.DocumentSnapshot<FirebaseFirestore.DocumentData>[] = await Promise.all(usersToNotifyFuture);
        console.log(`usersData:  ${usersData}`);

        usersData.forEach(userDoc => {
            console.log(`SENDING NOTIFICATION TO ${userDoc.get('name') ?? userDoc.get('username')}`);
            const tokens: string[] = userDoc.get('tokens');

            const recieverId = userDoc.id;

            db.collection('users').doc(recieverId).collection('notifications').doc().set({
                'senderId': userId,
                'senderName': userName,
                'message': newAccount ? `${userName} has added ${accountName}` : `${userName} has changed ${accountName} information`,
                'type': 'account',
                'timestamp': FieldValue.serverTimestamp(),
            });


            const notification: admin.messaging.NotificationMessagePayload = {
                title: newAccount ? `New account added` : `Account information updated`,
                body: newAccount ? `${userName} has added ${accountName}` : `${userName} has changed ${accountName} information`,
            }

            const data: admin.messaging.DataMessagePayload = {
                'userId': userDoc.get('userId'),
                'username': userDoc.get('username'),
            }


            const payload: admin.messaging.MessagingPayload = {
                notification: notification,
                data: data
            };

            return fcm.sendToDevice(tokens, payload);

        });


        // const to = snapshot.get("userId");

        // const docSnapshot = await db
        //     .collection('users')
        //     .doc(to).get();
        // const tokens = docSnapshot.get('tokens');

        // const payload = {
        // notification: {
        //     title: "Someone has saved you…",
        //     body: '',
        // },
        // };

        // console.log(tokens);

        // return fcm.sendToDevice(tokens, payload);
    });

