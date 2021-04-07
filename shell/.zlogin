# Execute in background
{
  # Check and compile.
  compile_file() {
    if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc) ]]; then
      zcompile ${1}
    fi
  }

  setopt EXTENDED_GLOB
  # Compile autocomplete cache
  for file in ${ZDOTDIR:-${HOME}}/.zcomp^(*.zwc)(.); do
    compile_file ${file}
  done

  # Compile all config files
  for file in ${ZDOTDIR:-${HOME}}/config/^*.zwc; do
      compile_file ${file}
  done


  # Compile .zshrc/.zprofile/zplugrc
  compile_file ${ZDOTDIR:-${HOME}}/.zshrc

} &!
