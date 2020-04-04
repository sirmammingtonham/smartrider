// File to hold a bunch of lists for our listbuilders

// Shuttle Schedules //
List<List<String>> shuttle_north = [
  ["Union to Troy Crosswalk", "time", "id"],
  ["Troy Crosswalk to 9th St", "time", "id"],
  ["9th St to Alumni House", "time", "id"],
  ["Alumni House to Jacob", "time", "id"],
  ["Jacob to Colonie", "time", "id"],
  ["Colonie to Georgian", "time", "id"],
  ["Georgian to Brinsmade", "time", "id"],
  ["Brinsmade to Sunset 1", "time", "id"],
  ["Sunset 1 to Sunset 2", "time", "id"],
  ["Sunset 2 to E-Lot", "time", "id"],
  ["E-Lot to B-Lot", "time", "id"],
  ["B-Lot to Union", "time", "id"],
];

List<List<String>> shuttle_south = [
  ["Union to B-Lot", "time", "id"],
  ["B-Lot to LXA", "time", "id"],
  ["LXA to Tibitts/Orchard", "time", "id"],
  ["Tibitts/Orchard to Polytech", "time", "id"],
  ["Polytech to 15th/College", "time", "id"],
];

List<List<String>> shuttle_west = [
  ["Union to CBIS/AH", "time", "id"],
  ["CBIS/AH to 15th/Off Commons", "time", "id"],
  ["15th/Off Commons to 15th/Poly", "time", "id"],
  ["15th/Poly to City Station", "time", "id"],
  ["City Station to Blitman", "time", "id"],
  ["Blitman to Winslow", "time", "id"],
  ["Winslow to West", "time", "id"],
  ["West to 87 Gym", "time", "id"],
  ["87 Gym to Union", "time", "id"],
];

List<String> north_stops = [
  "Union"
  ,"Troy Crosswalk"
  ,"9th St"
  ,"Alumni House"
  ,"Jacob"
  ,"Colonie"
  ,"Georgian"
  ,"Brinsmade"
  ,"Sunset 1"
  ,"Sunset 2"
  ,"E-Lot"
  ,"B-Lot"
];

List<String> south_stops = [
  "Union",
  "B-Lot",
  "LXA",
  "Tibitts/Orchard",
  "Polytech",
  "15th/College"
];

List<String> west_stops = [
  "Union",
  "CBIS/AH", 
  "15th/Off Commons", 
  "15th/Poly", 
  "City Station", 
  "Blitman", 
  "Winslow", 
  "West", 
  "87 Gym"

];

