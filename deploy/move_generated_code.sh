# Setup git credentials
git config --global user.name "$REPO_USER_NAME"
git config --global user.email "$REPO_USER_EMAIL"
git clone https://github.com/darkclown97/api.git


cd api

rm -rf go/
rm -rf js/
rm -rf ts/
rm -rf python/

# Copying the generated code from the source repository to the target repository
echo "Copying generated code to target repository..."
cp -r ../generated/* .

# Commit and push the changes
echo "Committing and pushing the changes..."
git add .
git commit -m "Update generated code"
git push https://x-access-token:${REPO_TOKEN}@github.com/darkclown97/api.git master