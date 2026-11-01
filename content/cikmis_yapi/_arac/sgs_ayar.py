# -*- coding: utf-8 -*-
import re
FIX = str.maketrans({'Ý': 'İ', 'ý': 'ı', 'Þ': 'Ş', 'þ': 'ş', 'Ð': 'Ğ', 'ð': 'ğ', 'Đ': 'İ', 'đ': 'ı',
                     '­': '', 'ﬁ': 'fi', 'ﬂ': 'fl'})
# alt ders -> (content/mufredat/smmm.yaml ders kodu, ad)
DERS = {
    'FIN': ('FIN', 'Finansal Muhasebe'), 'STD': ('STD', 'Muhasebe Standartları'),
    'MAL': ('MAL', 'Maliyet Muhasebesi'), 'TAB': ('TAB', 'Mali Tablolar Analizi'),
    'DEN': ('DEN', 'Denetim'), 'EKO': ('EKO', 'Ekonomi'), 'MLY': ('MLY', 'Maliye'),
    'MES': ('MES', 'Meslek Hukuku'),
    'IS': ('SHK', 'İş ve Sosyal Güvenlik Hukuku'), 'VER': ('SHK', 'Vergi Hukuku'),
    'TIC': ('SHK', 'Ticaret Hukuku'), 'BOR': ('SHK', 'Borçlar Hukuku'),
    'TUR': ('GKY', 'Türkçe'), 'MAT': ('GKY', 'Matematik'), 'ATA': ('GKY', 'Atatürk İlkeleri ve İnkılap Tarihi'),
    'YD': ('GKY', 'Yabancı Dil (İngilizce)'),
}
KAPAK_ADLARI = [('Finansal Muhasebe', 'FIN'), ('Genel Muhasebe', 'FIN'), ('Muhasebe Standartları', 'STD'),
                ('Maliyet Muhasebesi', 'MAL'), ('Mali Tablolar', 'TAB'), ('Denetim', 'DEN'),
                ('Meslek Hukuku', 'MES'), ('İş ve Sosyal', 'IS'), ('Vergi Hukuku', 'VER'),
                ('Ticaret Hukuku', 'TIC'), ('Borçlar Hukuku', 'BOR')]
