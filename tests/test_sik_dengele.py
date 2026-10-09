from pipeline import sik_dengele as sd


def soru(**k):
    s = {
        "id": "S1", "durum": "kontrolde", "dogru": "B", "kok": "Hangisi doğrudur?",
        "secenekler": {"A": "alfa", "B": "beta", "C": "gama", "D": "delta", "E": "epsilon"},
        "aciklama": {"dogru_neden": "beta doğrudur", "celdiriciler": {"A": "a yanlış", "E": "e yanlış"}},
    }
    s.update(k)
    return s


def test_takas_metni_ve_celdirici_aciklamasini_tasir():
    s = soru()
    sd.takas(s, "E")
    assert s["dogru"] == "E" and s["secenekler"]["E"] == "beta" and s["secenekler"]["B"] == "epsilon"
    assert s["aciklama"]["celdiriciler"] == {"A": "a yanlış", "B": "e yanlış"}
    assert s["gecmis"][-1]["kim"] == "otomatik"


def test_sirasi_anlamli_sorulara_dokunulmaz():
    assert sd.uygun(soru())
    assert not sd.uygun(soru(secenekler={"A": "1.000", "B": "2.000", "C": "3.000", "D": "4.000", "E": "5.000"}))
    assert not sd.uygun(soru(secenekler={"A": "Yalnız I", "B": "I ve II", "C": "II ve III", "D": "I ve III",
                                          "E": "I, II ve III"}))
    assert not sd.uygun(soru(aciklama={"dogru_neden": "B şıkkı doğrudur", "celdiriciler": {}}))
    assert not sd.uygun(soru(durum="taslak"))
