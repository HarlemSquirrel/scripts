#!/bin/bash

if command -v fastfetch >>/dev/null; then
  fastfetch
elif command -v sw_vers >>/dev/null; then
  printf "MacOS $(sw_vers -productVersion)\n"
fi

printf "\n\n Default shell: ${SHELL}\n"

if command -v node >>/dev/null; then
  printf "\n\n  Git\n"
  git --version
  git --no-pager config -l
fi

if command -v node >>/dev/null; then
  printf "\n\n  Node.js\n"
  printf "node $(node --version)\n"
  printf "npm $(npm --version)\n"
  printf "yarn $(yarn --version)\n"
fi

if command -v ruby >>/dev/null; then
  printf "\n\n  Ruby\n"
  ruby --version
  bundler --version
  if command -v rvm >>/dev/null; then
    rvm --version
  fi
fi

if command -v make >>/dev/null; then
  printf "\n\n  Make\n"
  make --version
fi

printf "\n\n  C\n"
if command -v clang >>/dev/null; then
  clang --version
fi

if command -v gcc >>/dev/null; then
  gcc --version
fi

if command -v cargo >>/dev/null; then
  printf "\n\n  Rust\n"
  cargo --version
  rustup --version
fi

if command -v brew >>/dev/null; then
  printf "\n\n  Homebrew\n"
  brew --version
  brew info
fi
