{ SIMPLE INDY 10 SSL CLIENT AND SERVER

  Written by Ralph Sickinger, Best Manufacturing Practices Center of Excellence (BMPCOE)

  e-mail: ralph@bmpcoe.org
  
  SSL CLIENT 10:
  This program is a simply TCP Client that makes an SSL connection on port 3000.  To connect
  to a server, enter the IP address of the server in the box labeled "Host:", and then press
  the "Connect" button.  Once a connection has been established, the client displays any text
  received from the server in the memo area.  To send text to the server, enter it in the
  available edit box, and then press [enter].

  SSL SERVER 10:
  This program establishes a TCP Server that listens for SSL connections on port 3000.  When a
  connection is received, the server responds with "Hello", and then listens for any other lines
  of text sent from the client.  When a line is received, it is echoed to the screen as well as
  back to the client.

  Note: in order to run this program, you must have libeay32.dll and ssleay32.dll installed where the
        application can find them  (either in the Windows System32 folder, or in the same folder as the
        application itself.  These files can be downloaded from:  http://indy.fulgan.com/SSL/

        The server also requires that the certificate files (sample.crt, sample.key, and sampleRoot.pem)
        be available in the same folder as the excutable.

  Changes from Indy 9:

  * In order to compile the application, you'll have to add the Indy 10 source folders to
    the Project/Options/Directories-Conditionals/Search Path;
    e.g: C:\Indy10\Lib\Core;C:\Indy10\Lib\System;C:\Indy10\Lib\Protocols

  * All instances of AThread.Connection.ReadLn (or WriteLn) must be changed to
    AContext.Connection.IOHandler.ReadLn

  * You must add the OnConnect method to check for SSL usage and set the passThrough property
    (see procedure IdTCPServerConnect).  This one is CRITICAL!

  * You will have to manually add "IdContext" to the "uses" clause.

}


