#!/bin/bash

# http://www.bunkus.org/videotools/mkvtoolnix/doc/mkvmerge.html

CmdPath="/usr/bin"
Charset="UTF-8"
#Charset="ISO_8859-15"

Delay="0"
#Delay="1000"

#clear
#echo "-----\nSet destination directory :"
#read UserTargetPath
#
#echo "-----\nSet videos path location :"
#read UserVideoFilePath
#
#echo "-----\nSet subtitles path location :"
#read UserSubFilePath
#

TargetPath="{{ download_path }}/Muxed/"
WorkPath="{{ download_path }}/@ToMux/"
VideoFilePath="{{ download_path }}/@ToMux/Vids/"
SubFilePath="{{ download_path }}/@ToMux/Subs/"

FileNumber=`ls "$VideoFilePath"|wc -l`
NumberCount=`expr $FileNumber - 1`

# Clean Synology specific directories
rm -rf $VideoFilePath\@eaDir
rm -rf $SubFilePath\@eaDir

# Remove spaces in filenames
for file in $VideoFilePath/* ; do newfile=$( echo "$file" | tr -d \\n | sed 's/ //g' );
   test "$file" != "$newfile" && mv "$file" "$newfile"; done

for file in $SubFilePath/* ; do newfile=$( echo "$file" | tr -d \\n | sed 's/ //g' );
   test "$file" != "$newfile" && mv "$file" "$newfile"; done

# List Video files in array
declare -a VideoArray=()
for VideoFile in `ls "$VideoFilePath"`
	do VideoArray=("${VideoArray[@]}" "$VideoFile") 
	#echo $VideoFile
	done

# List Subs files in array
declare -a SubArray=()
for SubFile in `ls "$SubFilePath"`
	do SubArray=("${SubArray[@]}" "$SubFile") 
	#echo $SubFile
	done

merge_files () {
count="-1"
while [ $count -lt $NumberCount ]; do
	count=$((count+1))
	OutputFile=${VideoArray[$count]/%.[a-z][a-z][a-z]/.mkv}
	OutputFile=${VideoArray[$count]/%.[a-z][a-z][0-9]/.mkv}
	"$CmdPath/mkvmerge" -o "$TargetPath$OutputFile" "--title" "$OutputFile" "--track-order" "0:0,0:1,1:0" \
	"--default-track" "0:yes" "--forced-track" "0:no" "--language" "1:eng" "--default-track" "1:yes" "--forced-track" "1:no" "-S" "-T" "--no-global-tags" "--no-chapters" "$VideoFilePath${VideoArray[$count]}" \
	"--language" "0:fre" "--sub-charset" "0:$Charset" "--track-name" "0:French Subs" "--forced-track" "0:no" "-s" "0" "-D" "-A" "-T" "--sync" "0:$Delay" "--no-global-tags" "--no-chapters" "$SubFilePath${SubArray[$count]}"
	done
}

merge_sample () {
	OutputFile=${VideoArray[0]/%.[a-z][a-z][a-z]/.mkv}
	OutputFile=${VideoArray[0]/%.[a-z][a-z][0-9]/.mkv}
	"$CmdPath/mkvmerge" -o "$TargetPath$OutputFile" "--title" "$OutputFile" "--track-order" "0:0,0:1,1:0" \
	"--default-track" "0:yes" "--forced-track" "0:no" "--language" "1:eng" "--default-track" "1:yes" "--forced-track" "1:no" "-S" "-T" "--no-global-tags" "--no-chapters" "$VideoFilePath${VideoArray[0]}" \
	"--language" "0:fre" "--sub-charset" "0:$Charset" "--track-name" "0:French Subs" "--forced-track" "0:no" "-s" "0" "-D" "-A" "-T" "--sync" "0:$Delay" "--no-global-tags" "--no-chapters" "$SubFilePath${SubArray[0]}"
}

list_files (){
count="-1"
while [ $count -lt $NumberCount ]; do
	count=$((count+1))
	echo "
  Number :	$count
  Input Video :	$VideoFilePath${VideoArray[$count]} 
  Input Sub :	$SubFilePath${SubArray[$count]}
  Output File :	$TargetPath${VideoArray[$count]}"
	done
	echo ""
}

cutom_mode (){

count="-1"
while [ $count -lt $NumberCount ]; do
        count=$((count+1))
	OutputFile=${VideoArray[$count]/%.[a-z][a-z][a-z]/.mkv}
        OutputFile=${VideoArray[$count]/%.[a-z][a-z][0-9]/.mkv}

	#### Keep only Audio ID 2 and Sub ID 3
	#"$CmdPath/mkvmerge" -o "$TargetPath$OutputFile" "--title" "$OutputFile" "-a" "2" -s "3" "$VideoFilePath${VideoArray[$count]}"
	
	#### Remove All subs and Keep only Audio ID 2
	#"$CmdPath/mkvmerge" -o "$TargetPath$OutputFile" "--title" "$OutputFile" "-a" "2" "--no-subtitles" "$VideoFilePath${VideoArray[$count]}"

	#### Remove Audio Track with ID 2 
	#"$CmdPath/mkvmerge" -o "$TargetPath$OutputFile" "--title" "$OutputFile" -a !0 "$VideoFilePath${VideoArray[$count]}"

	#### Remove Audio ID 1 and Keep only Sub ID 4 (making it default)
	#"$CmdPath/mkvmerge" -o "$TargetPath$OutputFile" "--title" "$OutputFile" "-a" "2" -s "5" "--track-name" "5:French Subs" "--default-track" "5:yes" "$VideoFilePath${VideoArray[$count]}"

	#### Merge Files keeping 1 video track and 2 audio tracks
	#"$CmdPath/mkvmerge" -o "$TargetPath$OutputFile" "--title" "$OutputFile" \
	#"--language" "1:eng" "--track-name" "1:VO" "--default-track" "1:yes" "-T" "-a" "1" "-d" "0" "--no-global-tags" "--no-chapters" "$VideoFilePath${VideoArray[$count]}" \
	#"--language" "1:fre" "--track-name" "1:VF" "-D" "-S" "-T" "--no-global-tags" "--no-chapters" "$SoundFilePath${SubArray[$count]}"

	#### Removes ALL Subs
	#"$CmdPath/mkvmerge" -o "$TargetPath$OutputFile" "--title" "$OutputFile" "--no-subtitles" "$VideoFilePath${VideoArray[$count]}"

	#### Clone Wars
	"$CmdPath/mkvmerge" -o "$TargetPath$OutputFile" "--title" "$OutputFile" "--default-track" "0:yes" \
	--language 1:eng --track-name 1:Stereo --language 2:fr --track-name 2:Stereo --default-track 1:yes "--no-subtitles" "--no-global-tags" "--no-chapters" "$VideoFilePath${VideoArray[$count]}" \
	"--language" "0:fre" "--sub-charset" "0:$Charset" "--track-name" "0:French Subs" "--default-track" "0:no" "--forced-track" "0:no" "-s" "0" "-D" "-A" "-T" "--sync" "0:$Delay" "--no-global-tags" "--no-chapters" "$SubFilePath${SubArray[$count]}"

	#### Korra Audio
#	"$CmdPath/mkvmerge" -o "$TargetPath$OutputFile" "--title" "$OutputFile" "--default-track" "0:yes" \
#	--language 1:eng --default-track 1:yes --track-name 1:DTS "$VideoFilePath${VideoArray[$count]}" \
#	--no-video --language 1:fre --track-name 1:Stereo "--sync" "1:1000" "$SubFilePath${SubArray[$count]}" --track-order 0:0,0:1,1:1
	
	done
}

display_tracks () {

count="-1"
while [ $count -lt $NumberCount ]; do
	count=$((count+1))
	
	"$CmdPath/mkvmerge" "--identify-verbose" "$VideoFilePath${VideoArray[$count]}"
	echo ""
	done
}

print_usage () {
	echo "
Usage : $1 [-v] [I] -l|-t|-s|-A|-o

	-h	  print this message
	-v	  enable Verbose mode
	-l	  only list files
	-t	  display tracks
	-i	  print language information
	-s	  merge only single file
	-A	  merge ALL files
	-o	  custom option
	-I	  Charset="ISO_8859-15"
	-U	  Charset="UTF-8" (Default)
	"
}

if [ $# -lt  1 ]
	then echo "
	Error : Missing argument"
	print_usage
	exit 1
fi

while getopts vloAtshIU args; do
	case $args in
		v)
		$v = "-v"
		;;
		l)
		list_files
		exit
		;;
		t)
		display_tracks
		exit
		;;
		A)
		merge_files
		exit
		;;
		s)
		merge_sample
		exit
		;;
#		I)
#		Charset="ISO_8859-15"
#		;;
#		U)
#		Charset="UTF-8"
#		;;
		h)
		print_usage
		exit
		;;
		o)
		cutom_mode
		;;
		*)
		echo "
	Error : Bad argument"
		print_usage
		exit 1
		;;
	esac
done

######### Debug

#echo ${VideoArray[@]}
#echo ${SubArray[@]}
#
#echo $NumberCount
#

#"$CmdPath/mkvmerge" -o "$TargetPath${VideoArray[0]}" "--title" "${VideoArray[0]}" "--default-track" "0:yes" "--forced-track" "0:no" "--language" "1:eng" "--default-track" "1:yes" "--forced-track" "1:no" "-S" "-T" "--no-global-tags" "--no-chapters" "$VideoFilePath${VideoArray[0]}" "--language" "0:fre" "--sub-charset" "0:$Charset" "--track-name" "0:French Subs" "--forced-track" "0:no" "-s" "0" "-D" "-A" "-T" "--no-global-tags" "--no-chapters" "$SubFilePath${SubArray[0]}" "--track-order" "0:0,0:1,1:0"
