#!/bin/bash
echo "Started"
mkdir result

mkdir ~/.aws
touch ~/.aws/credentials
cat > ~/.aws/credentials  <<EOF 
[default]
aws_access_key_id=$aws_access_key_id
aws_secret_access_key=$aws_secret_access_key
EOF

base_name=$(basename ${file_path})
xpath=${file_path%/*}

aws s3 cp s3://spext-project/$file_path $base_name


ffmpeg -re -i $base_name -map 0 -map 0 -c:a aac -c:v libx264 -b:v:0 1000k -b:v:1 600k -b:v:2 300k -s:v:1 640x360 -s:v:2 320x170 -profile:v:2 baseline -profile:v:0 main -bf 1 -keyint_min 120 -g 120 -sc_threshold 0 -b_strategy 0 -ar:a:1 22050 -use_timeline 1 -use_template 1 -window_size 5 -seg_duration 1000 -adaptation_sets "id=0,streams=v id=1,streams=a" -f dash result/output_manifest.mpd

aws s3 cp /src/result/ s3://spext-project-public/$xpath/result --recursive
rm -r result
rm -r $base_name


curl -X POST -H "Content-Type: application/json" -d '{"s3_file_path": "'${file_path}'"}' https://spext-project.staytools.com/transcode_completed