SET _length=300
@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
for /f "tokens=1,2 delims=, " %%A in (%cd%\urllist.txt) do (
  SET _url=%%A
  SET _filename=%%B
  
  youtube-dl --postprocessor-args "-threads 0" --extract-audio --audio-format mp3 --output "!_filename!.%%(ext)s" "!_url!"
  
  for /f "delims=" %%A in ('youtube-dl --get-duration "!_url!"') do (
    SET _dur=%%A
    for /f "tokens=1,2 delims=:" %%J in ("!_dur!") do (
      SET _min=%%J
	  SET _sec=%%K
      SET /a _dursec=_min*60+_sec
      SET _count=1
      SET _begin=11

      for /L %%F in (!_begin!,%_length%,!_dursec!) do (
        ffmpeg -i !_filename!.mp3 -ss !_begin! -t 300 -vn -c:a libmp3lame -threads 0 !_filename!_part!_count!.mp3
        SET /a _begin+=%_length%
        SET /a _count+=1
      )
    )
  )
)
ENDLOCAL
