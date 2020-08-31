s.doWhenBooted({
var path,l,test_config,major,minor,patch,dev_id,firmware_id,room_c,level,room_condition,firmware,sender,receiver;

room_condition=TwoWayIdentityDictionary[\Normal->0,\Closed->1,\Open->2];
firmware=TwoWayIdentityDictionary['APP-MIC-RECORDER_DDR426797A2936B'->0,'VocalSorcery_1.0.4'->1];
sender="128:4";
receiver="20:0";
path=PathName.new(File.getcwd++"/calibration_samples/");
test_config=0;
major=0;
minor=0;
patch=0;
dev_id=6;
firmware_id=firmware.at('VocalSorcery_1.0.4');
room_c=room_condition.at(\Closed);
~gap_size=0.05;


~signal=TwoWayIdentityDictionary['1kHz Tone'->1,'Person_3_(male)_03_16kHz_chopped'->2,'Person_3_(male)_03_48kHz_chopped'->3];
~weight=TwoWayIdentityDictionary['dBeq(A)'->0,'dBeq(C)'->1,'dBeq(Z)'->2,'dBf(A)'->3,'dBf(C)'->4,'dBeq(Z)'->5,'dBs(A)'->6,'dBs(C)'->7,'dBs(Z)'->8];
m=Server.local.options;
m.numOutputBusChannels=10;
m.numInputBusChannels=10;
m.numBuffers=2000;
~sys=Array.fill(24, { arg i; 0 });
~sys.insert(0,240);
~sys.insert(25,247);
~sys.insert(1,test_config);
~sys.insert(2,major);
~sys.insert(3,minor);
~sys.insert(4,patch);
~sys.insert(5,dev_id);
~sys.insert(6,firmware_id);
~sys.insert(7,room_c);

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


~cal_samp=Order.new(size:3);

path.entries.do({|path|
	~cal_samp.add(Buffer.read(s,path.fullPath));
});

MIDIClient.init;
g=MIDIOut.new(0);
g.latency=0;

~speech_rec=Routine({
	var synth,second,nframe,rate,buffer_num,sys_out,playout,level,signal,weight;

	sys_out=~sys;
	playout=0;
	level=94; //Level in dB
	signal=~signal.at('Person_3_(male)_03_48kHz_chopped');
	weight=~weight.at('dBeq(A)');

	switch(playout,
		0,{sys_out.put(8,((2*level)-71));
				sys_out.put(9,signal);
				sys_out.put(10,0);
				sys_out.put(11,weight);
		},
		1,{sys_out.put(12,((2*level)-71));
				sys_out.put(13,signal);
				sys_out.put(14,0);
				sys_out.put(15,weight);},
		2,{sys_out.put(16,((2*level)-71));
				sys_out.put(17,signal);
				sys_out.put(18,0);
				sys_out.put(19,weight);},
		3,{sys_out.put(20,((2*level)-71));
				sys_out.put(21,signal);
				sys_out.put(22,0);
				sys_out.put(23,weight);}
	);

	sys_out=sys_out.as(Int8Array);
	g.sysex(sys_out);

	//Setting up playback
	buffer_num=(signal-1);
	nframe=~cal_samp.at(buffer_num).numFrames;
	rate=~cal_samp.at(buffer_num).sampleRate;
	second=(nframe/rate);
	(5*~gap_size).wait;
	synth=Synth(\playbuf_m,[\amp,1,\cal,~noi_cal,\out,~playout,\bufnum,~cal_samp.at(buffer_num),\lp,0]);
	g.start;
	(second+~gap_size).wait;
	g.stop;

	});


	    //connects midi output
	    f=Pipe.new(format("aconnect % %",sender,receiver),"r");
        f.getLine;
});

s.boot;
~noi_cal=1;


/**
-9.2 at 0
-6.9 at 1
-2.7 at 2
-2.7 at 3
var noise_calibration;noise_calibration=(-9.2);
~noi_cal=noise_calibration.dbamp;

~ncl=Synth(\playbuf_m,[\amp,1,\cal,~noi_cal,\out,2,\bufnum,~cal_samp.at(0).bufnum,\lp,1]);

**/