KW = {
 'FIN': [r'hesab', r'kayd', r'kayıt', r'yevmiye', r'borçlandır', r'alacaklandır', r'envanter', r'amortisman', r'reeskont',
         r'karşılı', r'senet', r'\b[1-6]\d\d\s+[A-ZÇĞİÖŞÜ]', r'kasa', r'ticari mal', r'kdv', r'temettü',
         r'hisse senedi', r'tahvil', r'stok', r'fifo', r'kapanış', r'muhasebeleştir'],
 'STD': [r'\bTMS\b', r'\bTFRS\b', r'standard', r'gerçeğe uygun değer', r'\bKGK\b', r'BOBİ', r'finansal raporlama', r'kavramsal çerçeve',
         r'geri kazanılabilir', r'değer düşüklüğü', r'net gerçekleşebilir', r'kiralama', r'hasılat', r'UFRS', r'IFRS', r'raporlama dönemi'],
 'MAL': [r'maliyet', r'direkt ilk madde', r'direkt işçilik', r'genel üretim', r'mamul', r'eşdeğer', r'sipariş', r'safha', r'7/A', r'7/B',
         r'\b7[0-9][0-9]\b', r'yan ürün', r'birleşik', r'standart maliyet', r'sapma', r'gider yer', r'dağıtım', r'üretim', r'başabaş', r'katkı pay', r'hammadde'],
 'TAB': [r'oran', r'devir hız', r'cari oran', r'likidite', r'analiz', r'dikey', r'yatay', r'trend', r'nakit akı', r'fon akım',
         r'kaldıraç', r'kârlılı', r'işletme sermayesi', r'asit', r'mali tablo', r'finansal tablo', r'tahsil süre'],
 'DEN': [r'denetim', r'denetç', r'kanıt', r'örnekleme', r'iç kontrol', r'risk', r'görüş', r'\bBDS\b', r'güvence', r'hile',
         r'teftiş', r'çalışma kâğıt', r'önemlilik', r'denetle'],
}
KW.update({
 'EKO': [r'talep', r'\barz', r'esneklik', r'fayda', r'marjinal', r'tekel', r'piyasa', r'enflasyon', r'GSYİH', r'GSMH', r'milli gelir', r'millî gelir',
         r'para politika', r'merkez bankas', r'işsizlik', r'üretim faktör', r'kayıtsızlık', r'tüketici', r'ekonomi', r'firma', r'rekabet',
         r'devalüasyon', r'döviz kuru', r'büyüme', r'para arzı', r'çarpan', r'oligopol', r'monopol', r'resesyon', r'ödemeler dengesi', r'konjonktür'],
 'MLY': [r'kamu harcama', r'vergi yük', r'bütçe', r'kamu gelir', r'maliye politika', r'kamu mal', r'yansıma', r'dışsallık', r'kamu borç',
         r'sayıştay', r'mali yıl', r'kamu', r'maliye', r'vergileme', r'5018', r'devlet', r'vergi ilke', r'artan oranlı', r'transfer harcama', r'vergi teori',
         r'mali kural', r'vergi adaleti', r'laffer'],
 'MES': [r'3568', r'meslek', r'ruhsat', r'staj', r'mali müşavir', r'yeminli', r'TÜRMOB', r'\boda', r'disiplin', r'tasdik', r'serbest muhasebeci',
         r'yemin', r'büro', r'TESMER', r'ücret tarife'],
 'IS': [r'işçi', r'işveren', r'iş sözleşme', r'kıdem', r'ihbar', r'sendika', r'toplu iş', r'grev', r'sigortalı', r'SGK', r'5510', r'4857',
        r'iş kazası', r'yıllık izin', r'emeklilik', r'sosyal güvenlik', r'fazla çalışma', r'çalışma süre', r'meslek hastalığı', r'analık', r'iş kanunu', r'sigorta'],
 'VER': [r'vergi', r'mükellef', r'tarh', r'tebliğ', r'tahakkuk', r'uzlaşma', r'\bVUK\b', r'gelir vergisi', r'kurumlar',
         r'\bKDV\b', r'\bÖTV\b', r'beyan', r'matrah', r'istisna', r'muafiyet', r'damga', r'gecikme zammı', r'amme alacak', r'tevkifat', r'stopaj',
         r'vergi dairesi', r'kazanç', r'vergi ziyaı', r'usulsüzlük', r'213 sayılı'],
 'TIC': [r'anonim şirket', r'limited', r'kollektif', r'komandit', r'tacir', r'ticari işletme', r'ticaret sicil', r'kıymetli evrak', r'poliçe',
         r'bono', r'\bçek', r'genel kurul', r'yönetim kurulu', r'\bTTK\b', r'Türk Ticaret Kanunu', r'birleşme', r'ticaret unvan', r'şirket',
         r'ortak', r'pay sahib', r'haksız rekabet', r'acente', r'ciro', r'hamil', r'ticari defter'],
 'BOR': [r'borç ilişki', r'sözleşme', r'haksız fiil', r'sebepsiz zengin', r'temerrüt', r'zamanaşımı', r'\bifa', r'alacaklı', r'kefil',
         r'kira', r'vekâlet', r'vekalet', r'satış sözleşme', r'ceza koşul', r'\bTBK\b', r'Borçlar Kanunu', r'irade', r'hukuki işlem', r'icap',
         r'tazminat', r'eser sözleşme', r'bağışlama', r'ödünç', r'muvazaa', r'aşırı yararlanma', r'takas', r'ibra', r'borçlu', r'kusur'],
 'TUR': [r'cümle', r'sözcük', r'kelime', r'paragraf', r'anlatım', r'yazım', r'noktalama', r'parça', r'dize', r'deyim', r'\bek',
         r'sıfat', r'zarf', r'öge', r'metin', r'ses olay', r'anlam', r'yazar', r'şiir', r'yüklem', r'özne'],
 'MAT': [r'kaçtır', r'değeri', r'sayı', r'\bx\b', r'\by\b', r'yüzde', r'%', r'toplam', r'fonksiyon', r'denklem', r'olasılık',
         r'üçgen', r'küme', r'kaç farklı', r'ortalama', r'[0-9]\s*[\+\-×=/]\s*[0-9]', r'işlem', r'kaç', r'[\U0001D400-\U0001D7FF]', r'\blim', r'log', r'reel', r'gerçel', r'∑|√|∫'],
 'ATA': [r'Atatürk', r'Mustafa Kemal', r'TBMM', r'Lozan', r'inkılap', r'inkılâp', r'kongre', r'Cumhuriyet', r'cephe', r'Sakarya',
         r'Misak', r'Kurtuluş Savaşı', r'Mondros', r'Sevr', r'antlaşma', r'fırka', r'halifelik', r'saltanat', r'ilke', r'Osmanlı', r'Millî', r'Milli', r'cemiyet'],
})
KWC = {k: [re.compile(p, re.I) for p in v] for k, v in KW.items()}
