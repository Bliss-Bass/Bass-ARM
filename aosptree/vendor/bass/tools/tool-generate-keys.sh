# Provide a key pair for signing.
#
# This script generates a key pair for signing builds.
# It requires the development tools to be installed in the Android tree.
#
# Copyright (C) 2024 BlissLabs

subject='/C=US/ST=California/L=Mountain View/O=Android/OU=Android/CN=Android/emailAddress=contact@blisslabs.org'
mkdir vendor/tesla-android/signing
for x in testkey releasekey platform shared media sdk_sandbox bluetooth networkstack fullchain; do \
  ./development/tools/make_key vendor/tesla-android/signing/$x "$subject"; \
done

openssl genrsa > vendor/tesla-android/signing/privkey.pem
openssl req -new -x509 -key vendor/tesla-android/signing/privkey.pem > vendor/tesla-android/signing/fullchain.pem

openssl genrsa > vendor/tesla-android/signing/certkey.pem
openssl req -new -x509 -key vendor/tesla-android/signing/certkey.pem > vendor/tesla-android/signing/cert.pem