# Provide a key pair for signing.
#
# This script generates a key pair for signing builds.
# It requires the development tools to be installed in the Android tree.
#
# Copyright (C) 2024 Bliss Co-Labs

echo -e "\033[1;32m Generating signing keys... \033[0m\n"
echo -e "\033[0;33m You will only need to do this once \033[0m\n"
echo -e ""
subject='/C=US/ST=California/L=Mountain View/O=Android/OU=Android/CN=Android/emailAddress=contact@blisslabs.org'
mkdir vendor/bass/configs/signing
for x in testkey releasekey platform shared media sdk_sandbox bluetooth networkstack fullchain; do \
  ./development/tools/make_key vendor/bass/configs/signing/$x "$subject"; \
done
echo -e "\033[1;34m Generating Product Key... \033[0m\n"
echo -e ""
openssl genrsa > vendor/bass/configs/signing/privkey.pem
openssl req -new -x509 -key vendor/bass/configs/signing/privkey.pem > vendor/bass/configs/signing/fullchain.pem
echo -e "\033[1;34m Generating Certificate Key... \033[0m\n"
echo -e ""
openssl genrsa > vendor/bass/configs/signing/certkey.pem
openssl req -new -x509 -key vendor/bass/configs/signing/privkey.pem > vendor/bass/configs/signing/cert.pem