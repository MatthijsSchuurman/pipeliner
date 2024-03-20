FROM alpine:edge

RUN apk --no-cache add \
    gcc \
    musl-dev \
    ghc \
    cabal

# Takes too long to install hlint
#RUN cabal update && \
#    cabal install --installdir /usr/local/bin --overwrite-policy=always --install-method=copy hlint

WORKDIR /work