/datum/controller/process/pipenet/setup()
	name = "pipenet"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/pipenet/doWork()
	for(var/datum/pipeline/P in pipe_networks)
		P.process()
		scheck()

	//for(var/datum/pipe_network/pipeNetwork in pipe_networks)
	//	if(istype(pipeNetwork) && !pipeNetwork.disposed)
	//		pipeNetwork.process()
	//		scheck()
	//		continue

	//	pipe_networks.Remove(pipeNetwork)