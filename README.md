# AzureIot-NHDNUG

## How to send sensor data from the GizWits esp8266 Development Board (running NodeMCU) to Azure Event Hubs

### Step 1: Set up your Event Hub

**Fairly straightforward process, make a note of the following pieces of information:**
  - Namespace
  - Name
  - URL
  - SharedAccessKeyName
  - SharedAccessKey
  
**Download the Shared Access Signature generator:**
  https://github.com/sandrinodimattia/RedDog/releases/tag/0.2.0.1
  Use this tool to generate a shared access signature with a long ttl. Copy the key directly into your token.lua file.

### Step 2: Flash your esp8266 with a custom ROM

**Use the awesome build service: http://nodemcu-build.com/**
I recommend choosing the dev branch instead of master. 
Pick the modules you need, but don't forget to choose SSL (required for Azure)

**Download the NodeMCU flasher for Win32/Win64:**
  https://github.com/nodemcu/nodemcu-flasher/blob/master/Win32/Release/ESP8266Flasher.exe
  https://github.com/nodemcu/nodemcu-flasher/blob/master/Win64/Release/ESP8266Flasher.exe

**Connect your board to your PC via a USB to MicroUSB cable**
  Load the flasher program. It should recognize the chip as COM3. Point the flasher at the ROM you downloaded and you are set to go. After flashing, close the flasher app.

### Step 3: Upload your code to the esp8266  ###

**Open up the nhdnug.lua and token.lua files in Visual Studio Code or your favorite editor.**
  In nhdnug, on line 39, replace the string "[namespace]" with your Event Hub namespace. Make sure you replaced the contents of the token.lua file with shared access signature from step 1.
  
**Download Lua Loader: http://benlo.com/esp8266/#LuaLoader**
  This app will let you upload files to your esp8266. Use the "Upload File" button to upload the token.lua and nhdnug.lua files to your esp8266. Then use the "dofile" button to run nhdnug.lua. 


