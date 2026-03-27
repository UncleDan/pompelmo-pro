# ⚠️ ATTENZIONE: FASE ALPHA
**Pompelmo Pro** è attualmente in **fase Alpha**. Il sistema è potenzialmente instabile e destinato a scopi di test. Utilizzalo a tuo rischio e scatta sempre uno snapshot prima di modifiche critiche!

# 🍊 Pompelmo Pro

**Pompelmo Pro** è un'architettura di sistema personalizzata basata su **Debian 13 (Trixie)**. È nata per chi cerca un ambiente Wayland ultra-minimalista, sicuro e "portatile", capace di trasformarsi in una ISO live pronta all'uso in pochi istanti.

Il nome deriva dalla sua natura: **Agrodolce**. Aspro come una Debian Minimal, dolce come l'integrazione fluida di KDE e Sway.

---

## 🚀 Caratteristiche Principali

* **Debian Trixie Base:** Sfrutta la stabilità di Debian 13 con i pacchetti bleeding-edge del 2026.
* **Dual Shell Workflow:**
    * **KDE Plasma (Minimal):** Per la gestione quotidiana e la massima compatibilità GUI.
    * **Sway:** Window Manager tiling nativo Wayland per la produttività estrema.
* **Foot Terminal (Server/Client):** Latenza di input quasi zero. Un singolo processo server gestisce tutte le istanze del terminale per risparmiare RAM e garantire aperture istantanee.
* **MX Engine Integration:** Strumenti MX Linux portati su Debian per snapshot, pulizia e installazione grafica.
* **Driverless Printing:** Supporto universale IPP Everywhere (AirPrint) per stampanti moderne (es. Triumph-Adler, Kyocera, HP) senza installare blob proprietari.
* **Container-Native:** Podman (con alias Docker) e Distrobox pre-configurati per far girare app di altre distro senza sporcare il sistema host.

---

## 🛠️ Requisiti

* Una installazione Debian Trixie eseguita via "netinstall" (si raccomanda di NON selezionare alcun ambiente desktop durante l'installazione di base).
* Accesso sudo configurato.
* Connessione internet attiva.

---

## 📦 Installazione Rapida

Clona questo repository e lancia lo script di setup:

```
git clone https://github.com/UncleDan/pompelmo-pro.git
cd pompelmo-pro
chmod +x install-pompelmo-core.sh
sudo ./install-pompelmo-core.sh
```

---

## 🧹 Gestione, Manutenzione e Backup

Il progetto integra gli strumenti MX direttamente nel menu applicazioni con icone dedicate che richiedono privilegi sudo graficamente tramite pkexec:

1. MX Cleanup (Pompelmo Edition): Pulisce cache APT, file temporanei e log vecchi. Eseguilo sempre prima di creare una ISO.
2. MX Snapshot: Trasforma il tuo sistema attuale in un file .iso avviabile e installabile. È il tuo backup definitivo.
3. MX Live USB Maker: Scrive le tue ISO personalizzate su chiavette USB con supporto alla persistenza.
4. MX Installer (minstall): L'installer grafico di MX per distribuire la tua configurazione Pompelmo su altri hardware.

---

## 🛡️ Sicurezza e Rete

* Firewall (UFW): Attivo di default con policy Deny Incoming.
* Porte Aperte: Sono aperte solo le porte 5353/udp (mDNS) e 631/tcp (CUPS) per permettere il rilevamento automatico delle stampanti in rete locale.
* Browser: Utilizza Konqueror come browser predefinito di sistema per mantenere il footprint minimo, espandibile via Flatpak/Discover.

---

## ⌨️ Shortcut Rapide (Sway)

* Mod + Return: Apre un nuovo terminale Foot Client.
* Mod + d: Avvia il runner delle applicazioni (se configurato).
* Mod + Shift + e: Esci da Sway.

---

## 🖋️ Credits

Creato da **Daniele Lolli (UncleDan)** feat. **Gemini AI**.

---

## 📄 Licenza

Distribuito sotto licenza MIT. Sentiti libero di modificare, hackerare e distribuire il tuo Pompelmo.

"Minimalismo non è mancanza di qualcosa, è semplicemente la quantità perfetta di tutto."