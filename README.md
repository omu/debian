[![CircleCI](https://circleci.com/gh/omu/debian.svg)](https://circleci.com/gh/omu/debian)

Debian
=======

Minimal Debian ve Ubuntu özelleştirme katmanı

Dizin yapısı
------------

Geleneksel UNIX kök dizini ağacından esinlenen bir düzenleme kullanılıyor.

- `bin`: Program kodu

  Doğrudan çalıştırılabilir kod dosyaları; ör. betikler.

- `etc`: Yapılandırmalar

  Uygulama yapılandırma dosyaları; ör. editör ayarları.  Alt dizinler
  uygulamalara göre düzenlenmiştir.

- `lib`: Kitaplık kodu

  Program gibi doğrudan değil kitaplık gibi dolaylı kullanılan kod dosyaları;
  ör. kabuk kitaplıkları.

- `srv`: Servis verileri

  Dışarı sunulan servisler üzerinden tüketilebilecek kod ve veri dosyaları; ör.
  curl + shell ile çalıştırılan betikler, ikili biçimde resim dosyaları.

- `src`: Kaynak dosyalar

  İnşa edildiğinde diğer dizinlerde çıktı üretecek dosyalar; ör. resim
  kaynakları, şablonlar, derlenmeye konu programlama dilleriyle yazılmış kodlar.
