import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  final String feedbackMessage = 'Saran dan kesan Anda telah terkirim. Terima kasih!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan & Kesan'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pesan Kesan - 123210102',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '''
              Pesan:
              Menurut saya dalam mata kuliah TPM pentingnya pemahaman yang mendalam tentang konsep-konsep dasar pemrograman mobile (flutter). Materi yang diajarkan sangat relevan dan membantu dalam memahami bagaimana aplikasi mobile bekerja di berbagai platform. Selain itu, integrasi praktik langsung dalam pembelajaran juga memberikan pengalaman berharga. Melalui tugas-tugas praktis, saya dapat mengimplementasikan apa yang telah dipelajari dalam pengembangan aplikasi nyata.
              
              Kesan:
              Bagi saya mata kuliah ini memberikan pengalaman yang berharga dalam pengembangan aplikasi mobile. Materi yang disampaikan dengan baik, mendalam, dan pendekatan mengajar yang cukup baik memberikan pemahaman yang kuat dalam pemrograman mobile khususnya flutter.
              
              Namun, ada beberapa area yang menurut saya dapat diperbaiki.
                ''',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Saran Perbaikan:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildBulletList([
                'Memberikan waktu lebih banyak untuk pengerjaan proyek',
                'Memberikan penjelasan video rekomendasi belajar',
              ]),
              SizedBox(height: 20),
              Text(
                'Hal yang Harus Dipertahankan:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildBulletList([
                'Pembelajaran yang berbasis studi kasus',
                'Kuis diberitahukan 1 minggu sebelumnya',
                'Adanya tugas dan kuis untuk membantu pemahaman',
                'Sinkronisasi dengan materi praktikum',
              ]),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitFeedback(context);
                },
                child: Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• ', style: TextStyle(fontSize: 16)),
            Expanded(child: Text(item, style: TextStyle(fontSize: 16))),
          ],
        ),
      )).toList(),
    );
  }

  void _submitFeedback(BuildContext context) {
    print('Feedback: $feedbackMessage');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Feedback Terkirim'),
          content: Text(feedbackMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}