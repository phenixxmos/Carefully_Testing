m=Server.default.options;
m.numOutputBusChannels=10;
m.numInputBusChannels=10;
m.numBuffers=2000;

s.doWhenBooted({
var path,spath,l,test_config,major,minor,patch,dev_id,speak1,speak2,speak3,speak4,room_c,room_condition,sender,receiver;

path=PathName.new(File.getcwd++"/Playback_regain/");
//path=PathName.new("/Users/phenix/Documents/Cherish/Cherish_testing_0.0.0/calibration_samples/");
//path=PathName.new("/Users/phenix/Downloads/0.1.x/Playback_samples/");

	# test_config,major,minor,patch,speak1,speak2,speak3,speak4,room_c=this.compileFile(File.getcwd++"/sender_config.scd").value();
	// # test_config,major,minor,patch,speak1,speak2,speak3,speak4,room_c=this.compileFile("/Users/phenix/Documents/Cherish/Scripts/Carefully_Testing/sender_config.scd").value();



speak4.postln;
~gap_size=0.05;


spath=SortedList.new(size:8);
~signal=TwoWayIdentityDictionary.new;
~samp=Order.new(size:8);
path.entries.do({|path|
	spath.add(path.absolutePath);
});
spath.do({|path,i|
	~signal.put(PathName.new(path).fileNameWithoutExtension.asSymbol,(i+1));
	~samp.add(Buffer.read(s,path));
});
~signal.put(\silence,0);

MIDIClient.init;
g=MIDIOut.new(0);
g.latency=0;

~directional_playback=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('Person_3_48kHz_chopped'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->0,\level->0,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->0,\level->0,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->0,\level->0,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;

	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~directional_playback_all=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('Person_3_48kHz_chopped'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('Person_3_48kHz_chopped'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('Person_3_48kHz_chopped'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('Person_3_48kHz_chopped'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~bath_fill_1=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('024_Bathtub Fill'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););

	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~bath_fill_2=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('024_Bathtub Fill'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~bath_fill_3=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('024_Bathtub Fill'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););

	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~bath_fill_4=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('024_Bathtub Fill'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~bath_drain_1=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('025_Bathtub Drain'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~bath_drain_2=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('025_Bathtub Drain'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););

	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~bath_drain_3=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('025_Bathtub Drain'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););

	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~bath_drain_4=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('025_Bathtub Drain'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););

	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});


~microwave_1=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('038_Microwave'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););

	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~microwave_2=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('038_Microwave'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););

	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~microwave_3=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('038_Microwave'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););

	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~microwave_4=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('038_Microwave'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););

	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;

	});

~door_slam_1=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('07_Door Open and Slam'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;

	});

~door_slam_2=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('07_Door Open and Slam'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~door_slam_3=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('07_Door Open and Slam'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;

	});

~door_slam_4=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('07_Door Open and Slam'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;

	});


~voice_1=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('Person_3_48kHz_chopped'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;

	});

~voice_2=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('Person_3_48kHz_chopped'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;

	});

~voice_3=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('Person_3_48kHz_chopped'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;

	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~voice_4=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('Person_3_48kHz_chopped'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~noise_1=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('White_Noise'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;

	});

~noise_2=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('White_Noise'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;

	});

