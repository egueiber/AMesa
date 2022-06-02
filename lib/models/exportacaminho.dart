import 'package:gsheets/gsheets.dart';
import 'avaliacaoresult.dart';

//import 'package:flutter/cupertino.dart';
class ManipulaPlanilha {
  ManipulaPlanilha();
  static final _credenciais = r'''{
    "type": "service_account",
    "project_id": "pramesa",
    "private_key_id": "43c9654a51cd16cc09c4ce2a67da7264b0379e23",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDAtwmrWTr7P0Qe\nxzuaHgHpEkbo7LZCWZdZvhZyoSr2GNH0p3warpRzba6Wo63PYkPKxe64iojI35TY\n+svE7berhkL61B1sWL09eEsmbdMEentUtk8HAhN7Gye4hSpRsfNL8YLcEpobzcZb\n5vNtXKWguTh63r6Ea5PbO3UxgncYdFY3zsdIT1pWIU6CDNUel8egNIvdFjbc/jc7\n3D08wFbxymn+UkbaF9zhe+ACELsCQXy7ESMXQ7E7gDq3jatgA42xP8hzcAsqeuFn\n0AAE/rtIAuInZcFQUOBvfsfWVXi+RnhoymhcNauEHRcHxC126rCv6Jeovu9wZ+2i\n9opEBvuNAgMBAAECggEAAWpV43aOSz+ZRQvPUBUTT6XrurFYXvfuqhHl0XCg4DZ9\ny702y755/+BYBI+AonA/ThVNdmS/PEAGIDF4FoZEe4BfIishTlld6y11iWqZQirw\nLI2CRmt3oN76svQQKOLxVscexRePubE1gabW/O3HLFFzuLOdEuKBwAEsFw4rJvAd\n5vbGMWcY2OUjR5mEifvGP/TlE/4+/YBSuHspM+IYMICzgOTp+3GtzHni4dttJW4n\nfr0jeZB3EG8W482aDFGrtq//bUL/Po/strsbzqQqTpLFgGN/PNCqgr/OJZ7RliFP\no68XU15xaIavtqpAvhIMlG9DLf3BlbzgCxH8EGVsKQKBgQDjwChyHTLEGXKpls6T\ng6cQqlSyJVECujl+ebhpoWdVgwMNFRGgXcPJxu57m0kX3UVodZG6ll0+bbqecOub\nGRJBeEapdjwethhmdBeX2/Bk7WmPd6HXQUUU7gYetqqkZKzpcLKHArIsMto5dnoh\nlK+AO2zTBlqxDNKzibWQNrOrNQKBgQDYnmG66y0U4U0S40ZpkGqTXvAd4jPo1kI9\n55gZ9PnjzL0ELfvDW85kd0jdTivM37Jr0cZeMwO3Z5DhyjXIdkmpBg+diCvEfdcc\npygnhLKa2d4uHrVBh+SJcGjhBcrXUQL37/Gb8vdxSBI71bw1Ls+f3EmHzB0hOxd9\nBCO3SjlB+QKBgCw19yP/ywUKM5n8LmmwWtP/XKWgXNN8twB4PHY04MxWvFbjyiIp\nUYJv3YedI1lAmOKoP/vKiJs/zcRIA1R+T27qHD11OEJ18tKgopvWFBpjg+RXwtD4\nWKKxefqoVwPGj1JZkC5pNZEi5f3Vo+u040SvRHbKevx3ksdLajVuiP4pAoGBAMGu\n66dbvBVdVbK7sCuXSxO14XB23v8jBFuhheg/mGfMmnzwOJn2rlY6KdZmnNc0dK3f\nBUUYzAvi+DJKwUgaK8aLes7aAHhSJFKkS0z6Y0/92aDXKC4NuZQCBGSe7z0SXFsg\nGaHc3s5VKKiDdSMAVfiT2NMo+CrMUTYgy2aJYSTRAoGAE+Vm41Rq7npay8+gZCjO\nxNva2qgWz8txlRw2stQ5PymHX7NcoL4+ffCdgZk4+TNH99b/HgzI3WH26sjEjmnc\nwB7j8JXpsWMkrBv5hHQb7gRcctxUVdEMzw8BfCZa8cof8oqr7mFHhbUmlSc0vp4l\nYCk/l/6u4S11AcFeYPntT8k=\n-----END PRIVATE KEY-----\n",
    "client_email": "pramesa@pramesa.iam.gserviceaccount.com",
    "client_id": "112093162071501627061",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/pramesa%40pramesa.iam.gserviceaccount.com"
  }''';
  static final _planilhaId = '1GfLxsGWd3c1kHsz7E8reyunBHNOttQ8MXTJ0lCvg1GQ';
  // 'AKfycbzHERpiwDlXU0FjkEWSve9QM9jECj-HPV42vjd78KQ2lLPFUr_XYws7zWzZVNA4fS4c8Q';

  static final _amesacoleta = GSheets(_credenciais);
  static Worksheet _percurso;

  static Future init() async {
    try {
      final planilha = await _amesacoleta.spreadsheet(_planilhaId);
      _percurso = await _getWorkSheet(planilha, title: 'Percurso');
      final cabecalho = AvaliacaoResult().getFields();
      _percurso.values.insertRow(1, cabecalho);
    } catch (e) {
      print('Erro:$e');
    }
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet planilha,
      {String title}) async {
    try {
      return await planilha.addWorksheet(title);
    } catch (e) {
      return planilha.worksheetByTitle(title);
    }
  }

  static Future insert(List rowList) async {
    if (_percurso == null) return;
    _percurso.values.map.appendRows(rowList);
  }
}

class ExportaCaminho {
  ExportaCaminho(List<AvaliacaoResult> avaliacaoresultcolection) {
    //WidgetsFlutterBinding.ensureInitialized();
    //await ManipulaPlanilha.init();
    List<Map<String, dynamic>> linhas = [];
    avaliacaoresultcolection.forEach((av) {
      Map linha = av.toMap();
      if (linha.isNotEmpty) {
        linhas.add(linha);
      }
    });
    ManipulaPlanilha.insert(linhas);
  }
}
