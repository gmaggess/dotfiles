# Grab my $PATHs from ~/.extra
#set -l PATH_DIRS (cat "$HOME/.extra" | grep "^PATH" | \
#    clean up bash PATH setting pattern
#    sed "s/PATH=//" | sed "s/\\\$PATH://" | \
#    rewrite ~/ to use {$HOME}
#    sed "s/~\//{\$HOME}\//")
#
#
#set -l PA ""

for entry in (string split \n $PATH_DIRS)
    resolve the {$HOME} substitutions
    set -l resolved_path (eval echo $entry)
    if test -d "$resolved_path"; and not contains $resolved_path $PATH
        set PA $PA "$resolved_path"
    end
end

# set PA $PA /Users/gmaggessy/.rvm/gems/ruby-2.3.0/bin
set -gx JAVA_HOME /Library/Java/Home # JAVA_HOME
set -gx GRADLE_HOME /usr/local/Cellar/gradle/3.1 # GRADLE_HOME

set --export PATH $PA

#set -gx PATH $GRADLE_HOME/bin $JAVA_HOME/bin $PATH
#set fish_user_paths $fish_user_paths $GRADLE_HOME/bin $JAVA_HOME/bin