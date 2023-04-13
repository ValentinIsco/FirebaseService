import 'package:cloud_firestore/cloud_firestore.dart';

/* -------------------------------------------------------------------------- */
/*                               FirebaseService                              */
/* -------------------------------------------------------------------------- */

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference<Map<String, dynamic>> _collection;

  FirebaseService({required String collection}) {
    _collection = _db.collection(collection);
  }

  /* ----------------------------- Getter / Setter ---------------------------- */

  CollectionReference<Map<String, dynamic>> get collection => _collection;
  Stream<QuerySnapshot<Map<String, dynamic>>> get snapshots =>
      _collection.snapshots();

  /* --------------------- Ajout/Modification/Suppression --------------------- */

  /// Ajoute un document à la collection.
  void add(object) => _collection.add(object.toFirestore());

  /// Modifie un document à la collection.
  void update(object) =>
      _collection.doc(object.id).update(object.toFirestore());

  /// Supprime un document à la collection.
  void delete(String doc) => _collection.doc(doc).delete();

  /* ------------------------------ Récupération ------------------------------ */

  /// Retourne tout les documents de la collection.
  Future<List<Map<String, dynamic>>> fetchAll() => getList(_collection.get());

  /// Retourne un document de la collection.
  Future<Map<String, dynamic>> fetch(String doc) =>
      _collection.doc(doc).get().then((DocumentSnapshot doc) => _setId(doc));

  /* --------------------------- Méthodes Publiques --------------------------- */

  /// Retourne une liste de documents.
  Future<List<Map<String, dynamic>>> getList(
      Future<QuerySnapshot<Map<String, dynamic>>> data) {
    final List<Map<String, dynamic>> list = [];
    return data.then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = _setId(docSnapshot);
        list.add(data);
      }
      return list;
    });
  }

  /* ---------------------------- Méthodes Privées ---------------------------- */

  /// Ajoute l'id du document.
  Map<String, dynamic> _setId(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id.toString();
    return data;
  }
}
