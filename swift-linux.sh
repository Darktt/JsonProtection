#!/bin/bash
colima start
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  swift:latest bash