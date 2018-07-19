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

TaşRengi DizgedenRenkDön( string dizgeParametre)
{
	string dizge = dizgeParametre.toLower();
	if ( dizge ==  "sarı" || dizge == "sa" || dizge == "sari" )
		return TaşRengi.Sarı;
	else if ( dizge ==  "kırmızı" || dizge == "k" || dizge == "kirmizi" )
		return TaşRengi.Kırmızı;
	else if ( dizge ==  "mavi" || dizge == "m" )
		return TaşRengi.Mavi;
	else if ( dizge ==  "siyah" || dizge == "s" )
		return TaşRengi.Siyah;
	else 
		throw new StringException(" Yanlış renk girişi ");
}

enum Durumlar 
{
	OyunBitti,
	Devam,
	TaşÇek,
	TaşAt
}

struct OkeyTaşı 
{
	TaşRengi renk;
	int      sayı;	
	bool     ok;
	
	bool opEquals( OkeyTaşı diğer )
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

OkeyTaşı DizgedenTaşOluştur( string dizge )
{
	string[] ikilisi = dizge.split(",").array();
	if (ikilisi.length != 2 && ikilisi.length != 3)
	{
		writeln(" Geçersiz giriş bir daha giriniz");
		throw new StringException(" Yanlış giriş ");
	}
	
	if ( ikilisi.length == 2) 
		return OkeyTaşı(DizgedenRenkDön(ikilisi[0]), ikilisi[1].to!int, false);	
	else if ( ikilisi[2].toLower() == "ok" || ikilisi[2].toLower() == "okey")
		return OkeyTaşı(DizgedenRenkDön(ikilisi[0]), ikilisi[1].to!int, true);	
	else 
	{
		writeln(" Geçersiz giriş bir daha giriniz");
		throw new StringException(" Yanlış giriş ");
	}
}
OkeyTaşı KonsoledanTaşOluştur(  )
{
	while(true)
	{
		try 
		{
			return DizgedenTaşOluştur(stdin.readln.strip.chomp());
		}
		catch (StringException e)
		{
			writeln(" Hatalı giriş  bir daha giriniz");
			continue; 
		}

	}	
}

OkeyTaşı[] KonsoledanTaşDizisiOluştur(  )
{
	OkeyTaşı[] dönüşDeğeri; 
	try 
	{
		string[] taşlar = stdin.readln.strip.chomp.split(";").array();
		if ( taşlar.empty )
		{
			writeln("DüşenTaşlar girilmedi");
			return dönüşDeğeri;
		}
		else 
		{
			return taşlar.map!( a=> DizgedenTaşOluştur(a) ).array;
		}
					
	}
	catch (StringException e)
	{
		writeln(" Hatalı giriş  bir daha giriniz");
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
	this( this r)
	{
		düşenTaşlar = r.düşenTaşlar.dup;
		bütünTaşlarım = r.bütünTaşlarım.dup;
		foreach ( per; r.balyalarım )
		{
			Balya* yeniBalya = new Balya( per.isRenk, per.taşlar.dup);
			balyalarım ~= yeniBalya;
		}	

	}
	
	void KonsoledanOyna()
	{
		if ( bütünTaşlarım.length > 15 )
		{
			writeln(" Taş eklemeye izin verilmedi çünkü 15'den fazla taş olamaz " );
		}
		else if( bütünTaşlarım.length == 15 )
		{
			writeln( "Perleriniz: ", BalyaDizgesiniDön());
			
			OkeyTaşı atılacakTaş;
			if (TaşAt(atılacakTaş) == Durumlar.OyunBitti )
			{
				writeln( "!!!!!!!!!!!!!!!Kazandık ortaya!!!!!!!!!!!!!!!!!!!! ", atılacakTaş, " at" );
				assert(false);
			}
			else 
				writeln( "Lütfen ", atılacakTaş, " yere at" );
		} 
		else if ( bütünTaşlarım.length == 14 )
		{
			writeln("İsterseniz Düşen taşları yazın(kendi attığınız hariç) istemezseniz enter'a basın ");
			KonsoledanTaşDizisiOluştur().each!( a=> YereAtılanTaşEkle(a));
			writeln("Lütfen yerdeki taşı yazınız");
			OkeyTaşı yenitaş = KonsoledanTaşOluştur();
			Başla();
			if (YerdenEkle(yenitaş) == Durumlar.TaşÇek)
			{
				writeln("Lütfen ortadan taş çekin ve programa yazın" );
				yenitaş = KonsoledanTaşOluştur();
				OrtadanEkle(yenitaş);
			}	
			KonsoledanOyna();	
		}
		else 
		{
			writeln("14 'den daha az taşınız var lütfen taşlarınızı giriniz");
			OkeyTaşı yenitaş = KonsoledanTaşOluştur();
			Ekle(yenitaş);
		}
	}
	
	void Ekle( OkeyTaşı taş )
	{
		if ( bütünTaşlarım.length > 15 )
		{
			writeln(" Taş eklemeye izin verilmedi çünkü 15'den fazla taş olamaz " );
		}
		bütünTaşlarım ~= taş;
	}
	
	void YereAtılanTaşEkle( OkeyTaşı taş ) 
	{
		düşenTaşlar ~= taş;
		if ( düşenTaşlar.length >= 49 )
		{
			düşenTaşlar.length = 0;
			writeln(" Yerdeki taşlar bitti bir daha dağatılacak ");
		}
			
	}
	
	Durumlar TaşAt( out OkeyTaşı taş)  
	{ 
		Durumlar dönüşDeğeri = TaşAtUygulama(taş);
		bütünTaşlarım = bütünTaşlarım.remove( bütünTaşlarım.countUntil(taş) );
		YereAtılanTaşEkle(taş);
		return  dönüşDeğeri;
	}
	
	Durumlar YerdenEkle( OkeyTaşı yeniTaş )
	{
		OkeyTaşı[] şimdikibalyaTaşları = balyalarım.map!( a => a.taşlar).joiner().array.sort().array;
		Istaka* geçiciIstaka = new Istaka(this);
		geçiciIstaka.OrtadanEkle(yeniTaş);
		OkeyTaşı[] yeniBalyaTaşları = geçiciIstaka.balyalarım.map!( a => a.taşlar).joiner().array.sort().array;
		if ( yeniBalyaTaşları.length > şimdikibalyaTaşları.length) 
		{
			return OrtadanEkle(yeniTaş);
		} 
		return Durumlar.TaşÇek;
	}


	Durumlar OrtadanEkle( OkeyTaşı yeniTaş )
	{
		bütünTaşlarım ~= yeniTaş;
		Başla();

		return Durumlar.TaşAt;
	}
	
	void Başla()
	{
		OkeyTaşı[] istenilenTaşlar = IstenilenTaşlarıAyıkla(bütünTaşlarım).filter!( a => !a.ok ).array;
		balyalarım.length = 0;
		while ( true )
		{
			Balya*[] dönüşDeğeri;
			int max = 0;
			foreach ( taş; istenilenTaşlar)
			{
				Balya*[] geçiciBalya;
				//writeln(taş, " için balyalar oluşturulacak ");
				BalyalarıOluştur( taş, istenilenTaşlar, geçiciBalya );
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
		OkeyleriİşleVeÇıkar( istenilenTaşlar, balyalarım );	
	}
	
	void OkeyleriİşleVeÇıkar( OkeyTaşı[] istenilenTaşlar, ref Balya*[] geçiciBalya)
	{
		OkeyTaşı[] okeyler = bütünTaşlarım.filter!( a=> a.ok ).array;
		auto geçiçiTaşlar = istenilenTaşlar.dup;
		foreach( okey; okeyler)
		{
			OkeyTaşı[] balyaTaşları = geçiciBalya.map!( a => a.taşlar).joiner().array.sort().array;
			OkeyTaşı[] ikiliPerler = geçiçiTaşlar.sort().setDifference( balyaTaşları ).array;
			OkeyTaşı[] okeyPeri = Okeylerimiİşle(okey, ikiliPerler, geçiçiTaşlar);
			if ( !okeyPeri.empty )
			{
				geçiciBalya ~= BalyaOluştur(okeyPeri, false);
				//writeln(okeyPeri);
				geçiçiTaşlar = geçiçiTaşlar.dup.sort().setDifference(okeyPeri).array;
			}
		}		
	}

	OkeyTaşı[] Okeylerimiİşle( OkeyTaşı okey, OkeyTaşı[] balyaHariçiTaşlar, OkeyTaşı[] taşlar )
	{
		balyaHariçiTaşlar = IstenilenTaşlarıAyıkla(taşlar);
		ulong enUzunTamamlayan = 0;
		OkeyTaşı[] okeyPeri;
		foreach( taş ; balyaHariçiTaşlar )
		{
			OkeyTaşı[] tamamlayanTaşlar = TaşTamamla( taş, balyaHariçiTaşlar );
			foreach ( tamamlayanTaş; tamamlayanTaşlar)
			{
				OkeyTaşı[] sayıAralığı = AynıSayıdanBaşkaRenkAralığı( tamamlayanTaş, balyaHariçiTaşlar);
				OkeyTaşı[] renkAralığı = AynıRenktenDiziAralığı(tamamlayanTaş, balyaHariçiTaşlar);
				OkeyTaşı[] geçiciAralık = sayıAralığı.length > renkAralığı.length ?  sayıAralığı : renkAralığı;
				if ( geçiciAralık.length > enUzunTamamlayan )
				{
					okeyPeri = geçiciAralık.replace([tamamlayanTaş], [okey]).array;
					enUzunTamamlayan = geçiciAralık.length;
					
				}
			}
		}
		return okeyPeri;
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
	
	
	Durumlar TaşAtUygulama( out OkeyTaşı taş)  
	{ 
		if ( bütünTaşlarım.length != 15 )
		{
			writeln(" Taş atarken 15 tane taş olması lazım sorun var " );
		}
		
		auto istenmeyenTaşlar = İşeYaramayanTaşlarıBul(bütünTaşlarım);
		if ( !istenmeyenTaşlar.empty ) 
		{
			taş = istenmeyenTaşlar.front;
			return Durumlar.Devam;
		}
		else 
		{
			OkeyTaşı[] balyaTaşları = balyalarım.map!( a => a.taşlar).joiner().array.sort().array;
			OkeyTaşı[] balyaHariciTaşlar = bütünTaşlarım.sort().setDifference( balyaTaşları ).array;
			if (  balyaHariciTaşlar.length == 1 )
			{
				taş = balyaHariciTaşlar.front;
				return Durumlar.OyunBitti;
			}
			else if (balyaHariciTaşlar.empty )
			{
				auto üçtenBüyükBalyalar = balyalarım.filter!( a => a.taşlar.length > 3 );
				if ( üçtenBüyükBalyalar.empty() )
				{
					writeln("Beş tane üçlü balya iğrenç durum Erdem daha güzel bir çözüm üret ");
					taş = balyaHariciTaşlar.front;
					return Durumlar.Devam;
				}
				else 
				{
					taş = üçtenBüyükBalyalar.front().taşlar.front();
					return Durumlar.OyunBitti;
				}
			}
			else 
			{
				OkeyTaşı[] elenenTaşlar = chain(bütünTaşlarım, düşenTaşlar).array;
				double enDüşükİhtimal = double.max;
				OkeyTaşı atılacakTaş;
				foreach( kalanTaş;  balyaHariciTaşlar)
				{
					double şuankiİhtimal = TaşTamamlamaİhtimaliniHesapla(kalanTaş, bütünTaşlarım);
					if ( approxEqual(şuankiİhtimal, enDüşükİhtimal) )
					{
						if (AynıRenktenDiziAralığı(kalanTaş, bütünTaşlarım).length < 
							AynıRenktenDiziAralığı(atılacakTaş, bütünTaşlarım).length)
							continue;
					}
					enDüşükİhtimal = şuankiİhtimal;
					atılacakTaş = kalanTaş;
				}
				taş = atılacakTaş;
				return Durumlar.Devam;	
			}
		}	
	}
	
	
	void BalyalarıYazdır()
	{
		writeln(BalyaDizgesiniDön());	
	}
	
	string BalyaDizgesiniDön()
	{
		return balyalarım.map!( a=> a.Yazdır()).joiner("***").array.to!string;
	}
	
	OkeyTaşı[] düşenTaşlar;
	Balya*[]   balyalarım;
	OkeyTaşı[] bütünTaşlarım;
}

double TaşTamamlamaİhtimaliniHesapla( OkeyTaşı taş, OkeyTaşı[] elenenTaşlar )
{
	OkeyTaşı[] tamamlayanTaşlar = TaşTamamla( taş, elenenTaşlar);
	return tamamlayanTaşlar.map!( a=> IhtimalHesapla( a, elenenTaşlar) ).sum();
}

double IhtimalHesapla( OkeyTaşı taş, OkeyTaşı[] elenenTaşlar )
{
	ulong kaçTaneAtıldı = elenenTaşlar.count!( a=> a == taş );
	if ( kaçTaneAtıldı > 2 )
		writeln("Aynı taştan üç tane atılmış olamaz");
	ulong ortadaKalanlar = 2 - kaçTaneAtıldı;
	ulong geriyeKalanTaşlar = 106 -  elenenTaşlar.length;
	return to!double(ortadaKalanlar) / to!double(geriyeKalanTaşlar);
}

OkeyTaşı[] TaşTamamla( OkeyTaşı taşım, OkeyTaşı[] bütünTaşlarım  )
{
	return chain( RenkTamamla( taşım, bütünTaşlarım), SayıTamamlayıcılar( taşım, bütünTaşlarım) ).uniq.array;
}

OkeyTaşı[] RenkTamamla( OkeyTaşı taşım, OkeyTaşı[] bütünTaşlarım )
{
	TaşRengi[] aynıSayıdanBaşkaRenkler = AynıSayıdanBaşkaRenkAralığı( taşım, bütünTaşlarım ).map!( a => a.renk ).array;
	OkeyTaşı[]  beklenenTaşlar;
	if ( aynıSayıdanBaşkaRenkler.length != 2 )
		return beklenenTaşlar;
		
	 beklenenTaşlar = [TaşRengi.Sarı, TaşRengi.Kırmızı, TaşRengi.Mavi, TaşRengi.Siyah]
													.filter!( a=> !aynıSayıdanBaşkaRenkler.canFind(a) )
	                                                .map!( a => OkeyTaşı(a, taşım.sayı, false)).array;
	return beklenenTaşlar;
}

OkeyTaşı[] SayıTamamlayıcılar( OkeyTaşı taşım, OkeyTaşı[] bütünTaşlarım )
{
	OkeyTaşı[] aynıRenktenDiziler = AynıRenktenDiziAralığı( taşım, bütünTaşlarım).sort().array;
	OkeyTaşı[]  boşDizi;
	if ( aynıRenktenDiziler  == null && aynıRenktenDiziler.length < 2 )
		return boşDizi;
		
	OkeyTaşı[] dönüşDeğeri; 
	if ( aynıRenktenDiziler.front().sayı != 1 ) 
	{
		OkeyTaşı öneEk = aynıRenktenDiziler.front();
		öneEk.sayı--;
		dönüşDeğeri ~= öneEk;
	}
	
	if ( aynıRenktenDiziler.back().sayı != 13 ) 
	{
		OkeyTaşı sonaEk = aynıRenktenDiziler.back();
		sonaEk.sayı++;
		dönüşDeğeri ~= sonaEk;
	}
	return 	dönüşDeğeri;
}


ulong AynıSayıdanBaşkaRenkteSayısı( OkeyTaşı taşım, OkeyTaşı[] bütünTaşlarım )
{
	return  bütünTaşlarım.count!( a => a.renk != taşım.renk && a.sayı == taşım.sayı );
}

OkeyTaşı[] AynıSayıdanBaşkaRenkAralığı( OkeyTaşı taşım, OkeyTaşı[] bütünTaşlarım )
{
	auto dönüşDizisi = bütünTaşlarım.filter!( a => a.renk != taşım.renk && a.sayı == taşım.sayı ).array;
	dönüşDizisi ~= taşım;
	dönüşDizisi = dönüşDizisi.uniq.array;
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
		
		if ( taşım.ok )
			return false;
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
	
	Istaka ıstaka;
	while ( true )
	{
		ıstaka.KonsoledanOyna();
	}

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


unittest
{
	//Tamamlayıcı testleri 
	OkeyTaşı[] doğanınTaşları;
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 2, false);
	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Siyah, 3, false);
	
	auto tamamlanacakSayılar = SayıTamamlayıcılar(OkeyTaşı(TaşRengi.Siyah, 2, false), doğanınTaşları);
	assert( tamamlanacakSayılar.equal( [OkeyTaşı(TaşRengi.Siyah, 1, false), 
										OkeyTaşı(TaşRengi.Siyah, 4, false)]));	
	
	OkeyTaşı[] boşDizi;
	tamamlanacakSayılar = RenkTamamla(OkeyTaşı(TaşRengi.Siyah, 2, false), doğanınTaşları);
	assert( tamamlanacakSayılar.equal( boşDizi ));	
	
	tamamlanacakSayılar = SayıTamamlayıcılar(OkeyTaşı(TaşRengi.Siyah, 6, false), doğanınTaşları);


	doğanınTaşları ~=  OkeyTaşı(TaşRengi.Sarı, 3, false);
	
	tamamlanacakSayılar = TaşTamamla(OkeyTaşı(TaşRengi.Siyah, 3, false), doğanınTaşları);
	assert( tamamlanacakSayılar.equal( [OkeyTaşı(TaşRengi.Siyah, 1, false), 
										OkeyTaşı(TaşRengi.Siyah, 4, false),
										OkeyTaşı(TaşRengi.Mavi, 3, false), 
										OkeyTaşı(TaşRengi.Kırmızı, 3, false)].sort().array));	
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
	
	auto ıstakaKopyası = ıstaka.bütünTaşlarım.dup;
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 5, false));				
	ıstaka.Başla();
	OkeyTaşı atılacakTaş;
	
	auto durum = ıstaka.TaşAt(atılacakTaş);
	assert( durum ==  Durumlar.OyunBitti );	
	assert( atılacakTaş == OkeyTaşı(TaşRengi.Siyah, 5, false));	
	assert( ıstaka.bütünTaşlarım.sort().equal( ıstakaKopyası.sort()) );	
}

unittest
{
	// internetten bulduğum rasgele bir dizi gerçek 15 taş 
	Istaka ıstaka;

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 10, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 12, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 13, false));

