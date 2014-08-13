#!/bin/bash

ruby -e 'require "securerandom"; print SecureRandom.hex(64)' > ~/.secret_key_base
export SECRET_KEY_BASE=`cat ~/.secret_key_base`
