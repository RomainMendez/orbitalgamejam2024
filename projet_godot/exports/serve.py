from http.server import SimpleHTTPRequestHandler, HTTPServer

class MyHTTPRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        super().end_headers()

if __name__ == '__main__':
    server_address = ('', 8000)  # Change port if needed
    httpd = HTTPServer(server_address, MyHTTPRequestHandler)
    print('Server running at http://localhost:8000')
    httpd.serve_forever()

