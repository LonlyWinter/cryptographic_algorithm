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
hex_str = "0123456789abcdefff"
data = bytes.fromhex(hex_str)[::-1]
ser.write(data)
# %%
hex_str = "636f6d70757465720f"
data = bytes.fromhex(hex_str)[::-1]
ser.write(data)
v = ser.read(size=16)[::-1].hex()
print(v)
# %%
hex_str = "6a7d7274181d689ff0"
data = bytes.fromhex(hex_str)[::-1]
ser.write(data)
v = ser.read(size=16)[::-1].hex()
print(v)
# %%
ser.close()
# %%
