import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradetitan/data/bucket_data.dart';
import 'package:tradetitan/domain/bucket.dart';

class FirestoreService {
  final CollectionReference _bucketsCollection =
      FirebaseFirestore.instance.collection('buckets');

  Future<void> uploadInitialData() async {
    final snapshot = await _bucketsCollection.limit(1).get();
    if (snapshot.docs.isEmpty) {
      for (final bucket in initialBuckets) {
        await _bucketsCollection.add(bucket.toDocument());
      }
    }
  }

  Future<void> addBucket(Bucket bucket) {
    return _bucketsCollection.add(bucket.toDocument());
  }

  Stream<List<Bucket>> getBuckets() {
    return _bucketsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Bucket.fromSnapshot(doc)).toList();
    });
  }

  Future<void> updateBucket(Bucket bucket) {
    return _bucketsCollection.doc(bucket.id).update(bucket.toDocument());
  }

  Future<void> deleteBucket(String bucketId) {
    return _bucketsCollection.doc(bucketId).delete();
  }
}
