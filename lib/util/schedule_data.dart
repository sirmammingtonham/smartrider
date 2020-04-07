// File to hold a bunch of lists for our listbuilders
final shuttleStopLists = [south_stops, north_stops, west_stops];
final shuttleTimeLists = [
  weekday_south.expand((i) => i).toList(), 
  weekday_north.expand((i) => i).toList(), 
  weekday_west.expand((i) => i).toList()
];
final busStopLists = [
  stops_87,
  stops_286,
  stops_289,

];
final busTimeLists = [
  times_87.expand((i) => i).toList(),
  times_286.expand((i) => i).toList(),
  times_289.expand((i) => i).toList(),
];

// Shuttle Schedules //
List<String> north_stops = [
  "Union to Troy Crosswalk",
  "Troy Crosswalk to 9th St",
  "9th St to Alumni House",
  "Alumni House to Jacob",
  "Jacob to Colonie",
  "Colonie to Georgian",
  "Georgian to Brinsmade",
  "Brinsmade to Sunset 1",
  "Sunset 1 to Sunset 2",
  "Sunset 2 to E-Lot",
  "E-Lot to B-Lot",
  "B-Lot to Union",
];

List<String> south_stops = [
  "Union to B-Lot",
  "B-Lot to LXA",
  "LXA to Tibitts/Orchard",
  "Tibitts/Orchard to Polytech",
  "Polytech to 15th/College",
];

List<String> west_stops = [
  "Union to CBIS/AH",
  "CBIS/AH to 15th/Off Commons",
  "15th/Off Commons to 15th/Poly",
  "15th/Poly to City Station",
  "City Station to Blitman",
  "Blitman to Winslow",
  "Winslow to West",
  "West to 87 Gym",
  "87 Gym to Union",
];

