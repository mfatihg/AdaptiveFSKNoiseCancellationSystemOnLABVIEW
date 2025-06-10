function [] = rls(selectedNoiseIndex)

% 1) Select noise file

switch selectedNoiseIndex
    case "0", selectedNoise = "drillNoise1.txt";
    case "1", selectedNoise = "drillNoise2.txt";
    case "2", selectedNoise = "drillNoise3.txt";
    case "3", selectedNoise = "drillNoise4.txt";
    case "4", selectedNoise = "fanNoise.txt";
    case "5", selectedNoise = "chainsawNoise.txt";
    otherwise, selectedNoise = "drillNoise1.txt";
end

% 2) Read files and fix decimal separators

noisy_speech = sscanf(strrep(fileread("noisySpeech.txt"),  ",", "."), "%f");
noise        = sscanf(strrep(fileread(selectedNoise)     ,  ",", "."), "%f");

% 3) Match lengths

N = min(length(noisy_speech), length(noise));
x = noisy_speech(1:N);
d = noise(1:N);

% 4) RLS parameters

M      = 1;
lambda = 1;
delta  = 0.00000000001;

% 5) Initialization

w         = zeros(M,1);
P         = (1/delta)*eye(M);
y_est     = zeros(N,1);
lambdaInv = 1/lambda;

% 6) Adaptive filtering

for n = M:N
    u          = d(n:-1:n-M+1);
    y_est(n)   = x(n) - w'*u;
    K          = (P*u)/(lambda + u'*P*u);
    P          = (P - K*u'*P)*lambdaInv;
    w          = w + K*y_est(n);
end

% -------------  P R E - H A M P E L   S A V E -------------

y_raw = y_est;                                     % raw copy
% y_raw = y_raw / max(abs(y_raw));      % –1 … 1 range OPTIONAL
fidRaw = fopen('rlsOutput_raw.txt','w');
fprintf(fidRaw, strrep(sprintf('%.6f\n',y_raw),'.',','));
fclose(fidRaw);

% 7) Hampel filter (spike suppression)

winHalf = 20;    % window half-size
nSigma  = 3;     % threshold coefficient

if exist('hampel','file')
    [y_est,~] = hampel(y_est, winHalf, nSigma);
else
    L = 2*winHalf + 1;
    for i = winHalf+1 : N-winHalf
        wdw   = y_est(i-winHalf:i+winHalf);
        med   = median(wdw);
        sigma = 1.4826*median(abs(wdw - med));
        if abs(y_est(i)-med) > nSigma*sigma
            y_est(i) = med;
        end
    end
end

% 8) Save output with comma decimal separator (NO normalization)

y_est = y_est / max(abs(y_est));      % –1 … 1 range OPTIONAL

fid = fopen('rlsOutput.txt','w');
fprintf(fid, strrep(sprintf('%.6f\n',y_est),'.',','));
fclose(fid);

disp("rlsOutput.txt has been created with Hampel filter applied (without normalization).");
end
