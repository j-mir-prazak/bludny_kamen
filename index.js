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

function mpv_effect(index) {

	var index = index || false
	var effect = spawner.spawn("bash", new Array("-c", "node effect.js " + index), {detached: false})
	var decoder = new StringDecoder('utf-8')

	pids.push(effect["pid"])

	var effectTimeout = setTimeout(function(){
		effect.kill();
	},10000);


	console.log(index + ": " + effect["pid"])

	effect.stdout.on('data', (data) => {
	  var string = decoder.write(data)
		string=string.split(/\r?\n/)
		for( var i = 0; i < string.length; i++) {
			if ( string[i] != "" ) {
				console.log("effect " + index + " : " + string[i])
				}

			}
	});
	//not final state!
	effect.stderr.on('data', (data) => {


	});

	effect.on('close', function (pid, effectTimeout, index, code) {
		console.log(pid + " effect done. code " + code +".")
		cleanPID(pid)
		clearTimeout(effectTimeout)
		if ( players[index].started=true ) mpv_effect(index)

	}.bind(null, effect["pid"], effectTimeout, index));
	return effect;
}




function mpv_player(index, file) {

	var mpv = spawner.spawn("bash", new Array("-c", "./start_mpv.sh " + index + " " + file), {detached: false})
	var decoder = new StringDecoder('utf-8')

	pids.push(mpv["pid"])

	console.log(index + ": " + mpv["pid"])

	mpv.stdout.on('data', (data) => {
	  var string = decoder.write(data)
		string=string.split(/\r?\n/)
		for( var i = 0; i < string.length; i++) {
			if ( string[i] != "" ) console.log(index + " : " + string[i])
			if ( string[i].match(/AO:/) ) {
				players[index].started = true
				if (index == 1) {
					mpv_effect(index)
				}
				check_ready_players()
				}
			}
	});
	//not final state!
	mpv.stderr.on('data', (data) => {


	});

	mpv.on('close', function (pid, code) {
		console.log(pid + " mpv closed. code " + code +".")
		cleanPID(pid)
		for ( i in players ) {
			if ( players[i].pid == pid ) {
				delete players[i]
				if (code == 0) {
					check_dead_players(pid)
				}
				else {
					if ( status != "killing" && status != "dead" ) {
						status = "killing"
						kill_and_reset(pid)
					}
					else if ( status == "dead" ) {
						check_dead_players("")
					}
				}
			}
		}


	}.bind(null, mpv["pid"]));
	return mpv;
}

var players = {}
var players_count = 2
var status = "dead"

function setup_player(index,file) {
	var player = mpv_player(index, file)
	players[index] = 	{
		"player":player,
		"started":false,
		"pid":player["pid"]
		}
}

function check_ready_players() {
	var count = 0
	var length = 0
	for ( i in players ) {
		length++
		if ( players[i].started == true ) count++
	}
	console.log("ready: "+count)
	if (count == length && count == players_count) {
		console.log("all ready")
		bang_them(true)
	}
	//if too much
	else if (count == length && count > players_count) {
		console.log("all too much")
		kill_and_reset()
	}
}

function check_dead_players(pid) {

	var count = 0
	var length = 0
	for ( i in players ) {
		if ( players[i].pid == pid ) {
			delete players[i]
		}
		else  {
			count++
			length++
		}
	}
	if (count == length && count == 0) {
		status ="dead"
		console.log("all gone")
		console.log("once more!")
		if ( status == "dead" ) {
			setTimeout(function() { console.log("starting..."); setup_instalation(players_count)}, 1000);
		}
	}
}

function kill_and_reset(pid) {

	// console.log("kill")
	for ( i in players ) {
		if ( players[i].pid != pid ) {

			console.log("will kill " + players[i].pid)
			players[i].player.kill('SIGINT');
			delete players[i]
		}
	}

	status ="dead"
	console.log("all killed")

	check_dead_players("")

	}

function clean_up() {

		return spawner.spawnSync('bash', ['-c', './clean_up.sh']).status

}

function bang_them(play) {
		var play = play || false
		if ( play)	{
			status = "playing"
			console.log("starting playback")
			console.log("bang: " + spawner.spawnSync('bash', ['-c', './bang_mpv.sh play']).status )
		}
		else {
			status = "pausing"
			console.log("pausing playback")
			console.log("bang:" + spawner.spawnSync('bash', ['-c', './bang_mpv.sh pause']).status )
		}
}

function setup_instalation ( instances ) {
	var instances = instances || false
	status = "setting"
	console.log( clean_up() )
	for ( var i = 1;  i <= instances; i++ ) {
		if ( i == 1 ) setup_player(i, "./audio/kapital.flac")
		if ( i == 2 ) setup_player(i, "./audio/fulba.flac")

	}

}

var file=""
var assets = new Array();

if ( fs.existsSync('assets')) {

	console.log("assets folder exists.")

	assets = fs.readdirSync('assets')

	if ( assets.length < 1) {

		console.log("no assets. default playback.")
		file = "the_sea.flac"
	}

	else {

		console.log("assets:")
		console.log(assets)
		console.log("playing first.")
		file = "./assets/" + assets[0]

	}
	console.log("file: " + file)

}






console.log("waiting...");
setTimeout(function() {
	console.log("starting...");
	setup_instalation(players_count)
}, 1000);