List<List<String>> weekday_south = [
  ["7:15am","7:17am","7:18am","7:20am","7:23am","7:25am"],
  ["7:27am","7:29am","7:30am","7:32am","7:35am","7:37am"],
  ["7:39am","7:41am","7:42am","7:44am","7:47am","7:49am"],
  ["7:51am","7:53am","7:54am","7:56am","7:59am","8:01am"],
  ["8:03am","8:05am","8:06am","8:08am","8:11am","8:13am"],
  ["8:15am","8:17am","8:18am","8:20am","8:23am","8:25am"],
  ["8:27am","8:29am","8:30am","8:32am","8:35am","8:37am"],
  ["8:39am","8:41am","8:42am","8:44am","8:47am","8:49am"],
  ["8:51am","8:53am","8:54am","8:56am","8:59am","9:01am"],
  ["9:03am","9:05am","9:06am","9:08am","9:11am","9:13am"],
  ["9:15am","9:17am","9:18am","9:20am","9:23am","9:25am"],
  ["9:20am","9:22am","9:23am","9:25am","9:28am","9:30am"],
  ["9:32am","9:34am","9:35am","9:37am","9:40am","9:42am"],
  ["9:44am","9:46am","9:47am","9:49am","9:52am","9:54am"],
  ["9:56am","9:58am","9:59am","10:01am","10:04am","10:06am"],
  ["10:08am","10:10am","10:11am","10:13am","10:16am","10:18am"],
  ["10:20am","10:22am","10:23am","10:25am","10:28am","10:30am"],
  ["10:32am","10:34am","10:35am","10:37am","10:40am","10:42am"],
  ["10:44am","10:46am","10:47am","10:49am","10:52am","10:54am"],
  ["10:56am","10:58am","10:59am","11:01am","11:04am","11:06am"],
  ["11:08am","11:10am","11:11am","11:13am","11:16am","11:18am"],
  ["11:20am","11:22am","11:23am","11:25am","11:28am","11:30am"],
  ["11:32am","11:34am","11:35am","11:37am","11:40am","11:42am"],
  ["11:44am","11:46am","11:47am","11:49am","11:52am","11:54am"],
  ["11:56am","11:58am","11:59am","12:01pm","12:04pm","12:06pm"],
  ["12:08pm","12:10pm","12:11pm","12:13pm","12:16pm","12:18pm"],
  ["12:20pm","12:22pm","12:23pm","12:25pm","12:28pm","12:30pm"],
  ["12:44pm","12:46pm","12:47pm","12:49pm","12:52pm","12:54pm"],
  ["12:56pm","12:58pm","12:59pm","1:01pm","1:04pm","1:06pm"],
  ["1:08pm","1:10pm","1:11pm","1:13pm","1:16pm","1:18pm"],
  ["1:20pm","1:22pm","1:23pm","1:25pm","1:28pm","1:30pm"],
  ["1:44pm","1:46pm","1:47pm","1:49pm","1:52pm","1:54pm"],
  ["1:56pm","1:58pm","1:59pm","2:01pm","2:04pm","2:06pm"],
  ["2:08pm","2:10pm","2:11pm","2:13pm","2:16pm","2:18pm"],
  ["2:20pm","2:22pm","2:23pm","2:25pm","2:28pm","2:30pm"],
  ["2:44pm","2:46pm","2:47pm","2:49pm","2:52pm","2:54pm"],
  ["2:56pm","2:58pm","2:59pm","3:01pm","3:04pm","3:06pm"],
  ["3:08pm","3:10pm","3:11pm","3:13pm","3:16pm","3:18pm"],
  ["3:20pm","3:22pm","3:23pm","3:25pm","3:28pm","3:30pm"],
  ["3:44pm","3:46pm","3:47pm","3:49pm","3:52pm","3:54pm"],
  ["3:56pm","3:58pm","3:59pm","4:01pm","4:04pm","4:06pm"],
  ["4:08pm","4:10pm","4:11pm","4:13pm","4:16pm","4:18pm"],
  ["4:20pm","4:22pm","4:23pm","4:25pm","4:28pm","4:30pm"],
  ["4:44pm","4:46pm","4:47pm","4:49pm","4:52pm","4:54pm"],
  ["4:50pm","4:52pm","4:53pm","4:55pm","4:58pm","5:00pm"],
  ["4:56pm","4:58pm","4:59pm","5:01pm","5:04pm","5:06pm"],
  ["5:02pm","5:04pm","5:05pm","5:07pm","5:10pm","5:12pm"],
  ["5:14pm","5:16pm","5:17pm","5:19pm","5:22pm","5:24pm"],
  ["5:26pm","5:28pm","5:29pm","5:31pm","5:34pm","5:36pm"],
  ["5:38pm","5:40pm","5:41pm","5:43pm","5:46pm","5:48pm"],
  ["5:50pm","5:52pm","5:53pm","5:55pm","5:58pm","6:00pm"],
  ["6:02pm","6:04pm","6:05pm","6:07pm","6:10pm","6:12pm"],
  ["6:14pm","6:16pm","6:17pm","6:19pm","6:22pm","6:24pm"],
  ["6:26pm","6:28pm","6:29pm","6:31pm","6:34pm","6:36pm"],
  ["6:38pm","6:40pm","6:41pm","6:43pm","6:46pm","6:48pm"],
  ["6:50pm","6:52pm","6:53pm","6:55pm","6:58pm","7:00pm"],
  ["7:02pm","7:04pm","7:05pm","7:07pm","7:10pm","7:12pm"],
  ["7:14pm","7:16pm","7:17pm","7:19pm","7:22pm","7:24pm"],
  ["7:20pm","7:22pm","7:23pm","7:25pm","7:28pm","7:30pm"],
  ["7:26pm","7:28pm","7:29pm","7:31pm","7:34pm","7:36pm"],
  ["7:32pm","7:34pm","7:35pm","7:37pm","7:40pm","7:42pm"],
  ["7:38pm","7:40pm","7:41pm","7:43pm","7:46pm","7:48pm"],
  ["7:44pm","7:46pm","7:47pm","7:49pm","7:52pm","7:54pm"],
  ["7:50pm","7:52pm","7:53pm","7:55pm","7:58pm","8:00pm"],
  ["7:56pm","7:58pm","7:59pm","8:01pm","8:04pm","8:06pm"],
  ["8:02pm","8:04pm","8:05pm","8:07pm","8:10pm","8:12pm"],
  ["8:08pm","8:10pm","8:11pm","8:13pm","8:16pm","8:18pm"],
  ["8:20pm","8:22pm","8:23pm","8:25pm","8:28pm","8:30pm"],
  ["8:32pm","8:34pm","8:35pm","8:37pm","8:40pm","8:42pm"],
  ["8:44pm","8:46pm","8:47pm","8:49pm","8:52pm","8:54pm"],
  ["8:56pm","8:58pm","8:59pm","9:01pm","9:04pm","9:06pm"],
  ["9:08pm","9:10pm","9:11pm","9:13pm","9:16pm","9:18pm"],
  ["9:20pm","9:22pm","9:23pm","9:25pm","9:28pm","9:30pm"],
  ["9:32pm","9:34pm","9:35pm","9:37pm","9:40pm","9:42pm"],
  ["9:44pm","9:46pm","9:47pm","9:49pm","9:52pm","9:54pm"],
  ["9:56pm","9:58pm","9:59pm","10:01pm","10:04pm","10:06pm"],
  ["10:08pm","10:10pm","10:11pm","10:13pm","10:16pm","10:18pm"],
  ["10:20pm","10:22pm","10:23pm","10:25pm","10:28pm","10:30pm"],
  ["10:32pm","10:34pm","10:35pm","10:37pm","10:40pm","10:42pm"]
];

