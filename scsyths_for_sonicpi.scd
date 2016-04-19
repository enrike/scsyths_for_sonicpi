// creating synthdefs in supercollider for sonicpi by ixi-audio.net
// license: GPL

// https://github.com/enrike/scsyths_for_sonicpi


// https://github.com/samaaron/sonic-pi/blob/master/SYNTH_DESIGN.md#synth-design-constraints
// https://github.com/samaaron/sonic-pi/blob/master/etc/synthdefs/designs/sonic_pi/synths/


// you can use compiled synthdefs from supercollider in sonicpi
// you must define an arg out_bus set to 0 and point sonicpi to the compiled synth file
// compiled synthdefs go to (in Linux) ~/.local/share/SuperCollider/synthdefs and have .scsyndef extension
// in sonicpi you need to:
// load_synthdefs "~/.local/share/SuperCollider/synthdefs"
// use_synth :thesynthdefname
// play 666





// 01 simplest synth
// this one does not self terminate and keeps on forever. it has no external control
// in sonicpi:
// load_synthdefs "~/.local/share/SuperCollider/synthdefs"
// use_synth :test1
// play 666 # any note will do in this case
(
SynthDef(\test1, {arg out_bus=0;
	Out.ar(out_bus, SinOsc.ar(333))
}).store // store saves it to ~/.local/share/SuperCollider/synthdefs or similar
)

Synth(\test1); //test it





// 02 getting control of freq and amp
// in sonicpi:
// load_synthdefs "~/.local/share/SuperCollider/synthdefs"
// use_synth :test2
// play 60, amp:0.5
(
SynthDef(\test2, { arg note=60, amp=1, out_bus=0;
	var freq = note.midicps; // convert MIDI note to freq
	var snd = SinOsc.ar(freq); // envelope to shape and terminate it
	Out.ar(out_bus, snd * amp); //
}).store;
)

Synth(\test2, [\note, 80, \amp: 0.1]); //test it





// 03 getting control over pan and adding ADSR envelope to self terminate and control envelope
// in sonicpi:
// load_synthdefs "~/.local/share/SuperCollider/synthdefs"
// use_synth :test3
// play 73, pan:-1, attack: 0.3, decay: 0.1, sustain_level: 0.2, release: 0.5
(
SynthDef(\test3, { arg note=60, amp=1, pan=0, out_bus = 0, // NOTE, AMP, PAN and OUT_BUS!
	attack=0.1, decay=0.2, sustain_level=0.8, release=1.5; // ADSR env args
	var freq = note.midicps; // convert MIDI note to freq
	var snd = SinOsc.ar(freq);
	var env = Env.adsr(attack, decay, sustain_level, release); // envelope to shape and terminate it
    var gen = EnvGen.kr(env, gate: Impulse.ar(2), doneAction: 2);

	Out.ar(out_bus, Pan2.ar(snd * gen, pan, amp)); //
}).store;
)

Synth(\test3, [\pan, -1, \attack, 0.4, \decay, 0.1, \sustain_level, 0.5, \release, 3.5]); //test it





// 04 adding DETUNE extra control arguments
// you can add many more arguments to control from sonicpi in the synthdef
// in sonicpi:
// load_synthdefs "~/.local/share/SuperCollider/synthdefs"
// use_synth :test4
// play 73, detune: 0.5
(
SynthDef(\test4, { arg note=60, detune=0.1, amp=1, pan=0, out_bus = 0, // NOTE, AMP, PAN and OUT_BUS!
	attack=0.1, decay=0.2, sustain_level=0.8, release=1.5; // ADSR env args
	var freq = note.midicps; // convert MIDI note to freq
	var freq2 = (note + detune).midicps;
	var snd = SinOsc.ar(freq) +  SinOsc.ar(freq2);
	var env = Env.adsr(attack, decay, sustain_level, release); // envelope to shape and terminate it
    var gen = EnvGen.kr(env, gate: Impulse.ar(2), doneAction: 2);

	Out.ar(out_bus, Pan2.ar(snd * gen, pan, amp)); //
}).store;
)

Synth(\test4, [\detune, 0.5]); //test it











