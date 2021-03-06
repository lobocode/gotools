#! /bin/bash
# Automatic download and install latest Golang release for AMD64
echo -e "\n Finding latest version of Go for AMD64... \n"
_GOurl="$(wget -qO- https://golang.org/dl/ | grep -oP 'https:\/\/dl\.google\.com\/go\/go([0-9\.]+)\.linux-amd64\.tar\.gz' | head -n 1 )"
latest="$(echo $_GOurl | grep -oP 'go[0-9\.]+' | grep -oP '[0-9\.]+' | head -c -2 )"
echo -e "\n Downloading latest Go for AMD64: ${latest} \n"

wget -c "${_GOurl}"

# Remove vars
unset _GOurl

# Remove Old Go
echo -e "\n Removing the old version \n"
sudo rm -rf /usr/local/go

# Install new Go
sudo tar -C /usr/local -xzf go"${latest}".linux-amd64.tar.gz
mkdir -p ~/go/{bin,pkg,src}
echo -e "\nSetting up GOPATH \n"
echo -e "\nexport GOPATH=~/go \nexport GOROOT=/usr/local/go\n" >> ~/.bashrc && source ~/.bashrc
echo -e "\nSetting PATH to include golang binaries \n"
echo -e "\nexport PATH='$PATH':/usr/local/go/bin:$GOPATH/bin \n" >> ~/.bashrc && source ~/.bashrc 
echo -e "\nInstalling dep for dependency management \n"
go get -u github.com/golang/dep/cmd/dep

# Remove Download
echo -e "\nRemoving junk file\n"
rm go"${latest}".linux-amd64.tar.gz

# Print Go Version
echo -e "\n Check GO version \n"
/usr/local/go/bin/go version