List<List<String>> weekday_north = [
  ["7:00am","7:02am","7:03am","7:04am","7:06am","7:08am","7:10am","7:11am","7:12am","7:13am","7:14am","7:15am"],
  ["7:18am","7:20am","7:21am","7:22am","7:24am","7:26am","7:28am","7:29am","7:30am","7:31am","7:32am","7:33am"],
  ["7:36am","7:38am","7:39am","7:40am","7:42am","7:44am","7:46am","7:47am","7:48am","7:49am","7:50am","7:51am"],
  ["7:54am","7:56am","7:57am","7:58am","8:00am","8:02am","8:03am","8:04am","8:05am","8:06am","8:07am","8:08am"],
  ["8:11am","8:13am","8:14am","8:15am","8:17am","8:19am","8:20am","8:21am","8:22am","8:23am","8:24am","8:25am"],
  ["8:20am","8:22am","8:23am","8:24am","8:26am","8:28am","8:30am","8:31am","8:32am","8:33am","8:34am","8:35am"],
  ["8:28am","8:30am","8:31am","8:32am","8:34am","8:36am","8:37am","8:38am","8:39am","8:40am","8:41am","8:42am"],
  ["8:38am","8:40am","8:41am","8:42am","8:44am","8:46am","8:48am","8:49am","8:50am","8:51am","8:52am","8:53am"],
  ["8:45am","8:47am","8:48am","8:49am","8:51am","8:53am","8:55am","8:56am","8:57am","8:58am","8:59am","9:00am"],
  ["8:56am","8:58am","8:59am","9:00am","9:02am","9:04am","9:06am","9:07am","9:08am","9:09am","9:10am","9:11am"],
  ["9:03am","9:05am","9:06am","9:07am","9:09am","9:11am","9:13am","9:14am","9:15am","9:16am","9:17am","9:18am"],
  ["9:14am","9:16am","9:17am","9:18am","9:20am","9:22am","9:24am","9:25am","9:26am","9:27am","9:28am","9:29am"],
  ["9:21am","9:23am","9:24am","9:25am","9:27am","9:29am","9:31am","9:32am","9:33am","9:34am","9:35am","9:36am"],
  ["9:32am","9:34am","9:35am","9:36am","9:38am","9:40am","9:42am","9:43am","9:44am","9:45am","9:46am","9:47am"],
  ["9:39am","9:41am","9:42am","9:43am","9:45am","9:47am","9:49am","9:50am","9:51am","9:52am","9:53am","9:54am"],
  ["9:50am","9:52am","9:53am","9:54am","9:56am","9:58am","10:00am","10:01am","10:02am","10:03am","10:04am","10:05am"],
  ["9:57am","9:59am","10:00am","10:01am","10:03am","10:05am","10:07am","10:08am","10:09am","10:10am","10:11am","10:12am"],
  ["10:08am","10:10am","10:11am","10:12am","10:14am","10:16am","10:18am","10:19am","10:20am","10:21am","10:22am","10:23am"],
  ["10:15am","10:17am","10:18am","10:19am","10:21am","10:23am","10:25am","10:26am","10:27am","10:28am","10:29am","10:30am"],
  ["10:26am","10:28am","10:29am","10:30am","10:32am","10:34am","10:36am","10:37am","10:38am","10:39am","10:40am","10:41am"],
  ["10:33am","10:35am","10:36am","10:37am","10:39am","10:41am","10:43am","10:44am","10:45am","10:46am","10:47am","10:48am"],
  ["10:44am","10:46am","10:47am","10:48am","10:50am","10:52am","10:54am","10:55am","10:56am","10:57am","10:58am","10:59am"],
  ["10:51am","10:53am","10:54am","10:55am","10:57am","10:59am","11:01am","11:02am","11:03am","11:04am","11:05am","11:06am"],
  ["11:02am","11:04am","11:05am","11:06am","11:08am","11:10am","11:12am","11:13am","11:14am","11:15am","11:16am","11:17am"],
  ["11:09am","11:11am","11:12am","11:13am","11:15am","11:17am","11:19am","11:20am","11:21am","11:22am","11:23am","11:24am"],
  ["11:20am","11:22am","11:23am","11:24am","11:26am","11:28am","11:30am","11:31am","11:32am","11:33am","11:34am","11:35am"],
  ["11:27am","11:29am","11:30am","11:31am","11:33am","11:35am","11:37am","11:38am","11:39am","11:40am","11:41am","11:42am"],
  ["11:38am","11:40am","11:41am","11:42am","11:44am","11:46am","11:48am","11:49am","11:50am","11:51am","11:52am","11:53am"],
  ["11:45am","11:47am","11:48am","11:49am","11:51am","11:53am","11:55am","11:56am","11:57am","11:58am","11:59am","12:00pm"],
  ["11:56am","11:58am","11:59am","12:00pm","12:02pm","12:04pm","12:06pm","12:07pm","12:08pm","12:09pm","12:10pm","12:11pm"],
  ["12:03pm","12:05pm","12:06pm","12:07pm","12:09pm","12:11pm","12:13pm","12:14pm","12:15pm","12:16pm","12:17pm","12:18pm"],
  ["12:14pm","12:16pm","12:17pm","12:18pm","12:20pm","12:22pm","12:24pm","12:25pm","12:26pm","12:27pm","12:28pm","12:29pm"],
  ["12:20pm","12:22pm","12:23pm","12:24pm","12:26pm","12:28pm","12:30pm","12:31pm","12:32pm","12:33pm","12:34pm","12:35pm"],
  ["12:21pm","12:23pm","12:24pm","12:25pm","12:27pm","12:29pm","12:31pm","12:32pm","12:33pm","12:34pm","12:35pm","12:36pm"],
  ["12:32pm","12:34pm","12:35pm","12:36pm","12:38pm","12:40pm","12:42pm","12:43pm","12:44pm","12:45pm","12:46pm","12:47pm"],
  ["12:39pm","12:41pm","12:42pm","12:43pm","12:45pm","12:47pm","12:49pm","12:50pm","12:51pm","12:52pm","12:53pm","12:54pm"],
  ["12:56pm","12:58pm","12:59pm","1:00pm","1:02pm","1:04pm","1:06pm","1:07pm","1:08pm","1:09pm","1:10pm","1:11pm"],
  ["12:57pm","12:59pm","1:00pm","1:02pm","1:04pm","1:06pm","1:08pm","1:09pm","1:10pm","1:11pm","1:12pm","1:13pm"],
  ["1:14pm","1:16pm","1:17pm","1:18pm","1:20pm","1:22pm","1:24pm","1:26pm","1:27pm","1:28pm","1:29pm","1:30pm"],
  ["1:16pm","1:18pm","1:19pm","1:21pm","1:23pm","1:25pm","1:27pm","1:28pm","1:29pm","1:30pm","1:31pm","1:32pm"],
  ["1:33pm","1:35pm","1:36pm","1:37pm","1:39pm","1:41pm","1:43pm","1:44pm","1:45pm","1:46pm","1:47pm","1:43pm"],
  ["1:35pm","1:37pm","1:38pm","1:39pm","1:41pm","1:43pm","1:45pm","1:46pm","1:47pm","1:48pm","1:49pm","1:50pm"],
  ["1:46pm","1:48pm","1:49pm","1:50pm","1:52pm","1:54pm","1:56pm","1:57pm","1:58pm","1:59pm","2:00pm","2:01pm"],
  ["1:53pm","1:55pm","1:56pm","1:57pm","1:59pm","2:01pm","2:03pm","2:04pm","2:05pm","2:06pm","2:07pm","2:08pm"],
  ["2:04pm","2:06pm","2:07pm","2:08pm","2:10pm","2:12pm","2:14pm","2:15pm","2:16pm","2:17pm","2:18pm","2:19pm"],
  ["2:11pm","2:13pm","2:14pm","2:15pm","2:17pm","2:19pm","2:21pm","2:22pm","2:23pm","2:24pm","2:25pm","2:26pm"],
  ["2:22pm","2:24pm","2:25pm","2:26pm","2:28pm","2:30pm","2:32pm","2:31pm","2:32pm","2:33pm","2:34pm","2:35pm"],
  ["2:29pm","2:31pm","2:32pm","2:33pm","2:35pm","2:37pm","2:39pm","2:40pm","2:41pm","2:42pm","2:43pm","2:44pm"],
  ["2:38pm","2:40pm","2:41pm","2:42pm","2:44pm","2:46pm","2:48pm","2:49pm","2:50pm","2:51pm","2:52pm","2:53pm"],
  ["2:50pm","2:52pm","2:53pm","2:54pm","2:56pm","2:58pm","3:00pm","3:01pm","3:02pm","3:03pm","3:04pm","3:05pm"],
  ["2:56pm","2:58pm","2:59pm","3:00pm","3:02pm","3:04pm","3:06pm","3:08pm","3:10pm","3:11pm","3:12pm","3:13pm"],
  ["3:00pm","3:02pm","3:03pm","3:04pm","3:06pm","3:08pm","3:10pm","3:11pm","3:12pm","3:13pm","3:14pm","3:15pm"],
  ["3:08pm","3:10pm","3:11pm","3:12pm","3:14pm","3:16pm","3:18pm","3:19pm","3:20pm","3:21pm","3:22pm","3:23pm"],
  ["3:16pm","3:18pm","3:19pm","3:20pm","3:22pm","3:24pm","3:26pm","3:27pm","3:28pm","3:29pm","3:30pm","3:31pm"],
  ["3:18pm","3:20pm","3:21pm","3:22pm","3:24pm","3:26pm","3:28pm","3:29pm","3:30pm","3:31pm","3:32pm","3:33pm"],
  ["3:26pm","3:28pm","3:29pm","3:30pm","3:32pm","3:34pm","3:36pm","3:37pm","3:38pm","3:39pm","3:40pm","3:41pm"],
  ["3:34pm","3:36pm","3:37pm","3:38pm","3:40pm","3:42pm","3:44pm","3:45pm","3:46pm","3:47pm","3:48pm","3:49pm"],
  ["3:36pm","3:38pm","3:39pm","3:40pm","3:42pm","3:44pm","3:46pm","3:47pm","3:48pm","3:49pm","3:50pm","3:51pm"],
  ["3:44pm","3:46pm","3:47pm","3:48pm","3:50pm","3:52pm","3:54pm","3:55pm","3:56pm","3:57pm","3:58pm","3:59pm"],
  ["3:52pm","3:54pm","3:55pm","3:56pm","3:58pm","4:00pm","4:02pm","4:03pm","4:04pm","4:05pm","4:06pm","4:07pm"],
  ["3:54pm","3:56pm","3:57pm","3:58pm","4:00pm","4:02pm","4:04pm","4:05pm","4:06pm","4:07pm","4:08pm","4:09pm"],
  ["4:02pm","4:04pm","4:05pm","4:06pm","4:08pm","4:10pm","4:12pm","4:13pm","4:14pm","4:15pm","4:16pm","4:17pm"],
  ["4:12pm","4:14pm","4:15pm","4:16pm","4:18pm","4:20pm","4:22pm","4:23pm","4:24pm","4:25pm","4:26pm","4:27pm"],
  ["4:20pm","4:22pm","4:23pm","4:24pm","4:26pm","4:28pm","4:30pm","4:31pm","4:32pm","4:33pm","4:34pm","4:35pm"],
  ["4:30pm","4:32pm","4:33pm","4:34pm","4:36pm","4:38pm","4:40pm","4:41pm","4:42pm","4:43pm","4:44pm","4:45pm"],
  ["4:38pm","4:40pm","4:41pm","4:42pm","4:44pm","4:46pm","4:48pm","4:49pm","4:50pm","4:51pm","4:52pm","4:53pm"],
  ["4:48pm","4:50pm","4:51pm","4:52pm","4:54pm","4:56pm","4:58pm","4:59pm","5:00pm","5:01pm","5:02pm","5:03pm"],
  ["4:56pm","4:58pm","4:59pm","5:00pm","5:02pm","5:04pm","5:06pm","5:07pm","5:08pm","5:09pm","5:10pm","5:11pm"],
  ["5:06pm","5:08pm","5:09pm","5:10pm","5:12pm","5:14pm","5:16pm","5:17pm","5:18pm","5:19pm","5:20pm","5:21pm"],
  ["5:14pm","5:16pm","5:17pm","5:18pm","5:20pm","5:22pm","5:24pm","5:25pm","5:26pm","5:27pm","5:28pm","5:29pm"],
  ["5:24pm","5:26pm","5:27pm","5:28pm","5:30pm","5:32pm","5:34pm","5:35pm","5:36pm","5:37pm","5:38pm","5:39pm"],
  ["5:32pm","5:34pm","5:35pm","5:36pm","5:38pm","5:40pm","5:42pm","5:43pm","5:44pm","5:45pm","5:46pm","5:47pm"],
  ["5:42pm","5:44pm","5:45pm","5:46pm","5:48pm","5:50pm","5:52pm","5:53pm","5:54pm","5:55pm","5:56pm","5:57pm"],
  ["5:50pm","5:52pm","5:53pm","5:54pm","5:56pm","5:58pm","6:00pm","6:01pm","6:02pm","6:03pm","6:04pm","6:05pm"],
  ["6:00pm","6:02pm","6:03pm","6:04pm","6:06pm","6:08pm","6:10pm","6:11pm","6:12pm","6:13pm","6:14pm","6:15pm"],
  ["6:18pm","6:20pm","6:21pm","6:22pm","6:24pm","6:26pm","6:28pm","6:29pm","6:30pm","6:31pm","6:32pm","6:33pm"],
  ["6:36pm","6:38pm","6:39pm","6:40pm","6:42pm","6:44pm","6:46pm","6:47pm","6:48pm","6:49pm","6:50pm","6:51pm"],
  ["6:54pm","6:56pm","6:57pm","6:58pm","7:00pm","7:02pm","7:04pm","7:05pm","7:06pm","7:07pm","7:08pm","7:09pm"],
  ["7:12pm","7:14pm","7:15pm","7:16pm","7:18pm","7:20pm","7:22pm","7:23pm","7:24pm","7:25pm","7:26pm","7:27pm"],
  ["7:30pm","7:32pm","7:33pm","7:34pm","7:36pm","7:38pm","7:40pm","7:41pm","7:42pm","7:43pm","7:44pm","7:45pm"],
  ["7:48pm","7:50pm","7:51pm","7:52pm","7:54pm","7:56pm","7:58pm","7:59pm","8:00pm","8:01pm","8:02pm","8:03pm"],
  ["8:06pm","8:08pm","8:09pm","8:10pm","8:12pm","8:14pm","8:16pm","8:17pm","8:18pm","8:19pm","8:20pm","8:21pm"],
  ["8:24pm","8:26pm","8:27pm","8:28pm","8:30pm","8:32pm","8:34pm","8:35pm","8:36pm","8:37pm","8:38pm","8:39pm"],
  ["8:42pm","8:44pm","8:45pm","8:46pm","8:48pm","8:50pm","8:52pm","8:53pm","8:54pm","8:55pm","8:56pm","8:57pm"],
  ["9:00pm","9:02pm","9:03pm","9:04pm","9:06pm","9:08pm","9:10pm","9:11pm","9:12pm","9:13pm","9:14pm","9:15pm"],
  ["9:18pm","9:20pm","9:21pm","9:22pm","9:24pm","9:26pm","9:28pm","9:29pm","9:30pm","9:31pm","9:32pm","9:33pm"],
  ["9:36pm","9:38pm","9:39pm","9:40pm","9:42pm","9:44pm","9:46pm","9:47pm","9:48pm","9:49pm","9:50pm","9:51pm"],
  ["9:54pm","9:56pm","9:57pm","9:58pm","10:00pm","10:02pm","10:04pm","10:05pm","10:06pm","10:07pm","10:08pm","10:09pm"],
  ["10:12pm","10:14pm","10:15pm","10:16pm","10:18pm","10:20pm","10:22pm","10:23pm","10:24pm","10:25pm","10:26pm","10:27pm"],
  ["10:30pm","10:32pm","10:33pm","10:34pm","10:36pm","10:38pm","10:40pm","10:41pm","10:42pm","10:43pm","10:44pm","10:45pm"],
  ["10:48pm","10:50pm","10:51pm","10:52pm","10:54pm","10:56pm","10:58pm","10:59pm","11:00pm","11:01pm","11:02pm","11:03pm"]
];

