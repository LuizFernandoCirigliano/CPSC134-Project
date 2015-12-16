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
        params = data.split('/')
        if params[0] == 'n':
            Play.note(int(params[1]), 0, float(params[2]), 127, int(params[3]))
        elif params[0] =='b':
            Play.noteOn(int(params[1]), 100, int(params[2]))
        elif params[0] == 'e':
            Play.noteOff(int(params[1]), int(params[2]))
        elif params[0] == 'i':
            Play.setInstrument(int(params[1]), int(params[2]))
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
        params = self.data.split('/')
        Play.note(int(params[0]), 0, int(params[1]), 127, 0)

        print "{} wrote:".format(self.client_address[0])
        print self.data
        # just send back the same data, but upper-cased
#        self.request.sendall(self.data.upper())


if __name__ == "__main__":
    HOST, PORT = "0.0.0.0", 9999
    server = SocketServer.UDPServer((HOST, PORT), MyUDPHandler)
#    server = SocketServer.TCPServer((HOST, PORT), MyTCPHandler)
    server.serve_forever()
