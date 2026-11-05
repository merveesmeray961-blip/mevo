"""Yerel görsel sunucusu (Play Console'a görsel yüklemek için): CORS + Private Network Access başlıklarıyla."""
import sys, http.server, functools

class H(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Private-Network", "true")
        super().end_headers()

    def do_OPTIONS(self):
        self.send_response(204)
        self.send_header("Access-Control-Allow-Methods", "GET")
        self.send_header("Access-Control-Allow-Headers", "*")
        self.end_headers()

kok = sys.argv[1]
http.server.ThreadingHTTPServer(("127.0.0.1", 8799), functools.partial(H, directory=kok)).serve_forever()
