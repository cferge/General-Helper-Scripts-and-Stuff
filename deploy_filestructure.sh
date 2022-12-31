#!/bin/bash
chown -Rf cferge:cferge /home/cferge
cd /home/cferge

rsync -av -f"+ */" -f"- *" Docker cferge@homepi1.auroranetworx.us:/home/cferge
