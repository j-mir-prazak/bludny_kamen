#!/usr/bin/node
//modules declaration
var spawner = require('child_process')
var StringDecoder = require('string_decoder').StringDecoder
var events = require('events')
var fs = require('fs')


//clean up
process.on('SIGHUP',  function(){ console.log('\nCLOSING: [SIGHUP]'); process.emit("SIGINT"); })
process.on('SIGINT',  function(){
	 console.log('\nCLOSING: [SIGINT]');
	 for (var i = 0; i < pids.length; i++) {
		console.log("KILLING: " + pids[i])
		console.log(process.kill( pids[i], 0 ))
		if ( process.kill( pids[i], 0 ) ) process.kill( pids[i] )
 	}
	 process.emit("SIGKILL");
	 process.exit(0);
 })
process.on('SIGQUIT', function(){ console.log('\nCLOSING: [SIGQUIT]'); process.emit("SIGINT"); })
process.on('SIGABRT', function(){ console.log('\nCLOSING: [SIGABRT]'); process.emit("SIGINT"); })
process.on('SIGTERM', function(){ console.log('\nCLOSING: [SIGTERM]'); process.emit("SIGINT"); })

var pids = new Array();

function cleanPID(pid) {
	var pid = pid || false
	for (var i = 0; i < pids.length; i++) {
		if ( pids[i] == pid ) {
			pids.splice(i, 1)
			console.log("PID"+pid+" deleted")
		}
	}
}


function send_mpv_speed_effect( args ) {

	var sleep = args[0] || false;
	var speed = args[1] || false;
	var input = args[2] || false;

	console.log("sleep "+sleep)
	console.log("speed "+speed)

	var effect = spawner.spawn( './speed_effect.sh', new Array(sleep,speed,input), {detached:true, shell:'/bin/bash'} )
	var killerInstinct = setTimeout(function(){
		console.log("kill")
		console.log(effect.pid)
		// process.kill(effect.pid);
		if ( process.kill( effect.pid, 0 ) ) process.kill( effect.pid )
	},500)
	var decoder = new StringDecoder('utf-8')

	pids.push(effect["pid"])

	effect.stdout.on('data', (data) => {
	  var string = decoder.write(data)
		string=string.split(/\r?\n/)
		for( var i = 0; i < string.length; i++) {
			if ( string[i] != "" ) console.log(string[i])
			if ( string[i] != "bang" ) {
				console.log(sleep + " " + speed)
				clearTimeout(killerInstinct)
				killerInstinct = setTimeout(function(){
					console.log("kill")
					console.log(effect.pid)
					// process.kill(effect.pid);
					if ( process.kill( effect.pid, 0 ) ) process.kill( effect.pid )
				},(sleep*10)+10)

			}

			}
	});
	//not final state!
	effect.stderr.on('data', (data) => {


	});

	effect.on('close', function (pid,code) {
		clearTimeout(killerInstinct)
		console.log(pid + " effect done. code " + code +".")
		cleanPID(pid)
		handling_queue = false;
		queue_handler();


	}.bind(null, effect["pid"]));
	return effect;




}

//random between including
function randomBetween(min, max) {
	var min = min || false;
	var max = max | false;

	var r = Math.floor( Math.random() * ( max+1 - min ) ) + min
	return r;

}

function mpv_speed_effect ( input ) {
	var input = input || false;
	var start = String(randomBetween(910,999));
	for (var i = 0; i < randomBetween(69,92); i++) {

		// send_mpv_speed_effect(String(randomBetween(0,9)), String(randomBetween(89,99)), input)
		queue.push({
			"function":send_mpv_speed_effect,
			"args":[String(randomBetween(5,9)), start - i,  input]
		});

	}
	// console.log(queue)
	queue_handler()



}


var queue = new Array();
var handling_queue = false;

function queue_handler() {
	console.log("handling")

	if ( handling_queue == false && queue.length > 0 ) {
		handling_queue = true;
		var first = queue.shift();
		first["function"](first["args"])
	}

}


var index = process.argv[2];

mpv_speed_effect(index);

// mpv_effect()