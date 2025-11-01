import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradetitan/domain/bucket.dart';

class FirestoreService {
  final CollectionReference _bucketsCollection =
      FirebaseFirestore.instance.collection('buckets');

  Future<void> addBucket(Bucket bucket) {
    return _bucketsCollection.add(bucket.toMap());
  }

  Stream<List<Bucket>> getBuckets() {
    return _bucketsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Bucket.fromSnapshot(doc)).toList();
    });
  }

  Future<void> updateBucket(Bucket bucket) {
    return _bucketsCollection.doc(bucket.id).update(bucket.toMap());
  }

  Future<void> deleteBucket(String bucketId) {
    return _bucketsCollection.doc(bucketId).delete();
  }
}
