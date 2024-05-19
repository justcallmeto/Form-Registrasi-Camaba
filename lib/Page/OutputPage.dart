import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class OutputPage extends StatelessWidget {
  final String nik;
  final String nama;
  final String jk;
  final String prodi;
  final String imagePath;
  final VoidCallback onOkPressed;
  var downloadUrl;

  OutputPage({
    required this.nik,
    required this.nama,
    required this.jk,
    required this.prodi,
    required this.imagePath,
    required this.onOkPressed,
  });

  Future _uploadFile() async {
    final storageRef = FirebaseStorage.instance.ref();
    final uploadTask = storageRef.child('fotomhs/${basename(imagePath)}').putFile(File(imagePath));
    downloadUrl = await (await uploadTask).ref.getDownloadURL();
  }

  Future _uploadData() async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('clientform').doc();
    await docRef.set({
      'nik': nik,
      'nama': nama,
      'jk': jk,
      'prodi': prodi,
      'foto': downloadUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Daftar Calon Mahasiswa baru'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(3.0),
                  1: FlexColumnWidth(7.0),
                  2: FlexColumnWidth(4.0),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: _buildTableRows(),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _uploadFile();
                    await _uploadData();
                    Navigator.pop(context, true);
                    onOkPressed();
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      );
  }

  List<TableRow> _buildTableRows() {
    String imageFileName = basename(imagePath);
    return [
      _buildTableRow("NIK: ", nik ?? "-"),
      _buildTableRow("Nama: ", nama ?? "-"),
      _buildTableRow("Jenis Kelamin: ", jk ?? "-"),
      _buildTableRow("Program Studi: ", prodi ?? "-"),
      _buildImageTableRow("Foto", imagePath, imageFileName),
    ];
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Text(label),
        ),
        TableCell(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TableCell(
          child: Container(), // Add an empty container to maintain column count
        ),
      ],
    );
  }

  TableRow _buildImageTableRow(String label, String imagePath, String imageFileName) {
    return TableRow(
      children: [
        TableCell(
          child: Text(label),
        ),
        TableCell(child: Image.file(
          File(imagePath),
          height: 150,
        ),
        ),
        TableCell(
          child: Text(imageFileName),
        ),
      ],
    );
  }
}
