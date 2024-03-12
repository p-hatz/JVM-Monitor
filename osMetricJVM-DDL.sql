CREATE TABLE `osMetricJVM` (
  `pid` int(11) NOT NULL,
  `captureDt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `binName` varchar(128) DEFAULT NULL,
  `binParms` varchar(4000) DEFAULT NULL,
  `binType` varchar(32) DEFAULT NULL,
  `cpuUsage` decimal(5,2) DEFAULT NULL,
  `memUsage` decimal(5,2) DEFAULT NULL,
  `createdt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
