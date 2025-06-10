function [] = adc(selectedNoiseIndex)

disp(">> ADC Running: Selected index = " + selectedNoiseIndex);

switch selectedNoiseIndex
    case "0"
        selectedNoise = "drillNoise1.txt";
    case "1"
        selectedNoise = "drillNoise2.txt";
    case "2"
        selectedNoise = "drillNoise3.txt";
    case "3"
        selectedNoise = "drillNoise4.txt";
    case "4"
        selectedNoise = "fanNoise.txt";
    case "5"
        selectedNoise = "chainsawNoise.txt";
    otherwise 
        selectedNoise = "drillNoise1.txt";
end

reference = load("reference.txt");
noise = load(selectedNoise);
data = 0.6 * reference + noise;
bits = 16;
partition = linspace(-1, 1, pow2(bits));
indx = quantiz(data, partition);

% Binary conversion
d2b = dec2bin(indx, 16) - '0';
decimalToBinary = reshape(d2b', [], 1);

% adc.txt FILE
writematrix(decimalToBinary, "adc.txt");
disp("adc.txt has been saved.");

end
