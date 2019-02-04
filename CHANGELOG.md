## 12 (Şubat 05, 2019)

### İYİLEŞTİRMELER

- Ruby 2.6.1 sürümüne yükselt

### DÜZELTMELER

- runtime/common: PostgreSQL istemcisinin üst geliştiriciden kurulmasını sağla

## 11 (Ocak 20, 2019)

### ÖZELLİKLER

- server/postgresql: PostgreSQL 11 sürümüne yükselt
- runtime/javascript: Nodejs 11.x sürümüne yükselt
- runtime/common: wkhtmltox (eski adıyla wkhtmltopdf) kitaplığını ekle
- virtual/vagrant: Vagrant paylaşılan dizinine /app ile erişilmesini sağla

### İYİLEŞTİRMELER

- Rubian kurulumunu iyileştir
- Tmux aktif pencere rengini belirginleştir

### DÜZELTMELER

- base/network: ifupdown → networkd geçişinin yan etki üretmemesini sağla

## 10 (Ekim 5, 2018)

### ÖZELLİKLER

- Ruby kurulumlarını [rubian](https://rubian.alaturka.io) ile yönet
- runtime/javascript: Nodejs 10.x sürümüne yükselt
- runtime/common: Resim işleme kitaplıkları (libvips ve imagemagick) başta olmak
  üzere, inşa zamanında kullanılan kitaplık ve araçlara yenilerini ekle

### DÜZELTMELER

- Prune işleminin konteynerlerde de yapılabilmesini sağla

## 9 (Eylül 08, 2018)

### DÜZELTMELER

- desktop/avahi: LXC altında Avahi kurulumu için geçici çözüm uygula

## 8 (Ağustos 09, 2018)

### DÜZELTMELER

- Ağ yapılandırmasından sonra bekleme ekle
- bin/scripts: Root denetimini doğru yerde yap

## 7 (Ağustos 08, 2018)

### ÖZELLİKLER

- Port yönlendirmeleri için yeni paket ekle: rinetd

### İYİLEŞTİRMELER

- Açılış başlığında sadece inşa numarasını göster

## 6 (Ağustos 05, 2018)

### ÖZELLİKLER

- Yeni potpuri: paas

  + Dokku tabanlı
  + Kurulu eklentiler: postgres, redis, memcached, letsencrypt, http-auth, redirect, maintenance

### İYİLEŞTİRMELER

- Mysql (MariaDB) kurulumunu iyileştir
- "important" ve "standard" öncelikli paketleri daima kur
- Açılışta aktif fiziksel ağ arayüzlerine ait IP adreslerini görüntüle
- Açılış betiğinin adını kısaca "what" olarak değiştir
- Her sürümün artan bir sayı olduğu daha basit sürümlendirme kullan

## 5 (Temmuz 14, 2018)

### DÜZELTMELER

- SSH bağlantısının olmadığı durumda komut istemini düzelt

## 4 (Temmuz 14, 2018)

### DÜZELTMELER

- Komut istemi temasında komut tamamlama hatasını düzelt

## 3 (Temmuz 13, 2018)

### ÖZELLİKLER

- Yeni paket: ethtool

### DÜZELTMELER

- Ağ testinde yarış durumunu önle

## 2 (Temmuz 12, 2018)

### DÜZELTMELER

- Ağ ayarlarına Ubuntu netplan desteği ekle

## 1 (Temmuz 11, 2018)

İlk resmi sürüm

### ÖZELLİKLER

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
