@echo off

powershell -ExecutionPolicy bypass -file test.ps1

pushd ..\..\projects\on
cd _upload
aws s3 rm s3://siboroc2/latest.json
aws s3 rm s3://siboroc2/packs/news.html
aws s3 rm s3://siboroc2/packs/packages.json
aws s3 cp --recursive --acl public-read  . s3://siboroc2
cd ..
popd

