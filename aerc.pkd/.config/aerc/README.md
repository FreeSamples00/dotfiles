# Local Mail Setup

## General Set-Up

1. Install:
   a. `aerc` -> CLI email client
   b. `notmuch` -> mailbox indexer
   c. `isync` -> contains `mbsync`
   d. `proton mail bridge` -> for connection to proton accounts

2. Dependencies
   a. `imgcat` -> view images
   b. `w3m` -> render html nicely
   c. `lf` -> file picker
   d. `pick` -> option picker

3. Symlink configs into position

4. Run `/Applications/Proton Mail Bridge.app/Contents/MacOS/bridge -c`, then `cert install`. This will allow for proton accounts.

## Launchtl Job

**Link plist**

```bash
ln -s ~/dotfiles/mail.pkd/.config/mail-scripts/com.user.mail-fetch.plist  ~/Library/LaunchAgents/com.user.mail-fetch.plist
```

**Start job**

```bash
launchctl load ~/Library/LaunchAgents/com.user.mail-fetch.plist
```

## Auth Setup

**Add Credential**

```bash
security add-generic-password \
 -a "NAME" \
 -s "NAME" \
 -w "AUTH_SECRET" \
 -T /opt/homebrew/bin/mbsync
```

**Retrieve Credential**

```bash
security find-generic-password -w -s "NAME"
```

`security` will prompt on first run, authenticate and choose `always allow` to white list `mbysnc`.

## Office365

This method spoofs the client_id of thunderbird to generate an oauth token. Using methods from [here](https://lukaswerner.com/post/2024-07-08@aerc-outlook).

Use this [mutt_oauth2.py](https://gitlab.com/muttmua/mutt/-/blob/master/contrib/mutt_oauth2.py) script.

**Modifications**:

```diff
--- foo.py	2026-03-04 03:38:15
+++ mutt_oauth2.py	2026-03-04 03:24:30
@@ -45,8 +45,8 @@
 # encryption and decryption pipes you prefer. They should read from standard
 # input and write to standard output. The example values here invoke GPG,
 # although won't work until an appropriate identity appears in the first line.
-ENCRYPTION_PIPE = ["gpg", "--encrypt", "--recipient", "YOUR_GPG_IDENTITY"]
-DECRYPTION_PIPE = ["gpg", "--decrypt"]
+ENCRYPTION_PIPE = ["tee"]
+DECRYPTION_PIPE = ["tee"]

 registrations = {
     "google": {
@@ -77,7 +77,7 @@
             "https://outlook.office.com/POP.AccessAsUser.All "
             "https://outlook.office.com/SMTP.Send"
         ),
-        "client_id": "",
+        "client_id": "9e5f94bc-e8a4-4e73-b8be-63364c29d753",
         "client_secret": "",
     },
 }
```

**Setup**

```bash
python3 mutt_oauth2.py --authorize TOKEN_NAME
```

Enter:

1. microsoft
2. devicecode
3. EMAIL_ADDRESS
4. Follow web browser prompts

Token is now saved under TOKEN_NAME

**Testing**

If this runs without error it should be good to go.

```bash
python3 mutt_oauth2.py TOKEN_NAME --test
```

**Usage**

Use this for xoauth2 `cred-cmd`s

```bash
python3 /path/to/mutt_oauth2.py /path/to/TOKEN_NAME
```
