import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import messaging
from firebase_functions import pubsub_fn, scheduler_fn
import datetime

# Initialize Firebase Admin SDK
# Ensure your GOOGLE_APPLICATION_CREDENTIALS environment variable is set
# or that you are running in a Firebase environment.
firebase_admin.initialize_app()

db = firestore.client()

@scheduler_fn.on_schedule(schedule="every 5 minutes")
def send_scheduled_notifications(event: scheduler_fn.ScheduledEvent):
    """
    Scheduled function to check for notifications every 5 minutes.
    """
    print("Running send_scheduled_notifications...")
    now = firestore.SERVER_TIMESTAMP # Use server timestamp for consistency

    notifications_ref = db.collection("scheduled_notifications")

    # Query for notifications that are scheduled for now or in the past and haven't been sent
    snapshot = notifications_ref.where("scheduleTime", "<=", now).where("sent", "==", False).get()

    if not snapshot:
        print("No pending scheduled notifications.")
        return

    messages = []
    updates = []

    for doc in snapshot:
        notification_data = doc.to_dict()
        fcm_token = notification_data.get("fcmToken")
        list_name = notification_data.get("listName")
        list_id = notification_data.get("listId")

        if fcm_token:
            message = messaging.Message(
                notification=messaging.Notification(
                    title="Lembrete de Compra!",
                    body=f"Não se esqueça da sua lista de compras: {list_name}",
                ),
                data={
                    "listId": list_id,
                    # Add other data you might need in the app
                },
                token=fcm_token,
            )
            messages.append(message)
            updates.append({"ref": doc.reference, "data": {"sent": True}}) # Mark as sent
        else:
            print(f"FCM Token missing for scheduled notification {doc.id}")
            updates.append({"ref": doc.reference, "data": None}) # Mark for deletion

    if messages:
        try:
            response = messaging.send_all(messages)
            print(f"Successfully sent messages: {response}")

            # Apply updates to Firestore
            batch = db.batch()
            for update_item in updates:
                if update_item["data"] is not None:
                    batch.update(update_item["ref"], update_item["data"])
                else:
                    batch.delete(update_item["ref"])
            batch.commit()

        except Exception as e:
            print(f"Error sending messages: {e}")

    print("Finished send_scheduled_notifications.")
