class WebUtil {
  static Map<String, dynamic> parameters(
      {String title = '', String uri = '', bool recall = false}) {
    return {'title': title, 'uri': uri, 'recall': recall};
  }
}
