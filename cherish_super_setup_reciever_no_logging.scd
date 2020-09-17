m=Server.local.options;
m.numOutputBusChannels=8;
m.numInputBusChannels=8;
m.numBuffers=2000;

s.doWhenBooted({
var path,spath,l,rec_path,sender,receiver,gap,m_in,m_pos;
	// path=PathName.new(File.getcwd++"/Playback_samples/");
path=PathName.new("/Users/phenix/Downloads/0.1.x/Playback_samples/");
// # rec_path,gap,m_in,m_pos=this.compileFile(File.getcwd++"/reciever_config").value();
# rec_path,gap,m_in,m_pos=this.compileFile("/Users/phenix/Documents/Cherish/Scripts/Carefully_Testing/reciever_config.scd").value();


~gap_size=gap;
~mic_input=m_in;
~mic_positon=Dictionary.with(*[\x->79.2,\y->99.6,\z->31.2]);

spath=SortedList.new(size: 8);
~signal=TwoWayIdentityDictionary.new;
path.entries.do({|path|
	spath.add(path.absolutePath);
});
spath.do({|path,i|
		~signal.put(PathName.new(path).fileNameWithoutExtension.asSymbol,(i+1));
});
~signal.put(\silence,0);
~rec_raw=Recorder(s);
~raw_bus=Bus.audio(s,8);
~rec_crpd=Recorder(s);
~crpd_bus==Bus.audio(s,3);
~passthrough=Group.new;
~rec_raw.recSampleFormat="int16";
~rec_raw.recHeaderFormat="WAV";
~rec_crpd.recSampleFormat="int16";
~rec_crpd.recHeaderFormat="WAV";
~out=Dictionary.new(n=18);
~papn=rec_path++"Open/";
~paclsd=rec_path++"Closed/";
~panorm=rec_path++"Normal/";

	if(File.existsCaseSensitive(~papn)==false,
		{File.mkdir(~papn);"Open Created".postln;},
		{"Open Directory already exist".postln;}
	);

	if(File.existsCaseSensitive(~papn++"three_channels/")==false,
		{File.mkdir(~papn++"three_channels/");"Open/three_channels/ Created".postln;},
		{"Open/three_channels/ Directory already exist".postln;}
	);

	if(File.existsCaseSensitive(~papn++"raw/")==false,
		{File.mkdir(~papn++"raw/");"Open/raw/ Created".postln;},
		{"Open/raw/ Directory already exist".postln;}
	);

	if(File.existsCaseSensitive(~paclsd)==false,
		{File.mkdir(~paclsd);"Closed Created".postln;},
		{"Closed Directory already exist".postln;}
	);

	if(File.existsCaseSensitive(~paclsd++"three_channels/")==false,
		{File.mkdir(~paclsd++"three_channels/");"Closed/three_channels/ Created".postln;},
		{"Closed/three_channels/ Directory already exist".postln;}
	);

	if(File.existsCaseSensitive(~paclsd++"raw/")==false,
		{File.mkdir(~paclsd++"raw/");"Closed/raw/ Created".postln;},
		{"Closed/raw/ Directory already exist".postln;}
	);

	if(File.existsCaseSensitive(~panorm)==false,
		{File.mkdir(~panorm);"Normal Created".postln;},
		{"Normal Directory already exist".postln;}
	);

	if(File.existsCaseSensitive(~panorm++"three_channels/")==false,
		{File.mkdir(~panorm++"three_channels/");"Normal/three_channels/ Created".postln;},
		{"Normal/three_channels/ Directory already exist".postln;}
	);

	if(File.existsCaseSensitive(~panorm++"raw/")==false,
		{File.mkdir(~panorm++"raw/");"Normal/raw/ Created".postln;},
		{"Normal/raw/ Directory already exist".postln;}
	);
	rec_path.postln;
~upper={|x| x.rightShift(7).asInteger;}; //splits 14bit integer into upper 7
~lower={|x| x.asBinaryDigits(numDigits:7).convertDigits(base:2).asInteger;}; //splits 14bit integer into lower 7
~expand={|upper,lower| ((upper.asBinaryDigits(numDigits:7)++lower.asBinaryDigits(numDigits:7)).convertDigits(base:2));}; //recombines up and low

~upperq={|x| (x*(2**6)).round(1).asInteger.rightShift(7);};//splits 14bit integer Q format 10.4 into upper 7
~lowerq={|x| (x*(2**6)).round(1).asInteger.asBinaryDigits(numDigits:7).convertDigits(base:2);};//splits 14bit integer Q format 10.4 into lower 7
~expandq={|upper,lower| (((upper.asBinaryDigits(numDigits:7)++lower.asBinaryDigits(numDigits:7)).convertDigits(base:2))/(2**6)).round(0.01);};//recombines q format
~rad2degree={|x| switch(sign(x),1.0,{x*(180/pi);},(-1.0),{360+(x*(180/pi));},0.0,{0.0});}; //radian to degree converter
~sphere_radius={|speak,mic| [(speak.at(\x)-mic.at(\x)),(speak.at(\y)-mic.at(\y)),(speak.at(\z)-mic.at(\z))].squared.sum.sqrt;}; //computes Spherical radius
~cylinder_radius={|speak,mic| [(speak.at(\x)-mic.at(\x)),(speak.at(\y)-mic.at(\y))].squared.sum.sqrt;};//computes Cylindrical radius
~elevation={|speak,mic| (speak.at(\z)-mic.at(\z));}; //finds the elavtion relative to the microphone board
	~elevation_θ={|speak,mic| ~rad2degree.value(atan2((speak.at(\z)-mic.at(\z)),([(speak.at(\x)-mic.at(\x)),(speak.at(\y)-mic.at(\y))].squared.sum.sqrt;)));}; //finds the elavtion angle
	~azimuth_φ={|speak,mic| ~rad2degree.value(atan2((speak.at(\y)-mic.at(\y)),(speak.at(\x)-mic.at(\x))));};  //finds Azimuth angle

	/**
	~mlis -the 8 channel mic listener
	~mcrpd -the 3 channel mic listener

	**/

	SynthDef.new(\mic_listen_VS,{|out,in|
	var input;
	input=SoundIn.ar(in+[0,1,2,3,4,5,6,7],1);
	OffsetOut.ar(out,input);
	}).add;

	SynthDef.new(\mic_listen_crpd,{|out,in|
	var input;
	input=SoundIn.ar(in+5+[0,1,2],1);
	OffsetOut.ar(out,input);
	}).add;

	MIDIClient.init;

	MIDIdef.sysex(\parse,{|val,src|
		var prep;
	switch(val[1],
		0,{
			var l_sum,room_condition,firmware,signal,weight;
				room_condition=TwoWayIdentityDictionary[\Normal->0,\Closed->1,\Open->2];
				firmware=TwoWayIdentityDictionary['APP-MIC-RECORDER_DDR426797A2936B'->0,'VocalSorcery_1.0.4'->1];
				weight=TwoWayIdentityDictionary['dBeq(A)'->0,'dBeq(C)'->1,'dBeq(Z)'->2,'dBf(A)'->3,'dBf(C)'->4,'dBeq(Z)'->5,'dBs(A)'->6,'dBs(C)'->7,'dBs(Z)'->8];

			~out.add(\Version->format("%.%.%",val[2],val[3],val[4]));
			~out.add(\ID->val[5]);
			~out.add(\Firmware->firmware.getID(val[6]););
			~out.add(\Condition->room_condition.getID(val[7]););

			//location 1
				~out.add(\s1l->Dictionary.with(*[\x->~expandq.value(val[13],val[12]),\y->~expandq.value(val[11],val[10]),\z->~expandq.value(val[9],val[8])]););

				if(~expand.value(val[15],val[14])==0,{~out.add(\s1p->Dictionary.with(*[\signal->~signal.getID(~expand.value(val[15],val[14])),'signal num'->~expand.value(val[15],val[14]),\level->0,\weight->weight.getID(val[18])]);); },{
					~out.add(\s1p->Dictionary.with(*[\signal->~signal.getID(~expand.value(val[15],val[14])),'signal num'->~expand.value(val[15],val[14]),\level->~expandq.value(val[17],val[16]),\weight->weight.getID(val[18])]););});

				~out.add(\s1r->Dictionary.with(*[\elevation->~elevation.value(~out.at(\s1l),~mic_positon),'spherical Radius'->~sphere_radius.value(~out.at(\s1l),m_pos),'azimuth angle'->~azimuth_φ.value(~out.at(\s1l),~mic_positon),'elavation angle'->~elevation_θ.value(~out.at(\s1l),m_pos)]););

			//location 2
			    ~out.add(\s2l->Dictionary.with(*[\x->~expandq.value(val[24],val[23]),\y->~expandq.value(val[22],val[21]),\z->~expandq.value(val[20],val[19])]););

				if(~expand.value(val[26],val[25])==0,{~out.add(\s2p->Dictionary.with(*[\signal->~signal.getID(~expand.value(val[26],val[25])),'signal num'->~expand.value(val[26],val[25]),\level->0.0,\weight->weight.getID(val[29])]););},
					{~out.add(\s2p->Dictionary.with(*[\signal->~signal.getID(~expand.value(val[26],val[25])),'signal num'->~expand.value(val[26],val[25]),\level->~expandq.value(val[28],val[27]),\weight->weight.getID(val[29])]););});


				~out.add(\s2r->Dictionary.with(*[\elevation->~elevation.value(~out.at(\s2l),~mic_positon),'spherical Radius'->~sphere_radius.value(~out.at(\s2l),m_pos),'azimuth angle'->~azimuth_φ.value(~out.at(\s2l),~mic_positon),'elavation angle'->~elevation_θ.value(~out.at(\s2l),m_pos)]););

			//location 3
			    ~out.add(\s3l->Dictionary.with(*[\x->~expandq.value(val[35],val[34]),\y->~expandq.value(val[33],val[32]),\z->~expandq.value(val[31],val[30])]););

				if(~expand.value(val[37],val[36])==0,{~out.add(\s3p->Dictionary.with(*[\signal->~signal.getID(~expand.value(val[37],val[36])),'signal num'->~expand.value(val[37],val[36]),\level->0,\weight->weight.getID(val[40])]););},{~out.add(\s3p->Dictionary.with(*[\signal->~signal.getID(~expand.value(val[37],val[36])),'signal num'->~expand.value(val[37],val[36]),\level->~expandq.value(val[39],val[38]),\weight->weight.getID(val[40])]););});

				~out.add(\s3r->Dictionary.with(*[\elevation->~elevation.value(~out.at(\s3l),~mic_positon),'spherical Radius'->~sphere_radius.value(~out.at(\s3l),m_pos),'azimuth angle'->~azimuth_φ.value(~out.at(\s3l),~mic_positon),'elavation angle'->~elevation_θ.value(~out.at(\s3l),m_pos)]););

				//location 4
			    ~out.add(\s4l->Dictionary.with(*[\x->~expandq.value(val[46],val[45]),\y->~expandq.value(val[44],val[43]),\z->~expandq.value(val[42],val[41])]););

				if(~expand.value(val[48],val[47])==0,{~out.add(\s4p->Dictionary.with(*[\signal->~signal.getID(~expand.value(val[48],val[47])),'signal num'->~expand.value(val[48],val[47]),\level->0,\weight->weight.getID(val[51])]););},{~out.add(\s4p->Dictionary.with(*[\signal->~signal.getID(~expand.value(val[48],val[47])),'signal num'->~expand.value(val[48],val[47]),\level->~expandq.value(val[50],val[49]),\weight->weight.getID(val[51])]););});

				~out.add(\s4r->Dictionary.with(*[\elevation->~elevation.value(~out.at(\s4l),~mic_positon),'spherical Radius'->~sphere_radius.value(~out.at(\s4l),m_pos),'azimuth angle'->~azimuth_φ.value(~out.at(\s4l),~mic_positon),'elavation angle'->~elevation_θ.value(~out.at(\s4l),m_pos)]););

		}
	);
		switch(~out[\Condition],
		\Normal,{
				~tau_write=File(format("%Carefully-%_Firmware_%_L1_%_%%_L2_%_%%_L3_%_%%_L4_%_%%_v_%.csv",~panorm,~out[\ID],~out[\Firmware],~out[\s1p][\signal],~out[\s1p][\level],~out[\s1p][\weight],~out[\s2p][\signal],~out[\s2p][\level],~out[\s2p][\weight],~out[\s3p][\signal],~out[\s3p][\level],~out[\s3p][\weight],~out[\s4p][\signal],~out[\s4p][\level],~out[\s4p][\weight],~out[\Version]),"w");
				~crpd_path=~panorm++"three_channels/";
				~raw_path=~panorms++"raw/";

			},
		\Closed,{
				~tau_write=File(format("%Carefully-%_Firmware_%_L1_%_%%_L2_%_%%_L3_%_%%_L4_%_%%_v_%.csv",~paclsd,~out[\ID],~out[\Firmware],~out[\s1p][\signal],~out[\s1p][\level],~out[\s1p][\weight],~out[\s2p][\signal],~out[\s2p][\level],~out[\s2p][\weight],~out[\s3p][\signal],~out[\s3p][\level],~out[\s3p][\weight],~out[\s4p][\signal],~out[\s4p][\level],~out[\s4p][\weight],~out[\Version]),"w");
				~crpd_path=~paclsd++"three_channels/";
				~raw_path=~paclsd++"raw/";
			},
		\Open,{
				~tau_write=File(format("%Carefully-%_Firmware_%_L1_%_%%_L2_%_%%_L3_%_%%_L4_%_%%_v_%.csv",~papn,~out[\ID],~out[\Firmware],~out[\s1p][\signal],~out[\s1p][\level],~out[\s1p][\weight],~out[\s2p][\signal],~out[\s2p][\level],~out[\s2p][\weight],~out[\s3p][\signal],~out[\s3p][\level],~out[\s3p][\weight],~out[\s4p][\signal],~out[\s4p][\level],~out[\s4p][\weight],~out[\Version]),"w");
				~crpd_path=~papn++"three_channels/";
				~raw_path=~papn++"raw/";
		});

prep=Routine({
			(~gap_size*5).wait;

			~rec_raw.prepareForRecord(format("%Raw_Carefully-%_Firmware_%_L1_%_%%_L2_%_%%_L3_%_%%_L4_%_%%_v_%.wav",~raw_path,~out[\ID],~out[\Firmware],~out[\s1p][\signal],~out[\s1p][\level],~out[\s1p][\weight],~out[\s2p][\signal],~out[\s2p][\level],~out[\s2p][\weight],~out[\s3p][\signal],~out[\s3p][\level],~out[\s3p][\weight],~out[\s4p][\signal],~out[\s4p][\level],~out[\s4p][\weight],~out[\Version]),numChannels:8);

			~rec_crpd.prepareForRecord(format("%Three_Carefully-%_Firmware_%_L1_%_%%_L2_%_%%_L3_%_%%_L4_%_%%_v_%.wav",~crpd_path,~out[\ID],~out[\Firmware],~out[\s1p][\signal],~out[\s1p][\level],~out[\s1p][\weight],~out[\s2p][\signal],~out[\s2p][\level],~out[\s2p][\weight],~out[\s3p][\signal],~out[\s3p][\level],~out[\s3p][\weight],~out[\s4p][\signal],~out[\s4p][\level],~out[\s4p][\weight],~out[\Version]),numChannels:3);
});

		prep.play;

			~mlis=Synth(\mic_listen_VS,[\in,~mic_input,\out,~raw_bus],~passthrough);
			~mcrpd=Synth(\mic_listen_crpd,[\in,~mic_input,\out,~crpd_bus],~passthrough);

	});


	MIDIdef.start(\recorder,{|src|
		var player;
		//Start Recording
		~rec_csv=true;
		player=Routine({
		~rec_raw.record(bus:~raw_bus,node:~passthrough);
		~rec_crpd.record(bus:~crpd_bus,node:~passthrough);
		});

		"Recording Started".postln;
		player.play;
	});

	MIDIdef.stop(\freer,{|src|
		var stopper;
		//Stop Recording
		"this the stop".postln;
		stopper=Routine({
		~rec_csv=false;
		~rec_raw.stopRecording;
		~rec_crpd.stopRecording;
		2.wait;
		~nah.stop;
		~passthrough.freeAll;
		~tau_write.close;
		});
		stopper.play;
		"Recording Stopped".postln;

	});

	MIDIdef.continue(\beginner,{|src|
		//Pause Recording
		"this the continue".postln;
	});

	MIDIdef.reset(\pauser,{|src|
		//restart Recording
		"this the reset".postln;
	});

	sender="20:0";
	receiver="128:0";
	l=Pipe.new(format("aconnect % %",sender,receiver),"r");
	l.getLine;
	"Fully Loaded".postln;
});

s.boot;
