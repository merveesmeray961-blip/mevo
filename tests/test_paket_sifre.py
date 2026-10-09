from pipeline import paket_sifre as ps


def test_gidis_donus_ve_belirlenimcilik():
    veri = '{"sorular":[{"kok":"Aşağıdakilerden hangisi?"}]}'.encode()
    p = ps.sifrele(veri)
    assert p[:4] == b"MVO1" and veri not in p
    assert ps.coz(p) == veri
    assert ps.sifrele(veri) == p


def test_tanınmayan_paket_reddedilir():
    import pytest
    with pytest.raises(ValueError):
        ps.coz(b"XXXX" + bytes(40))