List<List<String>> weekday_west =[
  ["7:00am","7:01am","7:01am","7:03am","7:06am","7:08am","7:10am","7:12am","7:13am"],
  ["7:15am","7:16am","7:16am","7:18am","7:21am","7:23am","7:25am","7:27am","7:28am"],
  ["7:30am","7:31am","7:31am","7:33am","7:36am","7:38am","7:40am","7:42am","7:43am"],
  ["7:45am","7:46am","7:46am","7:48am","7:51am","7:53am","7:55am","7:57am","7:58am"],
  ["7:52am","7:53am","7:53am","7:55am","7:58am","8:01am","8:03am","8:05am","8:06am"],
  ["8:00am","8:01am","8:01am","8:03am","8:06am","8:08am","8:10am","8:12am","8:13am"],
  ["8:08am","8:09am","8:09am","8:10am","8:13am","8:15am","8:17am","8:19am","8:20am"],
  ["8:15am","8:16am","8:16am","8:18am","8:21am","8:23am","8:25am","8:27am","8:28am"],
  ["8:22am","8:23am","8:23am","8:25am","8:28am","8:30am","8:32am","8:34am","8:35am"],
  ["8:30am","8:31am","8:31am","8:33am","8:36am","8:38am","8:40am","8:42am","8:43am"],
  ["8:37am","8:38am","8:38am","8:40am","8:43am","8:45am","8:47am","8:49am","8:50am"],
  ["8:45am","8:46am","8:46am","8:48am","8:51am","8:53am","8:55am","8:57am","8:58am"],
  ["8:52am","8:53am","8:53am","8:55am","8:58am","9:00am","9:02am","9:04am","9:05am"],
  ["9:00am","9:01am","9:01am","9:03am","9:06am","9:08am","9:10am","9:12am","9:13am"],
  ["9:07am","9:08am","9:08am","9:10am","9:13am","9:15am","9:17am","9:19am","9:20am"],
  ["9:15am","9:16am","9:16am","9:18am","9:21am","9:23am","9:25am","9:27am","9:28am"],
  ["9:22am","9:23am","9:23am","9:25am","9:28am","9:30am","9:32am","9:34am","9:35am"],
  ["9:30am","9:31am","9:31am","9:33am","9:36am","9:38am","9:40am","9:42am","9:43am"],
  ["9:37am","9:38am","9:38am","9:40am","9:43am","9:45am","9:47am","9:49am","9:50am"],
  ["9:45am","9:46am","9:46am","9:48am","9:51am","9:53am","9:55am","9:57am","9:58am"],
  ["9:52am","9:53am","9:53am","9:55am","9:58am","10:00am","10:02am","10:04am","10:05am"],
  ["10:00am","10:01am","10:01am","10:03am","10:06am","10:08am","10:10am","10:12am","10:13am"],
  ["10:07pm","10:08pm","10:08pm","10:10pm","10:13pm","10:15pm","10:17pm","10:19pm","10207pm"],
  ["10:15am","10:16am","10:16am","10:18am","10:21am","10:23am","10:25am","10:27am","10:28am"],
  ["10:22pm","10:23pm","10:23pm","10:25pm","10:28pm","10:30pm","10:32pm","10:24pm","10:35pm"],
  ["10:30am","10:31am","10:31am","10:33am","10:36am","10:38am","10:40am","10:42am","10:43am"],
  ["10:37am","10:38am","10:38am","10:40am","10:43am","10:45am","10:47am","10:49am","10:50am"],
  ["10:45am","10:46am","10:46am","10:48am","10:51am","10:53am","10:55am","10:57am","10:58am"],
  ["10:52am","10:53am","10:53am","10:55am","10:58am","11:00am","11:02am","11:04am","11:05am"],
  ["11:00am","11:01am","11:01am","11:03am","11:06am","11:08am","11:10am","11:12am","11:13am"],
  ["11:07am","11:08am","11:08am","11:10am","11:13am","11:15am","11:17am","11:19am","11:20am"],
  ["11:15am","11:16am","11:16am","11:18am","11:21am","11:23am","11:25am","11:27am","11:28am"],
  ["11:22am","11:23am","11:23am","11:25am","11:28am","11:30am","11:32am","11:34am","11:35am"],
  ["11:30am","11:31am","11:31am","11:33am","11:36am","11:38am","11:40am","11:42am","11:43am"],
  ["11:37am","11:38am","11:38am","11:40am","11:43am","11:45am","11:47am","11:49am","11:50am"],
  ["11:45am","11:46am","11:46am","11:48am","11:51am","11:53am","11:55am","11:57am","11:58am"],
  ["11:52am","11:53am","11:53am","11:55am","11:58am","12:00pm","12:02pm","12:04pm","12:05pm"],
  ["12:00pm","12:01pm","12:01pm","12:03pm","12:06pm","12:08pm","12:10pm","12:12pm","12:13pm"],
  ["12:07pm","12:08pm","12:08pm","12:10pm","12:13pm","12:15pm","12:17pm","12:19pm","12:20pm"],
  ["12:15pm","12:16pm","12:16pm","12:18pm","12:21pm","12:23pm","12:25pm","12:27pm","12:28pm"],
  ["12:22pm","12:23pm","12:23pm","12:25pm","12:28pm","12:30pm","12:32pm","12:34pm","12:35pm"],
  ["12:30pm","12:31pm","12:31pm","12:33pm","12:36pm","12:38pm","12:40pm","12:42pm","12:43pm"],
  ["12:37pm","12:38pm","12:38pm","12:40pm","12:43pm","12:45pm","12:47pm","12:49pm","12:50pm"],
  ["12:45pm","12:46pm","12:46pm","12:48pm","12:51pm","12:53pm","12:55pm","12:57pm","12:58pm"],
  ["12:52pm","12:53pm","12:53pm","12:55pm","12:58pm","1:00pm","1:02pm","1:04pm","1:05pm"],
  ["1:00pm","1:01pm","1:01pm","1:03pm","1:06pm","1:08pm","1:10pm","1:12pm","1:13pm"],
  ["1:07pm","1:08pm","1:08pm","1:10pm","1:13pm","1:15pm","1:17pm","1:19pm","1:20pm"],
  ["1:15pm","1:16pm","1:16pm","1:18pm","1:21pm","1:23pm","1:25pm","1:27pm","1:28pm"],
  ["1:22pm","1:23pm","1:23pm","1:25pm","1:28pm","1:30pm","1:32pm","1:34pm","1:35pm"],
  ["1:30pm","1:31pm","1:31pm","1:33pm","1:36pm","1:38pm","1:40pm","1:42pm","1:43pm"],
  ["1:37pm","1:38pm","1:38pm","1:40pm","1:43pm","1:45pm","1:47pm","1:49pm","1:50pm"],
  ["1:45pm","1:46pm","1:46pm","1:48pm","1:50pm","1:52pm","1:54pm","1:56pm","1:57pm"],
  ["1:52pm","1:53pm","1:53pm","1:55pm","1:58pm","2:00pm","2:02pm","2:04pm","2:05pm"],
  ["2:00pm","2:01pm","2:01pm","2:03pm","2:06pm","2:08pm","2:10pm","2:12pm","2:13pm"],
  ["2:07pm","2:08pm","2:08pm","2:10pm","2:13pm","2:15pm","2:17pm","2:19pm","2:20pm"],
  ["2:15pm","2:16pm","2:16pm","2:18pm","2:21pm","2:23pm","2:25pm","2:27pm","2:28pm"],
  ["2:22pm","2:23pm","2:23pm","2:25pm","2:28pm","2:30pm","2:32pm","2:34pm","2:35pm"],
  ["2:30pm","2:31pm","2:31pm","2:33pm","2:36pm","2:38pm","2:40pm","2:42pm","2:43pm"],
  ["2:37pm","2:38pm","2:38pm","2:40pm","2:43pm","2:45pm","2:47pm","2:49pm","2:50pm"],
  ["2:52pm","2:53pm","2:53pm","2:55pm","2:58pm","3:00pm","3:02pm","3:04pm","3:05pm"],
  ["3:00pm","3:01pm","3:01pm","3:03pm","3:06pm","3:08pm","3:10pm","3:12pm","3:13pm"],
  ["3:07pm","3:08pm","3:08pm","3:10pm","3:13pm","3:15pm","3:17pm","3:19pm","3:20pm"],
  ["3:15pm","3:16pm","3:16pm","3:18pm","3:21pm","3:23pm","3:25pm","3:27pm","3:28pm"],
  ["3:22pm","3:23pm","3:23pm","3:25pm","3:28pm","3:30pm","3:32pm","3:34pm","3:35pm"],
  ["3:30pm","3:31pm","3:31pm","3:33pm","3:36pm","3:38pm","3:40pm","3:42pm","3:43pm"],
  ["3:45pm","3:46pm","3:46pm","3:48pm","3:51pm","3:53pm","3:55pm","3:57pm","3:58pm"],
  ["4:00pm","4:01pm","4:01pm","4:03pm","4:06pm","4:08pm","4:10pm","4:12pm","4:13pm"],
  ["4:15pm","4:16pm","4:16pm","4:18pm","4:21pm","4:23pm","4:25pm","4:27pm","4:28pm"],
  ["4:30pm","4:31pm","4:31pm","4:33pm","4:36pm","4:38pm","4:40pm","4:42pm","4:43pm"],
  ["4:45pm","4:46pm","4:46pm","4:48pm","4:51pm","4:53pm","4:55pm","4:57pm","4:58pm"],
  ["5:00pm","5:01pm","5:01pm","5:03pm","5:06pm","5:08pm","5:10pm","5:12pm","5:13pm"],
  ["5:15pm","5:16pm","5:16pm","5:18pm","5:21pm","5:23pm","5:25pm","5:27pm","5:28pm"],
  ["5:30pm","5:31pm","5:31pm","5:33pm","5:36pm","5:38pm","5:40pm","5:42pm","5:43pm"],
  ["5:45pm","5:46pm","5:46pm","5:48pm","5:51pm","5:53pm","5:55pm","5:57pm","5:58pm"],
  ["6:00pm","6:01pm","6:01pm","6:03pm","6:06pm","6:08pm","6:10pm","6:12pm","6:13pm"],
  ["6:15pm","6:16pm","6:16pm","6:18pm","6:21pm","6:23pm","6:25pm","6:27pm","6:28pm"],
  ["6:30pm","6:31pm","6:31pm","6:33pm","6:36pm","6:38pm","6:40pm","6:42pm","6:43pm"],
  ["6:45pm","6:46pm","6:46pm","6:48pm","6:51pm","6:53pm","6:55pm","6:57pm","6:58pm"],
  ["6:50pm","6:51pm","6:51pm","6:53pm","6:56pm","6:58pm","7:00pm","7:02pm","7:03pm"],
  ["7:00pm","7:01pm","7:01pm","7:03pm","7:06pm","7:08pm","7:10pm","7:12pm","7:13pm"],
  ["7:05pm","7:06pm","7:06pm","7:08pm","7:11pm","7:13pm","7:15pm","7:17pm","7:18pm"],
  ["7:15pm","7:16pm","7:16pm","7:18pm","7:21pm","7:23pm","7:25pm","7:27pm","7:28pm"],
  ["7:20pm","7:21pm","7:21pm","7:23pm","7:26pm","7:28pm","7:30pm","7:32pm","7:33pm"],
  ["7:30pm","7:31pm","7:31pm","7:33pm","7:36pm","7:38pm","7:40pm","7:42pm","7:43pm"],
  ["7:35pm","7:36pm","7:36pm","7:38pm","7:41pm","7:43pm","7:45pm","7:47pm","7:48pm"],
  ["7:45pm","7:46pm","7:46pm","7:48pm","7:51pm","7:53pm","7:55pm","7:57pm","7:58pm"],
  ["7:50pm","7:51pm","7:51pm","7:53pm","7:56pm","7:58pm","8:00pm","8:02pm","8:03pm"],
  ["8:00pm","8:01pm","8:01pm","8:03pm","8:06pm","8:08pm","8:10pm","8:12pm","8:13pm"],
  ["8:05pm","8:06pm","8:06pm","8:08pm","8:11pm","8:13pm","8:15pm","8:17pm","8:18pm"],
  ["8:15pm","8:16pm","8:16pm","8:18pm","8:21pm","8:23pm","8:25pm","8:27pm","8:28pm"],
  ["8:20pm","8:21pm","8:21pm","8:23pm","8:26pm","8:28pm","8:30pm","8:32pm","8:33pm"],
  ["8:30pm","8:31pm","8:31pm","8:33pm","8:36pm","8:38pm","8:40pm","8:42pm","8:43pm"],
  ["8:35pm","8:36pm","8:36pm","8:38pm","8:41pm","8:43pm","8:45pm","8:47pm","8:48pm"],
  ["8:45pm","8:46pm","8:46pm","8:48pm","8:51pm","8:53pm","8:55pm","8:57pm","8:58pm"],
  ["8:50pm","8:51pm","8:51pm","8:53pm","8:56pm","8:58pm","9:00pm","9:02pm","9:03pm"],
  ["9:00pm","9:01pm","9:01pm","9:03pm","9:06pm","9:08pm","9:10pm","9:12pm","9:13pm"],
  ["9:05pm","9:06pm","9:06pm","9:08pm","9:11pm","9:13pm","9:15pm","9:17pm","9:18pm"],
  ["9:15pm","9:16pm","9:16pm","9:18pm","9:21pm","9:23pm","9:25pm","9:27pm","9:28pm"],
  ["9:20pm","9:21pm","9:21pm","9:23pm","9:26pm","9:28pm","9:30pm","9:32pm","9:33pm"],
  ["9:30pm","9:31pm","9:31pm","9:33pm","9:36pm","9:38pm","9:40pm","9:42pm","9:43pm"],
  ["9:35pm","9:36pm","9:36pm","9:38pm","9:41pm","9:43pm","9:45pm","9:47pm","9:48pm"],
  ["9:45pm","9:46pm","9:46pm","9:48pm","9:51pm","9:53pm","9:55pm","9:57pm","9:58pm"],
  ["9:50pm","9:51pm","9:51pm","9:53pm","9:56pm","9:58pm","10:00pm","10:02pm","10:03pm"],
  ["10:00pm","10:01pm","10:01pm","10:03pm","10:06pm","10:08pm","10:10pm","10:12pm","10:13pm"],
  ["10:15pm","10:16pm","10:16pm","10:18pm","10:21pm","10:23pm","10:25pm","10:27pm","10:28pm"],
  ["10:30pm","10:31pm","10:31pm","10:33pm","10:36pm","10:38pm","10:40pm","10:42pm","10:43pm"],
  ["10:45pm","10:46pm","10:46pm","10:48pm","10:51pm","10:53pm","10:55pm","10:57pm","10:58pm"]
];

// BUS SCHEDULES //
List<String> stops_87 = [
  "test1",
  "test2",
  "test3",
  "test4",
];

List<String> stops_286 = [
  "test1",
  "test2",
  "test3",
  "test4",
];
List<String> stops_289 = [
  "test1",
  "test2",
  "test3",
  "test4",
];

List<List<String>> times_87 = [
  ["1:00am","2:00am","3:00am",],
  ["4:00am","5:00pm","6:00pm",],
  ["7:00pm","8:00pm","9:00pm",],
];

List<List<String>> times_286 = [
  ["1:00am","2:00am","3:00am",],
  ["4:00am","5:00pm","6:00pm",],
  ["7:00pm","8:00pm","9:00pm",],
];
List<List<String>> times_289 = [
  ["1:00am","2:00am","3:00am",],
  ["4:00am","5:00pm","6:00pm",],
  ["7:00pm","8:00pm","9:00pm",],
];