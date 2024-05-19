import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_pendaftaran2/Page/OutputPage.dart';
import 'package:image_picker/image_picker.dart';



class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //masukkan semua variable
  String? _selectedJk;
  String? _selectedProdi;

  //menuliskan semua controller
  TextEditingController controllerNik= new TextEditingController();
  TextEditingController controllerNama= new TextEditingController();

  //list Prodi
  final List<String> _prodiList= [
    'D3 Teknologi Informasi',
    'D3 Manajemen Informatika',
    'D3 Teknik Elektronika',
    'D3 Teknik Telekomunikasi',
    'D3 Teknik Listrik',
    'D3 Teknik Kimia',
    'D3 Teknik Mesin',
    'D3 Teknik Pemeliharaan Pesawat Udara',
    'D3 Teknik Sipil',
    'D3 Teknologi Pertambangan',
    'D3 Teknologi Konstruksi Jalan, Jembatan, dan Bangunan Air',
    'D3 Teknologi Sipil',
    'D3 Akuntansi',
    'D3 Administrasi Bisnis',
    'D4 Teknologi Rekayasa Otomotif',
    'D4 Teknologi Elektronika',
    'D4 Sistem Kelistrikan',
    'D4 Jaringan Telekomunikasi Digital (double degree Msu Malaysia)',
    'D4 Jaringan Telekomunikasi Digital (double degree Sdust China)',
    'D4 Teknologi Kimia Industri',
    'D4 Teknologi Kimia Industri (double degree Sdust China)',
    'D4 Manajemen Rekayasa Konstruksi',
    'D4 Manajemen Rekayasa Konstruksi (double degree Sdust China)',
    'D4 Teknologi Rekayasa Konstruksi Jalan dan Jembatan',
    'D4 Teknik Otomotif Elektronik',
    'D4 Teknik Otomotif Elektronik (double Degree Msu Malaysia)',
    'D4 Teknik Mesin Produksi Dan Perawatan',
    'D4 Teknik Mesin Produksi Dan Perawatan (double Degree Msu Malaysia)',
    'D4 Teknik Mesin Produksi Dan Perawatan (double Degree Sdust China)',
    'D4 Akuntansi Manajemen',
    'D4 Keuangan',
    'D4 Akuntansi Manajemen (double Degree Msu Malaysia)',
    'D4 Manajemen Pemasaran',
    'D4 Manajemen Pemasaran (double Degree Msu Malaysia)',
    'D4 Pengelolaan Arsip Dan Rekaman Informasi',
    'D4 Usaha Perjalanan Wisata',
    'D4 Bahasa Inggris Untuk Komunikasi Bisnis Dan Profesional',
    'D4 Bahasa Inggris Untuk Industri Pariwisata',
    'D4 Akuntansi Manajemen',
    'Magister Terapan Teknik Elektro',
    'Magister Terapan Rekayasa Teknologi Manufaktur',
    'Magister Terapan Sistem Informasi Akuntansi',
  ];

  //deklarasi file foto
  File? _selectedGambar;

  Future <String>_pickGambar() async {
    final returnedGambar= await ImagePicker().pickImage(source: ImageSource.gallery);
    if(returnedGambar!= null){
      setState(() {
        _selectedGambar = File(returnedGambar.path);
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Gambar Terpilih'),
              content: Text('Nama gambar terpilih: $returnedGambar'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: (){
                    Navigator.of(context).pop(); //menutup alert dialog
                  }, 
                  ),
              ],
            );
          },
        );
      });
      return returnedGambar.path.split('/').last;
    }
    return '';
  }
  //radiobutton Jk
  void _pilihJk(String? value){
    setState(() {
      _selectedJk= value;
    });
  }
  //kirim data
  void kirimData() async{
    int parseNik= int.tryParse(controllerNik.text)?? 0;
    if(
      controllerNik.text.isEmpty||
      controllerNama.text.isEmpty||
      _selectedJk == null||
      _selectedProdi == null||
      _selectedGambar== null
      ) { //cek jika ada yang kosong
      showDialog(
        context: context, 
        builder: (BuildContext context){
          return AlertDialog( //alertdialog/warning dialog
            title: Text('Error'),
            content: Text('Isi semua bagian yang dibutuhkan'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: (){
                  Navigator.of(context).pop(); //tutup alert dialog
                },
              ),
            ],
          );
        },
      );
    }
    else{
      final imagePath= _selectedGambar?.path ??'';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OutputPage(
            nik: controllerNik.text,
            nama: controllerNama.text,
            jk: _selectedJk ?? '',
            prodi: _selectedProdi ?? '',
            imagePath: imagePath,
            onOkPressed: (){
              _resetForm();
            },
          ),
        ),
      );
    }
  }

  //tombol reset
  void _resetForm(){
    setState(() {
      //Reset semua
      controllerNama.clear();
      controllerNik.clear();
      //Reset state variable
      _selectedJk= null;
      _selectedProdi= null;
      //Hilangkan gambar
      _selectedGambar = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.list),
          title: Text('Form Pendaftaran Mahasiswa Baru', style: TextStyle(fontSize: 16),),
          backgroundColor: Colors.blue,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //NIK
                  Text('NIK'),
                  TextField(
                    controller: controllerNik,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16)
                    ],
                    decoration: InputDecoration(
                      hintText: 'Masukkan 16 digit NIK',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top: 20)),
                  //Nama Calon
                  Text('Nama Calon Mahasiswa'),
                  TextField(
                    controller: controllerNama,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama lengkap',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(top: 20)),
                  //Jk
                  Text('Jenis Kelamin'),
                  RadioListTile<String>(
                    value: 'Laki-laki', 
                    title: Text('Laki-laki'),
                    groupValue: _selectedJk, 
                    onChanged: (value) => _pilihJk(value),
                  ),
                  RadioListTile<String>(
                    value: 'Perempuan', 
                    title: Text('Perempuan'),
                    groupValue: _selectedJk, 
                    onChanged: (value) => _pilihJk(value),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  //Prodi
                  Text('Program Studi'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedProdi,
                    hint: Text('Pilih Program Studi'),
                    items: _prodiList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue){
                      setState(() {
                        _selectedProdi= newValue;
                      });
                    }
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  MaterialButton(
                    color: Colors.blue,
                    child: Text(
                      'Pilih gambar',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      _pickGambar();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(  //tombol kirim
                        onPressed: (){
                          kirimData();
                        }, 
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        child: Text('Kirim'),
                      ),
                      ElevatedButton( //tombol reset
                        onPressed: (){
                          _resetForm();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                ],
              )
            ),
          ],
        ),
      );

  }
}
