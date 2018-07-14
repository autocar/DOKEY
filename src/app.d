import std.stdio;
import std.math;
import std.algorithm;
import std.array;
import std.string;
import std.conv;
import std.range;

enum TaşRengi
{
	Sarı,
	Kırmızı, 
	Mavi,
	Siyah
}

struct OkeyTaşı 
{
	TaşRengi renk;
	int      sayı;	
	bool     ok;
	
	bool opEquals( ref OkeyTaşı diğer )
	{
		return diğer.renk == this.renk && diğer.sayı == this.sayı && diğer.ok == this.ok;
	}
	
	int opCmp( ref OkeyTaşı diğer )
	{
		if ( this.renk < diğer.renk)
			return -1;
		else if ( this.renk > diğer.renk )
			return 1;
		else 
		{
			if ( this.sayı < diğer.sayı ) 
				return -1;
			else if ( this.sayı > diğer.sayı ) 
				return 1;
			else
				return 0;
		}	
	}
	
	int Fark(OkeyTaşı ötekiTaş)
	{
		if ( this.sayı == 1 )
		{
			if ( abs(ötekiTaş.sayı - 14) < abs(ötekiTaş.sayı - this.sayı) )
				return ötekiTaş.sayı - 14;		
		}
		else if ( ötekiTaş.sayı == 1 )
		{
			if ( abs(14 - this.sayı) < abs(ötekiTaş.sayı - this.sayı) )
				return 14 - this.sayı;		
		}
		return 	ötekiTaş.sayı - this.sayı;
	}
	
	string Yazdır()
	{
		string dönüşDeğeri;
		if ( TaşRengi.Kırmızı == renk)
			dönüşDeğeri ~= "K";
		else if ( TaşRengi.Mavi == renk)
			dönüşDeğeri ~= "M";
		else if ( TaşRengi.Siyah == renk)
			dönüşDeğeri ~= "Sİ";
		else if ( TaşRengi.Sarı == renk)
			dönüşDeğeri ~= "SA";	
			
		dönüşDeğeri ~= to!string(sayı);	
		return dönüşDeğeri;
	}
}

struct Balya
{
	bool opCmp( ref Balya diğer )
	{
		return taşlar.equal( diğer.taşlar );
	}
	
	string Yazdır()
	{
		return taşlar.map!( a=> a.Yazdır()).joiner(",").array.to!string;
	}
	
	void Çıkar( OkeyTaşı taş )
	{
		taşlar = taşlar.remove!( a=> a==taş).array;
	}
	
	bool       isRenk;
	OkeyTaşı[] taşlar;
}

Balya* BalyaOluştur( OkeyTaşı[] taşlar, bool isRenk )
{
	if ( taşlar.length < 3 )
		return null;
	return new Balya(isRenk, taşlar);
}

struct Istaka 
{
	void Ekle( OkeyTaşı taş )
	{
		bütünTaşlarım ~= taş;
	}
	
	void Başla()
	{
		OkeyTaşı[] istenilenTaşlar = IstenilenTaşlarıAyıkla(bütünTaşlarım);
		while ( true )
		{
			Balya*[] dönüşDeğeri;
			int max = 0;
			foreach ( taş; istenilenTaşlar)
			{
				Balya*[] geçiciBalya;
				BalyalarıOluştur(taş, istenilenTaşlar, geçiciBalya);
				auto toplam = 0;
				geçiciBalya.each!( a=> toplam += a.taşlar.length );	
				if ( toplam > max) 
				{
					max = toplam;
					dönüşDeğeri = geçiciBalya;
				}
			}
			if (dönüşDeğeri.empty)
				break;
			balyalarım = chain( balyalarım, dönüşDeğeri ).array;
			foreach( balya; dönüşDeğeri)
			{
				istenilenTaşlar = istenilenTaşlar.dup.sort().setDifference(balya.taşlar.sort()).array;
			}
		}
			
	}

