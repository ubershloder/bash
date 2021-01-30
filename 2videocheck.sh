IFS=$'\n'
while read -r Line || [ -n "${Line}" ]; do
  # Test if file is video
  buff=$(file -N -i "${Line}" | grep -E 'video')
  if [ ! -z  "$buff" ]
    then
      MediaDuration=$(mediainfo --Output='General;%Duration%' "${Line}")
      # Want total duration of listed files?
      TotalDuration=$((TotalDuration + MediaDuration))
      # Want total number of video files?
      NbMedia=$((NbMedia + 1))
  fi
done < me.txt

# Format Duration: milliseconds to H:M:S
Seconds=$((TotalDuration / 1000))
FormattedDuration=$(printf '%02dh:%02dm:%02ds\n' $(($Seconds/3600)) $(($Seconds%3600/60)) $(($Seconds%60)))

# Build report
ReportText="${NbFiles} File"
echo "$ReportText"
test $NbFiles -gt 1 && ReportText="${ReportText}s"
ReportText="${ReportText} selected\n"
test $NbMedia -gt 0 && ReportText="${ReportText}${NbMedia} Media file" || ReportText="${ReportText}No media file"
test $NbMedia -gt 1 && ReportText="${ReportText}s"
test $NbMedia -gt 0 && ReportText="${ReportText}\nTotal duration: ${FormattedDuration}"
echo "${MediaDuration}"
