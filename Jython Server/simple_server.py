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
        #Get the string sent and remove leading and trailing spaces
        data = self.request[0].strip()
        #Split the string into a list of parameters
        params = data.split('/')
        #Check the first parameter for what operation to do
    
        if params[0] == 'n':
            Play.note(int(params[1]), 0, float(params[2]), 127, int(params[3]))
        elif params[0] == 'b':
            Play.noteOn(int(params[1]), 100, int(params[2]))
        elif params[0] == 'e':
            Play.noteOff(int(params[1]), int(params[2]))
        elif params[0] == 'i':
            Play.setInstrument(int(params[1]), int(params[2]))
            
        print "{} wrote:".format(self.client_address[0])
        print data

if __name__ == "__main__":
    HOST, PORT = "0.0.0.0", 9999
    server = SocketServer.UDPServer((HOST, PORT), MyUDPHandler)
    server.serve_forever()
