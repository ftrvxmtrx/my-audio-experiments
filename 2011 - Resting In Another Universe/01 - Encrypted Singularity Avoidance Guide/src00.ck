SubNoise noise => PitShift shifter => Gain noiseGain => Chorus rev => dac;
SubNoise noise2 => PitShift shifter2 => Gain noiseGain2 => Chorus rev2 => dac.left;
SubNoise noise3 => PitShift shifter3 => Gain noiseGain3 => Chorus rev3 => dac.right;

13 => rev.modFreq;
9 => rev2.modFreq;
7 => rev3.modFreq;

0.7 => rev.mix;
0.5 => rev2.mix;
0.2 => rev3.mix;

0.3 => noiseGain.gain;
0.3 => noiseGain2.gain;
0.3 => noiseGain3.gain;

Phasor osc => blackhole;
SinOsc osc2 => blackhole;

0.7 => shifter.mix;
0.5 => shifter2.mix;
0.4 => shifter3.mix;

PulseOsc noiseRateOsc => blackhole;
1.8 => noiseRateOsc.freq;

SinOsc osc3 => blackhole;
5.3 => osc3.freq;

SawOsc saw => blackhole;
21.2 => saw.freq;

2::second => now;

now + 27.1::second => time end;

while (now < end) {
    Std.rand2f(7, 20) => float r;

    r => rev.modFreq;
    
    7 * saw.last() => shifter.shift;
    (70 - 50 * noiseRateOsc.last()) $ int => noise.rate;
    Std.rand2f(50, 100) => r;
    (120 + r * saw.last())::samp * 100 => now;
    5 * saw.last() => shifter2.shift;
    (50 - 20 * noiseRateOsc.last()) $ int => noise2.rate;
    Std.rand2f(50, 100) => r;
    (120 + r * saw.last())::samp * 200 => now;
    2 * saw.last() => shifter3.shift;
    (30 - 10 * noiseRateOsc.last()) $ int => noise3.rate;

    20 + 2 * osc2.last() => osc.freq;
    (4.1 + saw.last())::samp * 100 => now;

    Std.fabs(osc3.last()) => float osc3abs;
    Std.rand2f(20, 44) => r;
    r * (1 + osc3abs + saw.last())::samp => now;
}

2::second => now;
