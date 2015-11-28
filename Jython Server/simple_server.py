import SocketServer
from music import *

class MyUDPHandler(SocketServer.BaseRequestHandler):
    """
    This class works similar to the TCP handler class, except that
    self.request consists of a pair of data and client socket, and since
    there is no connection the client address must be given explicitly
    when sending data back via sendto().
    """

    def handle(self):
        data = self.request[0].strip()
        Play.note(int(data), 0, 100, 127, 0)
        socket = self.request[1]
        print "{} wrote:".format(self.client_address[0])
        print data
        socket.sendto(data.upper(), self.client_address)


class MyTCPHandler(SocketServer.BaseRequestHandler):
    """
    The RequestHandler class for our server.

    It is instantiated once per connection to the server, and must
    override the handle() method to implement communication to the
    client.
    """

    def handle(self):
        # self.request is the TCP socket connected to the client
        self.data = self.request.recv(1024).strip()
        Play.note(int(self.data), 0, 100, 127, 0)

        print "{} wrote:".format(self.client_address[0])
        print self.data
        # just send back the same data, but upper-cased
#        self.request.sendall(self.data.upper())


if __name__ == "__main__":
    HOST, PORT = "0.0.0.0", 9999
    server = SocketServer.UDPServer((HOST, PORT), MyUDPHandler)
#    server = SocketServer.TCPServer((HOST, PORT), MyTCPHandler)
    server.serve_forever()
