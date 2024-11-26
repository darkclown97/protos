# Setup git credentials
git config --global user.name "$GITHUB_USER_NAME"
git config --global user.email "$GITHUB_USER_EMAIL"
git clone https://github.com/darkclown97/api.git


cd api

rm -rf go/
rm -rf js/

# Copying the generated code from the source repository to the target repository
echo "Copying generated code to target repository..."
cp -r ../generated/* .

# Commit and push the changes
echo "Committing and pushing the changes..."
git add .
git commit -m "Update generated code"
git push https://x-access-token:${GITHUB_TOKEN}@github.com/darkclown97/api.git master