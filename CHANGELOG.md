Değişiklik Kayıtları
====================

23 - 2020-12-27
--------------------

### Değişti

- runtime/javascript: Nodejs 15.x sürümüne yükselt
- runtime/ruby: 3.0.0 sürümüne yükselt

22 - 2020-08-27
--------------------

### Değişti

- runtime/common: vips paketlerini 0.8.0 sürümüne yükselt
- runtime/common: wkhtmltox 0.12.16-1 sürümüne yükselt
- runtime/javascript: Nodejs 14.x sürümüne yükselt
- runtime/ruby: 2.7.1 sürümüne yükselt
- server/docker: Kurulacak paket listesini güncelle

21 - 2020-01-14
--------------------

### Değişti

- runtime/common: Manuel vips paketlerini kullan

### Düzeltildi

- virtual/kvm: Misafir eklentisi kurulumunu yeniden yapılandır

20 - 2019-12-26
--------------------

### Değişti

- runtime/ruby: 2.7.0 sürümüne yükselt
- runtime/javascript: Nodejs 13.x sürümüne yükselt
- runtime/common: wkhtmltox buster paketini kur
- runtime/common: Resmi vips paketini kullan

19 - 2019-09-09
--------------------

### Değişti

- runtime/ruby: 2.6.4 sürümüne yükselt

18 - 2019-06-22
--------------------

### Eklendi

- Makine sürümlendirmesinde değişiklik yap
- Makine üretimi verilerini projeye taşı
- etc/git: Git yapılandırması ekle
- development/shell: Kabuk geliştirme desteği ekle
- server, desktop ve ruby potpurilerine Chrome desteği ekle
- runtime/common: Markdown dokümanlarda link denetimi için Liche ekle
- base/common: libarchive-tools paketini ekle

### Değişti