	void BalyalarıOluştur( OkeyTaşı taş, OkeyTaşı[] taşlar, ref Balya*[] dönüşDeğeri )
	{
		Balya* renkBalyası = BalyaOluştur ( AynıSayıdanBaşkaRenkAralığı( taş, taşlar ), true);
		Balya* sayıBalyası = BalyaOluştur ( AynıRenktenDiziAralığı( taş, taşlar ), false);
		if ( renkBalyası && !sayıBalyası)
			dönüşDeğeri ~= renkBalyası;
		else if ( !renkBalyası && sayıBalyası)
			dönüşDeğeri ~= sayıBalyası;
		else if ( !renkBalyası && !sayıBalyası)
			return;
		else if ( renkBalyası.taşlar.length > 3 &&  sayıBalyası )
		{
			dönüşDeğeri ~= sayıBalyası;
			if (  taşlar.count(taş) == 1)
				renkBalyası.Çıkar(taş);
			dönüşDeğeri ~= renkBalyası; 
		}
		else if ( renkBalyası.taşlar.length == 3 &&  taşlar.count(taş) > 1 &&  sayıBalyası )
		{
			dönüşDeğeri ~= sayıBalyası;
			dönüşDeğeri ~= renkBalyası; 
		}
		else	
		{
			Balya*[] geçiciDönüşDeğeriRenk = BalyaOluşturmaYardımcısı(renkBalyası, taşlar);
			Balya*[] geçiciDönüşDeğeriSıra = BalyaOluşturmaYardımcısı(sayıBalyası, taşlar);
			auto renkToplamı = 0;
			geçiciDönüşDeğeriRenk.each!( a=> renkToplamı += a.taşlar.length );	
			auto sıraToplamı = 0;
			geçiciDönüşDeğeriSıra.each!( a=> sıraToplamı += a.taşlar.length );
			
			renkToplamı >  sıraToplamı ? chain(dönüşDeğeri, geçiciDönüşDeğeriRenk) 
			                           : chain(dönüşDeğeri, geçiciDönüşDeğeriSıra);
		}
	}
	
	Balya*[] BalyaOluşturmaYardımcısı( Balya* balya, OkeyTaşı[] taşlar )
	{
		Balya*[] geçiciDönüşDeğeri;
		auto balyaÇıkartılmışDizi = taşlar.dup.sort().setDifference(balya.taşlar.sort()).array;
		foreach( geçiciTaş; balyaÇıkartılmışDizi)
		{
			BalyalarıOluştur( geçiciTaş, balyaÇıkartılmışDizi.dup, geçiciDönüşDeğeri);
		}
		return geçiciDönüşDeğeri;	
	}
	
	void BalyalarıYazdır()
	{
		writeln(BalyaDizgesiniDön());	
	}
	
	string BalyaDizgesiniDön()
	{
		return balyalarım.map!( a=> a.Yazdır()).joiner("***").array.to!string;
	}
	
	Balya*[]   balyalarım;
	OkeyTaşı[] bütünTaşlarım;
}

ulong AynıSayıdanBaşkaRenkteSayısı( OkeyTaşı taşım, OkeyTaşı[] bütünTaşlarım )
{
	return  bütünTaşlarım.count!( a => a.renk != taşım.renk && a.sayı == taşım.sayı );
}

OkeyTaşı[] AynıSayıdanBaşkaRenkAralığı( OkeyTaşı taşım, OkeyTaşı[] bütünTaşlarım )
{
	auto dönüşDizisi = bütünTaşlarım.filter!( a => a.renk != taşım.renk && a.sayı == taşım.sayı ).array;
	dönüşDizisi ~= taşım;
	return dönüşDizisi; 
}

OkeyTaşı[] AynıRenktenDiziAralığı( OkeyTaşı taşım, OkeyTaşı[] bütünTaşlarım )
{
	OkeyTaşı[] dönüşDeğeri;
	auto sıralanmışAynıRenkteTaşlar = bütünTaşlarım.filter!( a => a.renk == taşım.renk ).array.sort();
	int şuankiSayı = taşım.sayı;
	while ( sıralanmışAynıRenkteTaşlar.canFind!( (a,b) => a.sayı == b )(--şuankiSayı) )
	{
		dönüşDeğeri ~= OkeyTaşı(taşım.renk, şuankiSayı, false);
	}
	
	dönüşDeğeri ~= taşım;
	şuankiSayı = taşım.sayı;
	while ( sıralanmışAynıRenkteTaşlar.canFind!( (a,b) => a.sayı == b )(++şuankiSayı) )
	{
		dönüşDeğeri~= OkeyTaşı(taşım.renk, şuankiSayı, false);
	}
	
	return dönüşDeğeri;
}