	auto ıstakaKopyası = ıstaka.bütünTaşlarım.dup;
	ıstakaKopyası ~= OkeyTaşı(TaşRengi.Siyah, 11, false);
	ıstaka.Başla();
	OkeyTaşı atılacakTaş;
	
	auto durum = ıstaka.YerdenEkle(OkeyTaşı(TaşRengi.Siyah, 11, false));
	assert( durum ==  Durumlar.TaşAt );	
	assert( ıstaka.bütünTaşlarım.sort().equal( ıstakaKopyası.sort()) );	
}

unittest
{
	// internetten bulduğum rasgele bir dizi gerçek 15 taş 
	Istaka ıstaka;

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 10, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 12, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 13, false));

	auto ıstakaKopyası = ıstaka.bütünTaşlarım.dup;
	ıstaka.Başla();
	OkeyTaşı atılacakTaş;
	auto durum = ıstaka.YerdenEkle(OkeyTaşı(TaşRengi.Siyah, 1, false));
	assert( durum ==  Durumlar.TaşÇek );	
	assert( ıstaka.bütünTaşlarım.sort().equal( ıstakaKopyası.sort()) );	
	durum = ıstaka.OrtadanEkle(OkeyTaşı(TaşRengi.Siyah, 11, false));
	ıstakaKopyası ~= OkeyTaşı(TaşRengi.Siyah, 11, false);
	assert( durum ==  Durumlar.TaşAt );	
	assert( ıstaka.bütünTaşlarım.sort().equal( ıstakaKopyası.sort()) );	
}

