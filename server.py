import socket


def server_program():
    # get the hostname
    host = socket.gethostname()
    port = 5000  # initiate port no above 1024

    server_socket = socket.socket()  # get instance
    # look closely. The bind() function takes tuple as argument
    server_socket.bind((host, port))  # bind host address and port together

    # configure how many client the server can listen simultaneously
    print(f"listenin on {str(host)}:{port}")
    server_socket.listen(1)
    conn, address = server_socket.accept()  # accept new connection
    print("Connection from: " + str(address))
    while True:
        # receive data stream. it won't accept data packet greater than 1024 bytes*
        print('1- receive togocom transaction')
        print('2- receive moov transaction')
        n = int(input())
        
        if n == 1:
            data = "NUMERO TOGOCOM"
            d = {
            'ref':'75264265675272',
            'type':'Togocom',
            'opType':'Retrait'
            'amount':20000,
            'date':'21-01-21',
            'time':'17:09:00',
            'amountAfter':40000
        }
            conn.send(data.encode())
        if n == 2:
            data = "NUMERO MOOV"
            d = {
            'ref':'75264265675272',
            'type':'Moov',
            'opType':'Retrait'
            'amount':20000,
            'date':'21-01-21',
            'time':'17:09:00',
            'amountAfter':40000
        }
            conn.send(data.encode())

        """data = conn.recv(1024).decode()
        if not data:
            # if data is not received break
            break
        print("from connected user: " + str(data))"""
  # send data to the client

    conn.close()  # close the connection