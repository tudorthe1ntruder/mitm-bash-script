# mitm-bash-script

MiTM Script designed for tricking a mobile device user to install a rogue CA file to allow for SSL interception.

How to use:

1. Host BurpSuite CA file in Kali's apache server
2. Overwrite hostapd & dnsmasq configuration files
3. Run shell script
4. Implement wildcard redirect rule in Burp to certificate path on webserver (eg:  http://10.0.0.1/Burp.cer)

When the victims will connect to the malicious WiFi network and try to hit any website they will be presented with a "profile install" iOS screen to install the fake CA. If victims are socially engineered to install it, you will be able to intercept SSL traffic for mobile applications.
