#!/bin/bash
docker start -ai its_mt 2>/dev/null || docker run -it --platform linux/arm64 \
    -v /Users/marctoiflhart/MT_VM_SHARED/:/shared -e DISPLAY=host.docker.internal:0 \
    --env="QT_X11_NO_MITSMH=1" --name its_mt its-mt:arm64 /bin/bash
