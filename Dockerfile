FROM ocaml/opam:alpine
# Install fstar and clean up
# `unsafe-yes` is there to prevent opam [apk install] prompts
# add --no-depexts to remove python3-distutils dependency from z3
RUN sudo apk add opam
RUN opam init --auto-setup --disable-sandboxing --yes \
    && eval $(opam env --switch=default) \
    && opam pin add -y --confirm-level=unsafe-yes --no-depexts fstar --dev-repo \
    && opam clean -a -c -s --logs

CMD ["/bin/bash", "--login"]

