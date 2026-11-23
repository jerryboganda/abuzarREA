import wave, glob, os
for f in glob.glob(r'C:\Projects\Abuzar\deploy\Application\*.wav'):
    try:
        w=wave.open(f,'rb'); d=w.getnframes()/w.getframerate(); print(os.path.basename(f), round(d,2),'s', w.getnchannels(), w.getframerate())
    except Exception as e: print(f,e)
