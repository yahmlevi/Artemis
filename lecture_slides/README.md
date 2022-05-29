running on Windows is problematic. run on linux tutorial https://www.rosehosting.com/blog/how-to-install-reveal-js-on-ubuntu-20-04/  -  linux machine (YahmTests - 192.168.114.177)


# create new branch and push
git checkout -b [name_of_your_new_branch]
git commit -am "your commit message"
git push origin [name_of_your_new_branch]

# switch to remote branch
git fetch origin <branchName>
git checkout <branchName>

# change name + email
git config --global user.name "johnnyonline"
git config --global user.email johnnyonline.eth@gmail.com

git config --global user.name "yahml"
git config --global user.email yahml@ctera.com