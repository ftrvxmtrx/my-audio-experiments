Wurley i0 => NRev r => Gain g => dac;

0 => g.gain;
500::ms => now;
0.3 => g.gain;

0.5 => float d;

[
[200.0, 75],
[300.0, 75],
[500.0, 50],
[600.0, 75],
[500.0, 50],
[300.0, 150],

[400.0, 75],
[300.0, 75],
[200.0, 50],
[400.0, 75],
[300.0, 50],
[500.0, 150],

[100.0, 75],
[300.0, 75],
[500.0, 50],
[400.0, 75],
[200.0, 50],
[600.0, 150]
] @=> float notes[][];

[0.5, 0.6] @=> float fmuls[];

0 => int i;
0 => int m;

0.6 => float speed;
0.5 => float fm;
2 => int rep;
notes.size() * 4 - 1 => int cycle;

0 => int fmul_i;
fmuls[fmul_i] => fm;

0 => int played;

while (played <= 3) {
    notes[i][0] * (m % 4 + 1) * fm => i0.freq;
    d => i0.noteOn;
    notes[i][1]::ms * speed => now;
    d => i0.noteOff;
    
    1 +=> i;
    1 +=> m;

    if (i >= notes.size()) {
        0 => i;
    }

    if (m % (cycle * rep) == 0) {
        (fmul_i + 1) % fmuls.size() => fmul_i;
        fmuls[fmul_i] => fm;

        if (fmul_i == 0) {
            1 +=> played;
        }
    }
}

2::second => now;
