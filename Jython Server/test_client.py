import socket
import sys

HOST, PORT = "localhost", 9999
data = "n/60/1000/0"

# SOCK_DGRAM is the socket type to use for UDP sockets
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# As you can see, there is no connect() call; UDP has no connections.
# Instead, data is directly sent to the recipient via sendto().
sock.sendto(data, (HOST, PORT))

print "Sent:     {}".format(data)
