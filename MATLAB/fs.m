% 1) Read the WAV file
[signal, fs_orig] = audioread('reference.wav');

% 2) Convert to mono if it's stereo
if size(signal, 2) > 1
    signal = mean(signal, 2);  % Stereo → Mono
end

% 3) Resample to 8000 Hz
fs_target = 8000;
if fs_orig ~= fs_target
    signal = resample(signal, fs_target, fs_orig);
end

% 4) Save as a single-column .txt file
save('reference.txt', 'signal', '-ascii');

disp('✅ reference.txt file created at 8000 Hz.');
