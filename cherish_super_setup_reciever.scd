//version 0.0.1
s.doWhenBooted({
var path,l,rec_path,sender,receiver;

rec_path="/home/pi/Cherish_testing_0.0.0/Testing_recording/";
~gap_size=0.05;
~mic_input=0;
sender="20:0";
receiver="128:0";


~rec_raw=Recorder(s);
~raw_bus=Bus.audio(s,8);
~rec_crpd=Recorder(s);
~crpd_bus=Bus.audio(s,3);
~rec_raw.recSampleFormat="int16";
~rec_raw.recHeaderFormat="WAV";
~rec_crpd.recSampleFormat="int16";
~rec_crpd.recHeaderFormat="WAV";
~out=Dictionary.new(n=8);
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
m=Server.local.options;
m.numOutputBusChannels=8;
m.numInputBusChannels=8;
m.numBuffers=2000;

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
		val.postln;
	switch(val[1],
		0,{
			var l_sum,room_condition,firmware,signal,weight,l1sig1,l1sig2,l1signal,l2sig1,l2sig2,l2signal,l3sig1,l3sig2,l3signal,l4sig1,l4sig2,l4signal,angle;
				room_condition=TwoWayIdentityDictionary[\Normal->0,\Closed->1,\Open->2];
				firmware=TwoWayIdentityDictionary['APP-MIC-RECORDER_DDR426797A2936B'->0,'VocalSorcery_1.0.4'->1];
				signal=TwoWayIdentityDictionary['1kHz Tone'->1,'Person_3_(male)_03_16kHz_chopped'->2,'Person_3_(male)_03_48kHz_chopped'->3];
				weight=TwoWayIdentityDictionary['dBeq(A)'->0,'dBeq(C)'->1,'dBeq(Z)'->2,'dBf(A)'->3,'dBf(C)'->4,'dBeq(Z)'->5,'dBs(A)'->6,'dBs(C)'->7,'dBs(Z)'->8];

			~out.add(\Version->format("%.%.%",val[2],val[3],val[4]));
			~out.add(\ID->val[5]);
			~out.add(\Firmware->firmware.getID(val[6]););
			~out.add(\Condition->room_condition.getID(val[7]););

			//location 1
			l1sig1=val[9].asBinaryDigits;
			l1sig1.removeAt(0);
			l1sig2=val[10].asBinaryDigits;
			l1sig2.removeAt(0);
			l1signal=l1sig2++l1sig1;
			l1signal=l1signal.convertDigits(base:2);
			if ( l1signal==0,                // Boolean expression (chooses one at random)
				{"No Signal Location 1".postln; },    // true function
				{
					l_sum=(0.5*val[8]+35.5).asString++weight.getID(val[11]);
					~out.add(\Playback->signal.getID(l1signal););
					~out.add(\Location->1);
					~out.add(\Level->l_sum);
					~out.add(\True_Position->Order[(pi/2),0.2293363]);
				}
				);

			//location 2
			l2sig1=val[13].asBinaryDigits;
			l2sig1.removeAt(0);
			l2sig2=val[14].asBinaryDigits;
			l2sig2.removeAt(0);
			l2signal=l2sig2++l2sig1;
			l2signal=l2signal.convertDigits(base:2);
			if ( l2signal==0,
				{ "No Signal Location 2".postln;},
				{
					l_sum=(0.5*val[12]+35.5).asString++weight.getID(val[15]);
					~out.add(\Playback->signal.getID(l2signal););
					~out.add(\Location->2);
					~out.add(\Level->l_sum);
					~out.add(\True_Position->Order[pi,0.2293363]);
				}
				);

			//location 3
			l3sig1=val[17].asBinaryDigits;
			l3sig1.removeAt(0);
			l3sig2=val[18].asBinaryDigits;
			l3sig2.removeAt(0);
			l3signal=l3sig2++l3sig1;
			l3signal=l3signal.convertDigits(base:2);
			if ( l3signal==0,
				{ "No Signal Location 3".postln; },
				{
					l_sum=(0.5*val[16]+35.5).asString++weight.getID(val[19]);
					~out.add(\Playback->signal.getID(l3signal););
					~out.add(\Location->3);
					~out.add(\Level->l_sum);
					~out.add(\True_Position->Order[((3*pi)/2),0.2293363]);
				}
				);


			//location 4
			l4sig1=val[21].asBinaryDigits;
			l4sig1.removeAt(0);
			l4sig2=val[22].asBinaryDigits;
			l4sig2.removeAt(0);
			l4signal=l4sig2++l4sig1;
			l4signal=l4signal.convertDigits(base:2);
			if ( l4signal==0,                // Boolean expression (chooses one at random)
				{ "No Signal Location 4".postln; },    // true function
				{
					l_sum=(0.5*val[20]+35.5).asString++weight.getID(val[23]);
					~out.add(\Playback->signal.getID(l4signal););
					~out.add(\Location->4);
					~out.add(\Level->l_sum);
					~out.add(\True_Position->Order[0,0.2293363]);
				}
				);
				~dev_num=~out[\ID];
		}
	);
});

	MIDIdef.start(\recorder,{|src|
		var player;
		~out.postln;
		//Start Recording
		switch(~out[\Condition],
		\Normal,{
				~tau_write=File(format("%Carefully-%_Location-%_%_%.csv",~panorm,~out[\ID],~out[\Location],~out[\Playback],~out[\Level]),"w");
				~crpd_path=~panorm++"three_channels/";
				~raw_path=~panorms++"raw/";

			},
		\Closed,{
				~tau_write=File(format("%Carefully-%_Location-%_%_%.csv",~paclsd,~out[\ID],~out[\Location],~out[\Playback],~out[\Level]),"w");
				~crpd_path=~paclsd++"three_channels/";
				~raw_path=~paclsd++"raw/";
			},
		\Open,{
				~tau_write=File(format("%Carefully-%_Location-%_%_%.csv",~papn,~out[\ID],~out[\Location],~out[\Playback],~out[\Level]),"w");
				~crpd_path=~papn++"three_channels/";
				~raw_path=~papn++"raw/";
		});




		player=Routine({
				~rec_raw.prepareForRecord(format("%Raw_Carefully-%_Location-%_%_%.wav",~raw_path,~out[\ID],~out[\Location], ~out[\Playback],~out[\Level]),numChannels:8);
			~rec_crpd.prepareForRecord(format("%Three_Carefully-%_Location-%_%_%.wav",~crpd_path,~out[\ID], ~out[\Location], ~out[\Playback],~out[\Level]),numChannels:3);
		~mlis=Synth(\mic_listen_VS,[\out,~raw_bus,\in,~mic_input]);
		~mcrpd=Synth(\mic_listen_crpd,[\out,~crpd_bus,\in,~mic_input]);
		~gap_size.wait;
		~rec_raw.record(bus:~raw_bus);
		~rec_crpd.record(bus:~crpd_bus);
		});
	~nah=Routine({
			var l,s,out;
			~tau_write.write("Seconds,Azimuth,Elevation,Target Azimuth,Target Elevation,\n");
			while({true},{
				l=Pipe.new("cd /home/pi/november-2018/app_device_control/bin && ./vsctrl doa_peak get","r");
				l.getLine;
				l.getLine;
				s=l.getLine.split($ );
					out=format("%,%,%,%,%,\n",Date.localtime.secStamp,s.at(4),s.at(10),~out[\True_Position].at(0),~out[\True_Position].at(1));
				~tau_write.write(out);
				1.wait;
			});
		});
			"Recording Started".postln;
		player.play;
		~nah.play;
	});

	MIDIdef.stop(\freer,{|src|
		var stopper;
		//Stop Recording
		"this the stop".postln;
		stopper=Routine({
		~rec_raw.stopRecording;
		~rec_crpd.stopRecording;
		~nah.stop;
		2.wait;
		~mlis.free;
		~mcrpd.free;
		~nah.stop;
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

	l=Pipe.new(format("aconnect % %",sender,receiver),"r");
	l.getLine;
});

s.boot;
