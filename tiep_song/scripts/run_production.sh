#!/usr/bin/env bash

set -e

flutter run \
  --flavor production \
  --dart-define=FLAVOR=production