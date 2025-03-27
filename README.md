# 🚀 ITS-MT Docker Image  

Das ITS-MT Docker-Image basiert auf Debian 12 und ist an die VM angepasst, die in der Lehrveranstaltung Medien-Technologie Labor verwendet wird. Es bietet eine vorkonfigurierte Umgebung für eine einfache und schnelle Entwicklung.

🔹 Plattformunabhängig: Das Image läuft auf Windows, macOS und Linux und unterstützt sowohl AMD64- als auch ARM64-Systeme.

🔹 Flexible Nutzung: Es kann im Headless-Modus verwendet oder mit einer grafischen Benutzeroberfläche (XFCE) gestartet werden (siehe unten).

🔹 Einfache Integration: Das Image kann direkt in Visual Studio Code integriert werden, um eine nahtlose Entwicklungsumgebung zu schaffen.

🔹 Freigegebene Verzeichnisse: Ein Shared Folder ermöglicht den einfachen Datenaustausch zwischen Host und Container.

## 🛠 Voraussetzungen  
### 1️⃣ **Docker installieren**  
Falls noch nicht installiert, lade Docker herunter und installiere es:  

- **Linux:**  
  ```sh
  sudo apt install docker.io
  ```
- **macOS & Windows:**  
  Installiere [Docker Desktop](https://www.docker.com/products/docker-desktop) und stelle sicher, dass es läuft.  

### 2️⃣ **Pulseaudio (für macOS)**

Für macOS-Nutzer, die mit Audio arbeiten möchten, muss Pulseaudio installiert und konfiguriert werden:

#### 📥 Pulseaudio installieren

Falls noch nicht installiert, kannst du Pulseaudio über Homebrew installieren:
```sh
brew install pulseaudio
```

#### 🛠 Pulseaudio starten

Um Pulseaudio zu starten und sicherzustellen, dass es auch nach einem Neustart läuft:
```sh
pulseaudio --load="module-native-protocol-tcp auth-ip-acl=0.0.0.0/0" --exit-idle-time=-1 --daemon
```


#### 🎧 Audiogerät auswählen
Um das richtige Audiogerät für Pulseaudio auszuwählen muss Pulseaudio wie oben beschrieben gestartet werden.
Mit folgendem Command können alle verfügbaren Audiogeräte ausgegeben werden:
```sh
pactl list sinks
```

Alle Audiogeräte werden mit einer Nummer und deren Name aufgelistet. Um ein Audiogerät auszuwählen 
kann folgendes Command verwendet werden:
```sh
pactl set-default-sink {Ziel ID}
```

## ℹ️ **GUI-Support für Windows- & macOS-Nutzer**  
Falls du GUI-Anwendungen verwendest, benötigst du einen X-Server:  

### 🖥️ **Windows (mit VcXsrv oder X410)**  
- Installiere [VcXsrv](https://sourceforge.net/projects/vcxsrv/) oder [X410](https://x410.dev/)  
- Starte den X-Server vor dem Container, damit grafische Programme funktionieren.  

### 🍏 **macOS (mit XQuartz)**  
- Installiere [XQuartz](https://www.xquartz.org/)  
- Starte XQuartz und erlaube Verbindungen von Netzwerkclients in den Einstellungen  
- Setze die DISPLAY-Variable mit:  
  ```sh
  export DISPLAY=:0
  ```
- Erlaube X11-Verbindungen für Docker:  
  ```sh
  xhost +localhost
  ```

Falls Probleme mit der Anzeige auftreten, überprüfe, ob dein X-Server läuft und die Access-Control korrekt gesetzt ist.  


## 📦 Installation & Nutzung  

### 2️⃣ **Container aus Image erstellen**  
Dies ist nur einmal erforderlich, um den Container anzulegen. Er wird mit einem freigegebenen Ordner (`/shared`) verbunden.  

🔹 **Ersetze `{PFAD_HOST}` mit dem absoluten Pfad auf deinem Host-System!**  

#### 🖥️ **Für ARM64-Systeme (Apple Silicon, Raspberry Pi, etc.)**  
```sh
docker run -it --platform "linux/arm64" \
    -v "{PFAD_HOST}:/shared" \
    -e DISPLAY=host.docker.internal:0 \
    --env="QT_X11_NO_MITSHM=1" \
    -e PULSE_SERVER=host.docker.internal \
    -v ~/.config/pulse/:/home/pulseaudio/.config/pulse \
    --name its_mt \
    ghcr.io/marc0908/its_mt:latest /bin/bash
```

#### 🖥️ **Für AMD64-Systeme (Intel/AMD PCs, Laptops, Server)**  
```sh
docker run -it --platform "linux/amd64" \
    -v "{PFAD_HOST}:/shared" \
    -e DISPLAY=host.docker.internal:0 \
    --env="QT_X11_NO_MITSHM=1" \
    -e PULSE_SERVER=host.docker.internal \
    -v ~/.config/pulse/:/home/pulseaudio/.config/pulse \
    --name its_mt \
    ghcr.io/marc0908/its_mt:latest /bin/bash
```

### 3️⃣ **Container starten (nach dem ersten Erstellen)**  
Falls der Container bereits existiert, starte ihn einfach erneut:  
```sh
docker start -ai its_mt
```

### 4️⃣ **Container beenden**
Der Container kann mit folgendem `Command` oder in `Docker Desktop` gestoppt werden.
```sh
docker stop its_mt
```

### 5️⃣ **Container löschen (falls nötig)**  
Falls du einen neuen Container mit demselben Namen erstellen möchtest, lösche den alten zuerst:  
```sh
docker rm -f its_mt
```

## 🛠 **Arbeiten mit dem Container in Visual Studio Code**  
Mit VS Code kannst du direkt im Docker-Container entwickeln. Dazu benötigst du die **Docker-Extension** und die **Remote - Containers**-Extension.  

### 📥 **1. Erweiterungen installieren**  
Installiere die folgenden VS Code Extensions:  
- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### 🔗 **2. Mit Container verbinden**  
1. Öffne VS Code.
2. Klicke links auf das **Docker-Icon**.
3. Rechtsklick auf `docker.io/marctoiflhart/its_mt:latest` .
4. Falls der Container noch nicht gestartet wurde **"Start"**
5. Läuft der Container kann VSC attached werden **"Attach Visual Studio Code"**
6. VS Code öffnet den Container als Entwicklungsumgebung.

## ⚠️ **Häufige Fehler & Lösungen**  

### ❌ **Fehler: Container-Name bereits vergeben**  
#### 📌 **Fehlermeldung:**  
```sh
docker: Error response from daemon: Conflict. The container name "/its_mt" is already in use by container "...".
You have to remove (or rename) that container to be able to reuse that name.
```

#### ✅ **Lösung:**  
Lösche den bestehenden Container oder wähle einen anderen Namen:  
🚨 **Achtung - das löscht den Container und alle Daten darin**  
```sh
docker rm -f its_mt
```
ODER:  
```sh
docker run -it --name its_mt_v2 ghcr.io/marc0908/its_mt:latest /bin/bash
```

---

### ❌ **Fehler: Langsamer Download des Docker-Images**  
#### ✅ **Lösung:**  
Falls der Download von **GitHub Container Registry (GHCR)** zu langsam ist, versuche stattdessen Docker Hub:  
```sh
docker run -it --platform "linux/amd64" \
    -v "{PFAD_HOST}:/shared" \
    --name its_mt \
    docker.io/marctoiflhart/its_mt:latest /bin/bash
```

---

### ❌ **Fehler: `DISPLAY`-Variable nicht gesetzt (GUI funktioniert nicht)**  
#### 📌 **Fehlermeldung:**  
```sh
Error: Can't open display:
```

#### ✅ **Lösung:**  
1. Stelle sicher, dass dein X-Server läuft (XQuartz, VcXsrv, X410)  
2. Setze die `DISPLAY`-Variable korrekt (Docker-Container):  
   ```sh
   export DISPLAY=host.docker.internal:0
   ```
3. Erlaube X11-Zugriff (Host-System):  
   ```sh
   xhost +localhost
   ```

---

Falls weitere Fehler auftreten, erstelle ein **Issue** auf [GitHub](https://github.com/marc0908/its_mt_image/issues). 🚀