~noise_3=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('White_Noise'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;

	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

~noise_4=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist;

		synth=Array.fill(4, { arg i; nil });

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('White_Noise'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
		if(playlist.at(0).at(\sig)>0,{synth.put(0,Synth(\playbuf_m,[\amp,(playlist.at(0).at(\level)-80).dbamp,\cal,~noi_cal.at(0),\out,0,\bufnum,~samp.at((playlist.at(0).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(1).at(\sig)>0,{synth.put(1,Synth(\playbuf_m,[\amp,(playlist.at(1).at(\level)-80).dbamp,\cal,~noi_cal.at(1),\out,1,\bufnum,~samp.at((playlist.at(1).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(2).at(\sig)>0,{synth.put(2,Synth(\playbuf_m,[\amp,(playlist.at(2).at(\level)-80).dbamp,\cal,~noi_cal.at(2),\out,2,\bufnum,~samp.at((playlist.at(2).at(\sig)-1)),\lp,1]););},{});

		if(playlist.at(3).at(\sig)>0,{synth.put(3,Synth(\playbuf_m,[\amp,(playlist.at(3).at(\level)-80).dbamp,\cal,~noi_cal.at(3),\out,3,\bufnum,~samp.at((playlist.at(3).at(\sig)-1)),\lp,1]););},{});
	(120+~gap_size).wait;
	g.stop;
	if(playlist.at(0).at(\sig)>0,{synth.at(0).free;},{});
	if(playlist.at(1).at(\sig)>0,{synth.at(1).free;},{});
	if(playlist.at(2).at(\sig)>0,{synth.at(2).free;},{});
	if(playlist.at(3).at(\sig)>0,{synth.at(3).free;},{});
	5.wait;
	});

	~quad=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist,voice,tv,ac,kitchen;

	voice=Pmono(\playbuf_m,
		\out,0,
		\cal,0.125,
	\bufnum,~samp.at(3),
		\amp,Pseq([1,0,1,0,1,0,1,0],1),
		\dur,15,);

	//TV
	tv=Pmono(\playbuf_m,
		\out,1,
		\cal,0.125,
	\bufnum,~samp.at(2),
		\amp,Pseq([0,1],1),
		\dur,60,);

	//AC
	ac=Pmono(\playbuf_m,
	\out,2,
	\cal,0.125,
	\bufnum,~samp.at(0),
	\amp,Pseq([0,1,0],1),
	\dur,Pseq([30,60,30],1),);

	//kitchen
	kitchen=Pmono(\playbuf_m,
	\out,3,
	\cal,0.125,
	\bufnum,~samp.at(1),
	\amp,Pseq([0,1,0,0,1,0,0,0],1),
	\dur,15,);

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
		playlist=[Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('025_Bathtub Drain'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('silence'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););

	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;

	(120+~gap_size).wait;
	g.stop;
	Ppar([voice,tv,ac,kitchen]).play;
	5.wait;
	});


~quad=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playlist,voice,tv,ac,kitchen;
	~voice=Pmono(\playbuf_m,\out,0,\cal,0.125,\bufnum,~samp.at(3),\amp,Pseq([1,0,1,0,1,0,1,0],1),\dur,15,);

//TV
	~tv=Pmono(\playbuf_m,\out,1,\cal,0.125,\bufnum,~samp.at(2),\amp,Pseq([0,1],1),\dur,60,);

//AC
~ac=Pmono(\playbuf_m,\out,2,\cal,0.125,\bufnum,~samp.at(0),\amp,Pseq([0,1,0],1),\dur,Pseq([30,60,30],1),);

//kitchen
~kitchen=Pmono(\playbuf_m,\out,3,\cal,0.125,\bufnum,~samp.at(1),\amp,Pseq([0,1,0,0,1,0,0,0],1),\dur,15,);

	sys_out=~sys;
		//playlist=[s1,s2,s3,s4]
	playlist=[Dictionary.with(*[\sig->~signal.at('Air_Conditioner'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('Radio Sounds'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('Air_Conditioner'),\level->80,\weight->~weight.at('dBeq(A)')]),
			Dictionary.with(*[\sig->~signal.at('Kitchen Sounds'),\level->80,\weight->~weight.at('dBeq(A)')])];

		sys_out.put(14,~lower.value(playlist.at(0).at(\sig)););
		sys_out.put(15,~upper.value(playlist.at(0).at(\sig)););
		sys_out.put(16,~lowerq.value(playlist.at(0).at(\level)););
		sys_out.put(17,~upperq.value(playlist.at(0).at(\level)););
		sys_out.put(18,playlist.at(0).at(\weight););
		sys_out.put(25,~lower.value(playlist.at(1).at(\sig)););
		sys_out.put(26,~upper.value(playlist.at(1).at(\sig)););
		sys_out.put(27,~lowerq.value(playlist.at(1).at(\level)););
		sys_out.put(28,~upperq.value(playlist.at(1).at(\level)););
		sys_out.put(29,playlist.at(1).at(\weight););
		sys_out.put(36,~lower.value(playlist.at(2).at(\sig)););
		sys_out.put(37,~upper.value(playlist.at(2).at(\sig)););
		sys_out.put(38,~lowerq.value(playlist.at(2).at(\level)););
		sys_out.put(39,~upperq.value(playlist.at(2).at(\level)););
		sys_out.put(40,playlist.at(2).at(\weight););
		sys_out.put(47,~lower.value(playlist.at(3).at(\sig)););
		sys_out.put(48,~upper.value(playlist.at(3).at(\sig)););
		sys_out.put(49,~lowerq.value(playlist.at(3).at(\level)););
		sys_out.put(50,~upperq.value(playlist.at(3).at(\level)););
		sys_out.put(51,playlist.at(3).at(\weight););
		sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);
	2.wait;
	g.start;
	Ppar([~voice,~tv,~ac,~kitchen]).play;
	(120+~gap_size).wait;
	g.stop;

	5.wait;
});

~fin=Routine({1.wait;"The Recordings are done".postln;});

~weight=TwoWayIdentityDictionary['dBeq(A)'->0,'dBeq(C)'->1,'dBeq(Z)'->2,'dBf(A)'->3,'dBf(C)'->4,'dBeq(Z)'->5,'dBs(A)'->6,'dBs(C)'->7,'dBs(Z)'->8];
SynthDef.new(\playbuf_m,{|amp=1,cal,out=0,bufnum=7,lp=0|
	var sig;
	sig=PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum),doneAction:2,loop:lp);
	sig=sig*amp*cal;
	OffsetOut.ar(out,sig);
}).add;
SynthDef.new(\send_m,{|amp=1,cal,out=0,send,bufnum=7,lp=0|
	var sig;
	sig=PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum),doneAction:2,loop:lp);
	sig=sig*amp*cal;
	OffsetOut.ar(out,sig);
	OffsetOut.ar(send,sig);
}).add;

~upper={|x| x.rightShift(7).asInteger;}; //splits 14bit integer into upper 7
~lower={|x| x.asBinaryDigits(numDigits:7).convertDigits(base:2).asInteger;}; //splits 14bit integer into lower 7
~expand={|upper,lower| ((upper.asBinaryDigits(numDigits:7)++lower.asBinaryDigits(numDigits:7)).convertDigits(base:2));}; //recombines up and low

~upperq={|x| (x*(2**4)).round(1).asInteger.rightShift(7);};//splits 14bit integer Q format 10.4 into upper 7
~lowerq={|x| (x*(2**4)).round(1).asInteger.asBinaryDigits(numDigits:7).convertDigits(base:2);};//splits 14bit integer Q format 10.4 into lower 7
~expandq={|upper,lower| (((upper.asBinaryDigits(numDigits:7)++lower.asBinaryDigits(numDigits:7)).convertDigits(base:2))/(2**4)).round(0.01);};//recombines q format
~rad2degree={|x| switch(sign(x),1.0,{x*(180/pi);},(-1.0),{360+(x*(180/pi));},0.0,{0.0});}; //radian to degree converter
~sphere_radius={|speak,mic| [(speak.at(\x)-mic.at(\x)),(speak.at(\y)-mic.at(\y)),(speak.at(\z)-mic.at(\z))].squared.sum.sqrt;}; //computes Spherical radius
~cylinder_radius={|speak,mic| [(speak.at(\x)-mic.at(\x)),(speak.at(\y)-mic.at(\y))].squared.sum.sqrt;};//computes Cylindrical radius
~elevation={|speak,mic| (speak.at(\z)-mic.at(\z));}; //finds the elavtion relative to the microphone board
	~elevation_θ={|speak,mic| ~rad2degree.value(atan2((speak.at(\z)-mic.at(\z)),([(speak.at(\x)-mic.at(\x)),(speak.at(\y)-mic.at(\y))].squared.sum.sqrt;)));}; //finds the elavtion angle
	~azimuth_φ={|speak,mic| ~rad2degree.value(atan2((speak.at(\y)-mic.at(\y)),(speak.at(\x)-mic.at(\x))));};  //finds Azimuth angle

~sys=Array.fill(53, { arg i; nil });
~sys.put(0,240);
~sys.put(52,247);
~sys.put(1,125);
~sys.put(2,major);
~sys.put(3,minor);
~sys.put(4,patch);
~sys.put(5,~lower.value(test_config);); //test config
~sys.put(6,~upper.value(test_config););//test config
~sys.put(7,room_c);
~sys.put(8,~lowerq.value(speak1.at(\z)););
~sys.put(9,~upperq.value(speak1.at(\z)););
~sys.put(10,~lowerq.value(speak1.at(\y)););
~sys.put(11,~upperq.value(speak1.at(\y)););
~sys.put(12,~lowerq.value(speak1.at(\x)););
~sys.put(13,~upperq.value(speak1.at(\x)););

~sys.put(19,~lowerq.value(speak2.at(\z)););
~sys.put(20,~upperq.value(speak2.at(\z)););
~sys.put(21,~lowerq.value(speak2.at(\y)););
~sys.put(22,~upperq.value(speak2.at(\y)););
~sys.put(23,~lowerq.value(speak2.at(\x)););
~sys.put(24,~upperq.value(speak2.at(\x)););

~sys.put(30,~lowerq.value(speak3.at(\z)););
~sys.put(31,~upperq.value(speak3.at(\z)););
~sys.put(32,~lowerq.value(speak3.at(\y)););
~sys.put(33,~upperq.value(speak3.at(\y)););
~sys.put(34,~lowerq.value(speak3.at(\x)););
~sys.put(35,~upperq.value(speak3.at(\x)););

~sys.put(41,~lowerq.value(speak4.at(\z)););
~sys.put(42,~upperq.value(speak4.at(\z)););
~sys.put(43,~lowerq.value(speak4.at(\y)););
~sys.put(44,~upperq.value(speak4.at(\y)););
~sys.put(45,~lowerq.value(speak4.at(\x)););
~sys.put(46,~upperq.value(speak4.at(\x)););


	//connects midi output
	    sender="128:4";
	    receiver="20:0";
	    l=Pipe.new(format("aconnect % %",sender,receiver),"r");
        l.getLine;

	"Fully Loaded".postln;
});

s.boot;
~noi_cal=[1,1,1,1];



~test_player=~bath_drain_1++~bath_drain_2++~bath_drain_3++~bath_drain_4++~bath_fill_1++~bath_fill_2++~bath_fill_3++~bath_fill_4++~microwave_1++~microwave_2++~microwave_3++~microwave_4++~door_slam_1++~door_slam_2++~door_slam_3++~door_slam_4++~voice_1++~voice_2++~voice_3++~voice_4++~noise_1++~noise_2++~noise_3++~noise_4++~fin;

~noise=~noise_1++~noise_2++~noise_3++~noise_4++~fin;


~vox=~voice_1++~voice_2++~voice_3++~voice_4++~fin;


//
//
// ~playlist=[Dictionary.with(*[\sig->~signal.at('Person_3_48kHz_chopped'),\level->80,\weight->~weight.at('dBeq(A)')]),
// 	Dictionary.with(*[\sig->0,\level->0,\weight->~weight.at('dBeq(A)')]),
// 	Dictionary.with(*[\sig->0,\level->0,\weight->~weight.at('dBeq(A)')]),
// Dictionary.with(*[\sig->0,\level->0,\weight->~weight.at('dBeq(A)')])];
// (
// var g;
// g=3;
// [~playlist.at(g).at(\sig),~playlist.at(g).at(\level),~playlist.at(g).at(\weight)].postln;
// )
// ~sys
/**
-9.2 at 0
-6.9 at 1
-2.7 at 2
-2.7 at 3
var noise_calibration;noise_calibration=(-9.2);
~noi_cal=noise_calibration.dbamp;

~ncl=Synth(\playbuf_m,[\amp,1,\cal,~noi_cal,\out,2,\bufnum,~cal_samp.at(0).bufnum,\lp,1]);
this is an excellent sysex guide
https://www.recordingblogs.com/wiki/midi-system-exclusive-message
**/
