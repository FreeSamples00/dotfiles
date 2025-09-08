from pydexcom import Dexcom


# TODO:
# - make this a background process w/ launchctl
# - mainloop:
#   - authenticate on run
#   - fetch data, dump to /tmp
#   - calculate time till next reading
#   - wait till next reading
# - if no reading make that clear so it is displayed as stale

# expects line1: username, line2: password
SECRETS_FILE="./dexcom_secrets.priv"

def dexcom_setup():
    with open(SECRETS_FILE) as f:
        secrets = f.readlines()
        username = secrets[0].strip()
        password = secrets[1].strip()

    return Dexcom(username=username, password=password)

def main():
    
    dexcom = dexcom_setup()

    dexcom = dexcom_setup()
    reading = dexcom.get_current_glucose_reading()

    print(f"{reading.value} {reading.trend_arrow}")


if __name__ == "__main__":
    main()
