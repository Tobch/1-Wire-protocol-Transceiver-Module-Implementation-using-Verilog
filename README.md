This project simulates a One-Wire Communication System between two devices:

•Master (Transmitter - TX) → Sends data bits over a single wire

•Slave (Receiver - RX) → Listens to the wire, reads the data, and acknowledges with a presence pulse

All of this happens using just one data wire (plus ground) — like how some sensors (e.g., DS18B20 temperature sensor) communicate with microcontrollers using the Dallas One-Wire protocol.


What Does It Do?

-------> Master (TX Module):

•Sends a reset signal to start communication

•Sends an 8-bit data byte, one bit at a time:

oSends a “1” → short low pulse

oSends a “0” → longer low pulse




-------> Slave (RX Module):

•Detects the master’s reset signal

•Sends a presence pulse to say “I’m here”

•Listens for the 8 data bits

•Assembles and outputs the received byte
