# %%
# pip install pyserial
# %%
import serial
# %%
ser = serial.Serial(
    port="/dev/ttyACM0",
    baudrate=9600,
    bytesize=8,
    timeout=3
)
# %%
hex_str = "FF133457799BBCDFF1"
data = bytes.fromhex(hex_str)
ser.write(data)
# %%
hex_str = "0f0123456789abcdef"
data = bytes.fromhex(hex_str)
ser.write(data)
v = ser.read(size=16).hex()
print(v)
# %%
hex_str = "f085E813540F0AB405"
data = bytes.fromhex(hex_str)
ser.write(data)
v = ser.read(size=16).hex()
print(v)
# %%
ser.close()
# %%
