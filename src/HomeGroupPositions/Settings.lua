HomeGroupPositions.Settings = {
    defaults = {
        serverSpecific = {
            commEnabled = true,  -- Enable/disable communication.
            channelName = 'HGP',  -- Communication channel name.
            sendInterval = 200,  -- How often to send updates (milliseconds).
            pruneTimeout = 5,  -- Prune position updates older than this (seconds).
        },
    },
    limits = {
        sendInterval = {
            min = 200,
            max = 1000,
            step = 50,
        },
        pruneTimeout = {
            min = 1,
            max = 10,
            step = 1,
        },
    },
    serverSpecific = {},
}