unittest
{
	// internetten bulduğum rasgele bir dizi gerçek 15 taş 
	Istaka ıstaka;

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 10, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 12, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 13, false));

	auto ıstakaKopyası = ıstaka.bütünTaşlarım.dup;
	ıstakaKopyası ~= OkeyTaşı(TaşRengi.Siyah, 11, false);
	ıstaka.Başla();
	OkeyTaşı atılacakTaş;
	
	auto durum = ıstaka.YerdenEkle(OkeyTaşı(TaşRengi.Siyah, 11, false));
	assert( durum ==  Durumlar.TaşAt );	
	assert( ıstaka.bütünTaşlarım.sort().equal( ıstakaKopyası.sort()) );	
}


unittest
{
	// internetten bulduğum rasgele bir dizi gerçek 15 taş 
	Istaka ıstaka;

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 10, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 12, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 12, false));

	OkeyTaşı atılacakTaş;
	ıstaka.TaşAt(atılacakTaş);
	assert( atılacakTaş ==  OkeyTaşı(TaşRengi.Siyah, 12, false));	
	assert( ıstaka.bütünTaşlarım.sort().equal([OkeyTaşı(TaşRengi.Siyah, 10, false), OkeyTaşı(TaşRengi.Siyah, 12, false)] ));	
}


