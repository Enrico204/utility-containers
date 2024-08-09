FROM node:lts

ARG MDTOC_VERSION
RUN npm install -g markdown-toc@${MDTOC_VERSION}

ENTRYPOINT ["/usr/local/bin/markdown-toc"]
