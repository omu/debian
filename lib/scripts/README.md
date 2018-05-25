Betikler
========

Kategoriler
-----------

#### `_`

Bu betikler Debian tabanlı herhangi bir sistemde kullanılabilecek düşük
bağımlılıklı provizyonlama betikleridir (ör. CI servisleri).  Sadece şu kabuller
yapılmıştır:

- Debian tabanlı

- Bash kurulu

Betiğin çalıştığı sistemde başka bir kabul yapılmaz.  Örneğin sistem minimal
olabilir.  Bir programı daima önce varlığını denetleyerek ve yoksa ilgili paketi
kurarak çalıştırıyoruz.

#### `base`

Tüm kategorilerde anlamlı taban provizyonlama betikleri.  Bu kategoride şu
özellikte betikler **bulunmamalı**:

- Grafik ortam gerektiren paket ve eylemler (`desktop` kategorisi kullanılmalı)

- Sunucular için anlamlı eylemler, örneğin bir servis kurulumu (`server`
  kategorisi kullanılmalı)

- Geliştirme ortamları (duruma göre `development` veya `desktop` kategorisi
  kullanılmalı)

#### `server`

Sunucu makinelerde anlamlı provizyonlama betikleri.  Çoğunlukla servis kurulumu
ve yapılandırmalarından oluşur.  Grafik ortam gerektiren paket ve eylemler bu
kategoride **bulunmamalı**.  Sadece sunucular için değil her makine için geçerli
olan provizyonlama betikleri de bu kategoriye değil `base` veya `development`
kategorisine konulmalı.

#### `runtime`

Çeşitli dil ve uygulama çatıları için gerekli çalışma zamanı ortamlarını kuran
ve yapılandıran provizyonlama betikleri.

#### `desktop`

Masaüstü (grafik ortam) geliştirici makinelerinde anlamlı provizyonlama
betikleri.  Provizyonlamanın grafik ortam gerektirmesi bir ölçüdür, fakat tek
ölçü değildir.  Geliştirici makinelerinde kurulması istenebilecek GUI
gerektirmeyen bazı programlar da, ör. vagrant, bu kategoriye konulmalı.

#### `development`

Çeşitli geliştirme ortamlarını kuran ve yapılandıran provizyonlama betikleri.
Çalışma zamanı (`runtime`) kuran betikler bu kategoride **bulunmamalıdır**.

Kurallar
--------

- Betikleri (aptallık derecesinde) basit tut.

- Bir önceki kural ihlal edilmemek kaydıyla betikleri elden geldiğince
  idempotent yap.

- Betikler `bin` ve `sbin` dizinlerindeki yardımcıları kullanabilir.

- Servisleri kurulumdan sonra etkisizleştir (Debian ve türevi dağıtımlarda
  servis içeren bir paket kurulduğunda öntanımlı olarak servis etkinleştirilir).
