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
hex_str = "ff0123456789abcdef"
data = bytes.fromhex(hex_str)
ser.write(data)
# %%
hex_str = "0f636f6d7075746572"
data = bytes.fromhex(hex_str)
ser.write(data)
v = ser.read(size=16).hex()
print(v)
# %%
hex_str = "f06a7d7274181d689f"
data = bytes.fromhex(hex_str)
ser.write(data)
v = ser.read(size=16).hex()
print(v)
# %%
ser.close()
# %%