int EnYakındakiAynıRenkMesafesi( OkeyTaşı taşım, OkeyTaşı[] bütünTaşlarım )
{
	auto adaylar = bütünTaşlarım.filter!( a => a.renk == taşım.renk &&  a.sayı != taşım.sayı);
	if ( adaylar.empty)
		return int.max;
	else 	
		return adaylar.minElement!( taş => abs(taşım.Fark(taş)) ).Fark(taşım);								   
}

OkeyTaşı[] İşeYaramayanTaşlarıBul( OkeyTaşı[] bütünTaşlarım  ) 
{
	bool GenelİşeYaramazTesti( OkeyTaşı taşım, int index , OkeyTaşı[] taşlarım )
	{
		ulong taşSayısı = taşlarım.filter!( a => a == taşım ).array.length;
		if ( taşSayısı < 2 )
		{
			return AynıSayıdanBaşkaRenkteSayısı(taşım, taşlarım) == 0 && 
									     abs(EnYakındakiAynıRenkMesafesi( taşım, taşlarım)) > 2 ;	
		}
		else if (taşSayısı == 2 )
		{
			bool ayniSayi = AynıSayıdanBaşkaRenkteSayısı(taşım, taşlarım) == 0;
			bool mesafe   = abs(EnYakındakiAynıRenkMesafesi( taşım, taşlarım)) > 2 ;
			if ( ayniSayi && mesafe)	
				return true;
			else if ( ayniSayi || mesafe ) 
			{
				return index == taşlarım.countUntil(taşım);
			}
			return false;							     				
		}
		else 
		{
			writeln("Geçersiz giriş bir taştan en az bir tane vaya en fazla iki tane olmalı fakat ", taşım , " taşından ", 
				     taşSayısı, " tane var", );
			return false;
		}
	}
	
	OkeyTaşı[] dönüşDeğeri; 
	for ( int i = 0; i < bütünTaşlarım.length; i++ )
	{
		if ( GenelİşeYaramazTesti( bütünTaşlarım[i], i , bütünTaşlarım) )
			dönüşDeğeri ~= bütünTaşlarım[i];
	}
	return dönüşDeğeri;
}

OkeyTaşı[] IstenilenTaşlarıAyıkla( OkeyTaşı[] taşlarım )
{
	
	auto istenmeyenTaşlar = İşeYaramayanTaşlarıBul(taşlarım).sort();
	
	auto sıralanmışTaşlar = taşlarım.sort();
	auto istenilenTaşlar = sıralanmışTaşlar.setDifference( istenmeyenTaşlar );	
	return istenilenTaşlar.array();
}

void main() {
	
	OkeyTaşı[] taşlarım;
	
}


unittest 
{
	
	// Aynı renkten olmasına rağmen aynı taştan iki tane varsa ikinci kopyanın istenmeyen olması lazım. 
	OkeyTaşı[] doğanınTaşları;

	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Mavi, 10, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Kırmızı, 10, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 10, false);

	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Kırmızı, 10, false);
	
	auto doğanınIstenmeyenTaşları = İşeYaramayanTaşlarıBul(doğanınTaşları);
	assert( doğanınIstenmeyenTaşları.equal([OkeyTaşı(TaşRengi.Kırmızı, 10, false)]));	
}


unittest
{
	// Baya karışık bir el Aynı renk, 13 1 gibi testlerde içeriyor 
	
	OkeyTaşı[] doğanınTaşları;
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Kırmızı, 3, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Sarı, 9, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Mavi, 7, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 1, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Mavi, 2, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 3, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 4, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 13, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Sarı, 3, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Sarı, 5, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Sarı, 6, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Sarı, 7, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Kırmızı, 5, false);
	
	auto doğanınIstenmeyenTaşları = İşeYaramayanTaşlarıBul(doğanınTaşları);
	assert( doğanınIstenmeyenTaşları.equal([OkeyTaşı(TaşRengi.Mavi, 2, false)]));	
}


