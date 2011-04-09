Noise noise => BiQuad nf => NRev noiseRev => Gain noiseGain => Pan2 noisePan => dac;

0.001 => noiseGain.gain;
0.985 => nf.prad;
0.5 => noisePan.pan;
0.1 => noiseRev.mix;

Std.rand2f(250, 500) => nf.pfreq;
0.5 + Std.rand2f(-0.2, 0.2) => noisePan.pan;

2::second => now;

Modulate m => Chorus c => BiQuad f => JCRev r => Pan2 span => dac;

.64 => f.prad;
1 => f.eqzs;
0.0 => float v;

4.0 => c.modDepth;
1.0 => c.mix;

-0.3 => span.pan;

1300.0 => m.vibratoRate;

0 => int tanSpeedSwitch;
[[3.0, 2.0], [20.0, 0.5]] @=> float tanSpeedsAndDelays[][];
tanSpeedsAndDelays[0][0] => float tanSpeed;
now + tanSpeedsAndDelays[0][1]::second => time tanSpeedSwitchTime;

Math.tan(v * tanSpeed) * 16000.0 => f.pfreq;
0.25 + (2.0 + Math.sin(v)) / 4.5 => r.mix;
3::second => now;

now + 120::second => time end;

while (now < end) {
    Math.tan(v * tanSpeed) * 16000.0 => f.pfreq;
    v + .01 => v;

    0.25 + (2.0 + Math.sin(v)) / 4.5 => r.mix;

    5::ms => now;
    Std.rand2f(250, 500) => nf.pfreq;

    if (now >= tanSpeedSwitchTime) {
        if (Std.rand2f(0.0, 1.0) <= 0.15) {
            0.0 => m.vibratoRate;
            0.25::second => now;
            1300.0 => m.vibratoRate;
            Std.rand2f(0.5, 2)::second => now;
        }

        (tanSpeedSwitch + 1) % tanSpeedsAndDelays.size() => tanSpeedSwitch;
        tanSpeedsAndDelays[tanSpeedSwitch][0] => tanSpeed;
        now + tanSpeedsAndDelays[tanSpeedSwitch][1]::second => tanSpeedSwitchTime;
    }
}

0.25::second => now;
0 => m.vibratoRate;
10::second => now;
