/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from "firebase-functions";
import { onRequest } from "firebase-functions/https";
import * as logger from "firebase-functions/logger";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { getFirestore } from "firebase-admin/firestore";
import * as admin from "firebase-admin";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

if (!admin.apps.length) {
  admin.initializeApp();
}

// HTTP function to send to a single user across all tokens
export const sendToUser = onRequest(async (req, res) => {
  try {
    const { uid, title, body, data } =
      req.method === "POST" ? req.body : req.query;
    if (!uid || !title || !body) {
      res.status(400).send("Missing uid/title/body");
      return;
    }

    const db = getFirestore();
    const tokensSnap = await db
      .collection("users")
      .doc(String(uid))
      .collection("tokens")
      .get();
    const tokens: string[] = [];
    tokensSnap.forEach((doc) => {
      const t = doc.get("token");
      if (typeof t === "string" && t.length > 0) tokens.push(t);
    });

    if (tokens.length === 0) {
      res.status(200).send({ delivered: 0, pruned: 0 });
      return;
    }

    const message = {
      notification: { title: String(title), body: String(body) },
      data:
        data && typeof data === "object"
          ? (data as Record<string, string>)
          : {},
      tokens,
    } as admin.messaging.MulticastMessage;

    const result = await admin.messaging().sendEachForMulticast(message);

    let pruned = 0;
    const invalidCodes = new Set([
      "messaging/registration-token-not-registered",
      "messaging/invalid-argument",
      "messaging/invalid-registration-token",
    ]);

    const batch = db.batch();
    result.responses.forEach((r, idx) => {
      if (!r.success) {
        const code = (r.error && (r.error as any).code) || "";
        const token = tokens[idx];
        if (invalidCodes.has(code)) {
          const hash = sha256(token);
          const ref = db
            .collection("users")
            .doc(String(uid))
            .collection("tokens")
            .doc(hash);
          batch.delete(ref);
          pruned++;
        }
      }
    });

    if (pruned > 0) {
      await batch.commit();
    }

    res.status(200).send({ delivered: result.successCount, pruned });
  } catch (e) {
    logger.error("sendToUser failed", e);
    res.status(500).send("Internal error");
  }
});

// Scheduled cleanup for stale tokens
export const pruneStaleTokens = onSchedule(
  { schedule: "every 24 hours" },
  async () => {
    const db = getFirestore();
    const cutoff = Date.now() - 90 * 24 * 60 * 60 * 1000; // 90 days
    const usersSnap = await db.collection("users").get();

    for (const userDoc of usersSnap.docs) {
      const tokensRef = userDoc.ref.collection("tokens");
      const tokensSnap = await tokensRef.get();
      const batch = db.batch();
      let hasChanges = false;

      tokensSnap.forEach((doc) => {
        const updatedAt = doc.get("updatedAt");
        const ms = updatedAt?.toMillis?.() ?? 0;
        if (ms && ms < cutoff) {
          batch.delete(doc.ref);
          hasChanges = true;
        }
      });

      if (hasChanges) {
        await batch.commit();
      }
    }
  }
);

function sha256(input: string): string {
  const crypto = require("crypto");
  return crypto.createHash("sha256").update(input).digest("hex");
}
