1) fs.m

The reference audio signal is loaded from reference.wav, converted to mono if necessary, and resampled to 8 kHz. The resulting waveform is saved as reference.txt for subsequent processing. 

2) adc.m

The speech reference and the user-selected noise file are combined and uniformly quantized to 16 bits. Each sample is converted into a 16-bit binary stream and written to adc.txt, which serves as the error-free bitstream input to the receiver. 

3) rls.m

The noisy speech and matching noise file are trimmed to equal length and passed through an RLS adaptive filter (M=1, λ=1, δ=1e-11) to remove structured interference. A Hampel filter (window half-size=20, threshold=3σ) is applied for spike suppression. Both the raw RLS output (rlsOutput_raw.txt) and the cleaned waveform (rlsOutput.txt) are generated for LabVIEW ingestion. 

--------------------- Usage ---------------------

Place all .m scripts and their associated .txt and .wav files in the same working folder.

Run fs.m to generate reference.txt.

When you run the system, in MATLAB,  adc(selectedNoiseIndex) and rls(selectedNoiseIndex) (with the desired noise index) are called to produce adc.txt and rlsOutput.txt.