# Scoreboard_service

Flutter Project (tested on android emulator)
- authorization with name
- adding new scores
- storing in db
- sorting
- removing

# How to create and install

1. git clone https://github.com/Goolpe/scoreboard_service.git
2. flutter pub get
3. if you haven't key run ```keytool -genkey -v -keystore c:/Users/USER_NAME/key.jks -storetype JKS -keyalg RSA -keysize 
2048 -validity 10000 -alias key``` (change USER_NAME)
4. update android/key.properties
5. flutter build apk --split-per-abi
6. flutter install

# Screenshots

<img src="https://raw.githubusercontent.com/Goolpe/scoreboard_service/master/assets/0.png" width="200" />
<img src="https://raw.githubusercontent.com/Goolpe/scoreboard_service/master/assets/1.png" width="200" />
<img src="https://raw.githubusercontent.com/Goolpe/scoreboard_service/master/assets/2.png" width="200" />