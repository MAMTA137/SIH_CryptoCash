import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../../main.dart';

class RegisterNew extends StatefulWidget {
  const RegisterNew({super.key});

  @override
  State<RegisterNew> createState() => _RegisterNewState();
}

class _RegisterNewState extends State<RegisterNew> {
  String? _imageUrl;
  void register() async {
    dynamic data = {
      'public_address': "10002XYAZ1023",
      'user_name': "Jitesh",
      'user_image': "something",
      'is_kyc_done': false
    };
    await Supabase.instance.client.from('UserProfile').insert(data);
  }
  final ImagePicker _picker = ImagePicker();
  String? imageUrl;

  Future<void> uploadImage() async {
    try {

      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final File imageFile = File(pickedFile.path);

      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      print("Filename: $fileName",);

      final uploadResponse = await supaBase.storage
          .from('profileImages')
          .upload(fileName, imageFile);

      final String publicUrl = supaBase.storage
          .from('profileImages')
          .getPublicUrl(fileName);

      setState(() {
        imageUrl = publicUrl;
      });
      print('Image uploaded successfully!');
      final result = await Supabase.instance.client
          .from('UserProfile')
          .select('id')
          .eq('public_address', "10002XYAZ")
          .single();

      final userId = result['id'];
      print('User ID: $userId');

      final data = {
        'id': userId,
        'user_image': publicUrl,
      };

      final response = await Supabase.instance.client.from('UserProfile').upsert(data);
      if (response.error == null) {
        print('Image URL inserted/updated in UserProfile successfully!');
      } else {
        print('Error inserting into UserProfile: ${response.error!.message}');
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: register,
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageUrl != null
                ? Image.network(imageUrl!, width: 200,height: 200,)
                : const Text('No image uploaded yet'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadImage,
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
