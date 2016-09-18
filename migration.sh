##############################################################################################################
###  backup old machine's key items

mkdir -p ~/migration/home
cd ~/migration

# what is worth reinstalling?
brew leaves      		> brew-list.txt    # all top-level brew installs
brew cask list 			> cask-list.txt
npm list -g --depth=0 	> npm-g-list.txt


# then compare brew-list to what's in `brew.sh`
#   comm <(sort brew-list.txt) <(sort brew.sh-cleaned-up)

# let's hold on to these

cp ~/.extra ~/migration/home
cp ~/.z ~/migration/home

cp -R ~/.ssh ~/migration/home
cp -R ~/.gnupg ~/migration/home

cp /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist ~/migration  # wifi

cp ~/Library/Preferences/net.limechat.LimeChat.plist ~/migration
cp ~/Library/Preferences/com.tinyspeck.slackmacgap.plist ~/migration

cp -R ~/Library/Services ~/migration # automator stuff

cp -R ~/Documents ~/migration

cp ~/.bash_history ~/migration # back it up for fun?

cp ~/.gitconfig.local ~/migration

cp ~/.z ~/migration # z history file.

# sublime text settings
cp "~/Library/Application Support/Sublime Text 3/Packages" ~/migration


# iTerm settings.
  # Prefs, General, Use settings from Folder

# Finder settings and TotalFinder settings
#   Not sure how to do this yet. Really want to.

# Timestats chrome extension stats
#   chrome-extension://ejifodhjoeeenihgfpjijjmpomaphmah/options.html#_options
# 	gotta export into JSON through devtools:
#     copy(JSON.stringify(localStorage, null, '  '))
#     pbpaste > timestats-canary.json.txt

# Current Chrome tabs via OneTab

# software licenses like sublimetext


### end of old machine backup
##############################################################################################################