List<List<String>> weekday_south = [
  ["7:15a","7:17a","7:18a","7:20a","7:23a","7:25a"],
  ["7:27a","7:29a","7:30a","7:32a","7:35a","7:37a"],
  ["7:39a","7:41a","7:42a","7:44a","7:47a","7:49a"],
  ["7:51a","7:53a","7:54a","7:56a","7:59a","8:01a"],
  ["8:03a","8:05a","8:06a","8:08a","8:11a","8:13a"],
  ["8:15a","8:17a","8:18a","8:20a","8:23a","8:25a"],
  ["8:27a","8:29a","8:30a","8:32a","8:35a","8:37a"],
  ["8:39a","8:41a","8:42a","8:44a","8:47a","8:49a"],
  ["8:51a","8:53a","8:54a","8:56a","8:59a","9:01a"],
  ["9:03a","9:05a","9:06a","9:08a","9:11a","9:13a"],
  ["9:15a","9:17a","9:18a","9:20a","9:23a","9:25a"],
  ["9:20a","9:22a","9:23a","9:25a","9:28a","9:30a"],
  ["9:32a","9:34a","9:35a","9:37a","9:40a","9:42a"],
  ["9:44a","9:46a","9:47a","9:49a","9:52a","9:54a"],
  ["9:56a","9:58a","9:59a","10:01a","10:04a","10:06a"],
  ["10:08a","10:10a","10:11a","10:13a","10:16a","10:18a"],
  ["10:20a","10:22a","10:23a","10:25a","10:28a","10:30a"],
  ["10:32a","10:34a","10:35a","10:37a","10:40a","10:42a"],
  ["10:44a","10:46a","10:47a","10:49a","10:52a","10:54a"],
  ["10:56a","10:58a","10:59a","11:01a","11:04a","11:06a"],
  ["11:08a","11:10a","11:11a","11:13a","11:16a","11:18a"],
  ["11:20a","11:22a","11:23a","11:25a","11:28a","11:30a"],
  ["11:32a","11:34a","11:35a","11:37a","11:40a","11:42a"],
  ["11:44a","11:46a","11:47a","11:49a","11:52a","11:54a"],
  ["11:56a","11:58a","11:59a","12:01p","12:04p","12:06p"],
  ["12:08p","12:10p","12:11p","12:13p","12:16p","12:18p"],
  ["12:20p","12:22p","12:23p","12:25p","12:28p","12:30p"],
  ["12:44p","12:46p","12:47p","12:49p","12:52p","12:54p"],
  ["12:56p","12:58p","12:59p","1:01p","1:04p","1:06a"],
  ["1:08a","1:10p","1:11p","1:13p","1:16p","1:18p"],
  ["1:20p","1:22p","1:23p","1:25p","1:28p","1:30p"],
  ["1:44p","1:46p","1:47p","1:49p","1:52p","1:54p"],
  ["1:56p","1:58p","1:59p","2:01p","2:04p","2:06p"],
  ["2:08a","2:10p","2:11p","2:13p","2:16p","2:18p"],
  ["2:20p","2:22p","2:23p","2:25p","2:28p","2:30p"],
  ["2:44p","2:46p","2:47p","2:49p","2:52p","2:54p"],
  ["2:56p","2:58p","2:59p","3:01p","3:04p","3:06a"],
  ["3:08p","3:10p","3:11p","3:13p","3:16p","3:18p"],
  ["3:20p","3:22p","3:23p","3:25p","3:28p","3:30p"],
  ["3:44p","3:46p","3:47p","3:49p","3:52p","3:54p"],
  ["3:56p","3:58p","3:59p","4:01p","4:04p","4:06a"],
  ["4:08p","4:10p","4:11p","4:13p","4:16p","4:18p"],
  ["4:20p","4:22p","4:23p","4:25p","4:28p","4:30p"],
  ["4:44p","4:46p","4:47p","4:49p","4:52p","4:54p"],
  ["4:50p","4:52p","4:53p","4:55p","4:58p","5:00p"],
  ["4:56p","4:58p","4:59p","5:01p","5:04p","5:06a"],
  ["5:02p","5:04p","5:05p","5:07p","5:10p","5:12p"],
  ["5:14p","5:16p","5:17p","5:19p","5:22p","5:24p"],
  ["5:26p","5:28p","5:29p","5:31p","5:34p","5:36p"],
  ["5:38p","5:40p","5:41p","5:43p","5:46p","5:48p"],
  ["5:50p","5:52p","5:53p","5:55p","5:58p","6:00p"],
  ["6:02p","6:04p","6:05p","6:07p","6:10p","6:12p"],
  ["6:14p","6:16p","6:17p","6:19p","6:22p","6:24p"],
  ["6:26p","6:28p","6:29p","6:31p","6:34p","6:36p"],
  ["6:38p","6:40p","6:41p","6:43p","6:46p","6:48p"],
  ["6:50p","6:52p","6:53p","6:55p","6:58p","7:00p"],
  ["7:02p","7:04p","7:05p","7:07p","7:10p","7:12p"],
  ["7:14p","7:16p","7:17p","7:19p","7:22p","7:24p"],
  ["7:20p","7:22p","7:23p","7:25p","7:28p","7:30p"],
  ["7:26p","7:28p","7:29p","7:31p","7:34p","7:36p"],
  ["7:32p","7:34p","7:35p","7:37p","7:40p","7:42p"],
  ["7:38p","7:40p","7:41p","7:43p","7:46p","7:48p"],
  ["7:44p","7:46p","7:47p","7:49p","7:52p","7:54p"],
  ["7:50p","7:52p","7:53p","7:55p","7:58p","8:00p"],
  ["7:56p","7:58p","7:59p","8:01p","8:04p","8:06p"],
  ["8:02p","8:04p","8:05p","8:07p","8:10p","8:12p"],
  ["8:08p","8:10p","8:11p","8:13p","8:16p","8:18p"],
  ["8:20p","8:22p","8:23p","8:25p","8:28p","8:30p"],
  ["8:32p","8:34p","8:35p","8:37p","8:40p","8:42p"],
  ["8:44p","8:46p","8:47p","8:49p","8:52p","8:54p"],
  ["8:56p","8:58p","8:59p","9:01p","9:04p","9:06p"],
  ["9:08p","9:10p","9:11p","9:13p","9:16p","9:18p"],
  ["9:20p","9:22p","9:23p","9:25p","9:28p","9:30p"],
  ["9:32p","9:34p","9:35p","9:37p","9:40p","9:42p"],
  ["9:44p","9:46p","9:47p","9:49p","9:52p","9:54p"],
  ["9:56p","9:58p","9:59p","10:01p","10:04p","10:06p"],
  ["10:08p","10:10p","10:11p","10:13p","10:16p","10:18p"],
  ["10:20p","10:22p","10:23p","10:25p","10:28p","10:30p"],
  ["10:32p","10:34p","10:35p","10:37p","10:40p","10:42p"]
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
  ["11:45am","11:47am","11:48am","11:49am","11:51am","11:53am","11:55am","11:56am","11:57am","11:58am","11:59am","12:00p"],
  ["11:56am","11:58am","11:59am","12:00p","12:02p","12:04p","12:06p","12:07p","12:08p","12:09p","12:10p","12:11p"],
  ["12:03p","12:05p","12:06p","12:07p","12:09p","12:11p","12:13p","12:14p","12:15p","12:16p","12:17p","12:18p"],
  ["12:14p","12:16p","12:17p","12:18p","12:20p","12:22p","12:24p","12:25p","12:26p","12:27p","12:28p","12:29p"],
  ["12:20a","12:22a","12:23a","12:24a","12:26a","12:28a","12:30p","12:31p","12:32p","12:33p","12:34p","12:35p"],
  ["12:21p","12:23p","12:24p","12:25p","12:27p","12:29p","12:31p","12:32p","12:33p","12:34p","12:35p","12:36p"],
  ["12:32p","12:34p","12:35p","12:36p","12:38p","12:40p","12:42p","12:43p","12:44p","12:45p","12:46p","12:47p"],
  ["12:39p","12:41p","12:42p","12:43p","12:45p","12:47p","12:49p","12:50p","12:51p","12:52p","12:53p","12:54p"],
  ["12:56p","12:58p","12:59p","1:00p","1:02p","1:04p","1:06p","1:07p","1:08p","1:09p","1:10p","1:11p"],
  ["12:57p","12:59p","1:00p","1:02p","1:04p","1:06p","1:08p","1:09p","1:10p","1:11p","1:12p","1:13p"],
  ["1:14p","1:16p","1:17p","1:18p","1:20p","1:22p","1:24p","1:26p","1:27p","1:28p","1:29p","1:30p"],
  ["1:16p","1:18p","1:19p","1:21p","1:23p","1:25p","1:27p","1:28p","1:29p","1:30p","1:31p","1:32p"],
  ["1:33p","1:35p","1:36p","1:37p","1:39p","1:41p","1:43p","1:44p","1:45p","1:46p","1:47p","1:43p"],
  ["1:35p","1:37p","1:38p","1:39p","1:41p","1:43p","1:45p","1:46p","1:47p","1:48p","1:49p","1:50p"],
  ["1:46p","1:48p","1:49p","1:50p","1:52p","1:54p","1:56p","1:57p","1:58p","1:59p","2:00p","2:01p"],
  ["1:53p","1:55p","1:56p","1:57p","1:59p","2:01p","2:03p","2:04p","2:05p","2:06p","2:07p","2:08p"],
  ["2:04p","2:06p","2:07p","2:08p","2:10p","2:12p","2:14p","2:15p","2:16p","2:17p","2:18p","2:19p"],
  ["2:11p","2:13p","2:14p","2:15p","2:17p","2:19p","2:21p","2:22p","2:23p","2:24p","2:25p","2:26p"],
  ["2:22p","2:24p","2:25p","2:26p","2:28p","2:30p","2:32p","2:31p","2:32p","2:33p","2:34p","2:35p"],
  ["2:29p","2:31p","2:32p","2:33p","2:35p","2:37p","2:39p","2:40p","2:41p","2:42p","2:43p","2:44p"],
  ["2:38p","2:40p","2:41p","2:42p","2:44p","2:46p","2:48p","2:49p","2:50p","2:51p","2:52p","2:53p"],
  ["2:50p","2:52p","2:53p","2:54p","2:56p","2:58p","3:00p","3:01p","3:02p","3:03p","3:04p","3:05p"],
  ["2:56p","2:58p","2:59p","3:00p","3:02p","3:04p","3:06p","3:08p","3:10p","3:11p","3:12p","3:13p"],
  ["3:00p","3:02p","3:03p","3:04p","3:06p","3:08p","3:10p","3:11p","3:12p","3:13p","3:14p","3:15p"],
  ["3:08p","3:10p","3:11p","3:12p","3:14p","3:16p","3:18p","3:19p","3:20p","3:21p","3:22p","3:23p"],
  ["3:16p","3:18p","3:19p","3:20p","3:22p","3:24p","3:26p","3:27p","3:28p","3:29p","3:30p","3:31p"],
  ["3:18p","3:20p","3:21p","3:22p","3:24p","3:26p","3:28p","3:29p","3:30p","3:31p","3:32p","3:33p"],
  ["3:26p","3:28p","3:29p","3:30p","3:32p","3:34p","3:36p","3:37p","3:38p","3:39p","3:40p","3:41p"],
  ["3:34p","3:36p","3:37p","3:38p","3:40p","3:42p","3:44p","3:45p","3:46p","3:47p","3:48p","3:49p"],
  ["3:36p","3:38p","3:39p","3:40p","3:42p","3:44p","3:46p","3:47p","3:48p","3:49p","3:50p","3:51p"],
  ["3:44p","3:46p","3:47p","3:48p","3:50p","3:52p","3:54p","3:55p","3:56p","3:57p","3:58p","3:59p"],
  ["3:52p","3:54p","3:55p","3:56p","3:58p","4:00p","4:02p","4:03p","4:04p","4:05p","4:06p","4:07p"],
  ["3:54p","3:56p","3:57p","3:58p","4:00p","4:02p","4:04p","4:05p","4:06p","4:07p","4:08p","4:09p"],
  ["4:02p","4:04p","4:05p","4:06p","4:08p","4:10p","4:12p","4:13p","4:14p","4:15p","4:16p","4:17p"],
  ["4:12p","4:14p","4:15p","4:16p","4:18p","4:20p","4:22p","4:23p","4:24p","4:25p","4:26p","4:27p"],
  ["4:20p","4:22p","4:23p","4:24p","4:26p","4:28p","4:30p","4:31p","4:32p","4:33p","4:34p","4:35p"],
  ["4:30p","4:32p","4:33p","4:34p","4:36p","4:38p","4:40p","4:41p","4:42p","4:43p","4:44p","4:45p"],
  ["4:38p","4:40p","4:41p","4:42p","4:44p","4:46p","4:48p","4:49p","4:50p","4:51p","4:52p","4:53p"],
  ["4:48p","4:50p","4:51p","4:52p","4:54p","4:56p","4:58p","4:59p","5:00p","5:01p","5:02p","5:03p"],
  ["4:56p","4:58p","4:59p","5:00p","5:02p","5:04p","5:06p","5:07p","5:08p","5:09p","5:10p","5:11p"],
  ["5:06p","5:08p","5:09p","5:10p","5:12p","5:14p","5:16p","5:17p","5:18p","5:19p","5:20p","5:21p"],
  ["5:14p","5:16p","5:17p","5:18p","5:20p","5:22p","5:24p","5:25p","5:26p","5:27p","5:28p","5:29p"],
  ["5:24p","5:26p","5:27p","5:28p","5:30p","5:32p","5:34p","5:35p","5:36p","5:37p","5:38p","5:39p"],
  ["5:32p","5:34p","5:35p","5:36p","5:38p","5:40p","5:42p","5:43p","5:44p","5:45p","5:46p","5:47p"],
  ["5:42p","5:44p","5:45p","5:46p","5:48p","5:50p","5:52p","5:53p","5:54p","5:55p","5:56p","5:57p"],
  ["5:50p","5:52p","5:53p","5:54p","5:56p","5:58p","6:00p","6:01p","6:02p","6:03p","6:04p","6:05p"],
  ["6:00p","6:02p","6:03p","6:04p","6:06p","6:08p","6:10p","6:11p","6:12p","6:13p","6:14p","6:15p"],
  ["6:18p","6:20p","6:21p","6:22p","6:24p","6:26p","6:28p","6:29p","6:30p","6:31p","6:32p","6:33p"],
  ["6:36p","6:38p","6:39p","6:40p","6:42p","6:44p","6:46p","6:47p","6:48p","6:49p","6:50p","6:51p"],
  ["6:54p","6:56p","6:57p","6:58p","7:00p","7:02p","7:04p","7:05p","7:06p","7:07p","7:08p","7:09p"],
  ["7:12p","7:14p","7:15p","7:16p","7:18p","7:20p","7:22p","7:23p","7:24p","7:25p","7:26p","7:27p"],
  ["7:30p","7:32p","7:33p","7:34p","7:36p","7:38p","7:40p","7:41p","7:42p","7:43p","7:44p","7:45p"],
  ["7:48p","7:50p","7:51p","7:52p","7:54p","7:56p","7:58p","7:59p","8:00p","8:01p","8:02p","8:03p"],
  ["8:06p","8:08p","8:09p","8:10p","8:12p","8:14p","8:16p","8:17p","8:18p","8:19p","8:20p","8:21p"],
  ["8:24p","8:26p","8:27p","8:28p","8:30p","8:32p","8:34p","8:35p","8:36p","8:37p","8:38p","8:39p"],
  ["8:42p","8:44p","8:45p","8:46p","8:48p","8:50p","8:52p","8:53p","8:54p","8:55p","8:56p","8:57p"],
  ["9:00p","9:02p","9:03p","9:04p","9:06p","9:08p","9:10p","9:11p","9:12p","9:13p","9:14p","9:15p"],
  ["9:18p","9:20p","9:21p","9:22p","9:24p","9:26p","9:28p","9:29p","9:30p","9:31p","9:32p","9:33p"],
  ["9:36p","9:38p","9:39p","9:40p","9:42p","9:44p","9:46p","9:47p","9:48p","9:49p","9:50p","9:51p"],
  ["9:54p","9:56p","9:57p","9:58p","10:00p","10:02p","10:04p","10:05p","10:06p","10:07p","10:08p","10:09p"],
  ["10:12p","10:14p","10:15p","10:16p","10:18p","10:20p","10:22p","10:23p","10:24p","10:25p","10:26p","10:27p"],
  ["10:30p","10:32p","10:33p","10:34p","10:36p","10:38p","10:40p","10:41p","10:42p","10:43p","10:44p","10:45p"],
  ["10:48p","10:50p","10:51p","10:52p","10:54p","10:56p","10:58p","10:59p","11:00p","11:01p","11:02p","11:03p"]
];