unittest
{
	// internetten bulduğum rasgele bir dizi gerçek 15 taş 
	Istaka ıstaka;

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 10, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 11, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 12, false));

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 4, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 5, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 11, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 12, false));


	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı, 1, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı, 6, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı, 8, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı, 10, false));

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 1, false));

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 2, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 9, false));

	
				
	ıstaka.Başla();
	//writeln(ıstaka.BalyaDizgesiniDön());
}

unittest
{
	// internetten bulduğum rasgele bir dizi gerçek 15 taş 
	Istaka ıstaka;

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 7, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 8, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 9, false));

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 3, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 4, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 6, false));

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 6, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 4, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 8, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı, 1, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 3, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 13, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı, 5, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 9, false));
	ıstaka.Başla();
	assert(ıstaka.YerdenEkle(OkeyTaşı(TaşRengi.Kırmızı, 10, false)) == Durumlar.TaşÇek);
}


unittest
{
	// internetten bulduğum rasgele bir dizi gerçek 15 taş 
	Istaka ıstaka;

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 7, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 8, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 9, false));

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 3, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 4, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 6, false));

	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 6, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 4, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 8, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 4, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 3, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 13, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı, 5, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 9, false));
	ıstaka.Başla();
	
	OkeyTaşı[] balyaTaşları = ıstaka.balyalarım.map!( a => a.taşlar).joiner().array.sort().array;	
	//writeln(balyaTaşları); 	
}

unittest
{
	Istaka ıstaka;
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 7, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı,8, true));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 9, false));
	ıstaka.Başla();
	
	OkeyTaşı[] balyaTaşları = ıstaka.balyalarım.map!( a => a.taşlar).joiner().array.sort().array;	
	//writeln(balyaTaşları); 	
}

unittest
{
	Istaka ıstaka;
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 7, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı,8, true));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 9, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 3, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı,8, true));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 3, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı,11, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı,12, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Kırmızı,6, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 6, false));
	
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Sarı, 10, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 1, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Siyah, 4, false));
	ıstaka.Ekle(OkeyTaşı(TaşRengi.Mavi, 8, false));
	ıstaka.Başla();
	
	OkeyTaşı[] balyaTaşları = ıstaka.balyalarım.map!( a => a.taşlar).joiner().array.sort().array;	
	writeln(ıstaka.BalyaDizgesiniDön()); 	
}


