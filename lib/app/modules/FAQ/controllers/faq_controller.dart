import 'package:get/get.dart';

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class FAQSection {
  final String title;
  final List<FAQItem> items;

  FAQSection({required this.title, required this.items});
}

class FaqController extends GetxController {
  final faqSections = <FAQSection>[
    FAQSection(
      title: 'Tentang Aplikasi',
      items: [
        FAQItem(
          question: 'Apa itu SmartStorage?',
          answer:
              'SmartStorage adalah aplikasi pencatat bahan makanan yang ada di kulkas. Aplikasi ini membantu kamu mengelola stok makanan, mengingatkan masa kedaluwarsa, dan merekomendasikan resep sesuai bahan yang tersedia.',
        ),
        FAQItem(
          question: 'Siapa yang bisa menggunakan aplikasi ini?',
          answer:
              'Aplikasi ini cocok untuk siapa saja, mulai dari mahasiswa, ibu rumah tangga, hingga pekerja sibuk yang ingin mengatur bahan makanan dengan lebih efisien.',
        ),
        FAQItem(
          question: 'Apakah aplikasi ini gratis?',
          answer:
              'Ya, SmartStorage bisa digunakan secara gratis. Namun, beberapa fitur lanjutan mungkin akan tersedia dalam versi premium di masa depan.',
        ),
      ],
    ),
    FAQSection(
      title: 'Penggunaan Dasar',
      items: [
        FAQItem(
          question: 'Bagaimana cara menambahkan bahan makanan?',
          answer:
              'Kamu bisa menambahkan bahan makanan secara manual melalui tombol “+” dan mengisi nama bahan, jumlah, dan tanggal kedaluwarsa.',
        ),
        FAQItem(
          question: 'Bagaimana cara mengedit atau menghapus item di kulkas?',
          answer:
              'Ketuk item yang ingin diubah, lalu pilih opsi "Edit" untuk memperbarui data, atau "Hapus" untuk menghilangkan dari daftar.',
        ),
        FAQItem(
          question:
              'Bagaimana cara melihat bahan yang akan segera kedaluwarsa?',
          answer:
              'Di bagian "My Fridge", bahan makanan akan diberi label seperti “Expiring Soon” atau “Expired” secara otomatis berdasarkan tanggal kedaluwarsa yang kamu input.',
        ),
      ],
    ),
    FAQSection(
      title: 'Fitur Deteksi & Notifikasi',
      items: [
        FAQItem(
          question: 'Bagaimana sistem mendeteksi bahan makanan?',
          answer:
              'Saat ini sistem menggunakan input manual oleh pengguna. Fitur deteksi otomatis berbasis kamera akan dikembangkan di masa depan.',
        ),
        FAQItem(
          question: 'Apakah saya bisa input bahan secara manual?',
          answer:
              'Ya, tentu! Cukup tekan tombol tambah, lalu masukkan nama bahan, jumlah, dan tanggal kedaluwarsa.',
        ),
        FAQItem(
          question:
              'Kapan saya akan mendapat notifikasi bahan yang kedaluwarsa?',
          answer:
              'Aplikasi akan mengirimkan notifikasi otomatis H-2 dan H-1 sebelum bahan kadaluarsa, serta pada hari kadaluarsa.',
        ),
      ],
    ),
    FAQSection(
      title: 'Rekomendasi Resep',
      items: [
        FAQItem(
          question: 'Bagaimana cara kerja fitur rekomendasi resep?',
          answer:
              'Fitur ini menyarankan resep berdasarkan bahan yang tersedia di kulkas kamu. Semakin lengkap data kulkasmu, semakin akurat rekomendasinya.',
        ),
        FAQItem(
          question:
              'Apakah resepnya menyesuaikan dengan bahan yang saya miliki?',
          answer:
              'Ya, sistem hanya menampilkan resep yang bisa dibuat dengan bahan-bahan yang tersedia (atau hampir tersedia).',
        ),
        FAQItem(
          question: 'Apakah saya bisa menyimpan resep favorit?',
          answer:
              'Bisa. Cukup tekan ikon hati (♥) pada resep yang kamu suka untuk menyimpannya ke daftar favorit.',
        ),
      ],
    ),
    FAQSection(
      title: 'Keamanan & Data',
      items: [
        FAQItem(
          question: 'Apakah data saya aman?',
          answer:
              'Ya. Data disimpan secara lokal atau di server aman sesuai standar privasi dan tidak dibagikan ke pihak ketiga.',
        ),
        FAQItem(
          question: 'Apakah aplikasi ini menyimpan informasi pribadi?',
          answer:
              'Hanya informasi dasar seperti nama dan email (jika login). Kami tidak menyimpan data sensitif tanpa izin kamu.',
        ),
        FAQItem(
          question:
              'Apakah saya perlu koneksi internet untuk menggunakan aplikasi ini?',
          answer:
              'Tidak selalu. Kamu bisa mengelola stok kulkas secara offline. Namun, fitur seperti sinkronisasi dan rekomendasi resep butuh internet.',
        ),
      ],
    ),
    FAQSection(
      title: 'Akun & Pengaturan',
      items: [
        FAQItem(
          question: 'Apakah saya perlu login untuk menggunakan aplikasi?',
          answer:
              'Tidak wajib. Namun login memungkinkan kamu menyimpan data ke cloud dan sinkronisasi antar perangkat.',
        ),
        FAQItem(
          question: 'Bagaimana cara mengganti bahasa aplikasi?',
          answer:
              'Masuk ke menu Pengaturan > Bahasa, lalu pilih bahasa yang diinginkan.',
        ),
        FAQItem(
          question: 'Bagaimana cara keluar (logout) dari akun?',
          answer: 'Buka icon Profile lalu klik tombol yang bertuliskan logout',
        ),
      ],
    ),
  ].obs;
}