- CHANGELOG için [standart biçim](https://keepachangelog.com/tr-TR/1.0.0/)
  kullan
- bin: Betikleri [zoo alt projesine](https://github.com/alaturka/zoo) taşı
- runtime/ruby: Ruby kurulumunu basitleştir
- runtime/javascript: Nodejs 12.x sürümüne yükselt

### Düzeltildi

- runtime/chrome: Kurulumu düzelt

17 - 2019-03-17
--------------------

### Eklendi

- virtual/kvm: Huawei desteği ekle

### Değişti

- Qemu/KVM terminolojisini düzelt; daima KVM terimini kullan

### Düzeltildi

- server/dokku: Dokku Git LFS uyumsuzluğu için önlem al
- Tüm potpurilerde KVM kurulumunun doğru şekilde çalışmasını sağla

16 - 2019-02-26
--------------------

### Eklendi

- base/common: Git LFS desteği ekle

### Değişti

- bin/app: İyileştir

  + Başlatma hatasını yakala ve yönlendirici ileti görüntüle
  + Ortam değişkenleri için/etc/environment dışında /app/.env dosyasını da
    dikkate al

### Düzeltildi

- runtime/common: libvips kurulumunu düzelt

15 - 2019-02-08
--------------------

### Eklendi

- runtime/chromium: Chrome Driver kurulumu ekle
- Operatör için direnv desteği ekle
- Terminal paylaşımı için ttyd ekle
- Procfile yönetimi için forego ekle
- bin/expose: Lokal servisleri dışarı ekspoze edecek bir araç ekle
- bin/app: Uygulamayı Procfile üzerinden yönetmek için araç ekle

14 - 2019-02-06
--------------------

### Eklendi

- virtual/final: Sanallaştırmanın sonunda kullanılabilecek yeni adım ekle
- Ruby Docker imajlarında operatör betiklerinin bulunmasını sağla

### Düzeltildi

- Ağ yapılandırmasının yol açtığı yan etkileri düzelt.

13 - 2019-02-05
--------------------

### Düzeltildi

- runtime/common: Elle derlenmiş 8.7.4 sürümlü güncel libvips paketini kur

12 - 2019-02-05
--------------------

### Değişti

- Ruby 2.6.1 sürümüne yükselt

### Düzeltildi

- runtime/common: PostgreSQL istemcisinin üst geliştiriciden kurulmasını sağla

11 - 2019-01-20
--------------------

### Eklendi

- server/postgresql: PostgreSQL 11 sürümüne yükselt
- runtime/javascript: Nodejs 11.x sürümüne yükselt
- runtime/common: wkhtmltox (eski adıyla wkhtmltopdf) kitaplığını ekle
- virtual/vagrant: Vagrant paylaşılan dizinine /app ile erişilmesini sağla

### Değişti

- Rubian kurulumunu iyileştir
- Tmux aktif pencere rengini belirginleştir

### Düzeltildi

- base/network: ifupdown → networkd geçişinin yan etki üretmemesini sağla

10 - 2018-10-05
--------------------

### Eklendi

- Ruby kurulumlarını [rubian](https://rubian.alaturka.io) ile yönet
- runtime/javascript: Nodejs 10.x sürümüne yükselt
- runtime/common: Resim işleme kitaplıkları (libvips ve imagemagick) başta olmak
  üzere, inşa zamanında kullanılan kitaplık ve araçlara yenilerini ekle

### Düzeltildi

- Prune işleminin konteynerlerde de yapılabilmesini sağla

9 - 2018-09-08
--------------------

### Düzeltildi

- desktop/avahi: LXC altında Avahi kurulumu için geçici çözüm uygula

8 - 2018-08-09
--------------------

### Düzeltildi

- Ağ yapılandırmasından sonra bekleme ekle
- bin/scripts: Root denetimini doğru yerde yap

7 - 2018-08-08
--------------------

### Eklendi

- Port yönlendirmeleri için yeni paket ekle: rinetd

### Değişti

- Açılış başlığında sadece inşa numarasını göster

6 - 2018-08-05
--------------------

### Eklendi

- Yeni potpuri: paas

  + Dokku tabanlı
  + Kurulu eklentiler: postgres, redis, memcached, letsencrypt, http-auth, redirect, maintenance

### Değişti

- Mysql (MariaDB) kurulumunu iyileştir
- "important" ve "standard" öncelikli paketleri daima kur
- Açılışta aktif fiziksel ağ arayüzlerine ait IP adreslerini görüntüle
- Açılış betiğinin adını kısaca "what" olarak değiştir
- Her sürümün artan bir sayı olduğu daha basit sürümlendirme kullan

5 - 2018-07-14)
--------------------

### Düzeltildi

- SSH bağlantısının olmadığı durumda komut istemini düzelt

4 - 2018-07-14
--------------------

### Düzeltildi

- Komut istemi temasında komut tamamlama hatasını düzelt

3 - 2018-07-13
--------------------

### Eklendi

- Yeni paket: ethtool

### Düzeltildi

- Ağ testinde yarış durumunu önle

2 - 2018-07-12
--------------------

### Düzeltildi

- Ağ ayarlarına Ubuntu netplan desteği ekle

1 - 2018-07-11
--------------------

İlk resmi sürüm

### Eklendi

- Kullanıcı adı ve parola: op/op
- Türkçe için yerelleştirilmiş; fakat sunucularda öntanımlı yerel: `en_US.UTF-8`
- Giriş kabuğu Tmux üzerinde Zsh
- Minimal Zsh, Tmux ve Vim teması
- Girişte minimal karşılama ekranı
- Kurulu servisler öntanımlı olarak etkisiz (disabled)
- Sunucu ağ yapılandırması öntanımlı olarak DHCP
- Öntanımlı ağ yönetimi networkd veya netplan (Ubuntu)
- Sanal makinelerde ilgili misafir araçları hazır
- Ruby yorumlayıcı minimal olarak kurulu
- Alaturka araçlarıyla zenginleştirilmiş
