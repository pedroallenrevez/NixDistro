{
  enable = true;
  enableAutosuggestions = true;
  enableCompletion = true;
  enableSyntaxHighlighting = true;
  autocd = true;
  history.share = true;
  dotDir = ".config/zsh";
  shellGlobalAliases = {
    "..." = "../..";
    "...." = "../../..";
    "....." = "../../../...";
  };
  shellAliases = {
    d = "direnv";
    g = "git";
    jc = "journalctl";
    la = "exa -lah";
    l = "exa -lh";
    ls = "exa";
    md = "mkdir -p";
    n = "nix";
    rd = "rmdir";
    sc = "systemctl";
    "_" = "sudo ";
  };
  initExtra = ''
    function j() {

        if [ $# -eq 0 ]; then
          _j_dir="$(fd --type d '\.git$' --hidden $HOME/src/ -d5 --prune | xargs dirname | fzf)"
        else
          _j_dir=$(command h --resolve $HOME/src/ "$@")
        fi

        _j_ret=$?

        [ "$_j_dir" != "$PWD" ] && cd "$_j_dir"
        return $_j_ret
    }

    alias kak="~/src/github.com/mawww/kakoune/src/kak"

    export EDITOR="/home/blaggacao/src/github.com/mawww/kakoune/src/kak"
    export GPG_TTY=$(tty)


    eval "$(h --setup ~/src)"

    ######################################### oh-my-zsh/lib/key-bindings.zsh #########################################
    # Start typing + [Up-Arrow] - fuzzy find history forward
    if [[ "''${terminfo[kcuu1]}" != "" ]]; then
      autoload -U up-line-or-beginning-search
      zle -N up-line-or-beginning-search
      bindkey "''${terminfo[kcuu1]}" up-line-or-beginning-search
    fi
    # Start typing + [Down-Arrow] - fuzzy find history backward
    if [[ "''${terminfo[kcud1]}" != "" ]]; then
      autoload -U down-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "''${terminfo[kcud1]}" down-line-or-beginning-search
    fi

    bindkey '^[[127;5u' backward-kill-word                  # [Ctrl-Backspace] - delete whole backward-word
    bindkey '^[[127;2u' backward-kill-word                  # [Shift-Backspace] - delete whole backward-word
    bindkey '^[[127;4u' backward-kill-line                  # [Shift-Alt-Backspace] - delete line up to cursor
    bindkey '^[[3;5~' kill-word                             # [Ctrl-Delete] - delete whole forward-word
    bindkey '^[[3;2~' kill-word                             # [Shift-Delete] - delete whole forward-word
    bindkey '^[[3;4~' kill-line                             # [Shift-Alt-Delete] - delete line from cursor
    bindkey '^[[Z' reverse-menu-complete                    # [Shift-Tab] - move through the completion menu backwards
    bindkey '^[[1;5C' forward-word                          # [Ctrl-RightArrow] - move forward one word
    bindkey '^[[1;5D' backward-word                         # [Ctrl-LeftArrow] - move backward one word
    ##################################################################################################################
  '';
}
