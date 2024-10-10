class Userdata {
  final String? id;
  final String? name;
  final String? email;
  final String? image;

  const Userdata({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory Userdata.fromfirestore(Map<String, dynamic> data, String docid) {
    return Userdata(
        id: docid,
        name: data?['name'],
        email: data?['email'],
        image: data?['image']);
  }
}