List<List<String>> weekday_west =[
  ["7:00a","7:01a","7:01a","7:03a","7:06a","7:08a","7:10a","7:12a","7:13a"],
  ["7:15a","7:16a","7:16a","7:18a","7:21a","7:23a","7:25a","7:27a","7:28a"],
  ["7:30a","7:31a","7:31a","7:33a","7:36a","7:38a","7:40a","7:42a","7:43a"],
  ["7:45a","7:46a","7:46a","7:48a","7:51a","7:53a","7:55a","7:57a","7:58a"],
  ["7:52a","7:53a","7:53a","7:55a","7:58a","8:01a","8:03a","8:05a","8:06a"],
  ["8:00a","8:01a","8:01a","8:03a","8:06a","8:08a","8:10a","8:12a","8:13a"],
  ["8:08a","8:09a","8:09a","8:10a","8:13a","8:15a","8:17a","8:19a","8:20a"],
  ["8:15a","8:16a","8:16a","8:18a","8:21a","8:23a","8:25a","8:27a","8:28a"],
  ["8:22a","8:23a","8:23a","8:25a","8:28a","8:30a","8:32a","8:34a","8:35a"],
  ["8:30a","8:31a","8:31a","8:33a","8:36a","8:38a","8:40a","8:42a","8:43a"],
  ["8:37a","8:38a","8:38a","8:40a","8:43a","8:45a","8:47a","8:49a","8:50a"],
  ["8:45a","8:46a","8:46a","8:48a","8:51a","8:53a","8:55a","8:57a","8:58a"],
  ["8:52a","8:53a","8:53a","8:55a","8:58a","9:00a","9:02a","9:04a","9:05a"],
  ["9:00a","9:01a","9:01a","9:03a","9:06a","9:08a","9:10a","9:12a","9:13a"],
  ["9:07a","9:08a","9:08a","9:10a","9:13a","9:15a","9:17a","9:19a","9:20a"],
  ["9:15a","9:16a","9:16a","9:18a","9:21a","9:23a","9:25a","9:27a","9:28a"],
  ["9:22a","9:23a","9:23a","9:25a","9:28a","9:30a","9:32a","9:34a","9:35a"],
  ["9:30a","9:31a","9:31a","9:33a","9:36a","9:38a","9:40a","9:42a","9:43a"],
  ["9:37a","9:38a","9:38a","9:40a","9:43a","9:45a","9:47a","9:49a","9:50a"],
  ["9:45a","9:46a","9:46a","9:48a","9:51a","9:53a","9:55a","9:57a","9:58a"],
  ["9:52a","9:53a","9:53a","9:55a","9:58a","10:00a","10:02a","10:04a","10:05a"],
  ["10:00a","10:01a","10:01a","10:03a","10:06a","10:08a","10:10a","10:12a","10:13a"],
  ["10:07p","10:08p","10:08p","10:10p","10:13p","10:15p","10:17p","10:19p","10207p"],
  ["10:15a","10:16a","10:16a","10:18a","10:21a","10:23a","10:25a","10:27a","10:28a"],
  ["10:22p","10:23p","10:23p","10:25p","10:28p","10:30p","10:32p","10:24p","10:35p"],
  ["10:30a","10:31a","10:31a","10:33a","10:36a","10:38a","10:40a","10:42a","10:43a"],
  ["10:37a","10:38a","10:38a","10:40a","10:43a","10:45a","10:47a","10:49a","10:50a"],
  ["10:45a","10:46a","10:46a","10:48a","10:51a","10:53a","10:55a","10:57a","10:58a"],
  ["10:52a","10:53a","10:53a","10:55a","10:58a","11:00a","11:02a","11:04a","11:05a"],
  ["11:00a","11:01a","11:01a","11:03a","11:06a","11:08a","11:10a","11:12a","11:13a"],
  ["11:07a","11:08a","11:08a","11:10a","11:13a","11:15a","11:17a","11:19a","11:20a"],
  ["11:15a","11:16a","11:16a","11:18a","11:21a","11:23a","11:25a","11:27a","11:28a"],
  ["11:22a","11:23a","11:23a","11:25a","11:28a","11:30a","11:32a","11:34a","11:35a"],
  ["11:30a","11:31a","11:31a","11:33a","11:36a","11:38a","11:40a","11:42a","11:43a"],
  ["11:37a","11:38a","11:38a","11:40a","11:43a","11:45a","11:47a","11:49a","11:50a"],
  ["11:45a","11:46a","11:46a","11:48a","11:51a","11:53a","11:55a","11:57a","11:58a"],
  ["11:52a","11:53a","11:53a","11:55a","11:58a","12:00p","12:02p","12:04p","12:05p"],
  ["12:00p","12:01p","12:01p","12:03p","12:06p","12:08p","12:10p","12:12p","12:13p"],
  ["12:07p","12:08p","12:08p","12:10p","12:13p","12:15p","12:17p","12:19p","12:20p"],
  ["12:15p","12:16p","12:16p","12:18p","12:21p","12:23p","12:25p","12:27p","12:28p"],
  ["12:22p","12:23p","12:23p","12:25p","12:28p","12:30p","12:32p","12:34p","12:35p"],
  ["12:30p","12:31p","12:31p","12:33p","12:36p","12:38p","12:40p","12:42p","12:43p"],
  ["12:37p","12:38p","12:38p","12:40p","12:43p","12:45p","12:47p","12:49p","12:50p"],
  ["12:45p","12:46p","12:46p","12:48p","12:51p","12:53p","12:55p","12:57p","12:58p"],
  ["12:52p","12:53p","12:53p","12:55p","12:58p","1:00p","1:02p","1:04p","1:05p"],
  ["1:00p","1:01p","1:01p","1:03p","1:06p","1:08p","1:10p","1:12p","1:13p"],
  ["1:07p","1:08p","1:08p","1:10p","1:13p","1:15p","1:17p","1:19p","1:20p"],
  ["1:15p","1:16p","1:16p","1:18p","1:21p","1:23p","1:25p","1:27p","1:28p"],
  ["1:22p","1:23p","1:23p","1:25p","1:28p","1:30p","1:32p","1:34p","1:35p"],
  ["1:30p","1:31p","1:31p","1:33p","1:36p","1:38p","1:40p","1:42p","1:43p"],
  ["1:37p","1:38p","1:38p","1:40p","1:43p","1:45p","1:47p","1:49p","1:50p"],
  ["1:45p","1:46p","1:46p","1:48p","1:50p","1:52p","1:54p","1:56p","1:57p"],
  ["1:52p","1:53p","1:53p","1:55p","1:58p","2:00p","2:02p","2:04p","2:05p"],
  ["2:00p","2:01p","2:01p","2:03p","2:06p","2:08p","2:10p","2:12p","2:13p"],
  ["2:07p","2:08p","2:08p","2:10p","2:13p","2:15p","2:17p","2:19p","2:20p"],
  ["2:15p","2:16p","2:16p","2:18p","2:21p","2:23p","2:25p","2:27p","2:28p"],
  ["2:22p","2:23p","2:23p","2:25p","2:28p","2:30p","2:32p","2:34p","2:35p"],
  ["2:30p","2:31p","2:31p","2:33p","2:36p","2:38p","2:40p","2:42p","2:43p"],
  ["2:37p","2:38p","2:38p","2:40p","2:43p","2:45p","2:47p","2:49p","2:50p"],
  ["2:52p","2:53p","2:53p","2:55p","2:58p","3:00p","3:02p","3:04p","3:05p"],
  ["3:00p","3:01p","3:01p","3:03p","3:06p","3:08p","3:10p","3:12p","3:13p"],
  ["3:07p","3:08p","3:08p","3:10p","3:13p","3:15p","3:17p","3:19p","3:20p"],
  ["3:15p","3:16p","3:16p","3:18p","3:21p","3:23p","3:25p","3:27p","3:28p"],
  ["3:22p","3:23p","3:23p","3:25p","3:28p","3:30p","3:32p","3:34p","3:35p"],
  ["3:30p","3:31p","3:31p","3:33p","3:36p","3:38p","3:40p","3:42p","3:43p"],
  ["3:45p","3:46p","3:46p","3:48p","3:51p","3:53p","3:55p","3:57p","3:58p"],
  ["4:00p","4:01p","4:01p","4:03p","4:06p","4:08p","4:10p","4:12p","4:13p"],
  ["4:15p","4:16p","4:16p","4:18p","4:21p","4:23p","4:25p","4:27p","4:28p"],
  ["4:30p","4:31p","4:31p","4:33p","4:36p","4:38p","4:40p","4:42p","4:43p"],
  ["4:45p","4:46p","4:46p","4:48p","4:51p","4:53p","4:55p","4:57p","4:58p"],
  ["5:00p","5:01p","5:01p","5:03p","5:06p","5:08p","5:10p","5:12p","5:13p"],
  ["5:15p","5:16p","5:16p","5:18p","5:21p","5:23p","5:25p","5:27p","5:28p"],
  ["5:30p","5:31p","5:31p","5:33p","5:36p","5:38p","5:40p","5:42p","5:43p"],
  ["5:45p","5:46p","5:46p","5:48p","5:51p","5:53p","5:55p","5:57p","5:58p"],
  ["6:00p","6:01p","6:01p","6:03p","6:06p","6:08p","6:10p","6:12p","6:13p"],
  ["6:15p","6:16p","6:16p","6:18p","6:21p","6:23p","6:25p","6:27p","6:28p"],
  ["6:30p","6:31p","6:31p","6:33p","6:36p","6:38p","6:40p","6:42p","6:43p"],
  ["6:45p","6:46p","6:46p","6:48p","6:51p","6:53p","6:55p","6:57p","6:58p"],
  ["6:50p","6:51p","6:51p","6:53p","6:56p","6:58p","7:00p","7:02p","7:03p"],
  ["7:00p","7:01p","7:01p","7:03p","7:06p","7:08p","7:10p","7:12p","7:13p"],
  ["7:05p","7:06p","7:06p","7:08p","7:11p","7:13p","7:15p","7:17p","7:18p"],
  ["7:15p","7:16p","7:16p","7:18p","7:21p","7:23p","7:25p","7:27p","7:28p"],
  ["7:20p","7:21p","7:21p","7:23p","7:26p","7:28p","7:30p","7:32p","7:33p"],
  ["7:30p","7:31p","7:31p","7:33p","7:36p","7:38p","7:40p","7:42p","7:43p"],
  ["7:35p","7:36p","7:36p","7:38p","7:41p","7:43p","7:45p","7:47p","7:48p"],
  ["7:45p","7:46p","7:46p","7:48p","7:51p","7:53p","7:55p","7:57p","7:58p"],
  ["7:50p","7:51p","7:51p","7:53p","7:56p","7:58p","8:00p","8:02p","8:03p"],
  ["8:00p","8:01p","8:01p","8:03p","8:06p","8:08p","8:10p","8:12p","8:13p"],
  ["8:05p","8:06p","8:06p","8:08p","8:11p","8:13p","8:15p","8:17p","8:18p"],
  ["8:15p","8:16p","8:16p","8:18p","8:21p","8:23p","8:25p","8:27p","8:28p"],
  ["8:20p","8:21p","8:21p","8:23p","8:26p","8:28p","8:30p","8:32p","8:33p"],
  ["8:30p","8:31p","8:31p","8:33p","8:36p","8:38p","8:40p","8:42p","8:43p"],
  ["8:35p","8:36p","8:36p","8:38p","8:41p","8:43p","8:45p","8:47p","8:48p"],
  ["8:45p","8:46p","8:46p","8:48p","8:51p","8:53p","8:55p","8:57p","8:58p"],
  ["8:50p","8:51p","8:51p","8:53p","8:56p","8:58p","9:00p","9:02p","9:03p"],
  ["9:00p","9:01p","9:01p","9:03p","9:06p","9:08p","9:10p","9:12p","9:13p"],
  ["9:05p","9:06p","9:06p","9:08p","9:11p","9:13p","9:15p","9:17p","9:18p"],
  ["9:15p","9:16p","9:16p","9:18p","9:21p","9:23p","9:25p","9:27p","9:28p"],
  ["9:20p","9:21p","9:21p","9:23p","9:26p","9:28p","9:30p","9:32p","9:33p"],
  ["9:30p","9:31p","9:31p","9:33p","9:36p","9:38p","9:40p","9:42p","9:43p"],
  ["9:35p","9:36p","9:36p","9:38p","9:41p","9:43p","9:45p","9:47p","9:48p"],
  ["9:45p","9:46p","9:46p","9:48p","9:51p","9:53p","9:55p","9:57p","9:58p"],
  ["9:50p","9:51p","9:51p","9:53p","9:56p","9:58p","10:00p","10:02p","10:03p"],
  ["10:00p","10:01p","10:01p","10:03p","10:06p","10:08p","10:10p","10:12p","10:13p"],
  ["10:15p","10:16p","10:16p","10:18p","10:21p","10:23p","10:25p","10:27p","10:28p"],
  ["10:30p","10:31p","10:31p","10:33p","10:36p","10:38p","10:40p","10:42p","10:43p"],
  ["10:45p","10:46p","10:46p","10:48p","10:51p","10:53p","10:55p","10:57p","10:58p"]
];
// BUS SCHEDULES //




