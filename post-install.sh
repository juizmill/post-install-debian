#!/bin/bash

cd /tmp

RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED}>>> ADD NAMESERVER GOOGLE <<<${NC}"
sudo echo > /etc/resolv.conf
sudo echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo -e "${RED}>>> Edit Source List <<<${NC}"
sudo mv /etc/apt/sources.list /etc/apt/sources.list-BKP
sudo touch /etc/apt/sources.list
cat << EOF | sudo tee -a /etc/apt/sources.list
deb [arch=amd64] http://ftp.br.debian.org/debian/ stable main contrib non-free
deb [arch=amd64] http://ftp.br.debian.org/debian/ stable-updates main contrib non-free
deb [arch=amd64] http://security.debian.org/ stable/updates main contrib non-free
EOF

echo -e "${RED}>>> Update and upgrade <<<${NC}"
sudo apt update && sudo upgrade -y

echo -e "${RED}>>> Install Fonts <<<${NC}"
wget https://github.com/tonsky/FiraCode/releases/download/4/Fira_Code_v4.zip
sudo unzip Fira_Code_v4.zip
sudo cp ttf/*.ttf /usr/share/fonts

echo -e "${RED}>>> Install default <<<${NC}"
sudo apt install git vim bash-completion snapd libavcodec-extra filezilla gnome-tweak-tool gnome-backgrounds dconf zsh screenfetch -y
sudo apt autoremove

echo -e "${RED}>>> Gnome cedilla fix <<<${NC}"
wget -q https://raw.githubusercontent.com/marcopaganini/gnome-cedilla-fix/master/fix-cedilla -O fix-cedilla
sudo chmod 755 fix-cedilla
./fix-cedilla

echo -e "${RED}>>> Gnome dash fix <<<${NC}"
wget https://raw.githubusercontent.com/BenJetson/gnome-dash-fix/master/appfixer.sh
sudo chmod +x appfixer.sh
./appfixer.sh

echo -e "${RED}>>> Install Development Tool <<<${NC}"
sudo snap install sublime-text --classic
sudo snap install code --classic
sudo snap install dbeaver-ce
sudo snap install insomnia

echo -e "${RED}>>> Configure Interface <<<${NC}"
sudo apt install numix-icon-theme
wget https://github.com/EliverLara/Sweet/releases/download/v1.10.5/Sweet-Dark.zip
sudo unzip Sweet-Dark.zip
sudo cp -r Sweet-Dark /usr/share/themes/

git clone https://github.com/EliverLara/Sweet-folders.git
sudo cp -r Sweet-folders/* /usr/share/icons/

# Change GTK-Theme
gsettings set org.gnome.desktop.interface gtk-theme "Sweet-Dark"

# Change Window-Theme
gsettings set org.gnome.desktop.wm.preferences theme "Sweet-Dark"

# Change Icon-Theme:
gsettings set org.gnome.desktop.interface icon-theme 'Sweet-Rainbow'

echo -e "${RED}>>> Install Docker <<<${NC}"
sudo apt remove docker docker-engine docker.io containerd runc -y
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt update
sudo apt autoremove
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker $USER
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo -e "${RED}>>> Configure environment development <<<${NC}"
sudo apt autoremove
sudo apt install curl wget gnupg2 ca-certificates lsb-release apt-transport-https -y
sudo wget https://packages.sury.org/php/apt.gpg
sudo apt-key add apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php7.list

echo -e "${RED}>>> Install PHP 7.4 <<<${NC}"
sudo apt install php7.4 php7.4-cli php7.4-common php7.4-bcmath php7.4-mbstring php7.4-xml php7.4-zip php7.4-mysql php7.4-pgsql php7.4-gd php7.4-fpm -y

echo -e "${RED}>>> Install PHP 7.3 <<<${NC}"
sudo apt install php7.3 php7.3-cli php7.3-common php7.3-bcmath php7.3-mbstring php7.3-xml php7.3-zip php7.3-mysql php7.3-pgsql php7.3-gd php7.4-fpm -y

echo -e "${RED}>>> Install PHP 7.2 <<<${NC}"
sudo apt install php7.2 php7.2-cli php7.2-common php7.2-bcmath php7.2-mbstring php7.2-xml php7.2-zip php7.2-mysql php7.2-pgsql php7.2-gd php7.4-fpm -y

sudo update-alternatives --set php /usr/bin/php7.4

echo -e "${RED}>>> Install nginx <<<${NC}"
sudo apt remove apache* -y
sudo apt purge apache* -y
sudo apt autoremove
sudo apt install nginx-full -y

echo -e "${RED}>>> Install Nodejs <<<${NC}"
curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
sudo apt install -y nodejs

echo -e "${RED}>>> Install Yarn <<<${NC}"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install --no-install-recommends yarn
sudo apt autoremove

echo -e "${RED}>>> Install Install oh-my-zsh <<<${NC}"
sudo chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd $HOME
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
sudo sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="spaceship"/g' $HOME/.zshrc 

cat << EOF | sudo tee -a $HOME/.zshrc
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
EOF

sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

cat << EOF | sudo tee -a $HOME/.zshrc
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
EOF

echo -e "${RED}>>> ADD Alias <<<${NC}"
cat << EOF | sudo tee -a $HOME/.zshrc
alias php74="sudo update-alternatives --set php /usr/bin/php7.4"
alias php73="sudo update-alternatives --set php /usr/bin/php7.3"
alias php72="sudo update-alternatives --set php /usr/bin/php7.2"
EOF

cat << EOF | sudo tee -a $HOME/.bashrc
alias php74="sudo update-alternatives --set php /usr/bin/php7.4"
alias php73="sudo update-alternatives --set php /usr/bin/php7.3"
alias php72="sudo update-alternatives --set php /usr/bin/php7.2"
EOF

cd $HOME

screenfetch