unittest
{
	// 	Siyah 1 siyah 3 'e bağlanabilir fakat siyah 13 siyah 2'ye bağlanamaz. 
	
	OkeyTaşı[] doğanınTaşları;
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 2, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 13, false);
	
	
	auto doğanınIstenmeyenTaşları = İşeYaramayanTaşlarıBul(doğanınTaşları);
	assert( doğanınIstenmeyenTaşları.equal([OkeyTaşı(TaşRengi.Siyah, 2, false), 
										    OkeyTaşı(TaşRengi.Siyah, 13, false)]));	
}

unittest
{
	// 	Filtre testi 1 
	
	OkeyTaşı[] doğanınTaşları;
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 2, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 2, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 13, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Mavi, 4, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Mavi, 5, false);
	
	auto doğanınIstenmeyenTaşları = İşeYaramayanTaşlarıBul(doğanınTaşları);
	assert( doğanınIstenmeyenTaşları.equal( [OkeyTaşı(TaşRengi.Siyah, 2, false), 
											 OkeyTaşı(TaşRengi.Siyah, 2, false), 
										     OkeyTaşı(TaşRengi.Siyah, 13, false)]));	
	
	auto istenilenTaşlar = doğanınTaşları.filter!( a=> !doğanınIstenmeyenTaşları.canFind( a ) ) ;
	assert(istenilenTaşlar.equal([OkeyTaşı(TaşRengi.Mavi, 4, false), 
												   OkeyTaşı(TaşRengi.Mavi, 5, false)])) ;	
}

unittest
{
	// 	Filtre testi 2 biraz daha karışık 
	OkeyTaşı[] doğanınTaşları;
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 2, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 2, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Mavi, 2, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 13, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Mavi, 4, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Mavi, 5, false);
	
	
	auto istenilenTaşlar = IstenilenTaşlarıAyıkla(doğanınTaşları);
	assert(istenilenTaşlar.equal(				  [
												   OkeyTaşı(TaşRengi.Siyah, 2, false), 
												   OkeyTaşı(TaşRengi.Mavi, 2, false),
												   OkeyTaşı(TaşRengi.Mavi, 4, false), 
												   OkeyTaşı(TaşRengi.Mavi, 5, false)].sort())) ;	
}

unittest
{
	// Sıralı Taş dizme testi
	Istaka ıstaka;
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 3, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 4, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 5, false));
	
	ıstaka.Başla();
	assert ( "M3,M4,M5" == ıstaka.BalyaDizgesiniDön());
}


unittest
{
	// 	Mavi beşten ikitane olduğu için mantıklı bir şekilde iki tane balya olması lazım 
	Istaka ıstaka;
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 3, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 4, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 5, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 7, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 8, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 10, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 5, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 5, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı, 5, false));
			
	ıstaka.Başla();
	assert ( "M3,M4,M5***SA5,K5,M5" == ıstaka.BalyaDizgesiniDön());	
}


unittest
{
	// 	Duplike taş olmadan 2 balya testi 
	Istaka ıstaka;

	

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 5, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı, 5, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 5, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 3, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 4, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 5, false));

			
	ıstaka.Başla();
	assert ( "M3,M4,M5***SA5,K5,Sİ5" == ıstaka.BalyaDizgesiniDön());
}


unittest
{
	// 	3 balya
	Istaka ıstaka;

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 5, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı, 5, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 5, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 3, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 4, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 5, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 8, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 8, false));		
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı, 8, false));
			
	ıstaka.Başla();
	assert ( "M3,M4,M5***SA5,K5,Sİ5***SA8,K8,M8" == ıstaka.BalyaDizgesiniDön());
}

unittest
{
	// internetten bulduğum rasgele bir dizi gerçek 15 taş 
	Istaka ıstaka;

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 5, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 6, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 7, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 3, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 4, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 5, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 10, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 11, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 12, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 13, false));

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 7, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 8, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 9, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 10, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 5, false));				
	ıstaka.Başla();
	assert ( "M7,M8,M9,M10***Sİ10,Sİ11,Sİ12,Sİ13***SA5,SA6,SA7***M3,M4,M5" == ıstaka.BalyaDizgesiniDön());
}



