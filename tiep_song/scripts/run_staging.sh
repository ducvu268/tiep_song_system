#!/usr/bin/env bash

set -e

flutter run \
  --flavor staging \
  --dart-define=FLAVOR=staging